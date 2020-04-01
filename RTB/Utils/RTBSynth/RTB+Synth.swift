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

    public func advanceSequencers(bufferSize: Int) {
        guard bufferSize < audioBuffer.count else { return }
        for n in 0..<bufferSize {
            audioBuffer[n] = 0
        }
        for seq in RTBSequencer.sequencers {
            for channel in seq.channels {
                guard channel.active else { continue }
                channel.advanceChannel(bufferSize: bufferSize, bpm: seq.bpm, loop: seq.loop)
                for n in 0..<bufferSize {
                    audioBuffer[n] += channel.channelBuffer[n]
                }
            }
        }
    }
}

public class RTBNote {
    // TODO: Random params.
    // TODO: Filter effect.
    var note: Double = 0
    var waveType: RTBOscillator.WaveType = .sine
    var effects: [RTBEffectParam] = []
    init(_ note: Double) {
        self.note = note
    }
}

public class RTBSequencer {

    public static var sequencers: [RTBSequencer] = []
    var loop: Bool = false
    var bpm: Double = 60
    var channels: [RTBChannel] = []

    func play() {
        for channel in channels {
            channel.active = true
        }
    }

    func stop() {
        for channel in channels {
            channel.active = false
        }
    }

    func rewind() {
        for channel in channels {
            channel.active = false
        }
    }
}

/*
extension RTB {

    func filterLowpass(bufferSize: Int) {
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
}*/

/*
public class RTBFilter {

    public static var amount: Double = 0
    public static var lastFilterDest: Int16 = 0
    func filterLowpass(src: [Int16], dest: [Int16], length: Int, amount: Double) {


    }

    /* TODO: Highpass
     static void vlk_tr_filter_lowpass(float *src, float *dest, int length, double amount) {
         int i;
         if(src == dest) {
             vlk_error_log("vlk_tr_lowpass source cannot be same as destination.");
         }
         /* https://www.electronicspoint.com/threads/digital-high-pass-filter.100423/ */
         /* lowpass */
         dest[0] = vlk_tr_last_filter_dest;
         for(i = 0; i < length-1; i++) {
             dest[i+1] = (dest[i]-src[i]) * /*0.99f*/amount + src[i];
         }
         vlk_tr_last_filter_dest = dest[length-1];
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
}
*/
