//
//  STClippingNode.h
//
//  Created by Steve Tranby on 12/16/11.
//  Copyright (c) Steve Tranby. All rights reserved.
//

#import "cocos2d.h"

/** Restricts (clips) drawing of all children to a specific region. */
@interface STClippingNode : CCNode
{
    CGRect clippingRegionInNodeCoordinates;
    CGRect clippingRegion;
}

@property (nonatomic) CGRect clippingRegion;

@end