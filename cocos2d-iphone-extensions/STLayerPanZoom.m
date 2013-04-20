/*
 * CCLayerPanZoom Tests
 *
 * cocos2d-extensions
 * https://github.com/cocos2d/cocos2d-iphone-extensions
 *
 * Copyright (c) 2011 Alexey Lang
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

 /*
  * STLayerPanZoom - extended version by Steve Tranby
  */


#import "STLayerPanZoom.h"
#import "CameraManager.h"
#import "GameConfig.h"

#ifdef DEBUG

/** @class STLayerPanZoomDebugLines Class that represents lines over the STLayerPanZoom
 * for debug frame mode */
@interface STLayerPanZoomDebugLines: CCNode
{
    CGFloat _topFrameMargin;
    CGFloat _bottomFrameMargin;
    CGFloat _leftFrameMargin;
    CGFloat _rightFrameMargin;
}
/** Distance from top edge of contenSize */
@property (readwrite, assign) CGFloat topFrameMargin;
/** Distance from bottom edge of contenSize */
@property (readwrite, assign) CGFloat bottomFrameMargin;
/** Distance from left edge of contenSize */
@property (readwrite, assign) CGFloat leftFrameMargin;
/** Distance from right edge of contenSize */
@property (readwrite, assign) CGFloat rightFrameMargin;

@end

enum nodeTags
{
	kDebugLinesTag,
};

@implementation STLayerPanZoomDebugLines

@synthesize topFrameMargin = _topFrameMargin, bottomFrameMargin = _bottomFrameMargin,
            leftFrameMargin = _leftFrameMargin, rightFrameMargin = _rightFrameMargin;

-(void)draw
{
//    glColor4f(1.0f, 0.0f, 0.0f, 1.0);
//    glLineWidth(2.0f);
//    ccDrawLine(ccp(self.leftFrameMargin, 0.0f),
//               ccp(self.leftFrameMargin, self.contentSize.height));
//    ccDrawLine(ccp(self.contentSize.width - self.rightFrameMargin, 0.0f),
//               ccp(self.contentSize.width - self.rightFrameMargin, self.contentSize.height));
//    ccDrawLine(ccp(0.0f, self.bottomFrameMargin),
//               ccp(self.contentSize.width, self.bottomFrameMargin));
//    ccDrawLine(ccp(0.0f, self.contentSize.height - self.topFrameMargin),
//               ccp(self.contentSize.width, self.contentSize.height - self.topFrameMargin));
}

@end

#endif


typedef enum
{
    kSTLayerPanZoomFrameEdgeNone,
    kSTLayerPanZoomFrameEdgeTop,
    kSTLayerPanZoomFrameEdgeBottom,
    kSTLayerPanZoomFrameEdgeLeft,
    kSTLayerPanZoomFrameEdgeRight,
    kSTLayerPanZoomFrameEdgeTopLeft,
    kSTLayerPanZoomFrameEdgeBottomLeft,
    kSTLayerPanZoomFrameEdgeTopRight,
    kSTLayerPanZoomFrameEdgeBottomRight
} STLayerPanZoomFrameEdge;


@interface STLayerPanZoom ()

@property (readwrite, retain) NSMutableArray *touches;
@property (readwrite, assign) CGFloat touchDistance;
@property (readwrite, retain) CCScheduler *scheduler;
// Return minimum possible scale for the layer considering panBoundsRect and enablePanBounds
- (CGFloat) minPossibleScale;
// Return edge in which current point located
- (STLayerPanZoomFrameEdge) frameEdgeWithPoint: (CGPoint) point;
// Return horizontal speed in order with current position
- (CGFloat) horSpeedWithPosition: (CGPoint) pos;
// Return vertical speed in order with current position
- (CGFloat) vertSpeedWithPosition: (CGPoint) pos;
// Return distance to top edge of screen
- (CGFloat) topEdgeDistance;
// Return distance to left edge of screen
- (CGFloat) leftEdgeDistance;
// Return distance to bottom edge of screen
- (CGFloat) bottomEdgeDistance;
// Return distance to right edge of screen
- (CGFloat) rightEdgeDistance;
// Recover position if it's need for emulate rubber edges
- (void) recoverPositionAndScale;

@end

@implementation STLayerPanZoom

@dynamic maxScale;
- (void) setMaxScale:(CGFloat)maxScale
{
    _maxScale = maxScale;
    self.scale = MIN(self.scale, _maxScale);
}

- (CGFloat) maxScale
{
    return _maxScale;
}

@dynamic minScale;
- (void) setMinScale:(CGFloat)minScale
{
    _minScale = minScale;
    self.scale = MAX(self.scale, minScale);
}

- (CGFloat) minScale
{
    return _minScale;
}

@dynamic rubberEffectRatio;
- (void) setRubberEffectRatio:(CGFloat)rubberEffectRatio
{
    _rubberEffectRatio = rubberEffectRatio;

    // Avoid turning rubber effect On in frame mode.
    if (self.mode == kSTLayerPanZoomModeFrame)
    {
        CCLOGWARN(@"STLayerPanZoom#setRubberEffectRatio: rubber effect is not supported in frame mode.");
        _rubberEffectRatio = 0.0f;
    }

}

- (CGFloat) rubberEffectRatio
{
    return _rubberEffectRatio;
}

#pragma mark Init

- (id) init
{
	if ((self = [super init]))
	{
		self.ignoreAnchorPointForPosition = NO;
		self.touchEnabled = YES;

		self.maxScale = 3.0f;
		self.minScale = 0.5f;
		self.touches = [NSMutableArray arrayWithCapacity: 10];
		self.panBoundsRect = CGRectNull;
		self.touchDistance = 0.0F;
		self.maxTouchDistanceToClick = 15.0f;

        self.mode = kSTLayerPanZoomModeSheet;
        self.minSpeed = 100.0f;
        self.maxSpeed = 1000.0f;
        self.topFrameMargin = 100.0f;
        self.bottomFrameMargin = 100.0f;
        self.leftFrameMargin = 100.0f;
        self.rightFrameMargin = 100.0f;

        self.rubberEffectRatio = 0.5f;
        self.rubberEffectRecoveryTime = 0.2f;
        _rubberEffectRecovering = NO;
        _rubberEffectZooming = NO;
	}
	return self;
}

#pragma mark CCStandardTouchDelegate Touch events

- (void) ccTouchesBegan: (NSSet *) touches
			  withEvent: (UIEvent *) event
{
    if(_isTouchDisabled)
        return;

	for (UITouch *touch in [touches allObjects])
	{
		// Add new touche to the array with current touches
		[self.touches addObject: touch];
	}

    if ([self.touches count] == 1)
    {
        _touchMoveBegan = NO;
        _singleTouchTimestamp = [NSDate timeIntervalSinceReferenceDate];
    }
    else
        _singleTouchTimestamp = INFINITY;
}

- (void) ccTouchesMoved: (NSSet *) touches
			  withEvent: (UIEvent *) event
{
    if(_isTouchDisabled)
        return;

	BOOL multitouch = [self.touches count] > 1;
	if (multitouch)
	{
		// Get the two first touches
        UITouch *touch1 = [self.touches objectAtIndex: 0];
		UITouch *touch2 = [self.touches objectAtIndex: 1];

		// Get current and previous positions of the touches
		CGPoint curPosTouch1 = [[CCDirector sharedDirector] convertToGL: [touch1 locationInView: [touch1 view]]];
		CGPoint curPosTouch2 = [[CCDirector sharedDirector] convertToGL: [touch2 locationInView: [touch2 view]]];
		CGPoint prevPosTouch1 = [[CCDirector sharedDirector] convertToGL: [touch1 previousLocationInView: [touch1 view]]];
		CGPoint prevPosTouch2 = [[CCDirector sharedDirector] convertToGL: [touch2 previousLocationInView: [touch2 view]]];

        // Calculate current and previous positions of the layer relative the anchor point
		CGPoint curMidpointTouch = ccpMidpoint(curPosTouch1, curPosTouch2);
		CGPoint prevMidpointTouch = ccpMidpoint(prevPosTouch1, prevPosTouch2);

        float curTouchDist = ccpDistance(curPosTouch1, curPosTouch2);
        float prevTouchDist = ccpDistance(prevPosTouch1, prevPosTouch2);

		// Calculate new scale
        CGFloat prevScale = self.scale;
        float newScale = prevScale * curTouchDist / prevTouchDist;

        // Avoid scaling out from panBoundsRect when Rubber Effect is OFF.
        newScale = MAX(newScale, [self minScale]);
        newScale = MIN(newScale, [self maxScale]);

        // If current and previous position of the multitouch's center aren't equal -> change position of the layer
        CGPoint midpointDelta = ccp(0,0);
		if (!CGPointEqualToPoint(prevMidpointTouch, curMidpointTouch))
		{
            midpointDelta = ccp(prevMidpointTouch.x - curMidpointTouch.x,
                                prevMidpointTouch.y - curMidpointTouch.y);
            midpointDelta = ccpMult(midpointDelta, 1.0/newScale);
        }

        [[CameraManager sharedManager] moveBy:midpointDelta
                                      scaleTo:newScale
                                     animated:NO
                                     duration:0.0];

        // Don't click with multitouch
		self.touchDistance = INFINITY;
	}
	else if([self.touches count] > 0)
	{
        // Get the single touch and it's previous & current position.
        UITouch *touch = [self.touches objectAtIndex: 0];
        CGPoint curTouchPosition = [[CCDirector sharedDirector] convertToGL: [touch locationInView: [touch view]]];
        CGPoint prevTouchPosition = [[CCDirector sharedDirector] convertToGL: [touch previousLocationInView: [touch view]]];

        // Always scroll in sheet mode.
        if (self.mode == kSTLayerPanZoomModeSheet)
        {
            // Set new position of the layer.
            self.position = ccp(self.position.x + curTouchPosition.x - prevTouchPosition.x,
                                self.position.y + curTouchPosition.y - prevTouchPosition.y);
        }

        // Accumulate touch distance for all modes.
        self.touchDistance += ccpDistance(curTouchPosition, prevTouchPosition);

        // Inform delegate about starting updating touch position, if click isn't possible.
        if (self.mode == kSTLayerPanZoomModeFrame)
        {
            if (self.touchDistance > self.maxTouchDistanceToClick && !_touchMoveBegan)
            {
                [self.delegate layerPanZoom: self
                   touchMoveBeganAtPosition: [self convertToNodeSpace: prevTouchPosition]];
                _touchMoveBegan = YES;
            }
        }
    }
}

- (void) ccTouchesEnded: (NSSet *) touches
			  withEvent: (UIEvent *) event
{
    if(_isTouchDisabled)
    {
        [self.touches removeObjectsInArray:[touches allObjects]];
        return;
    }

    _singleTouchTimestamp = INFINITY;

    // Process click event in single touch.
    if (  (self.touchDistance < self.maxTouchDistanceToClick) && (self.delegate)
        && ([self.touches count] == 1))
    {
        UITouch *touch = [self.touches objectAtIndex: 0];
        CGPoint curPos = [[CCDirector sharedDirector] convertToGL: [touch locationInView: [touch view]]];
        [self.delegate layerPanZoom: self
                     clickedAtPoint: [self convertToNodeSpace: curPos]
                           tapCount: [touch tapCount]];
    }

    if(! _isPanDisabled)
    {
        BOOL multitouch = [self.touches count] > 1;
        if (multitouch)
        {
            // Get the two first touches
            UITouch *touch1 = [self.touches objectAtIndex: 0];
            UITouch *touch2 = [self.touches objectAtIndex: 1];
            // Get current and previous positions of the touches
            CGPoint curPosTouch1 = [[CCDirector sharedDirector] convertToGL: [touch1 locationInView: [touch1 view]]];
            CGPoint curPosTouch2 = [[CCDirector sharedDirector] convertToGL: [touch2 locationInView: [touch2 view]]];
            CGPoint prevPosTouch1 = [[CCDirector sharedDirector] convertToGL: [touch1 previousLocationInView: [touch1 view]]];
            CGPoint prevPosTouch2 = [[CCDirector sharedDirector] convertToGL: [touch2 previousLocationInView: [touch2 view]]];

            // Calculate new scale
            CGFloat prevScale = self.scale;
            float newScale = prevScale * ccpDistance(curPosTouch1, curPosTouch2) / ccpDistance(prevPosTouch1, prevPosTouch2);

            float retinaScale = SCALE_BOTH;//_maxScale > 3.5 ? 2.0 : 1.0;
            if(newScale < 0.15 * retinaScale)
                newScale = 0.1 * retinaScale;
            else if(newScale < 0.25 * retinaScale)
                newScale = 0.2 * retinaScale;
            else if(newScale < 0.4 * retinaScale)
                newScale = 0.3 * retinaScale;
            else if(newScale < 0.75 * retinaScale)
                newScale = 0.5 * retinaScale;
            else if(newScale < 1.5 * retinaScale)
                newScale = 1.0 * retinaScale;
            else if(newScale < 2.5 * retinaScale)
                newScale = 2.0 * retinaScale;
            else if(newScale < 3.5 * retinaScale)
                newScale = 3.0 * retinaScale;

            [[CameraManager sharedManager] moveBy:ccp(0,0)
                                          scaleTo:newScale
                                         animated:YES
                                         duration:kZoomScaleAnimationDuration];

            // Don't click with multitouch
            self.touchDistance = INFINITY;
        }
    }

    [self.touches removeObjectsInArray:[touches allObjects]];

    if ([self.touches count] == 0)
		self.touchDistance = 0.0f;

//    if (![self.touches count] && !_rubberEffectRecovering)
//    {
//        [self recoverPositionAndScale];
//    }
}

- (void) ccTouchesCancelled: (NSSet *) touches
				  withEvent: (UIEvent *) event
{
    [self.touches removeObjectsInArray:[touches allObjects]];

    if ([self.touches count] == 0)
		self.touchDistance = 0.0f;
}

#pragma mark -

-(void)resetTouches
{
    [self.touches removeAllObjects];
}

#pragma mark Update

// Updates position in frame mode.
- (void) update: (ccTime) dt
{
    // Only for frame mode with one touch.
	if ( self.mode == kSTLayerPanZoomModeFrame && [self.touches count] == 1 )
    {
        // Do not update position if click is still possible.
        if (self.touchDistance <= self.maxTouchDistanceToClick)
            return;

        // Do not update position if pinch is still possible.
        if ([NSDate timeIntervalSinceReferenceDate] - _singleTouchTimestamp < kSTLayerPanZoomMultitouchGesturesDetectionDelay)
            return;

        // Otherwise - update touch position. Get current position of touch.
        UITouch *touch = [self.touches objectAtIndex: 0];
        CGPoint curPos = [[CCDirector sharedDirector] convertToGL: [touch locationInView: [touch view]]];

        // Scroll if finger in the scroll area near edge.
        if ([self frameEdgeWithPoint: curPos] != kSTLayerPanZoomFrameEdgeNone)
        {
            self.position = ccp(self.position.x + dt * [self horSpeedWithPosition: curPos],
                                self.position.y + dt * [self vertSpeedWithPosition: curPos]);
        }

        // Inform delegate if touch position in layer was changed due to finger or layer movement.
        CGPoint touchPositionInLayer = [self convertToNodeSpace: curPos];
        if (!CGPointEqualToPoint(_prevSingleTouchPositionInLayer, touchPositionInLayer))
        {
            _prevSingleTouchPositionInLayer = touchPositionInLayer;
            [self.delegate layerPanZoom: self
                   touchPositionUpdated: touchPositionInLayer];
        }

    }
}

- (void) onEnter
{
    [super onEnter];
    [[[CCDirector sharedDirector] scheduler] scheduleUpdateForTarget: self
                                                  priority: 0
                                                    paused: NO];
}

- (void) onExit
{
    [[[CCDirector sharedDirector] scheduler] unscheduleAllForTarget: self];
    [super onExit];
}

#pragma mark Layer Modes related

@dynamic mode;

- (void) setMode: (STLayerPanZoomMode) mode
{
#ifdef DEBUG
    if (mode == kSTLayerPanZoomModeFrame)
    {
        STLayerPanZoomDebugLines *lines = [STLayerPanZoomDebugLines node];
        [lines setContentSize: [CCDirector sharedDirector].winSize];
        lines.topFrameMargin = self.topFrameMargin;
        lines.bottomFrameMargin = self.bottomFrameMargin;
        lines.leftFrameMargin = self.leftFrameMargin;
        lines.rightFrameMargin = self.rightFrameMargin;
        [[CCDirector sharedDirector].runningScene addChild: lines
                                                         z: NSIntegerMax
                                                       tag: kDebugLinesTag];
    }
    if (_mode == kSTLayerPanZoomModeFrame)
    {
        [[CCDirector sharedDirector].runningScene removeChildByTag: kDebugLinesTag
                                                           cleanup: YES];
    }
#endif
    _mode = mode;

    // Disable rubber effect in Frame mode.
    if (_mode == kSTLayerPanZoomModeFrame)
    {
        self.rubberEffectRatio = 0.0f;
    }
}

- (STLayerPanZoomMode) mode
{
    return _mode;
}

#pragma mark Scale and Position related

@dynamic panBoundsRect;

- (void) setPanBoundsRect: (CGRect) rect
{
	_panBoundsRect = rect;
    self.scale = [self minPossibleScale];
    self.position = self.position;
}

- (CGRect) panBoundsRect
{
	return _panBoundsRect;
}

- (void) setPosition: (CGPoint) position
{
    if(_isPanDisabled)
        return;

    CGPoint prevPosition = self.position;
    [super setPosition: position];
    if (!CGRectIsNull(_panBoundsRect) && !_rubberEffectZooming)
    {
        if (self.rubberEffectRatio && self.mode == kSTLayerPanZoomModeSheet)
        {
            if (!_rubberEffectRecovering)
            {
                CGFloat topDistance = [self topEdgeDistance];
                CGFloat bottomDistance = [self bottomEdgeDistance];
                CGFloat leftDistance = [self leftEdgeDistance];
                CGFloat rightDistance = [self rightEdgeDistance];
                CGFloat dx = self.position.x - prevPosition.x;
                CGFloat dy = self.position.y - prevPosition.y;
                if (bottomDistance || topDistance)
                {
                    [super setPosition: ccp(self.position.x,
                                            prevPosition.y + dy * self.rubberEffectRatio)];
                }
                if (leftDistance || rightDistance)
                {
                    [super setPosition: ccp(prevPosition.x + dx * self.rubberEffectRatio,
                                            self.position.y)];
                }
            }
        }
        else
        {
            CGRect boundBox = [self boundingBox];
            if (self.position.x - boundBox.size.width * self.anchorPoint.x > self.panBoundsRect.origin.x)
            {
                [super setPosition: ccp(boundBox.size.width * self.anchorPoint.x + self.panBoundsRect.origin.x,
                                        self.position.y)];
            }
            if (self.position.y - boundBox.size.height * self.anchorPoint.y > self.panBoundsRect.origin.y)
            {
                [super setPosition: ccp(self.position.x, boundBox.size.height * self.anchorPoint.y +
                                        self.panBoundsRect.origin.y)];
            }
            if (self.position.x + boundBox.size.width * (1 - self.anchorPoint.x) < self.panBoundsRect.size.width +
                self.panBoundsRect.origin.x)
            {
                [super setPosition: ccp(self.panBoundsRect.size.width + _panBoundsRect.origin.x -
                                        boundBox.size.width * (1 - self.anchorPoint.x), self.position.y)];
            }
            if (self.position.y + boundBox.size.height * (1 - self.anchorPoint.y) < self.panBoundsRect.size.height +
                self.panBoundsRect.origin.y)
            {
                [super setPosition: ccp(self.position.x, self.panBoundsRect.size.height + self.panBoundsRect.origin.y -
                                        boundBox.size.height * (1 - self.anchorPoint.y))];
            }
        }
    }
    [super setPosition: ccp(ceil(self.position.x),
                            ceil(self.position.y))];

}

- (void) setScale: (float)scale
{
    if(_isZoomDisabled || _isPanDisabled)
        return;

    scale = MAX(scale, self.minScale);
    [super setScale: MIN(scale, self.maxScale)];
}

#pragma mark Ruber Edges related

- (void) recoverPositionAndScale
{
    if (!CGRectIsNull(self.panBoundsRect))
	{
        CGSize winSize = [CCDirector sharedDirector].winSize;
        CGFloat rightEdgeDistance = [self rightEdgeDistance];
        CGFloat leftEdgeDistance = [self leftEdgeDistance];
        CGFloat topEdgeDistance = [self topEdgeDistance];
        CGFloat bottomEdgeDistance = [self bottomEdgeDistance];
        CGFloat scale = [self minPossibleScale];

        if (!rightEdgeDistance && !leftEdgeDistance && !topEdgeDistance && !bottomEdgeDistance)
        {
            return;
        }

        if (self.scale < scale)
        {
            _rubberEffectRecovering = YES;
            CGPoint newPosition = CGPointZero;
            if (rightEdgeDistance && leftEdgeDistance && topEdgeDistance && bottomEdgeDistance)
            {
                CGFloat dx = scale * self.contentSize.width * (self.anchorPoint.x - 0.5f);
                CGFloat dy = scale * self.contentSize.height * (self.anchorPoint.y - 0.5f);
                newPosition = ccp(winSize.width * 0.5f + dx, winSize.height * 0.5f + dy);
            }
            else if (rightEdgeDistance && leftEdgeDistance && topEdgeDistance)
            {
                CGFloat dx = scale * self.contentSize.width * (self.anchorPoint.x - 0.5f);
                CGFloat dy = scale * self.contentSize.height * (1.0f - self.anchorPoint.y);
                newPosition = ccp(winSize.width * 0.5f + dx, winSize.height - dy);
            }
            else if (rightEdgeDistance && leftEdgeDistance && bottomEdgeDistance)
            {
                CGFloat dx = scale * self.contentSize.width * (self.anchorPoint.x - 0.5f);
                CGFloat dy = scale * self.contentSize.height * self.anchorPoint.y;
                newPosition = ccp(winSize.width * 0.5f + dx, dy);
            }
            else if (rightEdgeDistance && topEdgeDistance && bottomEdgeDistance)
            {
                CGFloat dx = scale * self.contentSize.width * (1.0f - self.anchorPoint.x);
                CGFloat dy = scale * self.contentSize.height * (self.anchorPoint.y - 0.5f);
                newPosition = ccp(winSize.width  - dx, winSize.height  * 0.5f + dy);
            }
            else if (leftEdgeDistance && topEdgeDistance && bottomEdgeDistance)
            {
                CGFloat dx = scale * self.contentSize.width * self.anchorPoint.x;
                CGFloat dy = scale * self.contentSize.height * (self.anchorPoint.y - 0.5f);
                newPosition = ccp(dx, winSize.height * 0.5f + dy);
            }
            else if (leftEdgeDistance && topEdgeDistance)
            {
                CGFloat dx = scale * self.contentSize.width * self.anchorPoint.x;
                CGFloat dy = scale * self.contentSize.height * (1.0f - self.anchorPoint.y);
                newPosition = ccp(dx, winSize.height - dy);
            }
            else if (leftEdgeDistance && bottomEdgeDistance)
            {
                CGFloat dx = scale * self.contentSize.width * self.anchorPoint.x;
                CGFloat dy = scale * self.contentSize.height * self.anchorPoint.y;
                newPosition = ccp(dx, dy);
            }
            else if (rightEdgeDistance && topEdgeDistance)
            {
                CGFloat dx = scale * self.contentSize.width * (1.0f - self.anchorPoint.x);
                CGFloat dy = scale * self.contentSize.height * (1.0f - self.anchorPoint.y);
                newPosition = ccp(winSize.width - dx, winSize.height - dy);
            }
            else if (rightEdgeDistance && bottomEdgeDistance)
            {
                CGFloat dx = scale * self.contentSize.width * (1.0f - self.anchorPoint.x);
                CGFloat dy = scale * self.contentSize.height * self.anchorPoint.y;
                newPosition = ccp(winSize.width - dx, dy);
            }
            else if (topEdgeDistance || bottomEdgeDistance)
            {
                CGFloat dy = scale * self.contentSize.height * (self.anchorPoint.y - 0.5f);
                newPosition = ccp(self.position.x, winSize.height * 0.5f + dy);
            }
            else if (leftEdgeDistance || rightEdgeDistance)
            {
                CGFloat dx = scale * self.contentSize.width * (self.anchorPoint.x - 0.5f);
                newPosition = ccp(winSize.width * 0.5f + dx, self.position.y);
            }

            id moveToPosition = [CCMoveTo actionWithDuration: self.rubberEffectRecoveryTime
                                                    position: newPosition];
            id scaleToPosition = [CCScaleTo actionWithDuration: self.rubberEffectRecoveryTime
                                                         scale: scale];
            id sequence = [CCSpawn actions: scaleToPosition, moveToPosition, [CCCallFunc actionWithTarget: self selector: @selector(recoverEnded)], nil];
            [self runAction: sequence];

        }
        else
        {
            _rubberEffectRecovering = YES;
            id moveToPosition = [CCMoveTo actionWithDuration: self.rubberEffectRecoveryTime
                                                    position: ccp(self.position.x + rightEdgeDistance - leftEdgeDistance,
                                                                  self.position.y + topEdgeDistance - bottomEdgeDistance)];
            id sequence = [CCSpawn actions: moveToPosition, [CCCallFunc actionWithTarget: self selector: @selector(recoverEnded)], nil];
            [self runAction: sequence];
        }
	}
    else if(NO)
    {
        CGFloat curScale = self.scale;
        GLfloat nextScale = 1.0;

        if(curScale < 0.2) nextScale = 0.1;
        else if(curScale < 0.75) nextScale = 0.5;
        else if(curScale < 1.5) nextScale = 1.0;
        else if(curScale < 2.5) nextScale = 2.0;
        else if(curScale < 3.5) nextScale = 3.0;

        if(curScale != nextScale)
        {
            GLfloat w = self.contentSize.width;
            GLfloat h = self.contentSize.height;
            CGPoint curPos = ccp(self.anchorPoint.x * w - self.position.x,
                                 self.anchorPoint.y * h - self.position.y);

            GLfloat diffScale = nextScale - curScale;
            CGFloat deltaX = (curPos.x - self.anchorPoint.x * w) * diffScale;
            CGFloat deltaY = (curPos.y - self.anchorPoint.y * h) * diffScale;
            CGPoint nextPos = ccp(self.position.x - deltaX, self.position.y - deltaY);


//
//            GLfloat diffScale = nextScale - curScale;
//            GLfloat h = self.contentSize.height;
//            GLfloat w = self.contentSize.width;
//            CGFloat dx = (self.anchorPoint.x * w - curPos.x) * diffScale;
//            CGFloat dy = (self.anchorPoint.y * h - curPos.y) * diffScale;
//            nextPos = ccp(curPos.x - dx,
//                          curPos.y - dy);

            /*
             cur position of node is 100,200

             cur scale is 1.25 (1280x960 => 640x480)
             new scale is 1.00 (1024x768 => 512x384)

             cur scale is 1.25 (600x400 => 300x200)
             new scale is 1.00 (480x320 => 240x160)

             diff scale is -0.25

             new position should be??

             scale up -> dx < 0, dy < 0
             scale down -> dx > 0, dy > 0

             */

            dlog(@"%@,%@",
                 NSStringFromCGPoint(self.anchorPoint),
                 NSStringFromCGSize(self.contentSize));
            dlog(@"s=%f,ns=%f,dx=%f,dy=%f,diffs=%f",
                 curScale,
                 nextScale,
                 deltaX,
                 deltaY,
                 diffScale);
            dlog(@"cpos=%@,npos=%@",
                 NSStringFromCGPoint(curPos),
                 NSStringFromCGPoint(nextPos));

            GLfloat duration = 0.05;
            id moveToPosition = [CCMoveTo actionWithDuration: duration
                                                    position: nextPos];
            id scaleToPosition = [CCScaleTo actionWithDuration: duration
                                                         scale: nextScale];
            id sequence = [CCSpawn actions: scaleToPosition, moveToPosition, nil];
            [self runAction: sequence];
        }
    }
}

- (void) recoverEnded
{
    _rubberEffectRecovering = NO;
}

#pragma mark Helpers

- (CGFloat) topEdgeDistance
{
    CGRect boundBox = [self boundingBox];
    return round(MAX(self.panBoundsRect.size.height + self.panBoundsRect.origin.y - self.position.y -
                     boundBox.size.height * (1 - self.anchorPoint.y), 0));
}

- (CGFloat) leftEdgeDistance
{
    CGRect boundBox = [self boundingBox];
    return round(MAX(self.position.x - boundBox.size.width * self.anchorPoint.x - self.panBoundsRect.origin.x, 0));
}

- (CGFloat) bottomEdgeDistance
{
    CGRect boundBox = [self boundingBox];
    return round(MAX(self.position.y - boundBox.size.height * self.anchorPoint.y - self.panBoundsRect.origin.y, 0));
}

- (CGFloat) rightEdgeDistance
{
    CGRect boundBox = [self boundingBox];
    return round(MAX(self.panBoundsRect.size.width + self.panBoundsRect.origin.x - self.position.x -
               boundBox.size.width * (1 - self.anchorPoint.x), 0));
}

- (CGFloat) minPossibleScale
{
	if (!CGRectIsNull(self.panBoundsRect))
	{
		return MAX(self.panBoundsRect.size.width / self.contentSize.width,
				   self.panBoundsRect.size.height / self.contentSize.height);
	}
	else
	{
		return self.minScale;
	}
}

- (STLayerPanZoomFrameEdge) frameEdgeWithPoint: (CGPoint) point
{
    BOOL isLeft = point.x <= self.panBoundsRect.origin.x + self.leftFrameMargin;
    BOOL isRight = point.x >= self.panBoundsRect.origin.x + self.panBoundsRect.size.width - self.rightFrameMargin;
    BOOL isBottom = point.y <= self.panBoundsRect.origin.y + self.bottomFrameMargin;
    BOOL isTop = point.y >= self.panBoundsRect.origin.y + self.panBoundsRect.size.height - self.topFrameMargin;

    if (isLeft && isBottom)
    {
        return kSTLayerPanZoomFrameEdgeBottomLeft;
    }
    if (isLeft && isTop)
    {
        return kSTLayerPanZoomFrameEdgeTopLeft;
    }
    if (isRight && isBottom)
    {
        return kSTLayerPanZoomFrameEdgeBottomRight;
    }
    if (isRight && isTop)
    {
        return kSTLayerPanZoomFrameEdgeTopRight;
    }

    if (isLeft)
    {
        return kSTLayerPanZoomFrameEdgeLeft;
    }
    if (isTop)
    {
        return kSTLayerPanZoomFrameEdgeTop;
    }
    if (isRight)
    {
        return kSTLayerPanZoomFrameEdgeRight;
    }
    if (isBottom)
    {
        return kSTLayerPanZoomFrameEdgeBottom;
    }

    return kSTLayerPanZoomFrameEdgeNone;
}

- (CGFloat) horSpeedWithPosition: (CGPoint) pos
{
    STLayerPanZoomFrameEdge edge = [self frameEdgeWithPoint: pos];
    CGFloat speed = 0.0f;
    if (edge == kSTLayerPanZoomFrameEdgeLeft)
    {
        speed = self.minSpeed + (self.maxSpeed - self.minSpeed) *
        (self.panBoundsRect.origin.x + self.leftFrameMargin - pos.x) / self.leftFrameMargin;
    }
    if (edge == kSTLayerPanZoomFrameEdgeBottomLeft || edge == kSTLayerPanZoomFrameEdgeTopLeft)
    {
        speed = self.minSpeed + (self.maxSpeed - self.minSpeed) *
        (self.panBoundsRect.origin.x + self.leftFrameMargin - pos.x) / (self.leftFrameMargin * sqrt(2.0f));
    }
    if (edge == kSTLayerPanZoomFrameEdgeRight)
    {
        speed = - (self.minSpeed + (self.maxSpeed - self.minSpeed) *
            (pos.x - self.panBoundsRect.origin.x - self.panBoundsRect.size.width +
             self.rightFrameMargin) / self.rightFrameMargin);
    }
    if (edge == kSTLayerPanZoomFrameEdgeBottomRight || edge == kSTLayerPanZoomFrameEdgeTopRight)
    {
        speed = - (self.minSpeed + (self.maxSpeed - self.minSpeed) *
            (pos.x - self.panBoundsRect.origin.x - self.panBoundsRect.size.width +
             self.rightFrameMargin) / (self.rightFrameMargin * sqrt(2.0f)));
    }
    return speed;
}

- (CGFloat) vertSpeedWithPosition: (CGPoint) pos
{
    STLayerPanZoomFrameEdge edge = [self frameEdgeWithPoint: pos];
    CGFloat speed = 0.0f;
    if (edge == kSTLayerPanZoomFrameEdgeBottom)
    {
        speed = self.minSpeed + (self.maxSpeed - self.minSpeed) *
            (self.panBoundsRect.origin.y + self.bottomFrameMargin - pos.y) / self.bottomFrameMargin;
    }
    if (edge == kSTLayerPanZoomFrameEdgeBottomLeft || edge == kSTLayerPanZoomFrameEdgeBottomRight)
    {
        speed = self.minSpeed + (self.maxSpeed - self.minSpeed) *
            (self.panBoundsRect.origin.y + self.bottomFrameMargin - pos.y) / (self.bottomFrameMargin * sqrt(2.0f));
    }
    if (edge == kSTLayerPanZoomFrameEdgeTop)
    {
        speed = - (self.minSpeed + (self.maxSpeed - self.minSpeed) *
            (pos.y - self.panBoundsRect.origin.y - self.panBoundsRect.size.height +
             self.topFrameMargin) / self.topFrameMargin);
    }
    if (edge == kSTLayerPanZoomFrameEdgeTopLeft || edge == kSTLayerPanZoomFrameEdgeTopRight)
    {
        speed = - (self.minSpeed + (self.maxSpeed - self.minSpeed) *
            (pos.y - self.panBoundsRect.origin.y - self.panBoundsRect.size.height +
             self.topFrameMargin) / (self.topFrameMargin * sqrt(2.0f)));
    }
    return speed;
}

#pragma mark Dealloc

- (void) dealloc
{
	self.touches = nil;
	self.delegate = nil;
	[super dealloc];
}

@end
