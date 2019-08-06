//
//  RTB.swift
//  RTB
//
//  Created by Harry Lundstrom on 2019-07-30.
//  Copyright © 2019 Harry Lundstrom. All rights reserved.
//

import Foundation

public class Input: NSObject {
    public var x: Int = 0
    public var y: Int = 0
    @objc public var active: Bool = false
    public var began: Bool = false
    public var began_lock: Bool = false
    public var ended: Bool = false

    override init() {
        super.init()
    }
}

public class RTB: NSObject {
    
    // input
    var inputX: Int = 0
    var inputY: Int = 0
    var inputActive: Bool = false
    var inputBegan: Bool = false
    var inputBeganLock: Bool = false
    var inputEnded: Bool = false

    let width: Int = 180
    let height: Int = 320
    let pixelCount: Int = 57600

    // TODO: set count in init.
    var raster: [UInt32] = Array(repeating: 0, count: 57600)
    override init() {
        super.init()
    }

    @objc func updateInputCoordinates(x: Int, y: Int) {
        self.inputX = x;
        self.inputY = y;
    }

    @objc func updateInputState(began: Bool, ended: Bool) {
        if began && !inputBeganLock {
            inputActive = true
            inputBeganLock = true // set began lock at the end of cycle to catch began event.
        } else if ended {
            inputActive = false // set ended at end of cycle to catch event.
            inputBeganLock = false
        }

        self.inputBegan = began;
        self.inputEnded = ended;
    }

    // TODO: Send touches array as param as well.
    @objc func updateWith(deltaTime: Double, rasterSize: Int, audioBufferSize: Int) -> [UInt32] {
        for index in 0...rasterSize-1 {
           // raster[index] = 0x0000ffff
        }
        let pixel = inputX + inputY * width
        if inputActive && pixel < pixelCount {
            raster[inputX + inputY * width] = 0xff00ffff
        }
        return raster
    }
}
