//
//  RTB.swift
//  RTB
//
//  Created by Harry Lundstrom on 2019-07-30.
//  Copyright © 2019 Harry Lundstrom. All rights reserved.
//

import Foundation

protocol RTBProtocol {
    func create()
    func updateAudio(bufferSize: Int) -> [Int16]
    func update(deltaTime: Double,
                rasterSize: Int,
                inputUpdated: Bool,
                inputX: Int,
                inputY: Int,
                inputBegan: Bool,
                inputEnded: Bool) -> [UInt32]
}

public class RTB: NSObject {
    let width: Int = 180
    let height: Int = 320
    let pixelCount: Int = 57600

    var raster: [UInt32] = Array(repeating: 0, count: 57600)
    var audioBuffer: [Int16] = Array(repeating: 0, count: 8192)

    @objc static func instance() -> RTB {
        return RTBDemo1()
    }

    override init() {
        super.init()
    }
}

// MARK: - RTBProtocol

extension RTB: RTBProtocol {

    @objc func create() {
        assert(true, "should only be run in subclass")
    }

    @objc func updateAudio(bufferSize: Int) -> [Int16] {
        assert(true, "should only be run in subclass")
        let buffer: [Int16] = Array(repeating: 0, count: 8192)
        return buffer
    }

    @objc func update(deltaTime: Double,
                      rasterSize: Int,
                      inputUpdated: Bool,
                      inputX: Int,
                      inputY: Int,
                      inputBegan: Bool,
                      inputEnded: Bool) -> [UInt32] {
        assert(true, "should only be run in subclass")
        let raster: [UInt32] = Array(repeating: 0, count: 57600)
        return raster
    }
}
