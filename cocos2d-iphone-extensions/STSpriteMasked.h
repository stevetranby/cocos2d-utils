//
//  STSpriteMasked.h
//
//  Created by Steve Tranby on 10/24/12.
//  Copyright (c) 2012 Steve Tranby. All rights reserved.
//

#import "CCSprite.h"

@interface STSpriteMasked : CCSprite
{
    GLuint	_textureLocation;
    GLuint	_maskLocation;
}

@end
