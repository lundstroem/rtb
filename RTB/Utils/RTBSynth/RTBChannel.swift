/*

MIT License

Copyright (c) 2020 Harry Lundström

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*/

import Foundation

public class RTBChannel {
    var channelBuffer: [Int16] = Array(repeating: 0, count: 4096)
    var notes: [RTBNote] = []
    let osc = RTBOscillator()
    let vibratoEffect = RTBVibratoEffect()
    let lowpassEffect = RTBFilterEffect()
    let pitchEffect = RTBPitchEffect()
    var sampleCursor: Double = 0
    var active = true
    var amplitude = 0.5
    let effectTickLimit = 64
    var effectTickCounter = 0
    var started = false

    init() {
        // fill pool of notes
        for _ in 0..<16 {
            notes.append(RTBNote())
        }
    }

    func playSfx(noteValue: Double,
                 wave: RTBOscillator.WaveType,
                 speed: Double = 60,
                 pitchBend: Double,
                 vibratoDepth: Double,
                 vibratoSpeed: Double,
                 clearQueue: Bool = false) {
        
        if clearQueue {
           inactivateNotes()
        }

        for note in notes {
            if !note.active {
                note.active = true
                note.note = noteValue
                note.bpm = speed
                note.waveType = wave

                if pitchBend != 0 {
                    note.pitchEffectDepth = pitchBend
                }

                if vibratoSpeed != 0 && vibratoDepth != 0 {
                    note.vibratoEffectSpeed = vibratoSpeed
                    note.vibratoEffectDepth = vibratoDepth
                }

                // TODO: Reset all params when setting..

                active = true
                return
            }
        }
    }

    private func inactivateNotes() {
        for note in notes {
            note.active = false
        }
    }

    public func reset() {
        inactivateNotes()
        started = false
        sampleCursor = 0
    }

    public func advanceChannel(bufferSize: Int) {
        for n in 0..<bufferSize {
            channelBuffer[n] = 0
        }

        for n in stride(from: 0, to: bufferSize, by: 2) {
            let sample = increment(bufferSize: 2)
            guard
                channelBuffer[n]+sample < INT16_MAX &&
                    channelBuffer[n]+sample > INT16_MIN &&
                    channelBuffer[n+1]+sample < INT16_MAX &&
                    channelBuffer[n+1]+sample > INT16_MIN
                else { continue }
            channelBuffer[n] += sample
            channelBuffer[n+1] += sample
        }

        if lowpassEffect.active() {
            filterLowpass(bufferSize: bufferSize)
        }
    }

    private func increment(bufferSize: Int) -> Int16 {

        guard active else {
            return 0
        }

        if !started {
            sampleCursor = 0
            if notes[0].active {
                activateNote(0)
                started = true
            }
        }

        let currentSampleCursor = Int(sampleCursor)
        let currentNote = notes[currentSampleCursor]

        let time: Double = ((RTBOscillator.sampleRate * 2) * 60.0) * Double(bufferSize)

        // TODO: Use milliseconds for speed/bpm param.
        let sampleTimeMod: Double = (currentNote.bpm * 100) / time

        sampleCursor += sampleTimeMod
        if Int(sampleCursor) > currentSampleCursor {
            let newSampleCursor = Int(sampleCursor)
            if newSampleCursor < notes.count && notes[newSampleCursor].active {
                activateNote(newSampleCursor)
            } else {

                // TODO: Handle amplitude and phase transitions to avoid clicks and pops.

                inactivateNotes()
                sampleCursor = 0
                started = false
                active = false
                amplitude = 0
                resetEffects()
            }
        }

        applyEffects(index: Int(sampleCursor))

        return osc.incrementOsc(amplitude)
    }

    private func applyEffects(index: Int) {
        guard index < notes.count else { return }

        effectTickCounter += 1
        if effectTickCounter >= effectTickLimit {
            effectTickCounter = 0
            if notes[index].active {
                var note = notes[index].note
                if pitchEffect.active() {
                    note = pitchEffect.modifiedNote(note: note)
                }
                if vibratoEffect.active() {
                    note = vibratoEffect.modifiedNote(note: note)
                }
                osc.pitch = note
            }
        }
    }
}

// MARK: Private

extension RTBChannel {

    private func resetEffects() {
        vibratoEffect.reset()
        lowpassEffect.reset()
        pitchEffect.reset()
    }

    private func activateNote(_ index: Int) {
        resetEffects()
        if index < notes.count {

            amplitude = 0.5
            osc.pitch = notes[index].note
            osc.setWaveType(waveType: notes[index].waveType)
            if notes[index].pitchEffectDepth != 0 {
                pitchEffect.isActive = true
                pitchEffect.setIncrement(value: notes[index].pitchEffectDepth)
            }
            if notes[index].vibratoEffectDepth != 0 && notes[index].vibratoEffectSpeed != 0 {
                vibratoEffect.isActive = true
                vibratoEffect.vibratoDepth = notes[index].vibratoEffectDepth
                vibratoEffect.vibratoSpeed = notes[index].vibratoEffectSpeed
            }
            // TODO: Handle lowpass.
        }
    }
}

// MARK: Filter effect

extension RTBChannel {

    public func filterLowpass(bufferSize: Int) {
        guard bufferSize < channelBuffer.count else { return }
        let srcBuffer = channelBuffer
        channelBuffer[0] = lowpassEffect.lastFilterDestLeft
        channelBuffer[1] = lowpassEffect.lastFilterDestRight
        for i in stride(from: 0, to: bufferSize, by: 2) {
            let destSampleLeft = Double(channelBuffer[i])
            let srcSampleLeft = Double(srcBuffer[i])
            let dSampleLeft: Double = (destSampleLeft-srcSampleLeft) * lowpassEffect.amountLeft + srcSampleLeft
            let sampleLeft: Int16 = Int16(max(min(dSampleLeft, Double(INT16_MAX)), Double(INT16_MIN)))
            channelBuffer[i+2] = sampleLeft

            let destSampleRight = Double(channelBuffer[i+1])
            let srcSampleRight = Double(srcBuffer[i+1])
            let dSampleRight: Double = (destSampleRight-srcSampleRight) * lowpassEffect.amountRight + srcSampleRight
            let sampleRight: Int16 = Int16(max(min(dSampleRight, Double(INT16_MAX)), Double(INT16_MIN)))
            channelBuffer[i+3] = sampleRight
        }
        lowpassEffect.lastFilterDestLeft = channelBuffer[bufferSize-2];
        lowpassEffect.lastFilterDestRight = channelBuffer[bufferSize-1];
    }
}
