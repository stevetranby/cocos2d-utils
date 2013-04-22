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

class ___FILEBASENAMEASIDENTIFIER___
: public cocos2d::CCLayer
, public cocos2d::extension::CCBSelectorResolver
, public cocos2d::extension::CCBMemberVariableAssigner
//, public cocos2d::extension::CCNodeLoaderListener // need if want callback for every node that's loaded
{
public:

    CCB_STATIC_NEW_AUTORELEASE_OBJECT_WITH_INIT_METHOD(___FILEBASENAMEASIDENTIFIER___, create);

    ___FILEBASENAMEASIDENTIFIER___();
    virtual ~___FILEBASENAMEASIDENTIFIER___();
    virtual bool init();
    static cocos2d::CCScene* scene();

    // CocosBuilder Classes
    virtual cocos2d::SEL_MenuHandler onResolveCCBCCMenuItemSelector(cocos2d::CCObject * pTarget, const char * pSelectorName);
    virtual bool onAssignCCBMemberVariable(cocos2d::CCObject * pTarget, const char * pMemberVariableName, cocos2d::CCNode * pNode);
    virtual cocos2d::extension::SEL_CCControlHandler onResolveCCBCCControlSelector(cocos2d::CCObject * pTarget, const char * pSelectorName);
    //virtual bool onAssignCCBCustomProperty(CCObject* pTarget, const char* pMemberVariableName, cocos2d::extension::CCBValue* pCCBValue);
    //virtual void onNodeLoaded(cocos2d::CCNode * pNode, cocos2d::extension::CCNodeLoader * pNodeLoader);

    // custom public methods named within cocosbuilder
    void menuAction(cocos2d::CCObject *sender);

private:

    // CCNode subclass named for owner/docroot
    cocos2d::CCSprite *mySprite;
};


/* Forward declaration. */
class CCBReader;

class ___FILEBASENAMEASIDENTIFIER___Loader : public cocos2d::extension::CCLayerLoader {
    public:
        CCB_STATIC_NEW_AUTORELEASE_OBJECT_METHOD(___FILEBASENAMEASIDENTIFIER___Loader, loader);
    protected:
        CCB_VIRTUAL_NEW_AUTORELEASE_CREATECCNODE_METHOD(___FILEBASENAMEASIDENTIFIER___);
};


#endif  /* defined(___PROJECTNAMEASIDENTIFIER_______FILEBASENAMEASIDENTIFIER_______FILEEXTENSION___) */