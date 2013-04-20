//
//  CCMenuItemLabel.h
//
//  Created by Steve Tranby on 8/31/11.
//  Copyright (c) Steve Tranby. All rights reserved.
//

#import "CCMenuItem.h"

@interface CCMenuItemSprite (LabelButton)

+(CCMenuItemSprite*)menuItemSpriteWithTitle:(NSString*)title
                                   fontName:(NSString*)fontName
                                   fontSize:(GLfloat)fontSize
                                 dimensions:(CGSize)dimensions
                                 background:(ccColor3B)bgColor
                                     target:(id)target
                                   selector:(SEL)selector;

@end
