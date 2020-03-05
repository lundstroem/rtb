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


extension RTB {

    public func printLabel(x: Int, y: Int, string: String, color: UInt32, bgColor: UInt32) {
        let charWidth = 8
        var offset = 0
        for char in string {
            let asciiValue = Character(String(char)).isASCII ? Character(String(char)).asciiValue : 63
            let charPixels: [Int] = RTBChars.charMap(asciiValue: asciiValue)
            for xPos in 0...charWidth-1 {
                for yPos in 0...charWidth-1 {
                    let index =  xPos + yPos * charWidth
                    if index < charPixels.count {
                        if charPixels[index] == 1 {
                            drawPixel(x: offset+xPos+x, y: y+yPos, color: color)
                        } else {
                            drawPixel(x: offset+xPos+x, y: y+yPos, color: bgColor)
                        }
                    }
                }
            }
            offset += charWidth
        }
    }
}

public class RTBChars {

    public static func charMap(asciiValue: UInt8?) -> [Int] {
        switch asciiValue {
        case 0: return char0
        case 1: return char1
        case 2: return char2
        case 3: return char3
        case 4: return char4
        case 5: return char5
        case 6: return char6
        case 7: return char7
        case 8: return char8
        case 9: return char9
        case 10: return char10
        case 11: return char11
        case 12: return char12
        case 13: return char13
        case 14: return char14
        case 15: return char15
        case 16: return char16
        case 17: return char17
        case 18: return char18
        case 19: return char19
        case 20: return char20
        case 21: return char21
        case 22: return char22
        case 23: return char23
        case 24: return char24
        case 25: return char25
        case 26: return char26
        case 27: return char27
        case 28: return char28
        case 29: return char29
        case 30: return char30
        case 31: return char31
        case 32: return char32
        case 33: return char33
        case 34: return char34
        case 35: return char35
        case 36: return char36
        case 37: return char37
        case 38: return char38
        case 39: return char39
        case 40: return char40
        case 41: return char41
        case 42: return char42
        case 43: return char43
        case 44: return char44
        case 45: return char45
        case 46: return char46
        case 47: return char47
        case 48: return char48
        case 49: return char49
        case 50: return char50
        case 51: return char51
        case 52: return char52
        case 53: return char53
        case 54: return char54
        case 55: return char55
        case 56: return char56
        case 57: return char57
        case 58: return char58
        case 59: return char59
        case 60: return char60
        case 61: return char61
        case 62: return char62
        case 63: return char63
        case 64: return char64
        case 65: return char65
        case 66: return char66
        case 67: return char67
        case 68: return char68
        case 69: return char69
        case 70: return char70
        case 71: return char71
        case 72: return char72
        case 73: return char73
        case 74: return char74
        case 75: return char75
        case 76: return char76
        case 77: return char77
        case 78: return char78
        case 79: return char79
        case 80: return char80
        case 81: return char81
        case 82: return char82
        case 83: return char83
        case 84: return char84
        case 85: return char85
        case 86: return char86
        case 87: return char87
        case 88: return char88
        case 89: return char89
        case 90: return char90
        case 91: return char91
        case 92: return char92
        case 93: return char93
        case 94: return char94
        case 95: return char95
        case 96: return char96
        case 97: return char97
        case 98: return char98
        case 99: return char99
        case 100: return char100
        case 101: return char101
        case 102: return char102
        case 103: return char103
        case 104: return char104
        case 105: return char105
        case 106: return char106
        case 107: return char107
        case 108: return char108
        case 109: return char109
        case 110: return char110
        case 111: return char111
        case 112: return char112
        case 113: return char113
        case 114: return char114
        case 115: return char115
        case 116: return char116
        case 117: return char117
        case 118: return char118
        case 119: return char119
        case 120: return char120
        case 121: return char121
        case 122: return char122
        case 123: return char123
        case 124: return char124
        case 125: return char125
        case 126: return char126
        case 127: return char127
        default:
            // question mark
            return char63
        }
    }

    public static let char0 = [0, 0, 0, 0, 0, 0, 0, 0,
                               0, 0, 0, 0, 0, 0, 0, 0,
                               0, 0, 0, 0, 0, 0, 0, 0,
                               0, 0, 0, 0, 0, 0, 0, 0,
                               0, 0, 0, 0, 0, 0, 0, 0,
                               0, 0, 0, 0, 0, 0, 0, 0,
                               0, 0, 0, 0, 0, 0, 0, 0,
                               0, 0, 0, 0, 0, 0, 0, 0]

    public static let char1 = [1, 1, 0, 0, 1, 1, 0, 0,
                               1, 1, 0, 0, 1, 1, 0, 0,
                               0, 0, 1, 1, 0, 0, 1, 1,
                               0, 0, 1, 1, 0, 0, 1, 1,
                               1, 1, 0, 0, 1, 1, 0, 0,
                               1, 1, 0, 0, 1, 1, 0, 0,
                               0, 0, 1, 1, 0, 0, 1, 1,
                               0, 0, 1, 1, 0, 0, 1, 1]

    public static let char2 = [1, 1, 0, 0, 0, 0, 1, 1,
                               1, 1, 1, 0, 0, 1, 1, 1,
                               0, 1, 1, 1, 1, 1, 1, 0,
                               0, 0, 1, 1, 1, 1, 0, 0,
                               0, 0, 1, 1, 1, 1, 0, 0,
                               0, 1, 1, 1, 1, 1, 1, 0,
                               1, 1, 1, 0, 0, 1, 1, 1,
                               1, 1, 0, 0, 0, 0, 1, 1]

    public static let char3 = [0, 0, 1, 1, 0, 1, 1, 0,
                               0, 1, 1, 1, 1, 1, 1, 1,
                               0, 1, 1, 1, 1, 1, 1, 1,
                               0, 1, 1, 1, 1, 1, 1, 1,
                               0, 0, 1, 1, 1, 1, 1, 0,
                               0, 0, 0, 1, 1, 1, 0, 0,
                               0, 0, 0, 0, 1, 0, 0, 0,
                               0, 0, 0, 0, 0, 0, 0, 0]

    public static let char4 = [0, 0, 0, 0, 1, 0, 0, 0,
                               0, 0, 0, 1, 1, 1, 0, 0,
                               0, 0, 1, 1, 1, 1, 1, 0,
                               0, 1, 1, 1, 1, 1, 1, 1,
                               0, 0, 1, 1, 1, 1, 1, 0,
                               0, 0, 0, 1, 1, 1, 0, 0,
                               0, 0, 0, 0, 1, 0, 0, 0,
                               0, 0, 0, 0, 0, 0, 0, 0]

    public static let char5 = [0, 0, 0, 1, 1, 0, 0, 0,
                               0, 0, 0, 1, 1, 0, 0, 0,
                               0, 1, 1, 0, 0, 1, 1, 0,
                               0, 1, 1, 0, 0, 1, 1, 0,
                               0, 0, 0, 1, 1, 0, 0, 0,
                               0, 0, 0, 1, 1, 0, 0, 0,
                               0, 0, 1, 1, 1, 1, 0, 0,
                               0, 0, 0, 0, 0, 0, 0, 0]

    public static let char6 = [0, 0, 0, 0, 1, 0, 0, 0,
                               0, 0, 0, 1, 1, 1, 0, 0,
                               0, 0, 1, 1, 1, 1, 1, 0,
                               0, 1, 1, 1, 1, 1, 1, 1,
                               0, 1, 1, 1, 1, 1, 1, 1,
                               0, 0, 0, 1, 1, 1, 0, 0,
                               0, 0, 1, 1, 1, 1, 1, 0,
                               0, 0, 0, 0, 0, 0, 0, 0]

    public static let char7 = [0, 0, 1, 1, 0, 0, 1, 1,
                               1, 0, 0, 1, 1, 0, 0, 1,
                               1, 1, 0, 0, 1, 1, 0, 0,
                               0, 1, 1, 0, 0, 1, 1, 0,
                               0, 0, 1, 1, 0, 0, 1, 1,
                               1, 0, 0, 1, 1, 0, 0, 1,
                               1, 1, 0, 0, 1, 1, 0, 0,
                               0, 1, 1, 0, 0, 1, 1, 0]

    public static let char8 = [0, 0, 0, 0, 0, 0, 0, 0,
                               0, 0, 1, 1, 1, 1, 0, 0,
                               0, 1, 1, 1, 1, 1, 1, 0,
                               0, 1, 1, 1, 1, 1, 1, 0,
                               0, 1, 1, 1, 1, 1, 1, 0,
                               0, 1, 1, 1, 1, 1, 1, 0,
                               0, 0, 1, 1, 1, 1, 0, 0,
                               0, 0, 0, 0, 0, 0, 0, 0]

    public static let char9 = [0, 0, 0, 0, 0, 0, 0, 0,
                               0, 0, 1, 1, 1, 1, 0, 0,
                               0, 1, 1, 1, 1, 1, 1, 0,
                               0, 1, 1, 0, 0, 1, 1, 0,
                               0, 1, 1, 0, 0, 1, 1, 0,
                               0, 1, 1, 1, 1, 1, 1, 0,
                               0, 0, 1, 1, 1, 1, 0, 0,
                               0, 0, 0, 0, 0, 0, 0, 0]

    public static let char10 = [0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 1, 1, 1, 1, 0, 0,
                                0, 1, 1, 1, 1, 1, 1, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0]

    public static let char11 = [0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 1, 1, 1, 1, 1, 1, 0,
                                0, 0, 1, 1, 1, 1, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0]

    public static let char12 = [0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 1, 0, 0, 0, 0,
                                0, 0, 1, 1, 0, 0, 0, 0,
                                0, 1, 1, 1, 1, 1, 1, 1,
                                0, 1, 1, 1, 1, 1, 1, 1,
                                0, 0, 1, 1, 0, 0, 0, 0,
                                0, 0, 0, 1, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char13 = [0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 1, 0, 0,
                                0, 0, 0, 0, 0, 1, 1, 0,
                                0, 1, 1, 1, 1, 1, 1, 1,
                                0, 1, 1, 1, 1, 1, 1, 1,
                                0, 0, 0, 0, 0, 1, 1, 0,
                                0, 0, 0, 0, 0, 1, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char14 = [1, 1, 1, 1, 1, 1, 1, 1,
                                1, 1, 1, 1, 1, 1, 1, 1,
                                1, 1, 1, 1, 1, 1, 1, 1,
                                1, 1, 1, 1, 1, 1, 1, 1,
                                1, 1, 1, 1, 1, 1, 1, 1,
                                1, 1, 1, 1, 1, 1, 1, 1,
                                1, 1, 1, 1, 1, 1, 1, 1,
                                1, 1, 1, 1, 1, 1, 1, 1]

    public static let char15 = [1, 1, 0, 0, 1, 1, 0, 0,
                                1, 0, 0, 1, 1, 0, 0, 1,
                                0, 0, 1, 1, 0, 0, 1, 1,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                1, 1, 0, 0, 1, 1, 0, 0,
                                1, 0, 0, 1, 1, 0, 0, 1,
                                0, 0, 1, 1, 0, 0, 1, 1,
                                0, 1, 1, 0, 0, 1, 1, 0]

    public static let char16 = [0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char17 = [0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char18 = [0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char19 = [0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char20 = [0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0]

    public static let char21 = [0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                1, 1, 1, 1, 1, 1, 1, 1,
                                1, 1, 1, 1, 1, 1, 1, 1,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char22 = [0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 1, 1, 1,
                                0, 0, 0, 0, 1, 1, 1, 1,
                                0, 0, 0, 1, 1, 1, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0]

    public static let char23 = [0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                1, 1, 1, 0, 0, 0, 0, 0,
                                1, 1, 1, 1, 0, 0, 0, 0,
                                0, 0, 1, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0]

    public static let char24 = [0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 1, 0, 0,
                                0, 0, 0, 0, 1, 1, 1, 1,
                                0, 0, 0, 0, 0, 1, 1, 1,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char25 = [0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 1, 1, 1, 0, 0, 0,
                                1, 1, 1, 1, 0, 0, 0, 0,
                                1, 1, 1, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char26 = [1, 1, 0, 0, 0, 0, 0, 0,
                                1, 1, 0, 0, 0, 0, 0, 0,
                                1, 1, 0, 0, 0, 0, 0, 0,
                                1, 1, 0, 0, 0, 0, 0, 0,
                                1, 1, 0, 0, 0, 0, 0, 0,
                                1, 1, 0, 0, 0, 0, 0, 0,
                                1, 1, 1, 1, 1, 1, 1, 1,
                                1, 1, 1, 1, 1, 1, 1, 1]

    public static let char27 = [1, 1, 0, 0, 0, 0, 0, 0,
                                1, 1, 1, 0, 0, 0, 0, 0,
                                0, 1, 1, 1, 0, 0, 0, 0,
                                0, 0, 1, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 1, 0, 0,
                                0, 0, 0, 0, 1, 1, 1, 0,
                                0, 0, 0, 0, 0, 1, 1, 1,
                                0, 0, 0, 0, 0, 0, 1, 1]

    public static let char28 = [0, 0, 0, 0, 0, 0, 1, 1,
                                0, 0, 0, 0, 0, 1, 1, 1,
                                0, 0, 0, 0, 1, 1, 1, 0,
                                0, 0, 0, 1, 1, 1, 0, 0,
                                0, 0, 1, 1, 1, 0, 0, 0,
                                0, 1, 1, 1, 0, 0, 0, 0,
                                1, 1, 1, 0, 0, 0, 0, 0,
                                1, 1, 0, 0, 0, 0, 0, 0]

    public static let char29 = [1, 1, 1, 1, 1, 1, 1, 1,
                                1, 1, 1, 1, 1, 1, 1, 1,
                                1, 1, 0, 0, 0, 0, 0, 0,
                                1, 1, 0, 0, 0, 0, 0, 0,
                                1, 1, 0, 0, 0, 0, 0, 0,
                                1, 1, 0, 0, 0, 0, 0, 0,
                                1, 1, 0, 0, 0, 0, 0, 0,
                                1, 1, 0, 0, 0, 0, 0, 0]

    public static let char30 = [0, 0, 0, 0, 0, 0, 0, 1,
                                0, 0, 0, 0, 0, 0, 1, 1,
                                0, 0, 0, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 1, 1, 0, 0,
                                0, 1, 1, 1, 1, 0, 0, 0,
                                0, 1, 1, 1, 0, 0, 0, 0,
                                0, 1, 1, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char31 = [0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char32 = [0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char33 = [0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char34 = [0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char35 = [0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                1, 1, 1, 1, 1, 1, 1, 1,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                1, 1, 1, 1, 1, 1, 1, 1,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char36 = [0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 1, 1, 1, 1, 1, 0,
                                0, 1, 1, 0, 0, 0, 0, 0,
                                0, 0, 1, 1, 1, 1, 0, 0,
                                0, 0, 0, 0, 0, 1, 1, 0,
                                0, 1, 1, 1, 1, 1, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char37 = [0, 1, 1, 0, 0, 0, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 0, 0, 0, 1, 1, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 1, 1, 0, 0, 0, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 0, 0, 0, 1, 1, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char38 = [0, 0, 1, 1, 1, 1, 0, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 0, 1, 1, 1, 1, 0, 0,
                                0, 0, 1, 1, 1, 0, 0, 0,
                                0, 1, 1, 0, 0, 1, 1, 1,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 0, 1, 1, 1, 1, 1, 1,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char39 = [0, 0, 0, 0, 0, 1, 1, 0,
                                0, 0, 0, 0, 1, 1, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char40 = [0, 0, 0, 0, 1, 1, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 1, 1, 0, 0, 0, 0,
                                0, 0, 1, 1, 0, 0, 0, 0,
                                0, 0, 1, 1, 0, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 0, 1, 1, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char41 = [0, 0, 1, 1, 0, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 0, 1, 1, 0, 0,
                                0, 0, 0, 0, 1, 1, 0, 0,
                                0, 0, 0, 0, 1, 1, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 1, 1, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char42 = [0, 0, 0, 0, 0, 0, 0, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 0, 1, 1, 1, 1, 0, 0,
                                1, 1, 1, 1, 1, 1, 1, 1,
                                0, 0, 1, 1, 1, 1, 0, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char43 = [0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 1, 1, 1, 1, 1, 1, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char44 = [0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 1, 1, 0, 0, 0, 0]

    public static let char45 = [0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 1, 1, 1, 1, 1, 1, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char46 = [0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char47 = [0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 1, 1,
                                0, 0, 0, 0, 0, 1, 1, 0,
                                0, 0, 0, 0, 1, 1, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 1, 1, 0, 0, 0, 0,
                                0, 1, 1, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char48 = [0, 0, 1, 1, 1, 1, 0, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 1, 1, 1, 0,
                                0, 1, 1, 1, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 0, 1, 1, 1, 1, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char49 = [0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 1, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 1, 1, 1, 1, 1, 1, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char50 = [0, 0, 1, 1, 1, 1, 0, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 0, 0, 0, 0, 1, 1, 0,
                                0, 0, 0, 0, 1, 1, 0, 0,
                                0, 0, 1, 1, 0, 0, 0, 0,
                                0, 1, 1, 0, 0, 0, 0, 0,
                                0, 1, 1, 1, 1, 1, 1, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char51 = [0, 0, 1, 1, 1, 1, 0, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 0, 0, 0, 0, 1, 1, 0,
                                0, 0, 0, 1, 1, 1, 0, 0,
                                0, 0, 0, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 0, 1, 1, 1, 1, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char52 = [0, 0, 0, 0, 0, 1, 1, 0,
                                0, 0, 0, 0, 1, 1, 1, 0,
                                0, 0, 0, 1, 1, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 1, 1, 1, 1, 1,
                                0, 0, 0, 0, 0, 1, 1, 0,
                                0, 0, 0, 0, 0, 1, 1, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char53 = [0, 1, 1, 1, 1, 1, 1, 0,
                                0, 1, 1, 0, 0, 0, 0, 0,
                                0, 1, 1, 1, 1, 1, 0, 0,
                                0, 0, 0, 0, 0, 1, 1, 0,
                                0, 0, 0, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 0, 1, 1, 1, 1, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char54 = [0, 0, 1, 1, 1, 1, 0, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 0, 0, 0,
                                0, 1, 1, 1, 1, 1, 0, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 0, 1, 1, 1, 1, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char55 = [0, 1, 1, 1, 1, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 0, 0, 0, 1, 1, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char56 = [0, 0, 1, 1, 1, 1, 0, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 0, 1, 1, 1, 1, 0, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 0, 1, 1, 1, 1, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char57 = [0, 0, 1, 1, 1, 1, 0, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 0, 1, 1, 1, 1, 1, 0,
                                0, 0, 0, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 0, 1, 1, 1, 1, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char58 = [0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char59 = [0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 1, 1, 0, 0, 0, 0]

    public static let char60 = [0, 0, 0, 0, 1, 1, 1, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 1, 1, 0, 0, 0, 0,
                                0, 1, 1, 0, 0, 0, 0, 0,
                                0, 0, 1, 1, 0, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 0, 1, 1, 1, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char61 = [0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 1, 1, 1, 1, 1, 1, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 1, 1, 1, 1, 1, 1, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char62 = [0, 1, 1, 1, 0, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 0, 1, 1, 0, 0,
                                0, 0, 0, 0, 0, 1, 1, 0,
                                0, 0, 0, 0, 1, 1, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 1, 1, 1, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char63 = [0, 0, 1, 1, 1, 1, 0, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 0, 0, 0, 0, 1, 1, 0,
                                0, 0, 0, 0, 1, 1, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char64 = [0, 0, 1, 1, 1, 1, 0, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 1, 1, 1, 0,
                                0, 1, 1, 0, 1, 1, 1, 0,
                                0, 1, 1, 0, 0, 0, 0, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 0, 1, 1, 1, 1, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char65 = [0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 1, 1, 1, 1, 0, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 1, 1, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char66 = [0, 1, 1, 1, 1, 1, 0, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 1, 1, 1, 0, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 1, 1, 1, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char67 = [0, 0, 1, 1, 1, 1, 0, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 0, 0, 0,
                                0, 1, 1, 0, 0, 0, 0, 0,
                                0, 1, 1, 0, 0, 0, 0, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 0, 1, 1, 1, 1, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char68 = [0, 1, 1, 1, 1, 0, 0, 0,
                                0, 1, 1, 0, 1, 1, 0, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 1, 1, 0, 0,
                                0, 1, 1, 1, 1, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char69 = [0, 1, 1, 1, 1, 1, 1, 0,
                                0, 1, 1, 0, 0, 0, 0, 0,
                                0, 1, 1, 0, 0, 0, 0, 0,
                                0, 1, 1, 1, 1, 0, 0, 0,
                                0, 1, 1, 0, 0, 0, 0, 0,
                                0, 1, 1, 0, 0, 0, 0, 0,
                                0, 1, 1, 1, 1, 1, 1, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char70 = [0, 1, 1, 1, 1, 1, 1, 0,
                                0, 1, 1, 0, 0, 0, 0, 0,
                                0, 1, 1, 0, 0, 0, 0, 0,
                                0, 1, 1, 1, 1, 0, 0, 0,
                                0, 1, 1, 0, 0, 0, 0, 0,
                                0, 1, 1, 0, 0, 0, 0, 0,
                                0, 1, 1, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char71 = [0, 0, 1, 1, 1, 1, 0, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 0, 0, 0,
                                0, 1, 1, 0, 1, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 0, 1, 1, 1, 1, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char72 = [0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 1, 1, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char73 = [0, 0, 1, 1, 1, 1, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 1, 1, 1, 1, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char74 = [0, 0, 0, 1, 1, 1, 1, 0,
                                0, 0, 0, 0, 1, 1, 0, 0,
                                0, 0, 0, 0, 1, 1, 0, 0,
                                0, 0, 0, 0, 1, 1, 0, 0,
                                0, 0, 0, 0, 1, 1, 0, 0,
                                0, 1, 1, 0, 1, 1, 0, 0,
                                0, 0, 1, 1, 1, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char75 = [0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 1, 1, 0, 0,
                                0, 1, 1, 1, 1, 0, 0, 0,
                                0, 1, 1, 1, 0, 0, 0, 0,
                                0, 1, 1, 1, 1, 0, 0, 0,
                                0, 1, 1, 0, 1, 1, 0, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char76 = [0, 1, 1, 0, 0, 0, 0, 0,
                                0, 1, 1, 0, 0, 0, 0, 0,
                                0, 1, 1, 0, 0, 0, 0, 0,
                                0, 1, 1, 0, 0, 0, 0, 0,
                                0, 1, 1, 0, 0, 0, 0, 0,
                                0, 1, 1, 0, 0, 0, 0, 0,
                                0, 1, 1, 1, 1, 1, 1, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char77 = [0, 1, 1, 0, 0, 0, 1, 1,
                                0, 1, 1, 1, 0, 1, 1, 1,
                                0, 1, 1, 1, 1, 1, 1, 1,
                                0, 1, 1, 0, 1, 0, 1, 1,
                                0, 1, 1, 0, 0, 0, 1, 1,
                                0, 1, 1, 0, 0, 0, 1, 1,
                                0, 1, 1, 0, 0, 0, 1, 1,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char78 = [0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 1, 0, 1, 1, 0,
                                0, 1, 1, 1, 1, 1, 1, 0,
                                0, 1, 1, 1, 1, 1, 1, 0,
                                0, 1, 1, 0, 1, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char79 = [0, 0, 1, 1, 1, 1, 0, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 0, 1, 1, 1, 1, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char80 = [0, 1, 1, 1, 1, 1, 0, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 1, 1, 1, 0, 0,
                                0, 1, 1, 0, 0, 0, 0, 0,
                                0, 1, 1, 0, 0, 0, 0, 0,
                                0, 1, 1, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char81 = [0, 0, 1, 1, 1, 1, 0, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 0, 1, 1, 1, 1, 0, 0,
                                0, 0, 0, 0, 1, 1, 1, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char82 = [0, 1, 1, 1, 1, 1, 0, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 1, 1, 1, 0, 0,
                                0, 1, 1, 1, 1, 0, 0, 0,
                                0, 1, 1, 0, 1, 1, 0, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char83 = [0, 0, 1, 1, 1, 1, 0, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 0, 0, 0,
                                0, 0, 1, 1, 1, 1, 0, 0,
                                0, 0, 0, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 0, 1, 1, 1, 1, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char84 = [0, 1, 1, 1, 1, 1, 1, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char85 = [0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 0, 1, 1, 1, 1, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char86 = [0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 0, 1, 1, 1, 1, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char87 = [0, 1, 1, 0, 0, 0, 1, 1,
                                0, 1, 1, 0, 0, 0, 1, 1,
                                0, 1, 1, 0, 0, 0, 1, 1,
                                0, 1, 1, 0, 1, 0, 1, 1,
                                0, 1, 1, 1, 1, 1, 1, 1,
                                0, 1, 1, 1, 0, 1, 1, 1,
                                0, 1, 1, 0, 0, 0, 1, 1,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char88 = [0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 0, 1, 1, 1, 1, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 1, 1, 1, 1, 0, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char89 = [0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 0, 1, 1, 1, 1, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char90 = [0, 1, 1, 1, 1, 1, 1, 0,
                                0, 0, 0, 0, 0, 1, 1, 0,
                                0, 0, 0, 0, 1, 1, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 1, 1, 0, 0, 0, 0,
                                0, 1, 1, 0, 0, 0, 0, 0,
                                0, 1, 1, 1, 1, 1, 1, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char91 = [0, 0, 1, 1, 1, 1, 0, 0,
                                0, 0, 1, 1, 0, 0, 0, 0,
                                0, 0, 1, 1, 0, 0, 0, 0,
                                0, 0, 1, 1, 0, 0, 0, 0,
                                0, 0, 1, 1, 0, 0, 0, 0,
                                0, 0, 1, 1, 0, 0, 0, 0,
                                0, 0, 1, 1, 1, 1, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char92 = [0, 0, 0, 0, 0, 0, 0, 0,
                                0, 1, 1, 0, 0, 0, 0, 0,
                                0, 0, 1, 1, 0, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 0, 1, 1, 0, 0,
                                0, 0, 0, 0, 0, 1, 1, 0,
                                0, 0, 0, 0, 0, 0, 1, 1,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char93 = [0, 0, 1, 1, 1, 1, 0, 0,
                                0, 0, 0, 0, 1, 1, 0, 0,
                                0, 0, 0, 0, 1, 1, 0, 0,
                                0, 0, 0, 0, 1, 1, 0, 0,
                                0, 0, 0, 0, 1, 1, 0, 0,
                                0, 0, 0, 0, 1, 1, 0, 0,
                                0, 0, 1, 1, 1, 1, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char94 = [0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char95 = [0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 1, 1, 1, 1, 1, 1,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char96 = [0, 1, 1, 0, 0, 0, 0, 0,
                                0, 0, 1, 1, 0, 0, 0, 0,
                                0, 0, 0, 1, 1, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char97 = [0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 1, 1, 1, 1, 0, 0,
                                0, 0, 0, 0, 0, 1, 1, 0,
                                0, 0, 1, 1, 1, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 0, 1, 1, 1, 1, 1, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char98 = [0, 0, 0, 0, 0, 0, 0, 0,
                                0, 1, 1, 0, 0, 0, 0, 0,
                                0, 1, 1, 0, 0, 0, 0, 0,
                                0, 1, 1, 1, 1, 1, 0, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 0, 0, 1, 1, 0,
                                0, 1, 1, 1, 1, 1, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char99 = [0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0,
                                0, 0, 1, 1, 1, 1, 0, 0,
                                0, 1, 1, 0, 0, 0, 0, 0,
                                0, 1, 1, 0, 0, 0, 0, 0,
                                0, 1, 1, 0, 0, 0, 0, 0,
                                0, 0, 1, 1, 1, 1, 0, 0,
                                0, 0, 0, 0, 0, 0, 0, 0]

    public static let char100 = [0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 1, 1, 0,
                                 0, 0, 0, 0, 0, 1, 1, 0,
                                 0, 0, 1, 1, 1, 1, 1, 0,
                                 0, 1, 1, 0, 0, 1, 1, 0,
                                 0, 1, 1, 0, 0, 1, 1, 0,
                                 0, 0, 1, 1, 1, 1, 1, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0]

    public static let char101 = [0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 1, 1, 1, 1, 0, 0,
                                 0, 1, 1, 0, 0, 1, 1, 0,
                                 0, 1, 1, 1, 1, 1, 1, 0,
                                 0, 1, 1, 0, 0, 0, 0, 0,
                                 0, 0, 1, 1, 1, 1, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0]

    public static let char102 = [0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 1, 1, 1, 0,
                                 0, 0, 0, 1, 1, 0, 0, 0,
                                 0, 0, 1, 1, 1, 1, 1, 0,
                                 0, 0, 0, 1, 1, 0, 0, 0,
                                 0, 0, 0, 1, 1, 0, 0, 0,
                                 0, 0, 0, 1, 1, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0]

    public static let char103 = [0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 1, 1, 1, 1, 1, 0,
                                 0, 1, 1, 0, 0, 1, 1, 0,
                                 0, 1, 1, 0, 0, 1, 1, 0,
                                 0, 0, 1, 1, 1, 1, 1, 0,
                                 0, 0, 0, 0, 0, 1, 1, 0,
                                 0, 1, 1, 1, 1, 1, 0, 0]

    public static let char104 = [0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 1, 1, 0, 0, 0, 0, 0,
                                 0, 1, 1, 0, 0, 0, 0, 0,
                                 0, 1, 1, 1, 1, 1, 0, 0,
                                 0, 1, 1, 0, 0, 1, 1, 0,
                                 0, 1, 1, 0, 0, 1, 1, 0,
                                 0, 1, 1, 0, 0, 1, 1, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0]

    public static let char105 = [0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 1, 1, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 1, 1, 1, 0, 0, 0,
                                 0, 0, 0, 1, 1, 0, 0, 0,
                                 0, 0, 0, 1, 1, 0, 0, 0,
                                 0, 0, 1, 1, 1, 1, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0]

    public static let char106 = [0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 1, 1, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 1, 1, 0,
                                 0, 0, 0, 0, 0, 1, 1, 0,
                                 0, 0, 0, 0, 0, 1, 1, 0,
                                 0, 0, 0, 0, 0, 1, 1, 0,
                                 0, 0, 1, 1, 1, 1, 0, 0]

    public static let char107 = [0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 1, 1, 0, 0, 0, 0, 0,
                                 0, 1, 1, 0, 0, 0, 0, 0,
                                 0, 1, 1, 0, 1, 1, 0, 0,
                                 0, 1, 1, 1, 1, 0, 0, 0,
                                 0, 1, 1, 0, 1, 1, 0, 0,
                                 0, 1, 1, 0, 0, 1, 1, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0]

    public static let char108 = [0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 1, 1, 1, 0, 0, 0,
                                 0, 0, 0, 1, 1, 0, 0, 0,
                                 0, 0, 0, 1, 1, 0, 0, 0,
                                 0, 0, 0, 1, 1, 0, 0, 0,
                                 0, 0, 0, 1, 1, 0, 0, 0,
                                 0, 0, 1, 1, 1, 1, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0]

    public static let char109 = [0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 1, 1, 0, 0, 1, 1, 0,
                                 0, 1, 1, 1, 1, 1, 1, 1,
                                 0, 1, 1, 1, 1, 1, 1, 1,
                                 0, 1, 1, 0, 1, 0, 1, 1,
                                 0, 1, 1, 0, 0, 0, 1, 1,
                                 0, 0, 0, 0, 0, 0, 0, 0]

    public static let char110 = [0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 1, 1, 1, 1, 1, 0, 0,
                                 0, 1, 1, 0, 0, 1, 1, 0,
                                 0, 1, 1, 0, 0, 1, 1, 0,
                                 0, 1, 1, 0, 0, 1, 1, 0,
                                 0, 1, 1, 0, 0, 1, 1, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0]

    public static let char111 = [0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 1, 1, 1, 1, 0, 0,
                                 0, 1, 1, 0, 0, 1, 1, 0,
                                 0, 1, 1, 0, 0, 1, 1, 0,
                                 0, 1, 1, 0, 0, 1, 1, 0,
                                 0, 0, 1, 1, 1, 1, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0]

    public static let char112 = [0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 1, 1, 1, 1, 1, 0, 0,
                                 0, 1, 1, 0, 0, 1, 1, 0,
                                 0, 1, 1, 0, 0, 1, 1, 0,
                                 0, 1, 1, 1, 1, 1, 0, 0,
                                 0, 1, 1, 0, 0, 0, 0, 0,
                                 0, 1, 1, 0, 0, 0, 0, 0]

    public static let char113 = [0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 1, 1, 1, 1, 1, 0,
                                 0, 1, 1, 0, 0, 1, 1, 0,
                                 0, 1, 1, 0, 0, 1, 1, 0,
                                 0, 0, 1, 1, 1, 1, 1, 0,
                                 0, 0, 0, 0, 0, 1, 1, 0,
                                 0, 0, 0, 0, 0, 1, 1, 0]

    public static let char114 = [0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 1, 1, 1, 1, 1, 0, 0,
                                 0, 1, 1, 0, 0, 1, 1, 0,
                                 0, 1, 1, 0, 0, 0, 0, 0,
                                 0, 1, 1, 0, 0, 0, 0, 0,
                                 0, 1, 1, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0]

    public static let char115 = [0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 1, 1, 1, 1, 1, 0,
                                 0, 1, 1, 0, 0, 0, 0, 0,
                                 0, 0, 1, 1, 1, 1, 0, 0,
                                 0, 0, 0, 0, 0, 1, 1, 0,
                                 0, 1, 1, 1, 1, 1, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0]

    public static let char116 = [0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 1, 1, 0, 0, 0,
                                 0, 1, 1, 1, 1, 1, 1, 0,
                                 0, 0, 0, 1, 1, 0, 0, 0,
                                 0, 0, 0, 1, 1, 0, 0, 0,
                                 0, 0, 0, 1, 1, 0, 0, 0,
                                 0, 0, 0, 0, 1, 1, 1, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0]

    public static let char117 = [0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 1, 1, 0, 0, 1, 1, 0,
                                 0, 1, 1, 0, 0, 1, 1, 0,
                                 0, 1, 1, 0, 0, 1, 1, 0,
                                 0, 1, 1, 0, 0, 1, 1, 0,
                                 0, 0, 1, 1, 1, 1, 1, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0]

    public static let char118 = [0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 1, 1, 0, 0, 1, 1, 0,
                                 0, 1, 1, 0, 0, 1, 1, 0,
                                 0, 1, 1, 0, 0, 1, 1, 0,
                                 0, 0, 1, 1, 1, 1, 0, 0,
                                 0, 0, 0, 1, 1, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0]

    public static let char119 = [0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 1, 1, 0, 0, 0, 1, 1,
                                 0, 1, 1, 0, 1, 0, 1, 1,
                                 0, 1, 1, 1, 1, 1, 1, 1,
                                 0, 0, 1, 1, 1, 1, 1, 0,
                                 0, 0, 1, 1, 0, 1, 1, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0]

    public static let char120 = [0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 1, 1, 0, 0, 1, 1, 0,
                                 0, 0, 1, 1, 1, 1, 0, 0,
                                 0, 0, 0, 1, 1, 0, 0, 0,
                                 0, 0, 1, 1, 1, 1, 0, 0,
                                 0, 1, 1, 0, 0, 1, 1, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0]

    public static let char121 = [0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 1, 1, 0, 0, 1, 1, 0,
                                 0, 1, 1, 0, 0, 1, 1, 0,
                                 0, 1, 1, 0, 0, 1, 1, 0,
                                 0, 0, 1, 1, 1, 1, 1, 0,
                                 0, 0, 0, 0, 1, 1, 0, 0,
                                 0, 1, 1, 1, 1, 0, 0, 0]

    public static let char122 = [0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 1, 1, 1, 1, 1, 1, 0,
                                 0, 0, 0, 0, 1, 1, 0, 0,
                                 0, 0, 0, 1, 1, 0, 0, 0,
                                 0, 0, 1, 1, 0, 0, 0, 0,
                                 0, 1, 1, 1, 1, 1, 1, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0]

    public static let char123 = [0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0]

    public static let char124 = [0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0]

    public static let char125 = [0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0]

    public static let char126 = [0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0]

    public static let char127 = [0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0,
                                 0, 0, 0, 0, 0, 0, 0, 0]
}

