//
//  CCTMXLayerExtensions.h
//
//  Created by Steve Tranby on 9/25/11.
//  Copyright (c) Steve Tranby. All rights reserved.
//

#import "cocos2d.h"

@interface CCTMXLayer (TileTransforms)

//-(void)setupTiles;
-(BOOL)tileIsFlippedHorizontally:(CGPoint)pos;
-(CCSprite*)tileWithValidFlipAt:(CGPoint)pos;
-(BOOL)validTileAt:(CGPoint)tileCoord;
-(uint32_t)tileGIDWithValidCheckAt:(CGPoint)tileCoordinate withFlags:(ccTMXTileFlags *)flags;
-(uint32_t)tileGIDWithValidCheckAt:(CGPoint)tileCoordinate;

@end
