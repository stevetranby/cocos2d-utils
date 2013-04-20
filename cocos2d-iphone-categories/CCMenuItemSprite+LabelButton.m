//
//  CCMenuItemLabel.m
//
//  Created by Steve Tranby on 8/31/11.
//  Copyright (c) Steve Tranby. All rights reserved.
//

#import "CCMenuItemSprite+LabelButton.h"
#import "cocos2d.h"
#import "SCLabel.h"

#import "FixCategoryBug.h"
FIX_CATEGORY_BUG(CCMenuItemSprite)

@implementation CCMenuItemSprite (LabelButton)


+(CCMenuItemSprite*)menuItemSpriteWithTitle:(NSString*)title
                                   fontName:(NSString*)fontName
                                   fontSize:(GLfloat)fontSize
                                 dimensions:(CGSize)dimensions
                                 background:(ccColor3B)bgColor
                                     target:(id)target
                                   selector:(SEL)selector
{
    ccColor3B foregroundColor = ccc3(240,240,255);

    SCLabel *label = [SCLabel labelWithString:title
                                     fontName:fontName
                                     fontSize:fontSize
                                   dimensions:dimensions
                                   hAlignment:kCCTextAlignmentRight
                                lineBreakMode:kCCLineBreakModeWordWrap];
    label.color = foregroundColor;

    ccColor4B bgColorNormal = ccc4(bgColor.r * 0.35,bgColor.g * 0.35, bgColor.b * 0.35, 255);
    ccColor4B bgColorPressed = ccc4(bgColor.r * 0.25,bgColor.g * 0.25, bgColor.b * 0.25, 255);

    CCLayerColor *layerBG = [CCLayerColor layerWithColor:bgColorNormal];
    layerBG.contentSize = dimensions;
    label.anchorPoint = layerBG.anchorPoint = ccp(0,0);
    label.position = layerBG.position = ccp(0,0);
    label.tag = 101;
    layerBG.touchEnabled = YES;
    [layerBG addChild:label];

    SCLabel *label2 = [SCLabel labelWithString:title
                                      fontName:fontName
                                      fontSize:fontSize
                                    dimensions:dimensions
                                    hAlignment:kCCTextAlignmentCenter
                                 lineBreakMode:kCCLineBreakModeWordWrap];
    label2.color = foregroundColor;

    CCLayerColor *layerBG2 = [CCLayerColor layerWithColor:bgColorPressed];
    layerBG2.contentSize = dimensions;
    label2.anchorPoint = layerBG2.anchorPoint = ccp(0,0);
    label2.position = layerBG2.position = ccp(0,0);
    label2.tag = 101;
    layerBG2.touchEnabled = YES;
    [layerBG2 addChild:label2];

    CCMenuItemSprite *menuItem = [CCMenuItemSprite itemWithNormalSprite:layerBG
                                                         selectedSprite:layerBG2
                                                                 target:target
                                                               selector:selector];
    menuItem.anchorPoint = ccp(0.5,0.5);
    menuItem.position =  ccp(0, 0);

    layerBG.visible = YES;
    label.visible = YES;
    menuItem.visible = YES;

    return menuItem;
}


@end
