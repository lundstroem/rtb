//
//  Shader.fsh
//  cengine-ios
//
//  Created by Harry Lundstrom on 23/07/15.
//  Copyright (c) 2015 Palestone Software. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
