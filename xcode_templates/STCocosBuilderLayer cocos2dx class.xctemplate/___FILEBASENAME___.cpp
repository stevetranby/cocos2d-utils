//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

#include "___FILEBASENAMEASIDENTIFIER___.h"
#include "___FILEBASENAMEASIDENTIFIER___Loader.h"

USING_NS_CC;
USING_NS_CC_EXT;

___FILEBASENAMEASIDENTIFIER___::___FILEBASENAMEASIDENTIFIER___() {}
___FILEBASENAMEASIDENTIFIER___::~___FILEBASENAMEASIDENTIFIER___() {}

CCScene* ___FILEBASENAMEASIDENTIFIER___::scene()
{
    CCScene* scene = CCScene::create();
    ___FILEBASENAMEASIDENTIFIER___* layer = ___FILEBASENAMEASIDENTIFIER___::create();
    scene->addChild(layer);
    return scene;
}

bool ___FILEBASENAMEASIDENTIFIER___::init()
{
    if( ! CCLayer::init())
        return false;

    //setTouchEnabled( true );

    /* Create an autorelease CCNodeLoaderLibrary. */
    CCNodeLoaderLibrary* ccNodeLoaderLibrary = CCNodeLoaderLibrary::newDefaultCCNodeLoaderLibrary();
    ccNodeLoaderLibrary->registerCCNodeLoader("___FILEBASENAMEASIDENTIFIER___", ___FILEBASENAMEASIDENTIFIER___Loader::loader());
    /* Create an autorelease CCBReader. */
    cocos2d::extension::CCBReader * ccbReader = new cocos2d::extension::CCBReader(ccNodeLoaderLibrary);
    ccbReader->autorelease();

    /* Read a ccbi file. In this case reading using this class as "OWNER" */
    CCNode* node = ccbReader->readNodeGraphFromFile("___FILEBASENAMEASIDENTIFIER___.ccbi", this);
    if(node)
        this->addChild(node);

    return true;
}

cocos2d::SEL_MenuHandler ___FILEBASENAMEASIDENTIFIER___::onResolveCCBCCMenuItemSelector(cocos2d::CCObject* pTarget, const char* pSelectorName)
{
    CCB_SELECTORRESOLVER_CCMENUITEM_GLUE(this, "menuAction:", ___FILEBASENAMEASIDENTIFIER___::menuAction);
    return NULL;
}

bool ___FILEBASENAMEASIDENTIFIER___::onAssignCCBMemberVariable(cocos2d::CCObject* pTarget, const char * pMemberVariableName, cocos2d::CCNode* pNode)
{
    CCB_MEMBERVARIABLEASSIGNER_GLUE(this, "mySprite", CCSprite*, this->mySprite);
    return false;
}

cocos2d::extension::SEL_CCControlHandler ___FILEBASENAMEASIDENTIFIER___::onResolveCCBCCControlSelector(cocos2d::CCObject* pTarget, const char * pSelectorName)
{
    return NULL;
}

#pragma mark - Action Methods

void ___FILEBASENAMEASIDENTIFIER___::menuAction(cocos2d::CCObject* pSender)
{
    // todo: menu code here
}
