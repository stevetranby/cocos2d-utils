//
//  STSpriteMasked.m
//
//  Created by Steve Tranby on 10/24/12.
//  Copyright (c) 2012 Steve Tranby. All rights reserved.
//

#import "STSpriteMasked.h"
#import "cocos2d.h"

@implementation STSpriteMasked


- (id)initWithFile:(NSString *)file
{
    if ((self = [super initWithFile:file]))
    {
        const GLchar * fragmentSource = (GLchar*) [[NSString stringWithContentsOfFile:[[CCFileUtils sharedFileUtils] fullPathFromRelativePath:@"STGradientMask_frag.txt"] encoding:NSUTF8StringEncoding error:nil] UTF8String];
        self.shaderProgram = [[[CCGLProgram alloc] initWithVertexShaderByteArray:ccPositionTextureA8Color_vert
                                                        fragmentShaderByteArray:fragmentSource] autorelease];
        [self.shaderProgram addAttribute:kCCAttributeNamePosition index:kCCVertexAttrib_Position];
        [self.shaderProgram addAttribute:kCCAttributeNameTexCoord index:kCCVertexAttrib_TexCoords];
        [self.shaderProgram link];
        [self.shaderProgram updateUniforms];
        [self.shaderProgram use];

        glActiveTexture(GL_TEXTURE1);
        glBindTexture(GL_TEXTURE_2D, [[self texture] name]);
        glActiveTexture(GL_TEXTURE0);
    }

    return self;
}

@end
