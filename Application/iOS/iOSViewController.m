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

#import "iOSViewController.h"
#import "iOSRenderer.h"
#import "RTB-Swift.h"
#import <AVFoundation/AVFoundation.h>
#include <stdlib.h>
#import <pthread.h>
#import "RTAudioBuffer.h"

@interface iOSViewController()

// input
@property (nonatomic, strong) NSMutableArray<UITouch *> *begunTouches;
@property (nonatomic, strong) NSMutableArray<UITouch *> *activeTouches;
@property (nonatomic, strong) NSMutableArray<NSValue *> *endedTouches;

@property (nonatomic, strong) RTB *rtb;
@property (nonatomic, strong) NSMutableArray<RTBTouch *> *rtbTouches;

@end

static bool sound_enabled = true;
static iOSViewController *gameViewController = NULL;
static int audioBufferMax = 8192;
static int maxTouches = 10;

@implementation iOSViewController {
    MTKView *_view;
    iOSRenderer *_renderer;
}

OSStatus iOSRenderCallback(void *userData,
                        AudioUnitRenderActionFlags *actionFlags,
                        const AudioTimeStamp *audioTimeStamp,
                        UInt32 busNumber,
                        UInt32 numFrames,
                        AudioBufferList *buffers) {
    SInt16 *inputFrames = (SInt16 *)(buffers->mBuffers->mData);
    int totalFrames = numFrames * 2;

    // zero the buffer
    for (int i = 0; i < totalFrames; i++) {
        inputFrames[i] = 0;
    }

    if (sound_enabled == false) {
        return noErr;
    }

    if (totalFrames > audioBufferMax) {
        printf("AudioCallback: totalFrames too big.\n");
        return noErr;
    }

    updateAudio(totalFrames);

    SInt16 *audio_bytes_pointer = (SInt16 *)gameViewController.rtb.audioBytesPointer;

    // write samples
    for (int i = 0; i < totalFrames; i += 2) {
        double amp = 0.3;

        inputFrames[i] = audio_bytes_pointer[i] * amp;
        inputFrames[i+1] = audio_bytes_pointer[i+1] * amp;
    }

    return noErr;
}

static void updateAudio(int size) {
    if (gameViewController != NULL) {
        [gameViewController.rtb updateAudioWithBufferSize:size];
    }
}

- (void)initInput {
    self.view.multipleTouchEnabled = YES;
    self.begunTouches = [[NSMutableArray alloc] init];
    self.activeTouches = [[NSMutableArray alloc] init];
    self.endedTouches = [[NSMutableArray alloc] init];
    _rtbTouches = [NSMutableArray array];
    for (int i = 0; i < maxTouches; i++) {
        RTBTouch *touch = [RTBTouch new];
        [_rtbTouches addObject:touch];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initInput];
    // Set the view to use the default device
    _view = (MTKView *)self.view;

    _view.device = MTLCreateSystemDefaultDevice();

    NSAssert(_view.device, @"Metal is not supported on this device");

    _renderer = [[iOSRenderer alloc] initWithMetalKitView:_view];
    _renderer.delegate = self;

    NSAssert(_renderer, @"Renderer failed initialization");

    // Initialize the renderer with the view size
    [_renderer mtkView:_view drawableSizeWillChange:_view.drawableSize];

    _view.delegate = _renderer;

    _rtb = [RTB instance];

    [self initAudio];

    gameViewController = self;

#if defined(TARGET_IOS) || defined(TARGET_TVOS)
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationWillTerminate:)
     name:UIApplicationWillTerminateNotification
     object:[UIApplication sharedApplication]];
#endif

}

- (void)applicationWillTerminate:(NSNotification *)notification {
    rtAudioStopAudioUnit();
}

- (void)initAudio {
    rtAudioInitWithCallback(iOSRenderCallback, 0.015);
}

- (void)update {

    [self checkActiveTouches];

    [self.rtb updateWithTouches:_rtbTouches];

    unsigned int *pixels = _renderer.pixels;

    unsigned int *bytes_pointer = self.rtb.bytesPointer;

    if (pixels) {
        for (int i = 0; i < 65536; i++) {
            // TODO: RGBA BGRA conversion needed?

            unsigned int c = bytes_pointer[i];
            unsigned int red = c & 0xff;
            unsigned int green = (c >> (8)) & 0xff;
            unsigned int blue = (c >> (16)) & 0xff;
            unsigned int alpha = (c >> (24)) & 0xff;
            pixels[i] = (red << 24) | (green << 16) | (blue << 8) | alpha;
            //pixels[i] = rand() % INT32_MAX;
        }
    }
}

- (void)resetTouches {
    for(int i = 0; i < _rtbTouches.count; i++) {
        RTBTouch *t = _rtbTouches[i];
        t.x = 0;
        t.y = 0;
        t.active = NO;
        t.ended = NO;
        t.endedLock = NO;
        t.began = NO;
        t.beganLock = NO;
    }
}

- (void)checkActiveTouches {
    [self resetTouches];
    int touchIndex = 0;

    for (UITouch *touch in self.begunTouches) {
        if(touchIndex < _rtbTouches.count) {
            RTBTouch *rtbTouch = _rtbTouches[touchIndex];
            if (!rtbTouch.active) {
                CGPoint pt = [touch locationInView: [touch view]];
                pt = [self translateCoordinates:pt];
                rtbTouch.x = pt.x;
                rtbTouch.y = pt.y;
                if(rtbTouch.beganLock == false) {
                    rtbTouch.beganLock = true;
                    rtbTouch.began = true;
                }
                rtbTouch.active = true;
                touchIndex++;
            }
        }
    }

    for (UITouch *touch in self.activeTouches) {
        if(touchIndex < _rtbTouches.count) {
            RTBTouch *rtbTouch = _rtbTouches[touchIndex];
            if (!rtbTouch.active) {
                CGPoint pt = [touch locationInView: [touch view]];
                pt = [self translateCoordinates:pt];
                rtbTouch.x = pt.x;
                rtbTouch.y = pt.y;
                rtbTouch.active = true;
                touchIndex++;
            }
        }
    }

    for (NSValue *value in self.endedTouches) {
        if(touchIndex < _rtbTouches.count) {
            RTBTouch *rtbTouch = _rtbTouches[touchIndex];
            if (!rtbTouch.active) {
                CGPoint p = [self translateCoordinates:[value CGPointValue]];
                rtbTouch.x = p.x;
                rtbTouch.y = p.y;
                if(rtbTouch.endedLock == false) {
                    rtbTouch.endedLock = true;
                    rtbTouch.ended = true;
                }
                rtbTouch.active = true;
                touchIndex++;
            }
        }
    }

    [self.activeTouches addObjectsFromArray:self.begunTouches];
    if (self.begunTouches.count > 0) {
        [self.begunTouches removeAllObjects];
    }
    if (self.endedTouches.count > 0) {
        [self.endedTouches removeAllObjects];
    }
}

- (CGPoint)translateCoordinates:(CGPoint)pt {

    int physical_center_x = [_renderer physicalWidth] / 2;
    int physical_center_y = [_renderer physicalHeight] / 2;

    int physical_touch_x = pt.x * [_renderer mainScreenScale];
    int physical_touch_y = pt.y * [_renderer mainScreenScale];

    int physical_touch_offset_x = physical_touch_x - physical_center_x;
    int physical_touch_offset_y = physical_touch_y - physical_center_y;

    // apply to canvas
    int canvas_center_x = ([_renderer scaling] * 256) / 2;
    int canvas_center_y = ([_renderer scaling] * 256) / 2;

    int t_x = (canvas_center_x + physical_touch_offset_x) / [_renderer scaling];
    int t_y = (canvas_center_y + physical_touch_offset_y) / [_renderer scaling];

    NSLog(@"x:%d y:%d", t_x, t_y);

    return CGPointMake(t_x, t_y);
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    for (UITouch *touch in touches) {
        [self.begunTouches addObject:touch];
    }
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    for (UITouch *touch in touches) {
        CGPoint pt = [touch locationInView: [touch view]];
        // For testing.
        if (pt.y < 300) {
            [_renderer increaseScaling];
        } else {
            [_renderer decreaseScaling];
        }
    }
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    for (UITouch *touch in touches) {
        CGPoint pt = [touch locationInView: [touch view]];
        [self.begunTouches removeObject:touch];
        [self.activeTouches removeObject:touch];
        NSValue *point = [NSValue valueWithCGPoint:CGPointMake(pt.x, pt.y)];
        [self.endedTouches addObject:point];
    }
}

- (BOOL)shouldAutorotate {
    return NO;
}

#pragma mark - iOSRendererDelegate

- (void)iOSRendererDrawCompleted {
    [self update];
}

@end
