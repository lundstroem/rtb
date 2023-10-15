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

    var color: UInt32 = 0xff00ffff
    var bgColor: UInt32 = 0x003300ff

    override func setup() {
        super.setup()
    }

    override func updateAudio(bufferSize: Int) {
        super.updateAudio(bufferSize: bufferSize)
    }

    override func update(touches: [RTBTouch]?) {
        x += xV
        y += yV
        if x > Double(RTB.width)-72 {
            xV = -xV
            playBounceSfx()
            color = UInt32(Int.random(in: 1..<4294967295))
        }
        if y > Double(RTB.height)-8 {
            yV = -yV
            playBounceSfx()
            bgColor = UInt32(Int.random(in: 1..<4294967295))
        }
        if x < 0 {
            xV = -xV
            playBounceSfx()
            color = UInt32(Int.random(in: 1..<4294967295))
        }
        if y < 0 {
            yV = -yV
            playBounceSfx()
            bgColor = UInt32(Int.random(in: 1..<4294967295))
        }
        printLabel(x: Int(x), y: Int(y), string: "hello RTB", color: color, bgColor: bgColor)
    }

    private func playBounceSfx() {
        playSfx(note: 3, wave: .tri, speed: 100)
        playSfx(note: 40, wave: .tri, speed: 30, pitchBend: 7)
    }
}

