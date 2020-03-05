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

extension RTB {

    public func writeSamples(bufferSize: Int) {
        guard bufferSize < audioBuffer.count else { return }
        for seq in RTBSequencer.sequencers {
            for n in stride(from: 0, to: bufferSize, by: 2) {
                let sample = seq.increment(bufferSize: 2)
                audioBuffer[n] = sample
                audioBuffer[n+1] = sample
            }
        }
    }
}

public class RTBSequencer {

    public static var sequencers: [RTBSequencer] = []
    var sampleCursor: Double = 0
    var loop: Bool = false
    var bpm: Double = 60
    var notes: [Double] = []
    // TODO: Change waveforms.
    var waves: [Int] = [0]
    let osc = RTBOscillator()

    public func increment(bufferSize: Int) -> Int16 {
        guard notes.count > 0 else { return Int16(0) }
        let currentSampleCursor = Int(sampleCursor)
        let sampleTimeMod = (bpm / ((RTBOscillator.sampleRate * 2) * 60.0) * Double(bufferSize))
        sampleCursor += sampleTimeMod
        if Int(sampleCursor) > currentSampleCursor {
            let newSampleCursor = Int(sampleCursor)
            if newSampleCursor < notes.count {
                osc.tone = notes[newSampleCursor]
            } else {
                sampleCursor = 0
                osc.tone = notes[0]
            }
        }
        return osc.incrementOsc()
    }
}

public class RTBOscillator {
    private let chromaticRatio = 1.059463094359295264562
    public static let sampleRate: Double = 44100.0

    private let noiseTable = RTBOscillator.buildNoiseTable(size: Int(sampleRate))
    private let triangleTable = RTBOscillator.buildSineTable(size: Int(sampleRate))
    private let sawTable = RTBOscillator.buildSineTable(size: Int(sampleRate))
    private let squareTable = RTBOscillator.buildSineTable(size: Int(sampleRate))
    private let sineTable = RTBOscillator.buildSineTable(size: Int(sampleRate))

    private let waveTable = RTBOscillator.buildSineTable(size: Int(sampleRate))

    var tone: Double = 50
    private var phaseIncrement: Double = 0
    private var currentPhase: Double = 0
    private var currentPhaseInt: Int = 0

    func incrementOsc() -> Int16 {
        let waveformLength = Double(waveTable.count)
        let delta = frequency(pitch: tone) / RTBOscillator.sampleRate * waveformLength
        currentPhase += delta;
        currentPhaseInt = Int(currentPhase)
        if currentPhase >= waveformLength {
            let diff = currentPhase - waveformLength;
            currentPhase = diff;
            currentPhaseInt = Int(diff)
        }
        if currentPhaseInt >= waveTable.count {
            currentPhase = 0
            currentPhaseInt = 0
        }
        let sample = Double(waveTable[currentPhaseInt]) * 0.3
        return Int16(sample)
    }

    private func frequency(pitch: Double) -> Double {
        return pow(chromaticRatio, pitch - 57) * 440;
    }

    private static func buildSineTable(size: Int) -> [Int16] {
        var table: [Int16] = Array(repeating: 0, count: size)
        let phaseIncrement: Double = (2 * Double.pi) / Double(size)
        var currentPhase: Double = 0
        for i in 0...size-1 {
            let sample: Int16 = Int16(sin(currentPhase) * Double(INT16_MAX))
            table[i] = sample
            currentPhase += phaseIncrement
        }
        return table
    }

    private static func buildSawtoothTable(size: Int) -> [Int16] {
        var table: [Int16] = Array(repeating: 0, count: size)
        let phaseIncrement = Double(INT16_MAX) * 2.0 / Double(size)
        var currentPhase: Double = 0.0
        for i in 0...size-1 {
            let sample = Int16(INT16_MAX)-Int16(min(currentPhase, Double(INT16_MAX)))
            table[i] = sample;
            currentPhase += phaseIncrement;
        }
        return table
    }

    private static func buildSquareTable(size: Int) -> [Int16] {
        var table: [Int16] = Array(repeating: 0, count: size)
        for i in 0...size-1 {
            var sample: Int16 = Int16(INT16_MAX)
            if i > size/2 {
                sample = Int16(INT16_MIN)
            }
            table[i] = sample
        }
        return table
    }

    private static func buildTriangleTable(size: Int) -> [Int16] {
        var table: [Int16] = Array(repeating: 0, count: size)
        let phaseIncrement = (Double(INT16_MAX) * 2 / Double(size)) * 2
        var currentPhase = Double(-INT16_MIN)
        for i in 0...size-1 {
            let sample = Int16(currentPhase)
            table[i] = sample
            if i < size/2 {
                currentPhase += phaseIncrement
            } else {
                currentPhase -= phaseIncrement
            }
        }
        return table
    }

    private static func buildNoiseTable(size: Int) -> [Int16] {
        var table: [Int16] = Array(repeating: 0, count: size)
        for i in 0...size-1 {
            table[i] = Int16(Int.random(in: Int(INT16_MIN) ..< Int(INT16_MAX)))
        }
        return table
    }
}

extension RTB {

    func filterLowpass(bufferSize: Int) {
        guard bufferSize < audioBuffer.count else { return }
        let srcBuffer = audioBuffer

        audioBuffer[0] = RTBFilter.lastFilterDest
        for i in stride(from: 0, to: bufferSize, by: 1) {
            // TODO: Need to make it work with interleaved?
            let destSample = Double(audioBuffer[i])
            let srcSample = Double(srcBuffer[i])
            let dSample: Double = (destSample-srcSample) * RTBFilter.amount + srcSample
            let sample: Int16 = Int16(max(min(dSample, Double(INT16_MAX)), Double(INT16_MIN)))
            audioBuffer[i+1] = sample
        }
        RTBFilter.lastFilterDest = audioBuffer[bufferSize-1];
    }
}

public class RTBFilter {

    public static var amount: Double = 0
    public static var lastFilterDest: Int16 = 0
    func filterLowpass(src: [Int16], dest: [Int16], length: Int, amount: Double) {


    }

    /* TODO: Highpass
     static void vlk_tr_filter_lowpass(float *src, float *dest, int length, double amount) {
         int i;
         if(src == dest) {
             vlk_error_log("vlk_tr_lowpass source cannot be same as destination.");
         }
         /* https://www.electronicspoint.com/threads/digital-high-pass-filter.100423/ */
         /* lowpass */
         dest[0] = vlk_tr_last_filter_dest;
         for(i = 0; i < length-1; i++) {
             dest[i+1] = (dest[i]-src[i]) * /*0.99f*/amount + src[i];
         }
         vlk_tr_last_filter_dest = dest[length-1];
     }

     static void vlk_tr_filter_highpass(float *src, float *dest, int length, double amount) {
         int i;
         if(src == dest) {
             vlk_error_log("vlk_tr_lowpass source cannot be same as destination.");
         }
         dest[0] = vlk_tr_last_filter_dest;
         /* https://en.wikipedia.org/wiki/High-pass_filter */
         /* highpass */
         for(i = 1; i < length; i++) {
             dest[i] = /*0.1f*/amount * (dest[i-1] + src[i] - src[i-1]);
         }
         vlk_tr_last_filter_dest = dest[length-1];
     }
     */
}

public class RTBSynth {

    public static let sharedInstance = RTBSynth()
    public let osc = RTBOscillator()
}
