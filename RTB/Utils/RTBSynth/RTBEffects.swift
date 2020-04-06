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

public class RTBEffectParam {

    enum RTBEffectParamType {
        case vibrato
        case lowpass
        case pitch
        case unknown
    }
    var type: RTBEffectParamType = .unknown
    var param1: Double = 0
    var param2: Double = 0
}

public protocol RTBEffectProtocol {

    func active() -> Bool
    func reset()
}

public class RTBVibratoEffect: RTBEffectProtocol {

    var isActive = false
    var vibratoDepth = 0.0
    var vibratoSpeed = 0.0

    private let vibratoDepthMod = 0.00001
    private var vibratoPhase = 0.0
    private let sineTable = RTBOscillator.buildSineTable(size: Int(1024))

    func modifiedNote(note: Double) -> Double {
        let bufferSize = 1024.0
        vibratoPhase += vibratoSpeed
        if vibratoPhase >= bufferSize {
            vibratoPhase = vibratoPhase - bufferSize
        }

        let depth = vibratoDepthMod * vibratoDepth
        var phaseInt = Int(vibratoPhase)
        if phaseInt >= 1024 || phaseInt < 0 {
            phaseInt = 0
        }
        let mod = Double(sineTable[phaseInt]) * depth
        return note + mod
    }

    public func active() -> Bool {
        return isActive
    }

    public func reset() {
        vibratoPhase = 0
        isActive = false
    }
}

public class RTBFilterEffect: RTBEffectProtocol {

    var isActive = false
    var amountLeft: Double = 0
    var amountRight: Double = 0

    var lastFilterDestLeft: Int16 = 0
    var lastFilterDestRight: Int16 = 0

    public func active() -> Bool {
        return isActive
    }

    public func reset() {
        lastFilterDestLeft = 0
        lastFilterDestRight = 0
    }
}

public class RTBPitchEffect: RTBEffectProtocol {

    var isActive = false
    private var increment: Double = 0
    private let pitchModifier = 0.001
    private var baseValue = 0.0

    func setIncrement(value: Double) {
        baseValue = value
    }

    func modifiedNote(note: Double) -> Double {
        increment += baseValue * pitchModifier
        return note + increment
    }

    public func active() -> Bool {
        return isActive
    }

    public func reset() {
        baseValue = 0
        isActive = false
    }
}
