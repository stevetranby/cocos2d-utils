//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

#ifndef ___PROJECTNAMEASIDENTIFIER_______FILEBASENAMEASIDENTIFIER_______FILEEXTENSION___
#define ___PROJECTNAMEASIDENTIFIER_______FILEBASENAMEASIDENTIFIER_______FILEEXTENSION___

#include "GameConfig.h"

class ___FILEBASENAMEASIDENTIFIER___ : public cocos2d::CCNode
{
public:

    ___FILEBASENAMEASIDENTIFIER___();
    ~___FILEBASENAMEASIDENTIFIER___();

    CREATE_FUNC(___FILEBASENAMEASIDENTIFIER___);

    static cocos2d::CCScene* scene();

    // Class Management
    virtual bool init();
    virtual void update(float dt);

    // Custom Methods
    void method();

    // Touches
    cocos2d::CCArray* allTouchesFromSet(cocos2d::CCSet *touches);
    virtual void ccTouchesBegan(cocos2d::CCSet* touches, cocos2d::CCEvent* event);
    virtual void ccTouchesMoved(cocos2d::CCSet* touches, cocos2d::CCEvent* event);
    virtual void ccTouchesEnded(cocos2d::CCSet* touches, cocos2d::CCEvent* event);

    // Properties
    CC_SYNTHESIZE_RETAIN(cocos2d::CCString*, example, Example);
    CC_SYNTHESIZE(cocos2d::CCPoint, exampleTwo, ExampleTwo);

private:
    CCObject* m_MemberOne;
    bool m_MemberTwo;
};

#endif  /* defined(___PROJECTNAMEASIDENTIFIER_______FILEBASENAMEASIDENTIFIER_______FILEEXTENSION___) */