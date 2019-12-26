//
//  RTBDemo2.swift
//  RTB
//
//  Created by Harry Lundstrom on 2019-11-25.
//  Copyright © 2019 Harry Lundstrom. All rights reserved.
//

class RTBDemo4: RTB {

    var written = false

    override init(orientation: Orientation) {
        super.init(orientation: orientation)
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

        if !written {
            for x in 0...width-1 {
                for y in 0...height-1 {

                    drawPixel(x: x, y: y, color: 0x333300ff)
                    if (x / 2) + (x / 2) == x {
                        drawPixel(x: x, y: y, color: 0x3355ffff)
                    }
                    if (y / 2) + (y / 2) == y {
                        drawPixel(x: x, y: y, color: 0x992233ff)
                    }

                    if x == 0 || y == 0 || y == height-1 || x == width-1{
                        drawPixel(x: x, y: y, color: 0xff0000ff)
                    }
                    /*
                    if y == height-1 {
                        drawPixel(x: x, y: y, color: 0xff00ffff)
                    }
                    if x == width-1 {
                        drawPixel(x: x, y: y, color: 0xff00ffff)
                    }
                    if x == 0 && x == 0 {
                        drawPixel(x: x, y: y, color:  0xffffffff)
                    }*/
                }
            }
            written = true
        }
        let pixel = inputY + inputX * height

        if inputActive && pixel < pixelCount {
            drawPixel(x: inputX, y: inputY, color: 0xffff00ff)
        }

        print("x:\(inputX) y:\(inputY)")

        return raster

    }
}
