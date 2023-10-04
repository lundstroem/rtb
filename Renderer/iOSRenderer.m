/*
 Copyright © 2019 Apple Inc.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

@import simd;
@import MetalKit;

#import "iOSRenderer.h"

// Header shared between C code here, which executes Metal API commands, and .metal files, which
//   uses these types as inputs to the shaders
#import "ShaderTypes.h"

// Main class performing the rendering
@implementation iOSRenderer {
    // The device (aka GPU) used to render
    id<MTLDevice> _device;

    id<MTLRenderPipelineState> _pipelineState;

    // The command Queue used to submit commands.
    id<MTLCommandQueue> _commandQueue;

    // The Metal texture object
    id<MTLTexture> _texture;

    // The Metal buffer that holds the vertex data.
    id<MTLBuffer> _vertices;

    // The number of vertices in the vertex buffer.
    NSUInteger _numVertices;

    // The current size of the view.
    vector_uint2 _viewportSize;
}

static unsigned int *pixels = NULL;
static int width = 256;
static int height = 256;
//static float scaling = 5.3f;
static float scaling = 1.0f;

- (void *)pixels {
    return pixels;
}

- (void)increaseScaling {
    //scaling += 0.0001;
    //NSLog(@"inc scaling: %f", scaling);
}

- (void)decreaseScaling {
    //scaling -= 0.0001;
    //NSLog(@"dec scaling: %f", scaling);
}

- (void)setupScaling {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;

    CGFloat size = screenHeight;
    if (screenWidth > screenHeight) {
        size = screenWidth;
    }

    NSLog(@"size %f", size);

    NSUInteger scale = UIScreen.mainScreen.scale;
    CGSize screenSize = UIScreen.mainScreen.fixedCoordinateSpace.bounds.size;
    NSLog(@"w:%f h:%f scale:%lu", screenSize.width, screenSize.height, (unsigned long)scale);

    CGFloat physicalWidth = screenSize.width * scale;

    CGFloat rawScaling = physicalWidth / 256.0;

    CGFloat decimals = fmodf(rawScaling, 1.0);

    // TODO: Determine which devices give incorrect physical size when using screenWidth * scale and hardcode those.

    // Make uniform virtual pixel sizes.
    if (decimals > 0.90) {
        // It's ok to round up in this case as we won't lose "too" much of the screen.
        scaling = ceil(rawScaling);
    } else {
        scaling = floor(rawScaling);
    }

    // Would it make sense to rewrite touch to use the same system? Would make if less prone to differences hopefully.
    // If using less pixelsize (rounding down) touch conversion could use this as well by sizing down 256 to the correct size. (4,60546875 == 256, 4.0 == 235.8) and set offsets on start and end to center it. Would need to convert touch to physical width grid etc.

    // iPhone 15 2556 × 1179


/*

    // pixel size
    1179 / 256 = 4,60546875

    4 * 256 = 1024;

 */
    //scaling = 3*2;


    /*

     if we can get the physical width of the device, we will be able to
     make a scaling with correct pixel sizes.
     However using screenWidth * sizetype might give the wrong value..

     */

    /*
    // iPhone X
    if(size == 812) {
        scaling = 7.936213f;
    // MAX
    } else if (size == 896) {
        scaling = 8.704093f;
    // SE
    } else if (size == 568) {
        scaling = 4.546494f;
    } else {
        scaling = 5.3f;
    }
    */
}

- (id<MTLTexture>)createTexture {

    [self setupScaling];

    MTLTextureDescriptor *textureDescriptor = [[MTLTextureDescriptor alloc] init];

    // Indicate that each pixel has a blue, green, red, and alpha channel, where each channel is
    // an 8-bit unsigned normalized value (i.e. 0 maps to 0.0 and 255 maps to 1.0)
    textureDescriptor.pixelFormat = MTLPixelFormatBGRA8Unorm;

    // Set the pixel dimensions of the texture
    textureDescriptor.width = width;
    textureDescriptor.height = height;

    // Create the texture from the device by using the descriptor
    id<MTLTexture> texture = [_device newTextureWithDescriptor:textureDescriptor];

    return texture;
}

- (void)updateTexture {
    MTLRegion region = {
        { 0, 0, 0 },  // MTLOrigin
        {width, height, 1} // MTLSize
    };
    int size = width * height;
    if (pixels == NULL) {
        pixels = malloc(sizeof(unsigned int) * size);
    }

    // Copy the bytes from the data object into the texture
    [_texture replaceRegion:region
                mipmapLevel:0
                  withBytes:(void *)pixels
                bytesPerRow:4 * width];
}

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView {
    self = [super init];
    if(self) {
        _device = mtkView.device;
        _texture = [self createTexture];
        [self updateTexture];

        // Set up a simple MTLBuffer with vertices which include texture coordinates
        static const Vertex quadVertices[] = {
            // Pixel positions, Texture coordinates
            { {  250,  -250 },  { 1.f, 1.f } },
            { { -250,  -250 },  { 0.f, 1.f } },
            { { -250,   250 },  { 0.f, 0.f } },

            { {  250,  -250 },  { 1.f, 1.f } },
            { { -250,   250 },  { 0.f, 0.f } },
            { {  250,   250 },  { 1.f, 0.f } },
        };

        // Create a vertex buffer, and initialize it with the quadVertices array
        _vertices = [_device newBufferWithBytes:quadVertices
                                         length:sizeof(quadVertices)
                                        options:MTLResourceStorageModeShared];

        // Calculate the number of vertices by dividing the byte length by the size of each vertex
        _numVertices = sizeof(quadVertices) / sizeof(Vertex);

        /// Create the render pipeline.

        // Load the shaders from the default library
        id<MTLLibrary> defaultLibrary = [_device newDefaultLibrary];
        id<MTLFunction> vertexFunction = [defaultLibrary newFunctionWithName:@"vertexShader"];
        id<MTLFunction> fragmentFunction = [defaultLibrary newFunctionWithName:@"samplingShader"];

        // Set up a descriptor for creating a pipeline state object
        MTLRenderPipelineDescriptor *pipelineStateDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
        pipelineStateDescriptor.label = @"Texturing Pipeline";
        pipelineStateDescriptor.vertexFunction = vertexFunction;
        pipelineStateDescriptor.fragmentFunction = fragmentFunction;
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat;

        NSError *error = NULL;
        _pipelineState = [_device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor
                                                                 error:&error];

        NSAssert(_pipelineState, @"Failed to created pipeline state, error %@", error);

        _commandQueue = [_device newCommandQueue];
    }

    return self;
}

/// Called whenever view changes orientation or is resized
- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size
{
    // Save the size of the drawable to pass to the vertex shader.
    _viewportSize.x = size.width;
    _viewportSize.y = size.height;
}

/// Called whenever the view needs to render a frame
- (void)drawInMTKView:(nonnull MTKView *)view {
    // Create a new command buffer for each render pass to the current drawable
    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    commandBuffer.label = @"MyCommand";

    [commandBuffer addCompletedHandler:^(id<MTLCommandBuffer> cb) {
        //CFTimeInterval executionDuration = cb.GPUEndTime - cb.GPUStartTime;
        /* ... write to texture */
        [self updateTexture];
        [self.delegate iOSRendererDrawCompleted];
    }];

    // Obtain a renderPassDescriptor generated from the view's drawable textures
    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;

    if(renderPassDescriptor != nil) {
        id<MTLRenderCommandEncoder> renderEncoder =
        [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        renderEncoder.label = @"MyRenderEncoder";

        // Set the region of the drawable to draw into.
        [renderEncoder setViewport:(MTLViewport){0.0, 0.0, _viewportSize.x, _viewportSize.y, -1.0, 1.0 }];
        [renderEncoder setRenderPipelineState:_pipelineState];
        [renderEncoder setVertexBuffer:_vertices
                                offset:0
                              atIndex:VertexInputIndexVertices];
        [renderEncoder setVertexBytes:&_viewportSize
                               length:sizeof(_viewportSize)
                              atIndex:VertexInputIndexViewportSize];
        [renderEncoder setVertexBytes:&scaling
                               length:sizeof(float)
                              atIndex:2];
        // Set the texture object.  The TextureIndexBaseColor enum value corresponds
        ///  to the 'colorMap' argument in the 'samplingShader' function because its
        //   texture attribute qualifier also uses TextureIndexBaseColor for its index.
        [renderEncoder setFragmentTexture:_texture
                                  atIndex:TextureIndexBaseColor];

        // Draw the triangles.
        [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle
                          vertexStart:0
                          vertexCount:_numVertices];

        [renderEncoder endEncoding];

        // Schedule a present once the framebuffer is complete using the current drawable
        [commandBuffer presentDrawable:view.currentDrawable];
    }

    // Finalize rendering here & push the command buffer to the GPU
    [commandBuffer commit];
}

@end
