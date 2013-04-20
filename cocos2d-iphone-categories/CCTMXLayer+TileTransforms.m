//
//  CCTMXLayerExtensions.m
//
//  Created by Steve Tranby on 9/25/11.
//  Copyright (c) Steve Tranby. All rights reserved.
//

#import "CCTMXLayer+TileTransforms.h"
#import "CCTMXLayer.h"

#import "FixCategoryBug.h"
FIX_CATEGORY_BUG(CCTMXLayer)

@implementation CCTMXLayer (TileTransforms)

-(BOOL)tileIsFlippedHorizontally:(CGPoint)pos
{
	NSAssert( pos.x < _layerSize.width && pos.y < _layerSize.height && pos.x >=0 && pos.y >=0, @"TMXLayer: invalid position");
	NSAssert( _tiles && _atlasIndexArray, @"TMXLayer: the tiles map has been released");

	uint idx = pos.x + pos.y * _layerSize.width;

	// Bits on the far end of the 32-bit global tile ID are used for tile flags
	return (_tiles[ idx ] & kCCFlipedAll & kCCTMXTileHorizontalFlag) != 0;
}

-(CCSprite*)tileWithValidFlipAt:(CGPoint)pos
{
    CCSprite *tileSprite = [self tileAt:pos];
    if([self tileIsFlippedHorizontally:pos])
        tileSprite.flipX = YES;
    else
        tileSprite.flipX = NO;
    return tileSprite;
}

-(BOOL)validTileAt:(CGPoint)pos
{
    if(pos.x < _layerSize.width && pos.y < _layerSize.height && pos.x >=0 && pos.y >=0)
        return YES;
    return NO;
}

-(uint32_t)tileGIDWithValidCheckAt:(CGPoint)tileCoordinate
                         withFlags:(ccTMXTileFlags *)flags
{
    if([self validTileAt:tileCoordinate])
        return [self tileGIDAt:tileCoordinate withFlags:flags];
    return 0;
}

-(uint32_t)tileGIDWithValidCheckAt:(CGPoint)tileCoordinate
{
    if([self validTileAt:tileCoordinate])
        return [self tileGIDAt:tileCoordinate];
    return 0;
}

@end
