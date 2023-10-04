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

class RTBDemo4: RTB {

    override func setup() {
        for x in 0...RTB.width-1 {
            for y in 0...RTB.height-1 {

                drawPixel(x: x, y: y, color: 0x333300ff)

                if (x / 2) + (x / 2) == x {
                    drawPixel(x: x, y: y, color: 0x3355ffff)
                }
                if (y / 2) + (y / 2) == y {
                    drawPixel(x: x, y: y, color: 0x992233ff)
                }
                if x == 0 {
                    drawPixel(x: x, y: y, color: 0xff00ffff)
                }
                if y == 0 {
                    drawPixel(x: x, y: y, color: 0xffff00ff)
                }
                if y == RTB.height-1 {
                    drawPixel(x: x, y: y, color: 0xffffffff)
                }
                if x == RTB.width-1 {
                    drawPixel(x: x, y: y, color: 0xff00ffff)
                }
                if x == RTB.offset {
                    drawPixel(x: x, y: y, color: 0xffffffff)
                }
                if x == RTB.width - RTB.offset-1 {
                    drawPixel(x: x, y: y, color: 0xffffffff)
                }
            }
        }
    }

    override func updateAudio(bufferSize: Int) {
    }

    override func update(touches: [RTBTouch]?) {
        if let touches = touches {
            for touch in touches {
                let pixel = touch.x + touch.y * RTB.width

                // Plot began and ended touches

                if touch.active && touch.began && pixel < pixelCount {
                    drawPixel(x: touch.x, y: touch.y, color: 0xffffffff)
                    print("began x:\(touch.x) y:\(touch.y)")
                }

                if touch.active && touch.ended && pixel < pixelCount {
                    drawPixel(x: touch.x, y: touch.y, color: 0xffff00ff)
                    print("ended x:\(touch.x) y:\(touch.y)")
                }
            }
        }
    }
}
