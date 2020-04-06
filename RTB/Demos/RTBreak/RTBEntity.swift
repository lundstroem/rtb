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

enum EntityType {
    case ball
    case padel
    case block
}

class Entity {

    let type: EntityType
    var x: Double = 0
    var y: Double = 0
    var w: Double = 0
    var h: Double = 0
    var xV: Double = 0
    var yV: Double = 0
    var active = true
    var paletteIndex = 0

    init(type: EntityType, x: Double, y: Double) {
        self.type = type
        self.x = x
        self.y = y
        switch type {
        case .ball:
            paletteIndex = 2
            w = 8
            h = 8
            xV = 1.367
            yV = 1.414
        case .padel:
            paletteIndex = 3
            w = 16
            h = 8
        case .block:
            paletteIndex = 4
            w = 16
            h = 16
        }
    }

    func gfx() -> [[Int]] {
        switch type {
        case .ball:
            return RTBreak.gfxBall
        case .padel:
            return RTBreak.gfxPadel
        case .block:
            return RTBreak.gfxBlock
        }
    }

    func update() {
        switch type {
        case .ball:
            x += xV
            y += yV
            if x > Double(RTB.width)-8 {
                xV = -xV
            }
            if y > Double(RTB.height)-8 {
                yV = -yV
            }
            if x < 0 {
                xV = -xV
            }
            if y < 0 {
                yV = -yV
            }
        case .padel:
            break
        case .block:
            break
        }
    }

    func interSects(entity: Entity) -> Bool {
        if entity.x+entity.w > x+w ||
            entity.x+entity.w < x {
            return false
        }
        if entity.y+entity.h > y+h ||
            entity.y+entity.h < y {
            return false
        }
        return true
    }
}
