//
//  CCNode+Utils.h
//
//  Created by Steve Tranby on 10/17/11.
//  Copyright (c) Steve Tranby. All rights reserved.
//

#import "cocos2d.h"
#import "GameConfig.h"

typedef enum
{
	CCScaleFitFull,
	CCScaleFitAspectFit,
	CCScaleFitAspectFill,
} CCScaleFit;

@interface CCNode (Utils)

//-(void)setPosition:(CGPoint)newPosition;

-(BOOL)containsPoint:(CGPoint)point;
-(BOOL)containsTouch:(UITouch*)touch;

-(void)setRelativePosition:(CGPoint)newPosition;
-(void)scaleToSize:(CGSize)size fitType:(CCScaleFit)fitType;

@end