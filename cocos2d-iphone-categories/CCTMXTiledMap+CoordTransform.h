//
//  CCTMXTileMapExtensions.h
//
//  Created by Steve Tranby on 9/24/11.
//  Copyright (c) Steve Tranby. All rights reserved.
//

#import "CCTMXTiledMap.h"
#import "CCTMXXMLParser.h"

@interface CCTMXTiledMap (CoordTransforms)

-(CGPoint)tileCoordForPosition:(CGPoint)point;
-(CGPoint)centerForTileCoord:(CGPoint)tileCoord MapLayer:(CCTMXLayer*)mapLayer;
-(CGPoint)positionForTileCoord:(CGPoint)tileCoord MapLayer:(CCTMXLayer*)mapLayer;
-(float)vertexZForPosition:(CGPoint)pos MapLayer:(CCTMXLayer*)mapLayer;
-(float)vertexZForTileCoord:(CGPoint)tileCoord MapLayer:(CCTMXLayer*)mapLayer;

//-(CGPoint)centerForTileCoord:(CGPoint)tileCoord;
//-(CGPoint)positionForTileCoord:(CGPoint)tileCoord;
//-(float)vertexZForPosition:(CGPoint)pos;
//-(float)vertexZForTileCoord:(CGPoint)tileCoord;

-(BOOL)validTileAt:(CGPoint)pos;

@end
