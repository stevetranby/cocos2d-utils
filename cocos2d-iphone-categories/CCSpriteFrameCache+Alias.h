//
//  CCSpriteFrameCache+Alias.h
//
//  Created by Steve Tranby on 10/24/11.
//  Copyright (c) Steve Tranby. All rights reserved.
//

#import "CCSpriteFrameCache.h"

@interface CCSpriteFrameCache (Alias)
-(void)updateSprite:(CCSprite*)sprite WithFrameName:(NSString*)frameName;
-(void)addFileWithName:(NSString*)frameName;
@end
