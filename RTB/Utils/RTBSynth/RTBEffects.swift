//
//  RTBEffects.swift
//  RTB
//
//  Created by Harry Lundstrom on 2020-04-01.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

public class RTBEffectParam {

    enum RTBEffectParamType {
        case vibrato
        case filter
        case pitch
        case unknown
    }
    var type: RTBEffectParamType = .unknown
    var param1: Double = 0
    var param2: Double = 0
}

public protocol RTBEffectProtocol {

    func active() -> Bool
    func reset()
}

public class RTBVibratoEffect: RTBEffectProtocol {

    var isActive = false
    var vibratoDepth = 0.0
    var vibratoSpeed = 0.0

    private let vibratoDepthMod = 0.00001
    private var vibratoPhase = 0.0
    private let sineTable = RTBOscillator.buildSineTable(size: Int(1024))

    func modifiedNote(note: Double) -> Double {
        let bufferSize = 1024.0
        vibratoPhase += vibratoSpeed
        if vibratoPhase >= bufferSize {
            vibratoPhase = vibratoPhase - bufferSize
        }

        let depth = vibratoDepthMod * vibratoDepth
        var phaseInt = Int(vibratoPhase)
        if phaseInt >= 1024 || phaseInt < 0 {
            phaseInt = 0
        }
        let mod = Double(sineTable[phaseInt]) * depth
        return note + mod
    }

    public func active() -> Bool {
        return isActive
    }

    public func reset() {
        vibratoPhase = 0
        isActive = false
    }
}

public class RTBFilterEffect: RTBEffectProtocol {

    var isActive = false
    var amountLeft: Double = 0
    var amountRight: Double = 0

    var lastFilterDestLeft: Int16 = 0
    var lastFilterDestRight: Int16 = 0
/*
    public func filterLowpass(bufferSize: Int) {
        guard bufferSize < audioBuffer.count else { return }
        let srcBuffer = audioBuffer

        audioBuffer[0] = RTBFilter.lastFilterDest
        for i in stride(from: 0, to: bufferSize, by: 1) {
            // TODO: Need to make it work with interleaved?
            let destSample = Double(audioBuffer[i])
            let srcSample = Double(srcBuffer[i])
            let dSample: Double = (destSample-srcSample) * RTBFilter.amount + srcSample
            let sample: Int16 = Int16(max(min(dSample, Double(INT16_MAX)), Double(INT16_MIN)))
            audioBuffer[i+1] = sample
        }
        RTBFilter.lastFilterDest = audioBuffer[bufferSize-1];
    }
     static void vlk_tr_filter_highpass(float *src, float *dest, int length, double amount) {
         int i;
         if(src == dest) {
             vlk_error_log("vlk_tr_lowpass source cannot be same as destination.");
         }
         dest[0] = vlk_tr_last_filter_dest;
         /* https://en.wikipedia.org/wiki/High-pass_filter */
         /* highpass */
         for(i = 1; i < length; i++) {
             dest[i] = /*0.1f*/amount * (dest[i-1] + src[i] - src[i-1]);
         }
         vlk_tr_last_filter_dest = dest[length-1];
     }
     */

    public func active() -> Bool {
        return isActive
    }

    public func reset() {
    }
}

public class RTBPitchEffect: RTBEffectProtocol {

    var isActive = false
    private var increment: Double = 0
    private let pitchModifier = 0.001

    func setIncrement(value: Double) {
        increment = value * pitchModifier
    }

    func modifiedNote(note: Double) -> Double {
        return note + increment
    }

    public func active() -> Bool {
        return isActive
    }

    public func reset() {
        isActive = false
    }
}
