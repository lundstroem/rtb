
#import "RTBViewController.h"
#import <OpenGLES/ES2/glext.h>
#import "RTAudioBuffer.h"
#import <pthread.h>
#import <AVFoundation/AVFoundation.h>
#import "RTB-Swift.h"

static RTBViewController *gameViewController = NULL;

@interface RTBViewController ()

@property (strong, nonatomic) EAGLContext *context;
@property (strong) GLKBaseEffect *effect;
@property (strong) NSMutableArray *active_touches;
@property (strong) UIImpactFeedbackGenerator *impactFeedbackGeneratorHeavy;
@property (strong) UIImpactFeedbackGenerator *impactFeedbackGeneratorMedium;
@property (strong) UIImpactFeedbackGenerator *impactFeedbackGeneratorLight;
@property (strong) RTB *rtb;
@property (strong) Input *input;
@property (strong) NSArray<NSNumber *> *rasterObjC;
@property (strong) NSArray<NSNumber *> *audioBufferObjC;

@end

@implementation RTBViewController

@synthesize effect = _effect;
@synthesize context = _context;
@synthesize active_touches;

//struct VLK_input *input = NULL;
static const double screen_scaling_factor = 1.6;
static const double screen_scaling_factor_reverse = 0.625;
static const double screen_16_9_width_factor = 0.5625;

GLuint nID;

int tex16_9 = 180;
int texWidth = 512;
int texHeight = 512;
int visibleTexWidth = 180;
int visibleTexHeight = 320;

GLubyte *textureData;
CGFloat x = 0;
CGFloat y = 0;
CGFloat w = 0;
CGFloat h = 0;
CGFloat visible_w = 0;
CGFloat visible_h = 0;
CGFloat screenWidth = 0;
CGFloat screenHeight = 0;

SInt16 *audioBuffer = NULL;

int audioBufferMax = 4096;
int rasterSize = 57600;
int samplesToWrite = 0;
bool isPrefilled = false;
bool shouldPrefill = false;
int16_t *sine_wave_table;
int sine_wave_table_size = 1024;
double sine_wave_table_cursor = 0;

typedef struct {
    GLKVector2 geometryVertex;
    GLKVector2 textureVertex;
} TexturedVertex;

typedef struct {
    TexturedVertex bl;
    TexturedVertex br;
    TexturedVertex tl;
    TexturedVertex tr;
} TexturedQuad;

int sound_enabled = 1;

#define MAX_TOUCHES 1
#define TARGET_FPS 60
#define landscape 0

pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
OSStatus renderCallback(void *userData,
                        AudioUnitRenderActionFlags *actionFlags,
                        const AudioTimeStamp *audioTimeStamp,
                        UInt32 busNumber,
                        UInt32 numFrames,
                        AudioBufferList *buffers) {
    SInt16 *inputFrames = (SInt16 *)(buffers->mBuffers->mData);
    int totalFrames = numFrames * 2;

    // zero the buffer
    for(int i = 0; i < totalFrames; i++) {
        inputFrames[i] = 0;
    }

    // When generating samples from a data structure such as a synthesizer that is controlled from
    // a UI thread, use a mutex to prevent the two threads from manupulating the data at the same time.
    // The code that manipulates the structure in the UI thread needs to be enclosed with the same mutex.
    // Try to keep the work inside the locks to an absolute minimum to prevent stalling.
    pthread_mutex_lock(&mutex);

    samplesToWrite = totalFrames;

    if(sound_enabled == 0) {
        pthread_mutex_unlock(&mutex);
        return noErr;
    }

    if(totalFrames > audioBufferMax) {
        printf("AudioCallback: totalFrames too big.\n");
        pthread_mutex_unlock(&mutex);
        return noErr;
    }

    if(!isPrefilled) {
        printf("AudioCallback: buffer is not prefilled.\n");
        pthread_mutex_unlock(&mutex);
        return noErr;
    }

    // write samples
    for(int i = 0; i < totalFrames; i += 2) {
        //int16_t sample = 0; audioBuffer[i];
        double amp = 0.3;
        inputFrames[i] += audioBuffer[i] * amp;
        inputFrames[i+1] += audioBuffer[i+1] * amp;
    }
    isPrefilled = false;
    shouldPrefill = true;

    pthread_mutex_unlock(&mutex);
    return noErr;
}

/*
 
 iOS makes a callback with a buffer and length to be filled.
 Once a latency is set, buffer size should remain fairly constant?
 
 suggestion 1: prefill from main thread?
    - first time audioCallback is made, write 0 and store size of buffer.
    - next, prefill buffer of size in main with stored size.
    - in audiocallback write from prefilled buffer of size. If sizes do not match, re-store size to fill
      and report error.
    - every time audiocallback has been made, prefill the buffer to be ready for next time.
 
 */

+ (RTBViewController *)sharedInstance {
    return gameViewController;
}

- (void)initAudio {
    // set the renderCallback and a preferred bufferduration (latency) of 0.02 seconds
    rtAudioInitWithCallback(renderCallback, 0.02);
}

- (void)tearDown {
    free(audioBuffer);
    pthread_mutex_unlock(&mutex);
}

- (void)handleApplicationWillTerminate:(NSNotification*)notification {
    [self tearDown];
}

- (void)handleApplicationDidEnterBackground:(NSNotification*)notification {
}

- (void)handleAudioSessionRouteChanged:(NSNotification*)notification {
    NSLog(@"handleAudioSessionRouteChanged: %@", notification);
}

- (void)handleAudioSessionInterruption:(NSNotification*)notification {
    NSLog(@"handleAudioSessionInterruption: %@", notification);
    NSNumber *interruptionType = [[notification userInfo] objectForKey:AVAudioSessionInterruptionTypeKey];
    NSNumber *interruptionOption = [[notification userInfo] objectForKey:AVAudioSessionInterruptionOptionKey];
    switch (interruptionType.unsignedIntegerValue) {
        case AVAudioSessionInterruptionTypeBegan:{
            NSLog(@"AVAudioSessionInterruptionTypeBegan");
        } break;
        case AVAudioSessionInterruptionTypeEnded: {
            NSLog(@"AVAudioSessionInterruptionTypeEnded");
            if (interruptionOption.unsignedIntegerValue == AVAudioSessionInterruptionOptionShouldResume) {
                NSLog(@"AVAudioSessionInterruptionOptionShouldResume");
                [self initAudio];
            }
        } break;
        default:
            break;
    }
}

- (void)handleMediaServicesReset {
    NSLog(@"handleMediaServicesReset");
    // - No userInfo dictionary for this notification
    // - Audio streaming objects are invalidated (zombies)
    // - Handle this notification by fully reconfiguring audio
    [self initAudio];
}

- (void)addObservers {

    // Audio
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleApplicationWillTerminate:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleApplicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleAudioSessionRouteChanged:)
                                                 name:AVAudioSessionRouteChangeNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleAudioSessionInterruption:)
                                                 name:AVAudioSessionInterruptionNotification
                                               object:[AVAudioSession sharedInstance]];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMediaServicesReset)
                                                 name:AVAudioSessionMediaServicesWereResetNotification
                                               object:[AVAudioSession sharedInstance]];
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionMediaServicesWereResetNotification object:[AVAudioSession sharedInstance]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    gameViewController = self;
    self.rtb = [[RTB alloc] init];
    self.input = [Input new];

    [self initInput];
    [self initVideo];
    [self initTexture];

    [self addObservers];
    [self initAudio];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)initVideo {
    self.preferredFramesPerSecond = TARGET_FPS;
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if(!self.context) {
        NSLog(@"Failed to create ES context");
    }

    // TODO: account for portrait/landscape
    NSMutableArray<NSNumber *> *array = [[NSMutableArray alloc] init];
    for(int r = 0; r < 180 * 320; r++) {
        [array addObject:[NSNumber numberWithUnsignedInteger:0]];
    }
    self.rasterObjC = [array copy];

    audioBuffer = (SInt16 *)malloc(audioBufferMax * sizeof(SInt16));
    for(int r = 0; r < audioBufferMax; r++) {
        audioBuffer[r] = 0;
    }

    array = [[NSMutableArray alloc] init];
    for(int r = 0; r < audioBufferMax; r++) {
        [array addObject:[NSNumber numberWithInteger:0]];
    }
    self.audioBufferObjC = [array copy];

    sine_wave_table = malloc(sizeof(int16_t) * sine_wave_table_size);
    cSynthBuildSineWave(sine_wave_table, sine_wave_table_size);

    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    [EAGLContext setCurrentContext:self.context];

    self.effect = [[GLKBaseEffect alloc] init];

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;

    NSLog(@"screen w:%f h:%f", screenWidth, screenHeight);

    CGFloat size = screenHeight;

    // iPhone X
    if(size == 812) {
        w = 1066.600000;
        h = 1066.600000;
    } else {
        w = screenHeight;
        h = screenHeight;
        w *= screen_scaling_factor;
        h *= screen_scaling_factor;
    }

    visible_w = w;
    visible_h = h;

    [self calculateInsets];

    GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(0, screenWidth, screenHeight, 0, 0, 1);
    self.effect.transform.projectionMatrix = projectionMatrix;
}

- (void)calculateInsets {
    visible_w = w * screen_scaling_factor_reverse;
    visible_h = h * screen_scaling_factor_reverse;
    int x_offset = (screenWidth - (visible_w * screen_16_9_width_factor)) / 2;
    x = x_offset;
    int y_offset = (screenHeight - visible_h) / 2;
    y = y_offset;
}

- (void)initInput {
    // TODO: Setting for multitouch true/false.
    self.view.multipleTouchEnabled = YES;
    self.active_touches = [[NSMutableArray alloc] init];
}

- (void)initTexture {
    textureData = (GLubyte *)malloc(texWidth * texHeight * 4);
    for(int i = 0; i < texWidth*texHeight * 4; i += 4){
        textureData[i] = 0;
        textureData[i+1] = 0;
        textureData[i+2] = 0;
        textureData[i+3] = 255;
    }
    glGenTextures(1, &nID);
    glBindTexture(GL_TEXTURE_2D, nID);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, texWidth, texHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, textureData);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
}

- (void)drawTexture {
    for (int i = 0; i < visibleTexWidth * visibleTexHeight; i++) {
        int iterator = i * 4;
        unsigned int color_int = [[self.rasterObjC objectAtIndex:i] intValue];
        textureData[iterator+3] = color_int & 0xff; //red
        textureData[iterator+2] = (color_int >> 8) & 0xff; //green
        textureData[iterator+1] = (color_int >> 16) & 0xff; //blue
        textureData[iterator] = (color_int >> 24) & 0xff; //alpha
    }

    TexturedQuad newQuad;

    newQuad.bl.geometryVertex = GLKVector2Make(x, y);
    newQuad.br.geometryVertex = GLKVector2Make(x+w, y);
    newQuad.tl.geometryVertex = GLKVector2Make(x, y+h);
    newQuad.tr.geometryVertex = GLKVector2Make(w+x, y+h);

    newQuad.bl.textureVertex = GLKVector2Make(0, 0);
    newQuad.br.textureVertex = GLKVector2Make(1, 0);
    newQuad.tl.textureVertex = GLKVector2Make(0, 1);
    newQuad.tr.textureVertex = GLKVector2Make(1, 1);
    TexturedQuad quad = newQuad;

    long offset = (long)&quad;
    self.effect.texture2d0.name = nID;
    self.effect.texture2d0.enabled = YES;
    [self.effect prepareToDraw];

    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, visibleTexWidth, visibleTexHeight, GL_RGBA, GL_UNSIGNED_BYTE, textureData);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, sizeof(TexturedVertex), (void *) (offset + offsetof(TexturedVertex, geometryVertex)));
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(TexturedVertex), (void *) (offset + offsetof(TexturedVertex, textureVertex)));
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0, 0, 0, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    [self drawTexture];
}

- (void)update {
    double ms_dt = self.timeSinceLastUpdate * 1000;
    pthread_mutex_lock(&mutex);
    
    int prefillSize = samplesToWrite;
    if (!shouldPrefill) {
        prefillSize = 0;
    }

    NSArray<NSNumber *> *r = [self.rtb updateWithDeltaTime:ms_dt
                                                rasterSize:rasterSize
                                           audioBufferSize:prefillSize];
    self.rasterObjC = r;
    isPrefilled = true;

    pthread_mutex_unlock(&mutex);
}

// Make as a protocol, usable in swift?
- (void)update:(double)deltaTime
        raster:(unsigned int *)raster
   audioBuffer:(SInt16 *)audioBuffer
   prefillSize:(int)prefillSize {

    // TODO: Write test data and sinus to audioBuffer.
    for(int i = 0; i < prefillSize; i++) {
        audioBuffer[i] = 0;
    }

    for(int i = 0; i < prefillSize; i += 2) {
        //int16_t sample = 0; audioBuffer[i];
        double amp = 1.0;
        audioBuffer[i] += sine_wave_table[(int)sine_wave_table_cursor] * amp;
        audioBuffer[i+1] += /*(rand() % INT16_MAX) -INT16_MAX/2*/0;

        sine_wave_table_cursor += 10;
        if(sine_wave_table_cursor >= sine_wave_table_size) {
            sine_wave_table_cursor -= sine_wave_table_size;
        }
    }
}

void cSynthBuildSineWave(int16_t *data, int wave_length) {
    
    double pi = 3.14159265358979323846;
    double phaseIncrement = (2.0f * pi)/(double)wave_length;
    double currentPhase = 0.0;
    for(int i = 0; i < wave_length; i++) {
        int sample = (int)(sin(currentPhase) * INT16_MAX);
        data[i] = (int16_t)sample;
        currentPhase += phaseIncrement;
    }
}

- (void)updateTouch:(UITouch *)touch {
    int t_16_9 = w * screen_16_9_width_factor;
    CGPoint l_location = [touch locationInView: [touch view]];
    CGPoint pt = l_location;
    //LogTrace(@"pt.x:%f pt.y:%f", pt.x, pt.y);
    pt.x -= x;
    pt.y -= y;
    if(landscape == 0) {
        pt.x = pt.x/t_16_9;
        pt.y = pt.y/h;
    }
    int t_x = floor(pt.x * (visibleTexWidth * screen_scaling_factor));
    int t_y = floor(pt.y * (visibleTexHeight * screen_scaling_factor));
    
    [self.rtb updateInputCoordinatesWithX:t_x y:t_y];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    for (UITouch *touch in touches) {
        [self updateTouch:touch];
    }
    [self.rtb updateInputStateWithBegan:YES ended:NO];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    for (UITouch *touch in touches) {
        [self updateTouch:touch];
    }
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    for (UITouch *touch in touches) {
        [self updateTouch:touch];
    }
    [self.rtb updateInputStateWithBegan:NO ended:YES];
}

/*
- (void)renderTestScreen {
    for (int r_x = 0; r_x < visibleTexWidth; r_x++) {
        for (int r_y = 0; r_y < visibleTexHeight; r_y++) {
            if(r_x <= visibleTexWidth && r_y <= visibleTexHeight) {
                raster[r_x + r_y * visibleTexWidth] = 0x333300ff;
                if((r_x / 2) + (r_x / 2) == r_x) {
                    raster[r_x + r_y * visibleTexWidth] = 0x3355ffff;
                }
                if((r_y / 2) + (r_y / 2) == r_y) {
                    raster[r_x + r_y * visibleTexWidth] = 0x992233ff;
                }
                if(r_x == 0 || r_y == 0) {
                    raster[r_x + r_y * visibleTexWidth] = 0xff00ffff;
                }
                if(r_y == visibleTexHeight-1) {
                    raster[r_x + r_y * visibleTexWidth] = 0xff00ffff;
                }
                if(r_x == visibleTexWidth-1) {
                    raster[r_x + r_y * visibleTexWidth] = 0xff00ffff;
                }
                if(r_x == 0 && r_y == 0) {
                    raster[r_x + r_y * visibleTexWidth] = 0xffffffff;
                }
            }
        }
    }
}
 */

@end
