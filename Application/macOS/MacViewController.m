/*
Copyright © 2019 Apple Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#import "MacViewController.h"
#import "MacRenderer.h"
#import "RTB-Swift.h"
#import <AVFoundation/AVFoundation.h>
#include <stdlib.h>
#import <pthread.h>
#import "RTAudioBuffer.h"

@interface MacViewController()

@property (nonatomic, strong) RTB *rtb;
@property (nonatomic, strong) NSMutableArray<RTBTouch *> *rtbTouches;
@property (nonatomic, strong) NSArray<NSNumber *> *rasterObjC;
@property (nonatomic, strong) NSArray<NSNumber *> *audioBufferObjC;

@end

@implementation MacViewController {
    MTKView *_view;
    MacRenderer *_renderer;
}

static bool sound_enabled = true;
static MacViewController *gameViewController = NULL;
static int audioBufferMax = 8192;

OSStatus renderCallback(void *userData,
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

    if (sound_enabled == 0) {
        return noErr;
    }

    if (totalFrames > audioBufferMax) {
        printf("AudioCallback: totalFrames too big.\n");
        return noErr;
    }

    updateAudio(totalFrames);

    // write samples
    for (int i = 0; i < totalFrames; i += 2) {
        double amp = 0.3;
        inputFrames[i] = [[gameViewController.audioBufferObjC objectAtIndex:i] intValue] * amp;
        inputFrames[i+1] = [[gameViewController.audioBufferObjC objectAtIndex:i+1] intValue] * amp;
    }

    return noErr;
}

static void updateAudio(int size) {
    if (gameViewController != NULL) {
        NSArray<NSNumber *> *r = [gameViewController.rtb updateAudioWithBufferSize:size];
        gameViewController.audioBufferObjC = r;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Set the view to use the default device
    _view = (MTKView *)self.view;
    
    _view.device = MTLCreateSystemDefaultDevice();
    
    NSAssert(_view.device, @"Metal is not supported on this device");
    
    _renderer = [[MacRenderer alloc] initWithMetalKitView:_view];
    _renderer.delegate = self;

    NSAssert(_renderer, @"Renderer failed initialization");

    // Initialize the renderer with the view size
    [_renderer mtkView:_view drawableSizeWillChange:_view.drawableSize];

    _view.delegate = _renderer;

    _rtb = [RTB instance];

    gameViewController = self;

    [self initAudio];

    _rtbTouches = [NSMutableArray array];
    RTBTouch *touch = [RTBTouch new];
    [_rtbTouches addObject:touch];

#if !defined(TARGET_IOS) && !defined(TARGET_TVOS)

    [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(applicationWillTerminate:)
         name:NSApplicationWillTerminateNotification
         object:[NSApplication sharedApplication]];
#endif
}


- (void)applicationWillTerminate:(NSNotification *)notification {
    rtAudioStopAudioUnit();
}

- (void)initAudio {
    rtAudioInitWithCallback(renderCallback, 0.015);
}

- (void)update {
    [self.rtb updateWithTouches:_rtbTouches];
    RTBTouch *touch = _rtbTouches.firstObject;

    if (touch.began) {
        touch.began = NO;
    }
    if (touch.ended) {
        touch.ended = NO;
        touch.active = NO;
    }

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
        }
    }
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (BOOL)becomeFirstResponder {
    return YES;
}

#if !defined(TARGET_IOS) && !defined(TARGET_TVOS)

- (void)mouseDown:(NSEvent *)event {
    NSPoint eventLocation = [event locationInWindow];

    RTBTouch *touch = _rtbTouches.firstObject;
    touch.began = YES;
    touch.ended = NO;
    touch.beganLock = NO;
    touch.active = YES;

    [self convertCoordinates:touch point:eventLocation];
}

- (void)mouseUp:(NSEvent *)event {
    NSPoint eventLocation = [event locationInWindow];

    RTBTouch *touch = _rtbTouches.firstObject;
    touch.began = NO;
    touch.beganLock = NO;
    touch.ended = YES;
    touch.active = YES;

    [self convertCoordinates:touch point:eventLocation];
}

- (void)mouseMoved:(NSEvent *)event {
}

- (void)mouseDragged:(NSEvent *)event {
    NSPoint eventLocation = [event locationInWindow];

    RTBTouch *touch = _rtbTouches.firstObject;
    [self convertCoordinates:touch point:eventLocation];
}

- (void)convertCoordinates:(RTBTouch *)touch point:(NSPoint)point {
    int inputX = point.x;
    int inputY = point.y;

    inputY = abs(512-inputY);
    float inputXf = inputX;
    float inputYf = inputY;

    inputXf *= 0.5;
    inputYf *= 0.5;

    touch.x = (int)inputXf;
    touch.y = (int)inputYf;
}

#endif

#pragma mark - MacRendererDelegate

- (void)macRendererDrawCompleted {
    [self update];
}

@end

