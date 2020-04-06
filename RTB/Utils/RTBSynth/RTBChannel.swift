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
    var beat: [Double] = []
    let osc = RTBOscillator()
    let vibratoEffect = RTBVibratoEffect()
    let lowpassEffect = RTBFilterEffect()
    let pitchEffect = RTBPitchEffect()
    var beatCursor: Int = 0
    var sampleCursor: Double = 0
    var active = false
    var amplitude = 0.5
    let effectTickLimit = 64
    var effectTickCounter = 0
    var currentNote: Double = 0
    var started = false

    public func advanceChannel(bufferSize: Int, bpm: Double, loop: Bool) {
        for n in 0..<bufferSize {
            channelBuffer[n] = 0
        }
        for n in stride(from: 0, to: bufferSize, by: 2) {
            let sample = increment(bufferSize: 2, bpm: bpm, loop: loop)
            guard
                channelBuffer[n]+sample < INT16_MAX &&
                    channelBuffer[n]+sample > INT16_MIN &&
                    channelBuffer[n+1]+sample < INT16_MAX &&
                    channelBuffer[n+1]+sample > INT16_MIN
                else { continue }
            channelBuffer[n] += sample
            channelBuffer[n+1] += sample
        }
        if vibratoEffect.active() {
            filterLowpass(bufferSize: bufferSize)
        }
    }

    private func increment(bufferSize: Int, bpm: Double, loop: Bool) -> Int16 {
        guard notes.count > 0, active else { return Int16(0) }
        if !started {
            activateNote(0)
            started = true
        }
        let currentSampleCursor = Int(sampleCursor)
        var currentBeat: Double = 1
        if beatCursor < beat.count {
            currentBeat = beat[beatCursor]
        }
        let sampleTimeMod = (bpm / ((RTBOscillator.sampleRate * 2) * 60.0) * Double(bufferSize)) * currentBeat
        sampleCursor += sampleTimeMod
        if Int(sampleCursor) > currentSampleCursor {
            beatCursor += 1
            if beatCursor >= beat.count {
                beatCursor = 0
            }
            let newSampleCursor = Int(sampleCursor)
            if newSampleCursor < notes.count {
                activateNote(newSampleCursor)
            } else {
                if !loop {
                    active = false
                }
                sampleCursor = 0
                activateNote(0)
            }
        }

        applyEffects()

        return osc.incrementOsc(amplitude)
    }

    private func applyEffects() {
        effectTickCounter += 1
        if effectTickCounter >= effectTickLimit {
            effectTickCounter = 0
            var note: Double = currentNote
            if pitchEffect.active() {
                note = pitchEffect.modifiedNote(note: note)
            }
            if vibratoEffect.active() {
                note = vibratoEffect.modifiedNote(note: note)
            }
            osc.tone = note
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
            currentNote = notes[index].note
            osc.tone = notes[index].note
            osc.setWaveType(waveType: notes[index].waveType)
            for effectParam in notes[index].effects{
                switch effectParam.type {
                case .vibrato:
                    vibratoEffect.isActive = true
                    vibratoEffect.vibratoSpeed = effectParam.param1
                    vibratoEffect.vibratoDepth = effectParam.param2
                case .lowpass:
                    lowpassEffect.isActive = true
                    lowpassEffect.amountLeft = effectParam.param1
                    lowpassEffect.amountRight = effectParam.param2
                    break
                case .pitch:
                    pitchEffect.isActive = true
                    pitchEffect.setIncrement(value: effectParam.param1)
                    break
                case .unknown:
                    break
                }
            }
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
