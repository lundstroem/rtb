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

    public func advanceSequencers(bufferSize: Int) {
        guard bufferSize < audioBuffer.count else { return }
        for n in 0..<bufferSize {
            audioBuffer[n] = 0
        }
        for seq in RTBSequencer.sequencers {
            for channel in seq.channels {
                guard channel.active else { continue }
                channel.advanceChannel(bufferSize: bufferSize, bpm: seq.bpm, loop: seq.loop)
                for n in 0..<bufferSize {
                    audioBuffer[n] += channel.channelBuffer[n]
                }
            }
        }
    }
}

public class RTBNote {

    var note: Double = 0
    var waveType: RTBOscillator.WaveType = .sine
    var effects: [RTBEffectParam] = []
    init(_ note: Double) {
        self.note = note
    }
}

public class RTBSequencer {

    public static var sequencers: [RTBSequencer] = []
    var loop: Bool = false
    var bpm: Double = 60
    var channels: [RTBChannel] = []

    func play() {
        for channel in channels {
            channel.active = true
        }
    }

    func stop() {
        for channel in channels {
            channel.active = false
        }
    }

    func rewind() {
        for channel in channels {
            channel.active = false
        }
    }
}
