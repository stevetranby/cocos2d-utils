//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

#include "___FILEBASENAMEASIDENTIFIER___.h"

USING_NS_CC;
//using namespace CocosDenshion;

___FILEBASENAMEASIDENTIFIER___::___FILEBASENAMEASIDENTIFIER___()
:m_MemberOne(new CCObject)
,m_MemberTwo(false)
{
}

___FILEBASENAMEASIDENTIFIER___::~___FILEBASENAMEASIDENTIFIER___()
{
    CC_SAFE_DELETE(m_MemberOne);
}

// REMOVE if not in need of scene creation
// (usually only needed for CCLayer subclasses)
CCScene* ___FILEBASENAMEASIDENTIFIER___::scene()
{
    CCScene *scene = CCScene::create();
    CCLayer* layer = ___FILEBASENAMEASIDENTIFIER___::create();
    scene->addChild(layer);
    return scene;
}

bool ___FILEBASENAMEASIDENTIFIER___::init()
{
    if ( !CCNode::init() )
    {
        CC_SAFE_DELETE(m_MemberOne);
        return false;
    }

    //setTouchEnabled( true );
    //setAccelerometerEnabled( true );

    //CCSize s = CCDirector::sharedDirector()->getWinSize();

    CCLOG("init success!");
    return true;
}

void ___FILEBASENAMEASIDENTIFIER___::update(float dt)
{
}

void ___FILEBASENAMEASIDENTIFIER___::method()
{
}

#pragma mark - Touches
// TOUCHES

CCArray* ___FILEBASENAMEASIDENTIFIER___::allTouchesFromSet(CCSet *touches)
{
    CCArray *arr = new CCArray();

    CCSetIterator it;
	for( it = touches->begin(); it != touches->end(); it++)
    {
        arr->addObject((CCTouch *)*it);
    }
    return arr;
}

void ___FILEBASENAMEASIDENTIFIER___::ccTouchesBegan(cocos2d::CCSet* touches, cocos2d::CCEvent* event)
{
    // This method is passed an NSSet of touches called (of course) "touches"
    // We need to convert it to an array first
    //CCArray *allTouches = this->allTouchesFromSet(touches);
    //CCTouch* fingerOne = (CCTouch *)allTouches->objectAtIndex(0);
}

void ___FILEBASENAMEASIDENTIFIER___::ccTouchesMoved(CCSet* touches, CCEvent* event)
{
    // This method is passed an NSSet of touches called (of course) "touches"
    // We need to convert it to an array first
    CCArray *allTouches = this->allTouchesFromSet(touches);

    // Only run the following code if there is more than one touch
    if (allTouches->count() > 1)
    {
    }
}

void ___FILEBASENAMEASIDENTIFIER___::ccTouchesEnded(CCSet* touches, CCEvent* event)
{
    // This method is passed an NSSet of touches called (of course) "touches"
    // We need to convert it to an array first
    //CCArray *allTouches = this->allTouchesFromSet(touches);
}
