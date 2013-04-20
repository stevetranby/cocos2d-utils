//
//  CCTextureCache+TexParameters.m
//
//  Created by Steve Tranby on 11/8/11.
//  Copyright (c) Steve Tranby. All rights reserved.
//

#import "CCTextureCache+TexParameters.h"

#import "FixCategoryBug.h"
FIX_CATEGORY_BUG(CCTextureCache)

@implementation CCTextureCache (AccessTextures)

-(NSMutableDictionary*)allTextures
{
    return _textures;
}

@end
