//
//  CCAnimationCacheExtensions.m
//
//  Created by Steve Tranby on 7/13/11.
//  Copyright (c) Steve Tranby. All rights reserved.
//

#import "CCAnimationCache+Utils.h"
#import "cocos2d.h"

#import "FixCategoryBug.h"
FIX_CATEGORY_BUG(CCAnimationCache)


@implementation CCAnimationCache (Utils)


-(void)addAnimationWithName:(NSString*)animName
                  FrameName:(NSString*)animFrameName
              FrameIndicies:(NSArray*)animFrameIndicies
                 FrameDelay:(GLfloat)frameDelay
{
    CCAnimationCache *animCache = [CCAnimationCache sharedAnimationCache];

    if([animCache animationByName:animName])
    {
        //dlog(@"already in cache");
        return;
    }

    int n = [animFrameIndicies count];
    //    dlog(@"n = %d", n);

    if(n <= 0) return;

    NSMutableArray *useAnimFrames = [NSMutableArray array];
    for(int i = 0; i < n; ++i)
    {
        id num = [animFrameIndicies objectAtIndex:i];
        int index = [num intValue];
        NSString *frameName = [NSString stringWithFormat:@"%@-%03d.png", animFrameName, index];
        CCSpriteFrame *spriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
        if(spriteFrame)
        {
            //dlog(@"added spriteframe %@", frameName);
            [useAnimFrames addObject:spriteFrame];
        }
        else
        {
            derr(@"NOT adding spriteframe %@", frameName);
        }
    }

    if([useAnimFrames count] > 0)
    {
        CCAnimation *anim = [CCAnimation animationWithSpriteFrames:useAnimFrames delay:frameDelay];
        [animCache addAnimation:anim name:animName];
        //dlog(@"animation %@ added with %d frames and delay %.2f", animName, [useAnimFrames count], frameDelay);
    }
    else
    {
        //derr(@"animation %@ not added with 0 frames", animName);
    }
}

-(void)addAnimationWithName:(NSString*)animName
                  FrameName:(NSString*)animFrameName
              FrameIndicies:(NSArray*)animFrameIndicies
{
    [self addAnimationWithName:animName
                     FrameName:animFrameName
                 FrameIndicies:animFrameIndicies
                    FrameDelay:0.1];
}

// Animation frames must exist in CCSpriteFrameCache before calling this
-(void)addAnimationWithName:(NSString*)animName
           FrameIndexString:(NSString*)animFrameIndexString
                 FrameDelay:(GLfloat)frameDelay
{
    NSArray *indicies = [animFrameIndexString componentsSeparatedByString:@","];
    [self addAnimationWithName:animName
                     FrameName:animName
                 FrameIndicies:indicies];
}

-(void)addAnimationWithName:(NSString*)animName
           FrameIndexString:(NSString*)animFrameIndexString
{
    [self addAnimationWithName:animName
              FrameIndexString:animFrameIndexString
     FrameDelay:0.1];
}


-(void)addAnimationWithName:(NSString*)animName
                  FrameName:(NSString*)animFrameName
              FrameIndexArray:(int*)animFrameIndexArray
            FrameIndexCount:(size_t)animFrameIndexCount
                 FrameDelay:(GLfloat)frameDelay
{
//    dlog(@"indexCount %lu", animFrameIndexCount);
    NSMutableArray *animFrameIndicies = [[NSMutableArray alloc] initWithCapacity:animFrameIndexCount];
    for(int i = 0; i < animFrameIndexCount; ++i)
    {
        int index = animFrameIndexArray[i];
        [animFrameIndicies addObject:[NSNumber numberWithInt:index]];
    }
    [self addAnimationWithName:animName
                     FrameName:animFrameName
                 FrameIndicies:animFrameIndicies];
    // dlog(@"exit");
    [animFrameIndicies release];
}

-(void)addAnimationWithName:(NSString*)animName
                  FrameName:(NSString*)animFrameName
            FrameIndexArray:(int*)animFrameIndexArray
            FrameIndexCount:(size_t)animFrameIndexCount
{
    [self addAnimationWithName:animName
                     FrameName:animFrameName
               FrameIndexArray:animFrameIndexArray
               FrameIndexCount:animFrameIndexCount
                    FrameDelay:0.1];

}

-(void)addAnimationWithName:(NSString*)animName
            FrameIndexArray:(int*)animFrameIndexArray
            FrameIndexCount:(size_t)animFrameIndexCount
                 FrameDelay:(GLfloat)frameDelay
{
    [self addAnimationWithName:animName
                     FrameName:animName
               FrameIndexArray:animFrameIndexArray
               FrameIndexCount:animFrameIndexCount
                    FrameDelay:frameDelay];
}

-(void)addAnimationWithName:(NSString*)animName
            FrameIndexArray:(int*)animFrameIndexArray
            FrameIndexCount:(size_t)animFrameIndexCount
{
    [self addAnimationWithName:animName
                     FrameName:animName
               FrameIndexArray:animFrameIndexArray
               FrameIndexCount:animFrameIndexCount
                    FrameDelay:0.1];
}

-(void)addAnimationWithName:(NSString*)animName
                     Format:(NSString*)animFormat
             FrameIndexList:(NSString*)frameIndexList
{
    NSString *delimiter = @",";
    NSArray *animFrameIndicies = [frameIndexList componentsSeparatedByString:delimiter];

    if(! animName)
        animName = animFormat;

    [self addAnimationWithName:animName
                     FrameName:animFormat
                 FrameIndicies:animFrameIndicies
                    FrameDelay:0.1];
}

#pragma mark - single image sequence animations

//-(void)addAnimWithName:(NSString*)animName
//           FrameFormat:(NSString*)frameFormat
//         FrameIndicies:(NSArray*)frameIndicies
//            FrameDelay:(GLfloat)frameDelay
//{
//    CCAnimationCache *animCache = [CCAnimationCache sharedAnimationCache];
//
//    if([cache animationByName:animName])
//    {
//        dlog(@"already in cache");
//        return;
//    }
//
//    int n = [frameIndicies count];
//    //    dlog(@"n = %d", n);
//
//    if(n <= 0) return;
//
//    NSMutableArray *useAnimFrames = [NSMutableArray array];
//    for(int i = 0; i < n; ++i)
//    {
//        id num = [frameIndicies objectAtIndex:i];
//        int index = [num intValue];
//        NSString *frameName = [NSString stringWithFormat:frameFormat, index];
//        CCSpriteFrame *spriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
//        if(spriteFrame)
//        {
//            //dlog(@"added spriteframe %@", frameName);
//            [useAnimFrames addObject:spriteFrame];
//        }
//    }
//
//    if([useAnimFrames count] > 0)
//    {
//        CCAnimation *anim = [CCAnimation animationWithSpriteFrames:useAnimFrames delay:frameDelay];
//        [animCache addAnimation:anim name:animName];
//        //dlog(@"animation %@ added with %d frames and delay %.2f", animName, [useAnimFrames count], frameDelay);
//    }
//    else
//    {
//        //derr(@"animation %@ not added with 0 frames", animName);
//    }
//}

#pragma  mark - spritesheet sequence

-(void)addAnimWithName:(NSString*)animName
           FrameFormat:(NSString*)frameFormat
         FrameIndicies:(NSArray*)frameIndicies
            FrameDelay:(GLfloat)frameDelay
{
    CCAnimationCache *animCache = [CCAnimationCache sharedAnimationCache];
    if([animCache animationByName:animName])
    {
        //dlog(@"already in cache");
        return;
    }

    int n = [frameIndicies count];
    //    dlog(@"n = %d", n);

    if(n <= 0) return;

    NSMutableArray *useAnimFrames = [NSMutableArray array];
    for(int i = 0; i < n; ++i)
    {
        id num = [frameIndicies objectAtIndex:i];
        int index = [num intValue];
        NSString *frameName = [NSString stringWithFormat:frameFormat, index];
        CCSpriteFrame *spriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
        if(spriteFrame)
        {
            //dlog(@"added spriteframe %@", frameName);
            [useAnimFrames addObject:spriteFrame];
        }
        else
        {
            //derr(@"not adding spriteframe %@", frameName);
        }
    }

    if([useAnimFrames count] > 0)
    {
        CCAnimation *anim = [CCAnimation animationWithSpriteFrames:useAnimFrames delay:frameDelay];
        [animCache addAnimation:anim name:animName];
        //dlog(@"animation %@ added with %d frames and delay %.2f", animName, [useAnimFrames count], frameDelay);
    }
    else
    {
        //derr(@"animation %@ not added with 0 frames", animName);
    }
}

-(void)addAnimWithName:(NSString*)animName
           FrameFormat:(NSString*)frameFormat
           FrameString:(NSString *)frameString
            FrameDelay:(float)delay
{
    NSAssert(animName, @"Animation Name must be specified!");
    NSArray *frameIndicies = [frameString componentsSeparatedByString:@","];
    [self addAnimWithName:animName
              FrameFormat:frameFormat
            FrameIndicies:frameIndicies
               FrameDelay:delay];
}

-(void)addAnimWithName:(NSString*)animName
           FrameFormat:(NSString*)frameFormat
           FrameString:(NSString *)frameString
{
    NSAssert(animName, @"Animation Name must be specified!");
    NSArray *frameIndicies = [frameString componentsSeparatedByString:@","];
    [self addAnimWithName:animName
              FrameFormat:frameFormat
            FrameIndicies:frameIndicies
               FrameDelay:0.1];
}

@end
