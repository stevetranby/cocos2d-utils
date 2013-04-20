//
//  ___FILEBASENAMEASIDENTIFIER___Loader.h
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

#ifndef ___PROJECTNAMEASIDENTIFIER_______FILEBASENAMEASIDENTIFIER___Loader____FILEEXTENSION___
#define ___PROJECTNAMEASIDENTIFIER_______FILEBASENAMEASIDENTIFIER___Loader____FILEEXTENSION___

#include "GameConfig.h"

#include "___FILEBASENAMEASIDENTIFIER___.h"

/* Forward declaration. */
class CCBReader;

class ___FILEBASENAMEASIDENTIFIER___Loader : public cocos2d::extension::CCLayerLoader {
    public:
        CCB_STATIC_NEW_AUTORELEASE_OBJECT_METHOD(___FILEBASENAMEASIDENTIFIER___Loader, loader);
    protected:
        CCB_VIRTUAL_NEW_AUTORELEASE_CREATECCNODE_METHOD(___FILEBASENAMEASIDENTIFIER___);
};

#endif  /* defined(___PROJECTNAMEASIDENTIFIER_______FILEBASENAMEASIDENTIFIER___Loader____FILEEXTENSION___) */