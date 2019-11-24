//
//  RTB_demo_1.swift
//  RTB
//
//  Created by Harry Lundstrom on 2019-08-07.
//  Copyright © 2019 Harry Lundstrom. All rights reserved.
//

import Foundation

class RTBDemo1: RTB {

    var inputActive = false

    override func create() {
    }

    override func updateAudio(bufferSize: Int) -> [Int16] {
        guard bufferSize < audioBuffer.count else { return audioBuffer }
        for n in 0...bufferSize-1 {
            audioBuffer[n] = Int16(Int.random(in: -16000 ..< 16000))
        }
        return audioBuffer
    }

    override func update(deltaTime: Double,
                rasterSize: Int,
                inputUpdated: Bool,
                inputX: Int,
                inputY: Int,
                inputBegan: Bool,
                inputEnded: Bool) -> [UInt32] {
         /*for index in 0...rasterSize-1 {
            raster[index] = 0x0000ffff
         }*/
        if inputBegan {
            
        }
        
        let pixel = inputX + inputY * width

        if inputBegan && pixel < pixelCount {
            raster[inputX + inputY * width] = 0xff0000ff
        }
        return raster
    }
}
