//
//  RTB_demo_1.swift
//  RTB
//
//  Created by Harry Lundstrom on 2019-08-07.
//  Copyright © 2019 Harry Lundstrom. All rights reserved.
//

import Foundation

class RTBDemo1: RTB {

    lazy var sineTable = buildSineTable(size: 1024)
    var yInput: Double = 0

    // osc
    var phaseIncrement: Double = 0
    var currentPhase: Double = 0
    var currentPhaseInt: Int = 0
    
    func incrementOsc() {
        phaseIncrement = yInput * 0.1
        currentPhase += phaseIncrement
        currentPhaseInt = Int(currentPhase)
        if currentPhaseInt >= 1024 {
            currentPhaseInt = 0
            currentPhase = 0
        }
    }
    
    override init() {
        super.init()
    }

    override func updateAudio(bufferSize: Int) -> [Int16] {
        guard bufferSize < audioBuffer.count else { return audioBuffer }
        for n in stride(from: 0, to: bufferSize, by: 2) {
            //audioBuffer[n] = Int16(Int.random(in: -16000 ..< 16000))
            //audioBuffer[n] = Int16(Int.random(in: -16000 ..< 16000))
            
            var sample = sineTable[currentPhaseInt]/* - Int16(INT16_MAX/2)*/
            
            if sample < INT16_MIN {
                sample = Int16(INT16_MIN)
            }
            if sample > INT16_MAX {
                sample = Int16(INT16_MAX)
            }
            print(currentPhaseInt)

            audioBuffer[n+1] = sample
            incrementOsc()
        }
        return audioBuffer
    }

    override func update(deltaTime: Double,
                rasterSize: Int,
                inputActive: Bool,
                inputX: Int,
                inputY: Int,
                inputBegan: Bool,
                inputEnded: Bool) -> [UInt32] {
        
        yInput = Double(inputY)
        
        let pixel = inputX + inputY * width

        if inputActive && pixel < pixelCount {
            raster[inputX + inputY * width] = 0xff0000ff
        }
        return raster
    }
}

extension RTBDemo1 {
    func buildSineTable(size: Int) -> [Int16] {
        var table: [Int16] = Array(repeating: 0, count: size)
        let phaseIncrement: Double = (2 * Double.pi) / Double(size)
        var currentPhase: Double = 0
        for i in 0...size-1 {
            let sample: Int16 = Int16(sin(currentPhase) * Double(INT16_MAX))
            table[i] = sample
            currentPhase += phaseIncrement
        }
        return table
    }
    /*
    void cSynthBuildSineWave(int16_t *data, int wave_length) {
        double pi = 3.14159265358979323846;
        double phaseIncrement = (2.0f * pi)/(double)wave_length;
        double currentPhase = 0.0;
        for(int i = 0; i < wave_length; i++) {
            int sample = (int)(sin(currentPhase) * INT16_MAX);
            data[i] = (int16_t)sample;
            currentPhase += phaseIncrement;
        }
    }*/
}
