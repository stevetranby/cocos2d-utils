//
//  STActions
//
//  Created by Steve Tranby on 10/18/11.
//  Copyright (c) Steve Tranby. All rights reserved.
//

#import "CCActionInstant.h"
#import "CCActionInterval.h"

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////

@interface STRemoveFromParentAction : CCActionInstant <NSCopying>
{
    BOOL shouldCleanup;
}

+(id)actionWithCleanup:(BOOL)cleanup;
-(id)initWithCleanup:(BOOL)cleanup;

@end

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////

@class CCNode, CCAnimation;

@interface STAnimateInSync : CCAnimate
{
}

@property (nonatomic,retain) id targetToSync;
@property (nonatomic,retain) CCAnimation* animationToSync;

+(id)actionWithAnimation:(CCAnimation*)anim
         animationToSync:(CCAnimation*)animSync
              TargetToSync:(CCNode*)targetToSync;

-(id)initWithAnimation:(CCAnimation*)anim
       animationToSync:(CCAnimation*)animSync
            TargetToSync:(CCNode*)targetToSync;

@end

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////