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

    var seq = RTBSequencer()

    override func updateAudio(bufferSize: Int) -> [Int16] {
        writeSamples(bufferSize: bufferSize)
        return audioBuffer
    }

    override func update(touches: [RTBTouch]?) -> [UInt32] {
        if start {
            seq.notes = [40, 64, 79, 60, 55, 45]
            seq.loop = true
            RTBSequencer.sequencers.append(seq)
            start = false
        }
        x += xV
        y += yV
        if x > Double(width) {
            xV = -xV
        }
        if y > Double(height) {
            yV = -yV
        }
        if x < 0 {
            xV = -xV
        }
        if y < 0 {
            yV = -yV
        }
        printLabel(x: Int(x), y: Int(y), string: "hello", color: 0xff00ffff, bgColor: 0x003300ff)
        return raster
    }
}

