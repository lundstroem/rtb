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

enum RTBEntityType {
    case ball
    case padel
    case block
}

class RTBEntity {

    let type: RTBEntityType
    var hp: Int = 1
    var x: Double = 0
    var y: Double = 0
    var w: Double = 0
    var h: Double = 0
    var xV: Double = 0
    var yV: Double = 0
    var active = true
    var hit = false
    var paletteIndex = 0

    init(type: RTBEntityType, x: Double, y: Double) {
        self.type = type
        self.x = x
        self.y = y
        switch type {
        case .ball:
            paletteIndex = 2
            w = 16
            h = 16
            xV = Double.random(in: 0..<3)+2
            yV = -(Double.random(in: 0..<2)+2)
        case .padel:
            paletteIndex = 3
            w = 32
            h = 2
        case .block:
            paletteIndex = 4
            w = 16
            h = 16
        }
    }

    func update() {
        switch type {
        case .ball:
            pendingMove()
        case .padel:
            break
        case .block:
            break
        }
    }

    func setHit(_ entity: RTBEntity) {
        switch type {
        case .ball:
            calibrateBallCollision(entity)
            break
        case .padel:
            break
        case .block:
            hit = true
            hp -= 1
            if hp == 0 {
                active = false
            }
            break
        }
    }

    func pendingMove() {
        x += xV
        y += yV
    }

    func calibrateBallCollision(_ entity: RTBEntity) {

        // Reset last move
        x -= xV
        y -= yV

        let xIncrement = xV / 10
        let yIncrement = yV / 10
        var intersected = false

        // Increment steps before collision
        while !intersected {
            x += xIncrement
            y += yIncrement
            let isIntersected = intersects(entity)
            if isIntersected {
                intersected = true
                ballCollisionResponse(entity: entity)
                x -= xIncrement
                y -= yIncrement
            }
        }
    }

    func ballCollisionResponse(entity: RTBEntity) {
        let centerX = x + w/2
        let centerY = y + h/2
        let entityCenterX = entity.x + entity.w/2
        let entityCenterY = entity.y + entity.h/2

        let xDiff = abs(centerX - entityCenterX)
        let yDiff = abs(centerY - entityCenterY)

        if xDiff == yDiff {
            xV = -xV
            yV = -yV
        } else if xDiff > yDiff {
            xV = -xV
        } else {
            yV = -yV
        }
    }

    func intersects(_ entity: RTBEntity) -> Bool {
        if entity.x+entity.w < x || entity.x > x+w {
            return false
        }
        if entity.y+entity.h < y || entity.y > y+h {
            return false
        }
        return true
    }
}
