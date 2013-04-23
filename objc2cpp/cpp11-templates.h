/*
http://www.cocos2d-x.org/boards/6/topics/18123

XCode: 
- Build Setting -> C++ Language Dialect choose C++11
- Build Setting -> C++ StandardLibrary choose libc++

android-ndk-r8b:
- add -std=gnu++0x to the APP_CPPFLAGS in jni/Application.mk
*/

namespace cc 
{
    // create node
    template<typename T, typename ...Args>
    T* create(Args&& ...args)
    {
        auto pRet = new T();
        if (pRet && pRet->init(std::forward<Args>(args)...)) 
        {
            pRet->autorelease();
            return pRet;
        }
        delete pRet;
        return nullptr;
    }

    // scene
    template<typename T, typename ...Args>
    cocos2d::CCScene* scene(Args&& ...args) 
    {
        cocos2d::CCScene *scene = cocos2d::CCScene::create();
        T *layer = cc::create<T>(std::forward<Args>(args)...);
        scene->addChild(layer);
        return scene;
    }

    // unique pointer 
    template<typename T>
    using unique_ptr = std::unique_ptr<T, std::function<void(void *)>>;
    template<typename T>
    unique_ptr<T> make_unique(T *ptr) 
    {
        if (ptr) ptr->retain();
        auto deleter = [](void *p) 
        {
            auto ptr = static_cast<T *>(p);
            if (ptr) ptr->release();
        };
        return unique_ptr<T>(ptr, deleter);
    }

    // unique pointer #2
    template<typename T>
    using unique_ptr = std::unique_ptr<T, std::function<void(void *)>>;
    template<typename T, typename ...Args>
    unique_ptr<T> make_unique(Args&& ...args) 
    {
        T *ptr = create<T>(std::forward<Args>(args)...);
        if (ptr) 
          ptr->retain();
        auto deleter = [](void *p) 
        {
            auto ptr = static_cast<T *>(p);
            if (ptr)
              ptr->release();
        };
        return unique_ptr<T>(ptr, deleter);
    }

    // shared pointer
    // ex:
    template<typename T>
    using shared_ptr = std::shared_ptr<T>;
    template<typename T>
    shared_ptr<T> make_shared(T *ptr) 
    {
        if (ptr) 
          ptr->retain();
        auto deleter = [](void *p) 
        {
            auto ptr = static_cast<T *>(p);
            if (ptr) 
              ptr->release();
        };
        return shared_ptr<T>(ptr, deleter);
    }
}

// create
auto node = cc::create<CustomNode>(...)

// scene
auto scene = cc::scene<CustomNode>(...)

// in xx.h
private:
    cc::unique_ptr<cocos2d::CCArray> _objects;
// in xx.cpp
bool CustomNode::init() 
{
    _objects = cc::make_unique(CCArray::createWithCapacity(objectCount));
    //...
}


