//
//  RTB_demo_1.swift
//  RTB
//
//  Created by Harry Lundstrom on 2019-08-07.
//  Copyright © 2019 Harry Lundstrom. All rights reserved.
//

import Foundation

class RTBDemo3: RTB {

    override init(orientation: Orientation) {
        super.init(orientation: orientation)
    }

    override func updateAudio(bufferSize: Int) -> [Int16] {
        return audioBuffer
    }

    override func update(deltaTime: Double,
                         rasterSize: Int,
                         inputActive: Bool,
                         inputX: Int,
                         inputY: Int,
                         inputBegan: Bool,
                         inputEnded: Bool) -> [UInt32] {
        return raster
    }
}

