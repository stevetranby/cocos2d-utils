//
//  CCSpriteExtensions.m
//
//  Created by Steve Tranby on 9/21/11.
//  Copyright (c) Steve Tranby. All rights reserved.
//

#import "CCSprite+Utils.h"
#import "cocos2d.h"
#import "CCDirector.h"

#import "FixCategoryBug.h"
FIX_CATEGORY_BUG(CCSprite)

@implementation CCSprite (Utils)

+(id) spriteWithSpriteFrameNameOrFile:(NSString*)nameOrFile
{
    if(! nameOrFile)
        return nil;

    CCSpriteFrameCache *cache = [CCSpriteFrameCache sharedSpriteFrameCache];
    CCSprite *retSprite = nil;

    CCSpriteFrame* spriteFrame = [cache spriteFrameByName:nameOrFile];
    if (spriteFrame && [spriteFrame texture])
    {
        //dlog(@"found sprite frame %@", nameOrFile);
        retSprite = [self spriteWithSpriteFrame:spriteFrame];
    }
    else
    {
        //derr(@"no sprite frame, trying to get from file %@", nameOrFile);
        retSprite = [self spriteWithFile:nameOrFile];
    }
    return retSprite;
}

-(void)setRelativePosition:(CGPoint)pos
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CGPoint p = CGPointMake(pos.x * winSize.width,
                            pos.y * winSize.height);
    [self setPosition:p];
}

@end
