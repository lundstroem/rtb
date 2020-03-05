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

protocol RTBProtocol {
    func updateAudio(bufferSize: Int) -> [Int16]
    func update(touches: [RTBTouch]?) -> [UInt32]
}

@objcMembers public class RTBTouch: NSObject {
    var x: Int = 0
    var y: Int = 0
    var active: Bool = false
    var began: Bool = false
    var beganLock: Bool = false
    var ended: Bool = false
    var endedLock: Bool = false
}

@objc public class RTB: NSObject {
    @objc var width: Int = 256
    @objc var height: Int = 256
    let offset = 56
    let pixelCount: Int = 65536
    var raster: [UInt32] = Array(repeating: 0, count: 65536)
    var audioBuffer: [Int16] = Array(repeating: 0, count: 8192)

    @objc static func instance() -> RTB {
        return RTBDemo2()
    }
}

extension RTB {

    func drawPixel(x: Int, y: Int, color: UInt32) {
        let index =  x + y * width
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

    func update(touches: [RTBTouch]?) -> [UInt32] {
        assert(true, "should only be run in subclass")
        return raster
    }
}
