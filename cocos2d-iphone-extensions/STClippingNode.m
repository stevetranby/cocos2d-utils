//
//  STClippingNode.m
//
//  Created by Steve Tranby on 12/16/11.
//  Copyright (c) Steve Tranby. All rights reserved.
//

#import "STClippingNode.h"

@interface STClippingNode (PrivateMethods)
-(void) deviceOrientationChanged:(NSNotification*)notification;
@end

@implementation STClippingNode

-(id) init
{
    if ((self = [super init]))
    {
        // register for device orientation change events
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationChanged:)
                                                     name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [super dealloc];
}

-(CGRect) clippingRegion
{
    return clippingRegionInNodeCoordinates;
}

-(void) setClippingRegion:(CGRect)region
{
    // keep the original region coordinates in case the user wants them back unchanged
    clippingRegionInNodeCoordinates = region;
    self.position = clippingRegionInNodeCoordinates.origin;
    self.contentSize = clippingRegionInNodeCoordinates.size;


    // if we need orientation management

    /*
     CCDirector* director = [CCDirector sharedDirector];
     CGSize screenSize = [director winSize];
     // glScissor requires the coordinates to be rotated to portrait mode
     region.origin = CGPointMake(region.origin.y, screenSize.width - region.size.width - region.origin.x);
     region.size = CGSizeMake(region.size.height, region.size.width);

     CCDirector* director = [CCDirector sharedDirector];
     CGSize screenSize = [director winSize];

     // glScissor requires the coordinates to be rotated to portrait mode
     switch (director.deviceOrientation)
     {
     default:
     case kCCDeviceOrientationPortrait:
     // do nothing, coords are already correct
     break;

     case kCCDeviceOrientationPortraitUpsideDown:
     region.origin.x = screenSize.width - region.size.width - region.origin.x;
     region.origin.y = screenSize.height - region.size.height - region.origin.y;
     break;

     case kCCDeviceOrientationLandscapeLeft:
     region.origin = CGPointMake(region.origin.y, screenSize.width - region.size.width - region.origin.x);
     region.size = CGSizeMake(region.size.height, region.size.width);
     break;

     case kCCDeviceOrientationLandscapeRight:
     region.origin = CGPointMake(screenSize.height - region.size.height - region.origin.y, region.origin.x);
     region.size = CGSizeMake(region.size.height, region.size.width);
     break;
     }
     */

    // convert to retina coordinates if needed
    region = CC_RECT_POINTS_TO_PIXELS(region);

    // respect scaling
    clippingRegion = CGRectMake(region.origin.x * _scaleX, region.origin.y * _scaleY,
                                region.size.width * _scaleX, region.size.height * _scaleY);
}

-(void) setScale:(float)newScale
{
    dlog(@"newscale = %f", newScale);
    [super setScale:newScale];
    // re-adjust the clipping region according to the current scale factor
    [self setClippingRegion:clippingRegionInNodeCoordinates];
}

-(void) deviceOrientationChanged:(NSNotification*)notification
{
    // re-adjust the clipping region according to the current orientation
    [self setClippingRegion:clippingRegionInNodeCoordinates];
}

-(void)draw
{
	[super draw];

	//if (self.debugDraw)
	{
		CGSize s = clippingRegion.size;
		CGPoint vertices[4]={
			ccp(0,0),ccp(s.width,0),
			ccp(s.width,s.height),ccp(0,s.height),
		};
		ccDrawPoly(vertices, 4, YES);

        CGPoint p =  CGPointMake(clippingRegion.origin.x + _position.x,
                                 clippingRegion.origin.y + _position.y);
        dlog(@"p=%@, s=%@, cs=%f",
             NSStringFromCGPoint(p),
             NSStringFromCGSize(s),
             __ccContentScaleFactor);
		CGPoint vertices2[4]={
			ccp(p.x,p.y),ccp(p.x+s.width,p.y),
			ccp(p.x+s.width,p.y+s.height),ccp(p.x,p.y+s.height),
		};
		ccDrawPoly(vertices2, 4, YES);
	}
}

-(void) visit
{
    //glPushMatrix();

    glEnable(GL_SCISSOR_TEST);

    glScissor(clippingRegion.origin.x,// + position_.x,
              clippingRegion.origin.y,// + position_.y,
              clippingRegion.size.width,
              clippingRegion.size.height);

    [super visit];

    glDisable(GL_SCISSOR_TEST);

    //glPopMatrix();
}

@end