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

public class RTBOscillator {

    public enum WaveType {
        case sine
        case tri
        case saw
        case square
        case noise
    }

    private let chromaticRatio = 1.059463094359295264562
    public static let sampleRate: Double = 44100.0
    public static let tableSize = 1024

    private let noiseTable = RTBOscillator.buildNoiseTable(size: Int(sampleRate))
    private let triangleTable = RTBOscillator.buildTriangleTable(size: Int(tableSize))
    private let sawTable = RTBOscillator.buildSawtoothTable(size: Int(tableSize))
    private let squareTable = RTBOscillator.buildSquareTable(size: Int(tableSize))
    private let sineTable = RTBOscillator.buildSineTable(size: Int(tableSize))

    private lazy var waveTable = sineTable
    private var waveType: WaveType = .sine

    var pitch: Double = 0

    private var phaseIncrement: Double = 0
    private var currentPhase: Double = 0
    private var currentPhaseInt: Int = 0

    func setWaveType(waveType: WaveType) {
        self.waveType = waveType
        switch waveType {
        case .sine:
            waveTable = sineTable
        case .tri:
            waveTable = triangleTable
        case .saw:
            waveTable = sawTable
        case .square:
            waveTable = squareTable
        case .noise:
            waveTable = noiseTable
        }
    }

    func reset() {
        pitch = 0
        phaseIncrement = 0
        currentPhase = 0
        currentPhaseInt = 0
    }

    func incrementOsc(_ amplitude: Double) -> Int16 {
        let waveformLength = Double(waveTable.count)

        var delta: Double = 0

        if waveType == .noise {
            delta = (frequency(pitch: pitch) * frequency(pitch: pitch)) / 22000
        } else {
            delta = frequency(pitch: pitch) / RTBOscillator.sampleRate * waveformLength
        }

        currentPhase += delta;
        if currentPhase >= Double(INT_MAX) {
            currentPhase = 0
        }
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
        let sample = Double(waveTable[currentPhaseInt]) * amplitude
        return Int16(sample)
    }

    private func frequency(pitch: Double) -> Double {
        return pow(chromaticRatio, pitch - 57) * 440;
    }

    static func buildSineTable(size: Int) -> [Int16] {
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
        var currentPhase = Double(INT16_MIN)
        for i in 0...size-1 {
            let sample = Int16(max(min(currentPhase, Double(INT16_MAX)), Double(INT16_MIN)))
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
