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

public class RTBreak: RTB {

    private var x = 0.0
    private var y = 0.0
    private var xV = 1.5
    private var yV = 0.7

    var color: UInt32 = 0xff00ffff
    var bgColor: UInt32 = 0x003300ff

    var seq = RTBSequencer()
    var sfxSeq = RTBSequencer()

    private var blockEntities: [Entity] = []
    private var ballEntity = Entity(type: .ball, x: 100, y: 100)
    private var padelEntity = Entity(type: .padel, x: 100, y: 200)

    override func setup() {

        for x in 0...5 {
            for y in 0...5 {
                blockEntities.append(Entity(type: .block, x: Double(x*20), y: Double(y*20)))
            }
        }

        /*
        let channel = RTBChannel()
        channel.notes = [40, 64, 79, 60, 55, 45, 64, 79, 60, 55, 45]
        channel.beat = [1,2]
        channel.amplitude = 0.1
        channel.waveTypes = [.tri, .tri, .tri, .tri, .tri, .tri]
        seq.channels.append(channel)
 */

        let vibratoNote = RTBNote(60)
        vibratoNote.waveType = .square

        let vibratoEffectParam = RTBEffectParam()
        vibratoEffectParam.type = .vibrato
        vibratoEffectParam.param1 = 4
        vibratoEffectParam.param2 = 4

        let filterEffectParam = RTBEffectParam()
        filterEffectParam.type = .lowpass
        filterEffectParam.param1 = 0.99
        filterEffectParam.param2 = 0.99

        let pitchEffectParam = RTBEffectParam()
        pitchEffectParam.type = .pitch
        pitchEffectParam.param1 = -10

        vibratoNote.effects.append(vibratoEffectParam)
        vibratoNote.effects.append(filterEffectParam)
        vibratoNote.effects.append(pitchEffectParam)

        let channel2 = RTBChannel()
        channel2.notes = [vibratoNote, RTBNote(30), RTBNote(38), RTBNote(50), RTBNote(52)]
        channel2.beat = [1,1]
        channel2.amplitude = 0.05
        seq.channels.append(channel2)

        seq.loop = true
        seq.bpm = 30
        seq.play()
        RTBSequencer.sequencers.append(seq)

        let sfx = RTBChannel()
        sfx.notes = [RTBNote(40), RTBNote(30), RTBNote(28)]
        sfx.beat = [32]
        sfxSeq.channels.append(sfx)
        RTBSequencer.sequencers.append(sfxSeq)
    }

    override func updateAudio(bufferSize: Int) -> [Int16] {
        advanceSequencers(bufferSize: bufferSize)
        return audioBuffer
    }

    override func update(touches: [RTBTouch]?) -> [UInt32] {
        updateEntities()
        return raster
    }

    func updateEntities() {
        cls(color: 0)
        for entity in blockEntities {
            entity.update()
            renderEntity(entity)
        }

        ballEntity.update()
        renderEntity(ballEntity)
        renderEntity(padelEntity)
    }

    func renderEntity(_ entity: Entity) {
        let gfx = entity.gfx()
        for yPos in 0...gfx.count-1 {
            for xPos in 0...gfx[yPos].count-1 {
            var color: UInt32 = RTBreak.palette[entity.paletteIndex]
                if gfx[yPos][xPos] == 0 {
                    color = RTBreak.palette[0]
                }
                drawPixel(x: xPos+Int(entity.x), y: Int(entity.y)+yPos, color: color)
            }
        }
    }

    // MARK: - Graphics

    // zx spectrum palette + transparent on index 0
    public static let palette: [UInt32] = [0x00000000,
                                           0x000000ff,
                                           0x0022c7ff,
                                           0x002bfbff,
                                           0xd62816ff,
                                           0xff331cff,
                                           0xd433c7ff,
                                           0xff40fcff,
                                           0x00c525ff,
                                           0x00f92fff,
                                           0x00c7c9ff,
                                           0x00fbfeff,
                                           0xccc82aff,
                                           0xfffc36ff,
                                           0xcacacaff,
                                           0xffffffff]

    public static let gfxBall = [[0, 0, 1, 1, 1, 1, 0, 0],
                                 [0, 1, 1, 1, 1, 1, 1, 0],
                                 [1, 1, 1, 1, 1, 1, 1, 1],
                                 [1, 1, 1, 1, 1, 1, 1, 1],
                                 [1, 1, 1, 1, 1, 1, 1, 1],
                                 [1, 1, 1, 1, 1, 1, 1, 1],
                                 [0, 1, 1, 1, 1, 1, 1, 0],
                                 [0, 0, 1, 1, 1, 1, 0, 0]]

    public static let gfxBlock = [[0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
                                  [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
                                  [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
                                  [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
                                  [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
                                  [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
                                  [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
                                  [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0]]

    public static let gfxPadel = [[0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
                                  [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
                                  [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
                                  [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0]]

}
