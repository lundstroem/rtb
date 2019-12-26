//
//  RTB.swift
//  RTB
//
//  Created by Harry Lundstrom on 2019-07-30.
//  Copyright © 2019 Harry Lundstrom. All rights reserved.
//

import Foundation

@objc enum Orientation: Int {
    case landscape
    case portrait
}

protocol RTBProtocol {
    func updateAudio(bufferSize: Int) -> [Int16]
    func update(deltaTime: Double,
                rasterSize: Int,
                inputActive: Bool,
                inputX: Int,
                inputY: Int,
                inputBegan: Bool,
                inputEnded: Bool) -> [UInt32]
}

@objcMembers
public class RTB: NSObject {
    var width: Int = 180
    var height: Int = 320
    let pixelCount: Int = 57600
    let orientation: Orientation
    var raster: [UInt32] = Array(repeating: 0, count: 57600)
    var audioBuffer: [Int16] = Array(repeating: 0, count: 8192)

    @objc static func instance() -> RTB {
        return RTBDemo4(orientation: .portrait)
    }

    @objc func isPortrait() -> Bool {
        return orientation == .portrait
    }

    init(orientation: Orientation) {
        self.orientation = orientation
        if orientation == .portrait {
            self.width = 180
            self.height = 320
        } else {
            self.width = 320
            self.height = 180
        }
        super.init()
    }
}

extension RTB {

    func drawPixel(x: Int, y: Int, color: UInt32) {
        // Override for optimizations.

        var index = x + y * width
        if orientation == .landscape {
            index = abs(y-179) + x * height
        }
        if index > -1 && index < pixelCount {
            raster[index] = color
        }
    }
}

// MARK: - RTBProtocol

@objc extension RTB: RTBProtocol {

    func updateAudio(bufferSize: Int) -> [Int16] {
        assert(true, "should only be run in subclass")
        return audioBuffer
    }

    func update(deltaTime: Double,
                rasterSize: Int,
                inputActive: Bool,
                inputX: Int,
                inputY: Int,
                inputBegan: Bool,
                inputEnded: Bool) -> [UInt32] {
        assert(true, "should only be run in subclass")
        return raster
    }
}
