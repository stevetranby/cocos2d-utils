//
//  CCDirector+Extensions.m
//
//  Created by Steve Tranby on 6/19/12.
//  Copyright (c) 2012 Steve Tranby. All rights reserved.
//

#import "CCDirector+Extensions.h"
#import "CCScene.h"
#import "CCTransition.h"

@implementation CCDirector (Extensions)

-(void) popSceneWithTransition:(CCTransitionFade*)transition duration:(ccTime)t
{
//    NSAssert( runningScene_ != nil, @"A running Scene is needed");
//
//    [scenesStack_ removeLastObject];
//    NSUInteger c = [scenesStack_ count];
//    dlog(@"%d scenes in stack!", c);
//    if( c == 0 )
//    {
//        [self end];
//    }
//    else
//    {
//        CCScene *curScene = [[scenesStack_ objectAtIndex:c-1] retain];
//        dlog(@"curscene = %@, sceneStack = %@", curScene, scenesStack_);
//        CCScene *scene = [transitionClass transitionWithDuration:t scene:curScene];
//        dlog(@"scene = %@", scene);
//        [scenesStack_ replaceObjectAtIndex:c-1 withObject:scene];
//        nextScene_ = scene;
//    }
}

@end
