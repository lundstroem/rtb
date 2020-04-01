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
    func setup()
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
    var audioBuffer: [Int16] = Array(repeating: 0, count: 4096)
    @objc static var instance: RTB = {
        let instance = RTBDemo2()
        instance.setup()
        return instance
    }()
}

extension RTB {

    func drawPixel(x: Int, y: Int, color: UInt32) {
        if x > 0 && y > 0 && x < width && y < height {
            let index =  x + y * width
            raster[index] = color
        }
    }
}

// MARK: - RTBProtocol

@objc extension RTB: RTBProtocol {

    /// Run at the start of the program.
    func setup() {
        assert(true, "should only be run in subclass")
    }

    /// Updated every time the audio system needs new samples. Is run on a prioritized audio thread.
    func updateAudio(bufferSize: Int) -> [Int16] {
        assert(true, "should only be run in subclass")
        return audioBuffer
    }

    /// Updated every time the screen is to be redrawn, target 60fps.
    func update(touches: [RTBTouch]?) -> [UInt32] {
        assert(true, "should only be run in subclass")
        return raster
    }
}
