//
//  STActions.m
//
//  Created by Steve Tranby on 10/18/11.
//  Copyright (c) Steve Tranby. All rights reserved.
//

#import "STActions.h"
#import "cocos2d.h"

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////

@implementation STRemoveFromParentAction

+(id)actionWithCleanup:(BOOL)cleanup {
	return [[[self alloc] initWithCleanup:cleanup] autorelease];
}

-(id)initWithCleanup:(BOOL)cleanup
{
    if( (self = [super init]) )
    {
        shouldCleanup = cleanup;
    }
    return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	CCActionInstant *copy = [[[self class] allocWithZone: zone] initWithCleanup:shouldCleanup];
	return copy;
}

-(void) startWithTarget:(id)aTarget
{
	[super startWithTarget:aTarget];
	[[(CCSprite*)aTarget parent] removeChild:(CCSprite*)aTarget cleanup:shouldCleanup];
    aTarget = nil;
}

@end

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////

@implementation STAnimateInSync

+(id)actionWithAnimation:(CCAnimation*)anim
         animationToSync:(CCAnimation*)animSync
            TargetToSync:(CCNode*)targetToSync
{
	return [[[self alloc] initWithAnimation:anim
                            animationToSync:animSync
                                 TargetToSync:targetToSync] autorelease];
}

-(id)initWithAnimation:(CCAnimation*)anim
       animationToSync:(CCAnimation*)animSync
          TargetToSync:(CCNode*)targetToSync
{
	NSAssert( anim != nil, @"Animate: argument anim must be non-nil");
	NSAssert( animSync != nil, @"Animate: argument animSync must be non-nil");
	NSAssert( targetToSync != nil, @"Animate: argument node must be non-nil");

	if((self=[super initWithAnimation:anim]))
	{
		self.animationToSync = animSync;
		_targetToSync = targetToSync;
	}
	return self;
}

-(id)copyWithZone:(NSZone*)zone
{
	return [[[self class] allocWithZone:zone] initWithAnimation:_animation
                                                animationToSync:_animationToSync
                                                     TargetToSync:_targetToSync];
}

-(void) dealloc
{
	[_animationToSync release];
	[super dealloc];
}

#pragma mark

-(void)update:(ccTime)t
{
    // if t==1, ignore. Animation should finish with t==1
	if( t < 1.0f ) {
		t *= _animation.loops;

		// new loop?  If so, reset frame counter
		NSUInteger loopNumber = (NSUInteger)t;
		if( loopNumber > _executedLoops ) {
			_nextFrame = 0;
			_executedLoops++;
		}

		// new t for animations
		t = fmodf(t, 1.0f);
	}

	NSArray *frames = [_animation frames];
	NSUInteger numberOfFrames = [frames count];
	CCSpriteFrame *frameToDisplay = nil;

    // Sync Animation
	NSArray *framesToSync = [_animationToSync frames];
	NSUInteger numberOfFramesSync = [framesToSync count];
    CCSpriteFrame *frameSyncToDisplay = nil;

	for( NSUInteger i=_nextFrame; i < numberOfFrames; i++ ) {
		NSNumber *splitTime = [_splitTimes objectAtIndex:i];

		if( [splitTime floatValue] <= t ) {
			CCAnimationFrame *frame = [frames objectAtIndex:i];
			frameToDisplay = [frame spriteFrame];
			[(CCSprite*)_target setDisplayFrame: frameToDisplay];

            // Sync Animation
            if(i < numberOfFramesSync)
            {
                CCAnimationFrame *frameSync = [framesToSync objectAtIndex:i];
                frameSyncToDisplay = [frameSync spriteFrame];
            }
            else
            {
                frameSyncToDisplay = nil;
            }
            [(CCSprite*)_targetToSync setDisplayFrame: frameSyncToDisplay];

			NSDictionary *dict = [frame userInfo];
			if( dict )
				[[NSNotificationCenter defaultCenter] postNotificationName:CCAnimationFrameDisplayedNotification object:_target userInfo:dict];

			_nextFrame = i+1;
		}
		// Issue 1438. Could be more than one frame per tick, due to low frame rate or frame delta < 1/FPS
		else
			break;
	}
}

- (CCActionInterval *) reverse
{
	NSArray *oldArray = [_animation frames];
	NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:[oldArray count]];
    NSEnumerator *enumerator = [oldArray reverseObjectEnumerator];
    for (id element in enumerator)
        [newArray addObject:[[element copy] autorelease]];

	CCAnimation *newAnim = [CCAnimation animationWithAnimationFrames:newArray
                                                        delayPerUnit:_animation.delayPerUnit
                                                               loops:_animation.loops];
	newAnim.restoreOriginalFrame = _animation.restoreOriginalFrame;


    // Sync Animation
    NSArray *oldArrayToSync = [_animationToSync frames];
	NSMutableArray *newArrayToSync = [NSMutableArray arrayWithCapacity:[oldArrayToSync count]];
    NSEnumerator *enumeratorToSync = [oldArrayToSync reverseObjectEnumerator];
    for (id element in enumeratorToSync)
        [newArray addObject:[[element copy] autorelease]];

	CCAnimation *newAnimToSync = [CCAnimation animationWithAnimationFrames:newArrayToSync
                                                              delayPerUnit:_animationToSync.delayPerUnit
                                                                     loops:_animationToSync.loops];
	newAnimToSync.restoreOriginalFrame = _animation.restoreOriginalFrame;


	return [[self class] actionWithAnimation:newAnim
                             animationToSync:newAnimToSync
                                TargetToSync:_targetToSync];
}

@end

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
