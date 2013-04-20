//
//  CCNode+Utils.m
//
//  Created by Steve Tranby on 10/17/11.
//  Copyright (c) Steve Tranby. All rights reserved.
//

#import "CCNode+Utils.h"

@implementation CCNode (Utils)

//
// Test if contains point in world space, taking into account parents offsets
//
-(BOOL)containsPoint:(CGPoint)point
{
    CGRect bbox = CGRectMake(0, 0, _contentSize.width, _contentSize.height);
    CGPoint locationInNodeSpace = [self convertToNodeSpace:point];
    return CGRectContainsPoint(bbox, locationInNodeSpace);
}

-(BOOL)containsTouch:(UITouch*)touch
{
    CCDirector* director = [CCDirector sharedDirector];
    CGPoint locationGL = [director convertToGL:[touch locationInView:director.view]];
    return [self containsPoint:locationGL];
}

// Set relative position to screen size (0.0-1.0)
-(void)setRelativePosition:(CGPoint)newPosition
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
//    BOOL landscape = winSize.width > winSize.height ? YES : NO;
    newPosition = CGPointMake(newPosition.x * winSize.width,
                              newPosition.y * winSize.height);
    [self setPosition:newPosition];
}

-(void)scaleToSize:(CGSize)size fitType:(CCScaleFit)fitType
{
	CGSize targetSize = size;
	CGSize mySize = [self contentSize];

	float targetAspect = targetSize.width/targetSize.height;
	float myAspect = mySize.width/mySize.height;

	float xScale;
	float yScale;

	switch (fitType)
	{
		case CCScaleFitFull:
			xScale = targetSize.width/mySize.width;
			yScale = targetSize.height/mySize.height;
			break;

		case CCScaleFitAspectFit:
			if(targetAspect > myAspect)
			{
				xScale = yScale = targetSize.height/mySize.height;
			}
			else
			{
				yScale = xScale = targetSize.width/mySize.width;
			}
			break;

		case CCScaleFitAspectFill:

			if(targetAspect > myAspect)
			{
				xScale = yScale = targetSize.width/mySize.width;
			}
			else
			{
				yScale = xScale = targetSize.height/mySize.height;
			}
			break;

		default:
            xScale = [self scaleX];
            yScale = [self scaleY];
			break;
	}

	[self setScaleX:xScale];
	[self setScaleY:yScale];

}

@end