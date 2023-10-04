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
    func updateAudio(bufferSize: Int)
    func update(touches: [RTBTouch]?)
    func willTerminate()
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
    @objc static let width: Int = 256
    @objc static let height: Int = 256
    static let offset = 56
    let pixelCount: Int = 65536
    @objc let bytesPointer = UnsafeMutableRawPointer.allocate(byteCount: 65536*4,
                                                              alignment: MemoryLayout<UInt32>.alignment)
    

    let audioBufferCount = 8192
    @objc let audioBytesPointer = UnsafeMutableRawPointer.allocate(byteCount: 8192*2,
                                                                   alignment: MemoryLayout<Int16>.alignment)
    @objc static var instance: RTB = {
        let instance = RTBreak()
        instance.setup()
        return instance
    }()

    /// Run at the start of the program.
    func setup() {
        bytesPointer.storeBytes(of: 0x00000000, as: UInt32.self)
        for n in 0..<65536 {
            bytesPointer.advanced(by: n*4).copyMemory(from: [0], byteCount: 4)
        }

        audioBytesPointer.storeBytes(of: 0x00000000, as: Int16.self)
        for n in 0..<8192 {
            bytesPointer.advanced(by: n*2).copyMemory(from: [0], byteCount: 2)
        }
    }
}

extension RTB {

    func drawPixel(x: Int, y: Int, color: UInt32) {
        if x > -1 && y > -1 && x < RTB.width && y < RTB.height {
            let index =  x + y * RTB.width
            bytesPointer.advanced(by: index*4).copyMemory(from: [color], byteCount: 4)
        }
    }

    func cls(color: UInt32) {
        for n in 0..<pixelCount {
            bytesPointer.advanced(by: n*4).copyMemory(from: [color], byteCount: 4)
        }
    }
}

// MARK: - RTBProtocol

@objc extension RTB: RTBProtocol {

    /// Updated every time the audio system needs new samples. Is run on a prioritized audio thread.
    func updateAudio(bufferSize: Int) {
        assert(true, "should only be run in subclass")
    }

    /// Updated every time the screen is to be redrawn, target 60fps.
    func update(touches: [RTBTouch]?) {
        assert(true, "should only be run in subclass")
    }
    
    func willTerminate() {
        bytesPointer.deallocate()
        audioBytesPointer.deallocate()
    }
}
