//
//  RTBDemo2.swift
//  RTB
//
//  Created by Harry Lundstrom on 2019-11-25.
//  Copyright © 2019 Harry Lundstrom. All rights reserved.
//

class RTBDemo2: RTB {

    override init() {
        super.init()
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

        let pixel = inputX + inputY * width

        if inputActive && pixel < pixelCount {
            raster[inputX + inputY * width] = UInt32(Int.random(in: 0 ..< 160000))
        }
        return raster
    }
}
