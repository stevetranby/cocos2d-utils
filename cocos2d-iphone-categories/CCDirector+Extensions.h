//
//  CCDirector+Extensions.h
//
//  Created by Steve Tranby on 6/19/12.
//  Copyright (c) 2012 Steve Tranby. All rights reserved.
//

#import "CCDirector.h"

@interface CCDirector (Extensions)

-(void) popSceneWithTransition: (Class)transitionClass duration:(ccTime)t;

@end
