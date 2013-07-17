## cocos2d-utils

Various utility classes or tools for working with Cocos2D (-iphone,-x,-html) and porting from ObjC to C++.

# Porting
It goes without saying that if you plan to use Cocos2D-X in any capacity in the future it would be better to start out using it, whether to write everything in c++ or as the underlying engine to use with Javascript/Lua. However, if you want to convert an iOS project there are a couple tools and templates here to utilize.

There are businesses promoting tools and frameworks for running objC/cocos2d code on top of a custom runtime, but after looking at the ones available I decided it would be more efficient to just port the code base and move over to c++ entirely. YMMV.

# Disclaimer & Licensing:

Eventually I will note here that all code without a license present in the file, or otherwise expressed in this readme or other license.txt files in this repository will be given permission under the MIT license. Currently, however, this is just a dump of stuff that I have not sorted through, so for now you'll have to assume any files is licensed elsewhere or is copyright of Steve Tranby.

- * A few files are curtesy of other projects which I will eventually link to here.
- ** Some of the code in this repository is inspired by code found online. I will eventually document where the code came from. In some cases I may have written code without knowledge of other code that is similar or [nearly] identical.
- *** Again, I will update this once I sort everything out.

Also, once organized I will likely move the extensions specific to Cocos2d-iphone/-x to the respective forks from the main repositories. Everything else may remain in this repository, or may be separated out. This note is mainly to make sure others don't fork this with the idea that it's finished or necessarily production-ready code, but instead is posted in case someone finds something useful or for future integration/collaboration.

Note that cocos2d-x is changing rapidly, along with -iphone, and notably the -html for web and on top of native. This means that various things will be different in the future, but I believe most of the framework API is somewhat frozen for 2.x, so changes shouldn't be major until 3.x is released. Logging is one of these things that will change heavily, but you can start now by integrating CCPrettyPrint/CCDataVisitor into your logging system, at least for CCArray and CCDictionary. Anyway, will refine this paragraph once ideas coalesce.

Lastly, this is all stuff I have done to attempt to port a game as quickly as possible from iOS to cross platform. There are things on the objective-C / cocos2d-iPhone side that I could have been doing while coding to make the translation easier, but were done in a manner to make coding in the iOS specific platform better.

## Building for Android on MacOSX

(will move this to blog instead at a later date)

# Wiki Guides
- http://www.cocos2d-x.org/projects/cocos2d-x/wiki/Setting_up_Android_Development_Environment_on_Mac_OSX
- http://www.cocos2d-x.org/projects/cocos2d-x/wiki/How_to_create_android_project_with_script

./create-project-android.sh

Fix NDK_ROOT and ANDROID_ROOT variables in build-native.sh

./build-native.sh

Application.mk
APP_CPPFLAGS := -std=c++11 -frtti -fexceptions
APP_CPPFLAGS := -std=gnu++11 -frtti -fexceptions

New Project: Import From Existing Source
- /cocos2dx/platform/android/java/ (http://www.cocos2d-x.org/boards/6/topics/13949)
- path to your project

- http://stackoverflow.com/questions/13053353/unable-to-resolve-target-android-8

Watch out for platform specific preprocessor flags (may be cause for linker errors if removing method implementations)

    #ifdef __IPHONE_OS_VERSION_MAX_ALLOWED

## C++11 Additions & Resources

- http://www.cocos2d-x.org/boards/6/topics/18123

## TODOs

# Audio

conversion tools
- brew install vorbis-tools

# Misc
- https://github.com/radif/MCBCallLambda
- https://github.com/ivzave/cocos2dx-ext/blob/master/CCGeometryExtended.h
- http://yui.co/make-ccscrollview-work-with-ccmenuitemimage/
- https://github.com/cocos2d/cocos2d-x-extensions
- https://github.com/dualface/cocos2d-x-extensions

# Line Count
    find . "(" -name "*.m" -or -name "*.mm" -or -name "*.cpp" ")" -print0 | xargs -0 wc -l

# Scroll+Menu
- http://www.cocos2d-x.org/boards/6/topics/21294
- https://github.com/cocos2d/cocos2d-iphone-extensions/tree/master/Extensions/CCMenuAdvanced

# Guides
- http://gameit.ro/2011/09/performing-a-selector-after-a-delay-in-cocos2d-x/

# Music
- update/extend/replace Cocos2dxMusic.java to support seekTo and any other methods
- add these methods to CocosDenshion/{android,ios} and eventually win32/mac/linux
- http://cocos2d-x.org/attachments/468/Cocos2dxMusic.java
- http://developer.android.com/guide/topics/media/mediaplayer.html
- http://cocos2d-x.org/boards/6/topics/14460?r=14525#message-14525

# Arrays & Dictionaries (Conversion)
- http://www.cocos2d-x.org/projects/cocos2d-x/wiki/CCArray
- http://www.cocos2d-x.org/projects/cocos2d-x/wiki/Reference_Count_and_AutoReleasePool_in_Cocos2d-x
- http://www.cocos2d-x.org/projects/cocos2d-x/wiki/CCString
- http://www.cocos2d-x.org/projects/cocos2d-x/wiki/CCDictionary
- http://www.cocos2d-x.org/projects/cocos2d-x/wiki/Moving_From_Objective-C_to_C++

# Memory Management (notes to cleanup, some related to both, some to c++)
Look for any retains in iPhone code, make sure all CCArray/CCDictionary are created before attempting use, or initialize to NULL and check for null. Double check your retain/release pairing, so once converted to c++ code  do a search of all code for ->retain() and make sure a corresponding CC_SAFE_RELEASE_NULL is called either in the destructor or wherever [OBJECT release] was called in the iPhone code, or if not determine where it should go.

Rembmer objC handles sending messages to nil references gracefully. This is a double edged sword, and with c++ you have to be explicit in handling of NULL references. Either make sure that any potential allowed path through the code will have a valid reference (no NULL check necessary, but will crash), or make sure to check for NULL and only operate on that node or object if reference is valid.

While c++ can be a bit annoying after translating right away, it actually is helpful in that the code will crash either at the given method call on a NULL/invalid instance or it will crash in a release method.

Also, remember the retain,remove,release sequence when acting on an object you remove from container.

    node = (CCNode*)nodeArray->objectAtIndex(index);
    node->retain();
    // do stuff
    nodeArray->removeObjectAtIndex(index);
    // do stuff
    node->release();

Utilize weak references where possible. CC_SYNTHESIZE instead of CC_SYNTHESIZE_RETAIN. Create nodes and add as children, keep weak reference or use tag to get/remove.

Unless CCObject/subclass field is added as a child to another node, you probably need it to be a strong property using CC_SYNTHESIZE_RETAIN(), make sure to safe release these in destructor.


Convert C++ CC_PROP/SYNTH_ to Constructor Initializers
FIND: CC_\w+(?:_\w+)?\([^,]+,\s?([^,]+),[^;]+;
FIND: ^.+\s\*?(\w+);
REPL: , \1(NULL)

FIND: (\w+[\s*]+)([^;]+);
REPL: CCB_MEMBERVARIABLEASSIGNER_GLUE(this, "\2", \1, \2);

# NOTES
- always initialize everything (use constructor, regex find/replace helper)
- create copyWithZone for all or at least any CCObject subclasses that will be in an array that's copied

# MACROS
- maybe SAFE_REMOVESELF (remove from parent with null check of property calling "remove")
- convert all node->getChildByTag(tag)->removeFromParent(); this->setNode(NULL); TO removechildbytag

## RESOURCES

# Multi-Resolution
- http://www.cocos2d-x.org/projects/cocos2d-x/wiki/Multi_resolution_support
- http://stackoverflow.com/questions/3166501/getting-the-screen-density-programmatically-in-android
- https://github.com/cocos2d/cocos2d-x/issues/1793

# Arrays & Dictionaries
- Pretty Print: https://github.com/cocos2d/cocos2d-x/pull/2406

=== PLEASE FEEL FREE TO CONTACT ME OR FILE AN ISSUE IF ANYTHING HERE IS NOT CORRECT ===