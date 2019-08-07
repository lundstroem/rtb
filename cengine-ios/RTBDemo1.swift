//
//  RTB_demo_1.swift
//  RTB
//
//  Created by Harry Lundstrom on 2019-08-07.
//  Copyright © 2019 Harry Lundstrom. All rights reserved.
//

import Foundation

class RTBDemo1: RTB {
    override func create() {
    }

    override func update(deltaTime: Double,
                rasterSize: Int,
                audioBufferSize: Int,
                inputUpdated: Bool,
                inputX: Int,
                inputY: Int,
                inputBegan: Bool,
                inputEnded: Bool) -> [UInt32] {
         /*for index in 0...rasterSize-1 {
            raster[index] = 0x0000ffff
         }*/
        let pixel = inputX + inputY * width

        if inputBegan && pixel < pixelCount {
            raster[inputX + inputY * width] = 0xff0000ff
        }
        return raster
    }
}
