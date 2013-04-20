//
//  CCSpriteFrameCache+Alias.m
//
//  Created by Steve Tranby on 10/24/11.
//  Copyright (c) Steve Tranby. All rights reserved.
//

#import "CCSpriteFrameCache+Alias.h"
#import "CCTextureCache.h"
#import "CCSprite.h"

#import "FixCategoryBug.h"
FIX_CATEGORY_BUG(CCSpriteFrameCache)

@implementation CCSpriteFrameCache (Alias)

-(void)updateSprite:(CCSprite*)sprite WithFrameName:(NSString*)frameName
{
    if(! sprite)
    {
        derr(@"sprite is NIL!");
        return;
    }

    if(! frameName)
    {
        derr(@"frameName is NIL!");
        return;
    }

    CCSpriteFrameCache *cache = [CCSpriteFrameCache sharedSpriteFrameCache];
    CCSpriteFrame *spriteFrame = [cache spriteFrameByName:frameName];
    if(spriteFrame)
    {
        [sprite setDisplayFrame:spriteFrame];
    }
    else
    {
        CCTexture2D *tex = [[CCTextureCache sharedTextureCache] addImage:frameName];
        CCSprite *newSprite = [CCSprite spriteWithFile:frameName];
        if(tex && newSprite)
        {
            spriteFrame = [newSprite displayFrame];
            if(spriteFrame)
            {
                [sprite setDisplayFrame:spriteFrame];
                [cache addSpriteFrame:spriteFrame
                                 name:frameName];
            }
        }
    }
}

-(void)addFileWithName:(NSString*)frameName
{
    CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    CCTexture2D* tex = [[CCTextureCache sharedTextureCache] addImage:frameName];
    CCSprite* newSprite = [CCSprite spriteWithFile:frameName];
    if(tex && newSprite)
    {
        CCSpriteFrame* spriteFrame = [newSprite displayFrame];
        if(spriteFrame)
        {
            [frameCache addSpriteFrame:spriteFrame name:frameName];
        }
    }
}

@end
