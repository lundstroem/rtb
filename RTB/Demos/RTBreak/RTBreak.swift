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

public class RTBreak: RTB {

    private var blockEntities: [RTBEntity] = []
    private var ballEntity = RTBEntity(type: .ball, x: 100, y: 170)
    private var padelEntity = RTBEntity(type: .padel, x: 150, y: 200)

    private var boundsLeft: Double = Double(RTB.offset)
    private var boundsRight: Double = Double(RTB.width-RTB.offset-1)

    var elapsedTime = CFAbsoluteTimeGetCurrent()
    var padelOffsetX: Double = 0

    override func setup() {
        super.setup()

        for x in 0...5 {
            for y in 0...5 {
                blockEntities.append(RTBEntity(type: .block, x: Double(x*20)+70, y: Double(y*20)+20))
            }
        }
    }

    override func updateAudio(bufferSize: Int) {
        super.updateAudio(bufferSize: bufferSize)
    }

    override func update(touches: [RTBTouch]?) {
        if let touches = touches {
            if touches.count > 0 && touches[0].active {
                let touchX = Double(touches[0].x)
                if touches[0].began {
                    padelOffsetX = padelEntity.x - touchX
                }
                padelEntity.x = touchX + padelOffsetX
                if padelEntity.x < boundsLeft {
                    padelEntity.x = boundsLeft
                }
                if padelEntity.x+padelEntity.w > boundsRight {
                    padelEntity.x = boundsRight-padelEntity.w
                }
            }
        }
        updateEntities()
    }

    func updateBallBounds() {
        if ballEntity.x > boundsRight-ballEntity.w {
            ballEntity.x = boundsRight-ballEntity.w
            ballEntity.xV = -ballEntity.xV
        }
        if ballEntity.y > Double(RTB.height)-ballEntity.h {
            ballEntity.y = Double(RTB.height)-ballEntity.h
            ballEntity.yV = -ballEntity.yV
        }
        if ballEntity.x < boundsLeft {
            ballEntity.x = boundsLeft
            ballEntity.xV = -ballEntity.xV
        }
        if ballEntity.y < 0 {
            ballEntity.y = 0
            ballEntity.yV = -ballEntity.yV
        }
        if ballEntity.y+ballEntity.w > padelEntity.y &&
            ballEntity.yV > 0 &&
            (ballEntity.y+ballEntity.w - padelEntity.y) < abs(ballEntity.yV) {
            if !(ballEntity.x+ballEntity.w < padelEntity.x || ballEntity.x > padelEntity.x+padelEntity.w) {
                ballEntity.y = padelEntity.y-ballEntity.h
                ballEntity.yV = -ballEntity.yV
            }
        }
    }

    func updateEntities() {
        cls(color: 0x222222ff)
        ballEntity.update()
        updateBallBounds()

        for entity in blockEntities {
            guard entity.active else { continue }
            if entity.intersects(ballEntity) {
                entity.setHit(ballEntity)
                ballEntity.setHit(entity)

                playSfx(note: 60, wave: .noise, speed: 1000)
                playSfx(note: 40, wave: .sine, speed: 20, pitchBend: 4)
                //playSfx(note: 40, wave: .sine, speed: 10, vibratoDepth: 10, vibratoSpeed: 10)
            }
            renderEntity(entity)
        }

        for yPos in 0..<RTB.height {
            drawPixel(x: Int(boundsLeft), y: yPos, color: RTBreak.palette[3])
            drawPixel(x: Int(boundsRight), y: yPos, color: RTBreak.palette[3])
        }

        renderEntity(ballEntity)
        renderEntity(padelEntity)

        for entity in blockEntities {
            entity.hit = false
        }

        //let randomInt = 0xffff00ff
        //let randomInt2 = 0xffffff00

        //for n in 0..<pixelCount {

            
            //drawPixel(x: xPos, y: yPos, color: randomInt)
            //let randomInt = UInt32.random(in: 0..<UINT32_MAX)
            //bytesPointer.advanced(by: n*4).copyMemory(from: [randomInt], byteCount: 4)
        //}
    }

    func renderEntity(_ entity: RTBEntity) {
        for yPos in 0...Int(entity.h)-1 {
            for xPos in 0...Int(entity.w)-1 {
                var color: UInt32 = RTBreak.palette[entity.paletteIndex]
                if entity.hit {
                    color = RTBreak.palette[15]
                }
                drawPixel(x: xPos+Int(entity.x), y: Int(entity.y)+yPos, color: color)
            }
        }
    }

    // MARK: - Graphics

    // zx spectrum palette + transparent on index 0
    public static let palette: [UInt32] = [0x00000000,
                                           0x000000ff,
                                           0x0022c7ff,
                                           0x002bfbff,
                                           0xd62816ff,
                                           0xff331cff,
                                           0xd433c7ff,
                                           0xff40fcff,
                                           0x00c525ff,
                                           0x00f92fff,
                                           0x00c7c9ff,
                                           0x00fbfeff,
                                           0xccc82aff,
                                           0xfffc36ff,
                                           0xcacacaff,
                                           0xffffffff]

}
