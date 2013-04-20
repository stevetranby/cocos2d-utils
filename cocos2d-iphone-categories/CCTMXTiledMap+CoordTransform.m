//
//  CCTMXTileMapExtensions.m
//
//  Created by Steve Tranby on 9/24/11.
//  Copyright (c) Steve Tranby. All rights reserved.
//

#import "CCTMXTiledMap+CoordTransform.h"
#import "CCTMXLayer.h"
#import "CGPointExtension.h"

#import "FixCategoryBug.h"
FIX_CATEGORY_BUG(CCTMXTiledMap)

@implementation CCTMXTiledMap (CoordTransforms)

#pragma mark - Positioning

-(CGPoint)tileCoordForPosition:(CGPoint)pos
{
    pos = CC_POINT_POINTS_TO_PIXELS( pos );
    CGFloat tw = _tileSize.width;
    CGFloat th = _tileSize.height;
    CGFloat mw = _mapSize.width;
    CGFloat mh = _mapSize.height;
    CGFloat x = pos.x;
    CGFloat y = pos.y;

    CGPoint iso = {
        floorf(mh - y/th + x/tw - mw/2),// - 1/2),
        floorf(mh - y/th - x/tw + mw/2 - 1/2)// - 3/2)
    };
    return iso;
}

-(CGPoint)centerForTileCoord:(CGPoint)tileCoord MapLayer:(CCTMXLayer*)mapLayer
{
    CGPoint xy = [self positionForTileCoord:tileCoord MapLayer:mapLayer];
    return ccp(xy.x + _tileSize.width/2 * 1/CC_CONTENT_SCALE_FACTOR(),
               xy.y + _tileSize.height/2 * 1/CC_CONTENT_SCALE_FACTOR());
}

-(CGPoint)positionForTileCoord:(CGPoint)tileCoord MapLayer:(CCTMXLayer*)mapLayer
{
    return [mapLayer positionAt:tileCoord];
}

-(float)vertexZForPosition:(CGPoint)pos MapLayer:(CCTMXLayer*)mapLayer
{
    CGPoint tileCoord = [self tileCoordForPosition:pos];
    return [self vertexZForTileCoord:tileCoord MapLayer:mapLayer];
}

-(float)vertexZForTileCoord:(CGPoint)tileCoord MapLayer:(CCTMXLayer*)mapLayer
{
    NSUInteger maxVal = mapLayer.layerSize.width + mapLayer.layerSize.height;
    return -(maxVal - (tileCoord.x + tileCoord.y));
}

-(BOOL)validTileAt:(CGPoint)pos
{
    if(pos.x < _mapSize.width && pos.y < _mapSize.height && pos.x >=0 && pos.y >=0)
        return YES;
    return NO;
}

@end
