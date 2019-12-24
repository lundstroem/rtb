//
//  RTBDemo2.swift
//  RTB
//
//  Created by Harry Lundstrom on 2019-11-25.
//  Copyright © 2019 Harry Lundstrom. All rights reserved.
//

class RTBDemo3: RTB {

    var written = false
    var portrait = false // Convert coordinate systems between portrait and landscape.

    override init(width: Int, height: Int) {
        super.init(width: width, height: height)
    }

    override func updateAudio(bufferSize: Int) -> [Int16] {
        guard bufferSize < audioBuffer.count else { return audioBuffer }
        for n in stride(from: 0, to: bufferSize, by: 2) {
            audioBuffer[n] = 0
            audioBuffer[n+1] = 0
        }
        return audioBuffer
    }

    override func update(deltaTime: Double,
                         rasterSize: Int,
                         inputActive: Bool,
                         inputX: Int,
                         inputY: Int,
                         inputBegan: Bool,
                         inputEnded: Bool) -> [UInt32] {

        var l_width = 320
        var l_height = 180
        var l_inputX = inputY
        var l_inputY = abs(inputX-180)

        if portrait {
            l_width = 180
            l_height = 320
            l_inputX = inputX
            l_inputY = inputY
        }

        if !written {
            for x in 0...l_width-1 {
                for y in 0...l_height-1 {

                    drawPixel(x: x, y: y, w: l_width, h: l_height, color: 0x333300ff)
                    if (x / 2) + (x / 2) == x {
                        drawPixel(x: x, y: y, w: l_width, h: l_height, color: 0x3355ffff)
                    }
                    if (y / 2) + (y / 2) == y {
                        drawPixel(x: x, y: y, w: l_width, h: l_height, color: 0x992233ff)
                    }
                    if x == 0 || y == 0 {
                        drawPixel(x: x, y: y, w: l_width, h: l_height, color: 0xffffffff)
                    }
                    if y == l_height-1 {
                        drawPixel(x: x, y: y, w: l_width, h: l_height, color: 0xff00ffff)
                    }
                    if x == l_width-1 {
                        drawPixel(x: x, y: y, w: l_width, h: l_height, color: 0xff00ffff)
                    }
                    if x == 0 && x == 0 {
                        drawPixel(x: x, y: y, w: l_width, h: l_height, color:  0xffffffff)
                    }
                }
            }
            written = true
        }
        let pixel = l_inputY + l_inputX * l_height

        if inputActive && pixel < pixelCount {
            drawPixel(x: l_inputX, y: l_inputY, w: l_width, h: l_height, color: 0xffff00ff)
        }

        print("x:\(l_inputX) y:\(l_inputY)")

        return raster
    }

    func drawPixel(x: Int, y: Int, w: Int, h: Int, color: UInt32) {
        var index = abs(y-180) + x * h
        if portrait {
            index = x + y * w
        }
        if index > -1 && index < 57600 {
            raster[index] = color
        }
    }
}
