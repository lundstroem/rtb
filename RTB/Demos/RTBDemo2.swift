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

class RTBDemo2: RTB {

    private var x = 0.0
    private var y = 0.0
    private var xV = 1.5
    private var yV = 0.7
    var start: Bool = true

    var color: UInt32 = 0xff00ffff
    var bgColor: UInt32 = 0x003300ff

    var seq = RTBSequencer()
    var sfxSeq = RTBSequencer()

    override func updateAudio(bufferSize: Int) -> [Int16] {
        advanceSequencers(bufferSize: bufferSize)
        return audioBuffer
    }

    override func update(touches: [RTBTouch]?) -> [UInt32] {
        if start {
            let channel = RTBChannel()
            channel.notes = [40, 64, 79, 60, 55, 45, 64, 79, 60, 55, 45]
            channel.beat = [1]
            channel.amplitude = 0.1
            channel.waveTypes = [.tri, .tri, .tri, .tri, .tri, .tri]
            seq.channels.append(channel)

            let channel2 = RTBChannel()
            channel2.notes = [40, 30, 38, 50, 52]
            channel2.beat = [2]
            channel2.amplitude = 0.05
            channel2.waveTypes = [.sine, .tri, .sine, .saw, .saw, .tri]
            seq.channels.append(channel2)

            seq.loop = true
            seq.bpm = 30
            seq.start()
            RTBSequencer.sequencers.append(seq)

            let sfx = RTBChannel()
            sfx.notes = [40, 30, 28]
            sfx.beat = [32]
            sfx.waveTypes = [.noise, .saw, .tri]
            sfxSeq.channels.append(sfx)
            RTBSequencer.sequencers.append(sfxSeq)

            start = false
        }
        x += xV
        y += yV
        if x > Double(width)-40 {
            xV = -xV
            sfxSeq.start()
            color = UInt32(Int.random(in: 1..<4294967295))
        }
        if y > Double(height)-8 {
            yV = -yV
            sfxSeq.start()
            bgColor = UInt32(Int.random(in: 1..<4294967295))
        }
        if x < 0 {
            xV = -xV
            sfxSeq.start()
        }
        if y < 0 {
            yV = -yV
            sfxSeq.start()
        }
        printLabel(x: Int(x), y: Int(y), string: "hello", color: color, bgColor: bgColor)
        return raster
    }
}

