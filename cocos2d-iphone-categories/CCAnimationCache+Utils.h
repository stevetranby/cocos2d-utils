//
//  CCAnimationCacheExtensions.h
//
//  Created by Steve Tranby on 7/13/11.
//  Copyright (c) Steve Tranby. All rights reserved.
//

#import "CCAnimationCache.h"

@interface CCAnimationCache (SCExtensions)

-(void)addAnimationWithName:(NSString*)animName
                  FrameName:(NSString*)animFrameName
              FrameIndicies:(NSArray*)animFrameIndicies
                 FrameDelay:(GLfloat)frameDelay;

-(void)addAnimationWithName:(NSString*)animName
                  FrameName:(NSString*)animFrameName
              FrameIndicies:(NSArray*)animFrameIndicies;

///////

-(void)addAnimationWithName:(NSString*)animName
                  FrameName:(NSString*)animFrameName
           FrameIndexString:(NSString*)animFrameIndexString
                 FrameDelay:(GLfloat)frameDelay;

-(void)addAnimationWithName:(NSString*)animName
                  FrameName:(NSString*)animFrameName
           FrameIndexString:(NSString*)animFrameIndexString;

///////

-(void)addAnimationWithName:(NSString*)animName
                  FrameName:(NSString*)animFrameName
            FrameIndexArray:(int*)animFrameIndexArray
            FrameIndexCount:(size_t)animFrameIndexCount
                 FrameDelay:(GLfloat)frameDelay;

-(void)addAnimationWithName:(NSString*)animName
                  FrameName:(NSString*)animFrameName
            FrameIndexArray:(int*)animFrameIndexArray
            FrameIndexCount:(size_t)animFrameIndexCount;

///////

-(void)addAnimationWithName:(NSString*)animName
            FrameIndexArray:(int*)animFrameIndexArray
            FrameIndexCount:(size_t)animFrameIndexCount
                 FrameDelay:(GLfloat)frameDelay;

-(void)addAnimationWithName:(NSString*)animName
            FrameIndexArray:(int*)animFrameIndexArray
            FrameIndexCount:(size_t)animFrameIndexCount;

-(void)addAnimationWithName:(NSString*)animName
                     Format:(NSString*)animFormat
             FrameIndexList:(NSString*)frameIndexList;

/////

-(void)addAnimWithName:(NSString*)animName
           FrameFormat:(NSString*)frameFormat
         FrameIndicies:(NSArray*)frameIndicies
            FrameDelay:(GLfloat)frameDelay;

-(void)addAnimWithName:(NSString*)animName
           FrameFormat:(NSString*)frameFormat
           FrameString:(NSString *)frameString
            FrameDelay:(float)delay;

-(void)addAnimWithName:(NSString*)animName
           FrameFormat:(NSString*)frameFormat
           FrameString:(NSString *)frameString;

@end
