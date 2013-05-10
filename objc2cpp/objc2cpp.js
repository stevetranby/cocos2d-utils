// 
// Author: Steve Tranby
//
// Regex Optimization Ideas:
// - naive implementation, so this is not optimized at all
// - regular expression also somewhat naive and should be improved
// - currently replace is called on the entire source input for every type of code "feature"
// - perform replace for simple string to string on entire input with global flag "g"
// - test calling replace with regex on every line instead of entire input for complex exprs
// - test preprocessing the original source into one line statements to allow using ^ and $ and "m" flag
//   (so all method declarations, calls, and signatures should have no newlines in the middle)
// - use positive instead of negative character sets, i.e. [a-z] instead of [^\s;] for types/vars/params
// - use more selective boundary conditions where possible
//
// Todo:
// - for(var in array)
// - array/dict literals
// - convert [XXX CGPointValue] to CCPointFromString(XXX)
// - convert [XXX CGSizeValue] to CCSizeFromString(XXX)
// - convert [XXX CGRectValue] to CCRectFromString(XXX)
//---------------------------------------------------------------------------

(function(exports) {

    String.prototype.repeat = function(num) {
        return new Array(num + 1).join(this);
    };

    // var objc2cpp = require('./objc2cpp.js');
    // online test: http://codepen.io/tranbonium/pen/ohLvC
    //
    // --OPTIONS--
    // option:filetype (interface|implementation)
    // option:use_cocos2d_prefix (use cocos2d prefix "cocos2d::" with types in interface)
    // option:class_name (string to use as prefix in method names)
    //
    // filetype==interface:
    // -
    //
    // filetype==implementation:
    // - prepends "{class_name}::" to all non-static methods

    // todo: lookup init constructor for commonjs/requirejs/node/browserify
    exports.useprefix = false;
    exports.isheader = true;
    exports.allgetset = false;
    exports.classname = "";

    // Translate objc -> objc
    // remove newlines within a method/declaration/etc
    exports.preprocess = function(input) {
        var o = input;
        o = o.trim();
        return o;
    };

    // Stuff that should be done before the main pass "convert"
    exports.firstPass = function(input) {
        var o = input;

        console.log("in firstPass");

        // id to bool for Return Value (better practice)
        o = o.replace(/\+\(\s*id\s*\)/g, "+(bool)");
        o = o.replace(/-\(\s*id\s*\)/g, "-(bool)");

        // TODO: could possibly use 'auto' instead of CCObject* if supported
        // id to CCObject* for object pointer as param or assignment
        o = o.replace(/\bid\b/g, "CCObject*");

        // CUSTOM: I was using ccs() macro in iphone code to mean CGSizeMake()
        //         could switch to ccz() instead as seen elsewhere in others' extensions
        o = o.replace(/ccs\(/g, "CCSize(");

        return o;
    };

    // implementations
    exports.secondPass = function(input) {
        var o = input;
        console.log("in secondPass");
        return o;
    };

    // final pass converts simple keyword replacements
    // also converts all create methods (labelWithString:) to "create()"
    exports.finalPass = function(input) {
        var o = input;
        console.log("in finalPass");
        return o;
    };

    exports.convert = function(input) {

        console.log("input = " + input);

        var o = this.firstPass(input);
        o = this.secondPass(o);

        // believe this must occur before method calls
        var selfGetReplace = function(match, p1) {
            return "this->get" + p1.charAt(0).toUpperCase() + p1.substr(1) + "() ";
        };
        var selfSetReplace = function(match, p1, p2) {
            return "this->set" + p1.charAt(0).toUpperCase() + p1.substr(1) + "(" + p2 + ")";
        };
        o = o.replace(/self.([\w]+)\s*=\s*([^;=]+)/g, selfSetReplace);
        o = o.replace(/self.([\w]+)\s/g, selfGetReplace);

        var replaceStr = "CCObject* __obj__;\nCCARRAY_FOREACH($3,__obj__)\n{\n$1 $2 = static_cast<$1>(__obj__);";
        o = o.replace(/for\s*\(([\w._]+(?:\s?\*))\s*([\w\s_.*]+)\s+in\s+([^)]+)\)\s*\{/g, replaceStr);

        ////////////////////////////////////////////////////////////////////////////////////
        // METHOD CALLS
        //
        // [Class classWith:param1 n2:p2  n3:p3] -> Class::classWith(param1,p2,p3);
        // [Class classWith] -> Class::classWith()
        //
        ////////////////////////////////////////////////////////////////////////////////////

        // TODO: repeat this XX times (prob 3 is enough, should preprocess source if need more)
        // - convert multiple nested calls into separate temporary variables

        for (var repeat = 6; repeat >= 0; --repeat) {
            // helper to get method calls
            o = o.replace(/\[([^\]\[]+)\]/g, "--*$1=--");

            // var startPatternA = "--\\*([A-Z][A-Z]?[^=\\n]+)\\s+([^=\\n]+)";
            // var startPatternB = "--\\*([^=\\n]+)\\s+([^=\\n]*)";
            var startPatternA = "--\\*([A-Z][A-Z]?\\w+)\\s+([\\w.]+)";
            var startPatternB = "--\\*([^=\\n]+)\\s+([\\w.]+)";
            var startReplaceA = "$1::$2(";
            var startReplaceB = "$1->$2(";
            var endPattern2 = "=--";
            var endReplace2 = ")";

            var paramPatternFirst2 = ":\\s*([^:=\\n]+)";
            var paramPatternExtra = "\\s+[^:=\\n]*:\\s*([^:=\\n]+)";

            if (o.match(new RegExp(startPatternA)) || o.match(new RegExp(startPatternB))) {

                console.log("found match for method call");

                var nParams2 = 7;
                for (var i2 = nParams2; i2 >= 0; --i2) {

                    var patternA = "";
                    if (i2 > 1) patternA = startPatternA + paramPatternFirst2 + paramPatternExtra.repeat(i2 - 1) + endPattern2;
                    else if (i2 == 1) patternA = startPatternA + paramPatternFirst2 + endPattern2;
                    else patternA = startPatternA + endPattern2;

                    //console.log(patternA);
                    var regexA = new RegExp(patternA, "g");

                    var paramReplacesA = [];
                    for (var j2 = 0; j2 < i2; ++j2) {
                        var a2 = 3 + j2;
                        paramReplacesA.push("$" + a2);
                    }

                    var replacementA = startReplaceA + paramReplacesA.join(", ") + endReplace2;
                    //console.log(replacementA);
                    o = o.replace(regexA, replacementA);

                    var patternB = "";
                    if (i2 > 1) patternB = startPatternB + paramPatternFirst2 + paramPatternExtra.repeat(i2 - 1) + endPattern2;
                    else if (i2 == 1) patternB = startPatternB + paramPatternFirst2 + endPattern2;
                    else patternB = startPatternB + endPattern2;

                    var regexB = new RegExp(patternB, "g");
                    var paramReplacesB = [];
                    for (var jB = 0; jB < i2; ++jB) {
                        var aB = 3 + jB;
                        paramReplacesB.push("$" + aB);
                    }
                    var replacementB = startReplaceB + paramReplacesB.join(", ") + endReplace2;
                    o = o.replace(regexB, replacementB);
                }
            }
        }

        ////////////////////////////////////////////////////////////////////////////////////
        // METHOD DECLARATIONS
        //
        // note: this currently creates _ delimited function names so
        //
        //   -(CCSprite*)myMethod:(int)arg1 Another:(float)arg2 {
        //
        // becomes:
        //
        //   CCSprite* myMethod(int arg1, float arg2) {
        //
        // it could become:
        //   CCSprite* myMethod_Another(int arg1, float arg2) {
        //
        ////////////////////////////////////////////////////////////////////////////////////

        var prefix = exports.classname !== null && exports.classname.length > 0 ? exports.classname + "::" : "";

        // variable identifier: [a-zA-Z_][a-zA-Z_0-9]+
        // type identifier: [a-zA-Z_][a-zA-Z_0-9]+(?:\*|\s\*)?
        var startPattern = "\\s*\\(\\s*([a-zA-Z_][a-zA-Z_0-9]+(?:\\*|\\s\\*)?)\\s*\\)\\s*([^:;\\s\\n]+)\\s*";
        var startReplace = "$1 " + prefix + "$2(";
        var paramPatternFirst = ":\\s*\\(\\s*([a-zA-Z_][a-zA-Z_0-9]+(?:\\*|\\s\\*)?)\\s*\\)\\s*([a-zA-Z_][a-zA-Z_0-9]+)\\s*";
        var paramPattern = "\\s+[a-zA-Z_][a-zA-Z_0-9]+\\s*:\\s*\\(\\s*([a-zA-Z_][a-zA-Z_0-9]+(?:\\*|\\s\\*)?)\\s*\\)\\s*([a-zA-Z_][a-zA-Z_0-9]+)\\s*";

        if (o.match(new RegExp(startPattern))) {

            console.log("found match for method declaration/signature");

            var nParams = 8;
            for (var i = nParams; i >= 0; --i) {
                for (var start = 0; start < 2; ++start) {
                    for (var end = 0; end < 2; ++end) {
                        var startChar = start === 0 ? "-" : "\\+";
                        var startReplaceChar = start === 0 ? "" : "static ";
                        var endPattern = end === 0 ? ";" : "{";
                        var endReplace = end === 0 ? ");" : ")\n{";

                        var pattern = "";
                        if (i > 1) pattern = startChar + startPattern + paramPatternFirst + paramPattern.repeat(i - 1) + endPattern;
                        else if (i == 1) pattern = startChar + startPattern + paramPatternFirst + endPattern;
                        else pattern = startChar + startPattern + endPattern;

                        console.log(pattern);
                        var regex = new RegExp(pattern, "g");

                        if(o.match(regex))
                        {
                            var paramReplaces = [];
                            for (var j = 0; j < i; ++j)
                            {
                                var a = 3 + j * 2;
                                var b = 4 + j * 2;
                                paramReplaces.push("$" + a + " $" + b);
                            }
                            var replacement = startReplaceChar + startReplace + paramReplaces.join(", ") + endReplace;
                            console.log("match, replacing: " + replacement);
                            o = o.replace(regex, replacement);
                        }
                    }
                }
            }
        }
        // CCDictionary dictionaryWithObjectsAndKeys:
        o = o.replace(/--\*([A-Z][A-Z]?\w+)\s+([\w.]+):([^:=]+)=--/g, "$1::$2($3)");

        ////////////////////////////////////////////////////////////////////////////////////
        // CLASS INTERFACE & IMPLEMENTATION
        //
        // note: this currently creates _ delimited function names so
        //
        //   @implementation IntroLayer (category)
        //   @interface IntroLayer (category)
        //   @interface IntroLayer : SCLayer (category)
        //
        // becomes:
        //
        //   __COMMENT_OUT__
        //   class HelloWorld
        //   class HelloWorld : public cocos2d::CCLayer
        //
        ////////////////////////////////////////////////////////////////////////////////////

        o = o.replace(/@implementation\s+([^\s]+)[\s\n]/g, "\/\/ Implementation $1");
        o = o.replace(/@interface\s+([^\s]+)\s*:\s*([^\s]+)(\s*\([^)]*\))?/g, "class $1 : public cocos2d::$2");
        o = o.replace(/@interface\s+([^():;{]+)(\([^)]*\))?/g, "class $1");

        ////////////////////////////////////////////////////////////////////////////////////
        // PROPERTIES
        //
        //   @property (nonatomic, retain) TYPE name
        //
        // becomes:
        //
        //   CC_SYNTHESIZE(type, name, funcName)
        //
        // TODO: need to consider other formats and order of property "flags"
        //
        ////////////////////////////////////////////////////////////////////////////////////

        var assignProperty = function(match, p1, p2) {
            return "CC_SYNTHESIZE(" + p1 + ", _" + p2 + ", " + p2.charAt(0).toUpperCase() + p2.substr(1) + ")";
        };

        var retainProperty = function(match, p1, p2) {
            return "CC_SYNTHESIZE_RETAIN(" + p1 + ", _" + p2 + ", " + p2.charAt(0).toUpperCase() + p2.substr(1) + ")";
        };

        var copyProperty = function(match, p1, p2) {
            // DOES NOT EXIST, use macro
            return "CC_SYNTHESIZE_COPY(" + p1 + ", _" + p2 + ", " + p2.charAt(0).toUpperCase() + p2.substr(1) + ")";
        };

        // assign (weak)
        o = o.replace(/@property\s*\(nonatomic\)\s*([a-zA-Z_][a-zA-Z_0-9]+(?:\*|\s\*)?)\s*([a-zA-Z]+)/g, assignProperty);
        o = o.replace(/@property\s*\(nonatomic,\s*assign\)\s*([a-zA-Z_][a-zA-Z_0-9]+(?:\*|\s\*)?)\s*([a-zA-Z]+)/g, assignProperty);
        o = o.replace(/@property\s*\(readwrite,\s*assign\)\s*([a-zA-Z_][a-zA-Z_0-9]+(?:\*|\s\*)?)\s*([a-zA-Z]+)/g, assignProperty);
        o = o.replace(/@property\s*\(nonatomic,\s*readwrite\)\s*([a-zA-Z_][a-zA-Z_0-9]+(?:\*|\s\*)?)\s*([a-zA-Z]+)/g, assignProperty);
        o = o.replace(/@property\s*\(readwrite\)\s*([a-zA-Z_][a-zA-Z_0-9]+(?:\*|\s\*)?)\s*([a-zA-Z]+)/g, assignProperty);

        // retain (strong)
        o = o.replace(/@property\s*\(nonatomic,\s*retain\)\s*([a-zA-Z_][a-zA-Z_0-9]+(?:\*|\s\*)?)\s*([a-zA-Z]+)/g, retainProperty);
        o = o.replace(/@property\s*\(readwrite,\s*retain\)\s*([a-zA-Z_][a-zA-Z_0-9]+(?:\*|\s\*)?)\s*([a-zA-Z]+)/g, retainProperty);

        // copy (strong) - should prob use a copy constructor
        o = o.replace(/@property\s*\(nonatomic,\s*copy\)\s*([a-zA-Z_][a-zA-Z_0-9]+(?:\*|\s\*)?)\s*([a-zA-Z]+)/g, copyProperty);

        ////////////////////////////////////////////////////////////////////////////////////
        // HANDLE id
        //
        // *Note: disabled by default, you may want to enable depending on porting preferences
        //
        // Sometimes id should be bool for Return Value
        // - [nil autorelease] is allowed, null->method() is ERROR
        //
        // Sometimes id is used as an ANY_OBJECT pointer
        // - id action = [CCAction action] => void* action = CCAction->action();
        //
        ////////////////////////////////////////////////////////////////////////////////////

        // GENERAL
        // first convert to c++ string identifiers so we don't replace %@" with %s"
        o = o.replace(/%@/g, "%s");
        o = o.replace(/@\"/g, "\"");
        o = o.replace(/import/g, "include");
        o = o.replace(/self/g, "this");
        o = o.replace(/YES/g, "true");
        o = o.replace(/BOOL/g, "bool");
        o = o.replace(/NO/g, "false");
        o = o.replace(/nil/g, "NULL");
        o = o.replace(/ccTime/g, "float"); // could do double? I believe CCNode defines as double in update()
        o = o.replace(/GLfloat/g, "float");

        // keep cocos2d:: prefix if header file
        // CGFloat => float
        // CGPointMake => cocos2d::CCPointMake
        // CGSizeMake => cocos2d::CCSizeMake
        // CGRectMake => cocos2d::CCRectMake
        // CGPoint => cocos2d::CCPoint
        // CGSize => cocos2d::CCSize
        // CGRect => cocos2d::CCRect

        o = o.replace(/CGPointMake/g, "CCPoint");
        o = o.replace(/CGSizeMake/g, "CCSize");
        o = o.replace(/CGRectMake/g, "CCRect");
        o = o.replace(/CGPoint/g, "CCPoint");
        o = o.replace(/CGSize/g, "CCSize");
        o = o.replace(/CGRect/g, "CCRect");
        o = o.replace(/CGFloat/g, "float");
        o = o.replace(/UITouch/g, "CCTouch");
        o = o.replace(/UIEvent/g, "CCEvent");
        o = o.replace(/ccTime/g, "double");
        o = o.replace(/NSTimeInterval/g, "double");
        o = o.replace(/NSInteger/g, "int");
        

        // NSMutableArray => cocos2d::CCArray
        // NSMutableDictionary => cocos2d::CCDictionary
        // NSString => cocos2d::CCString

        o = o.replace(/NSArray/g, "CCArray");
        o = o.replace(/NSMutableArray/g, "CCArray");
        o = o.replace(/NSDictionary/g, "CCDictionary");
        o = o.replace(/NSMutableDictionary/g, "CCDictionary");
        o = o.replace(/NSString/g, "CCString");

        // YOUR OWN CUSTOM REPLACEMENTS
        o = o.replace(/SCLabel/g, "CCLabelBMFont");
        o = o.replace(/CCLabelTTF/g, "CCLabelBMFont");

        // If use prefix, go through and check for any not prefixed
        // for now we'll prefix everything using new checks, could litter
        // throughout the rest of the code instead, but this is hopefully a
        // bit more clean
        var ccprefix = exports.useprefix ? "cocos2d::" : "";
        if(exports.useprefix)
        {
            o = o.replace(/([^:])(CCLabelBMFont)/g, "$1" + ccprefix + "$2");
            o = o.replace(/([^:])(CCPoint)/g,       "$1" + ccprefix + "$2");
            o = o.replace(/([^:])(CCSize)/g,        "$1" + ccprefix + "$2");
            o = o.replace(/([^:])(CCRect)/g,        "$1" + ccprefix + "$2");
            o = o.replace(/([^:])(CCPoint)/g,       "$1" + ccprefix + "$2");
            o = o.replace(/([^:])(CCSize)/g,        "$1" + ccprefix + "$2");
            o = o.replace(/([^:])(CCRect)/g,        "$1" + ccprefix + "$2");
            o = o.replace(/([^:])(CCObject)/g, "$1" + ccprefix + "$2");
            o = o.replace(/([^:])(CCArray)/g,       "$1" + ccprefix + "$2");
            o = o.replace(/([^:])(CCDictionary)/g,  "$1" + ccprefix + "$2");
            o = o.replace(/([^:])(CCString)/g,      "$1" + ccprefix + "$2");
        }

        // Create Methods
        o = o.replace(/CCAnimate::actionWithAnimation\(/g, "CCAnimate::create(");
        o = o.replace(/CCArray::array\(/g, "CCArray::create(");
        o = o.replace(/CCArray::arrayWithCapacity\(/g, "CCArray::create(");
        o = o.replace(/CCArray::arrayWithObject\(/g, "CCArray::create(");
        o = o.replace(/CCArray::arrayWithObjects\(/g, "CCArray::create(");
        o = o.replace(/CCDelayTime::actionWithDuration\(/g, "CCDelayTime::create(");
        o = o.replace(/CCDictionary::dictionary\(/g, "CCDictionary::create(");
        o = o.replace(/CCDictionary::dictionaryWithCapaticy\(/g, "CCDictionary::create(");
        o = o.replace(/CCDictionary::dictionaryWithObjectsAndKeys\(/g, "CCDictionary::create(");
        o = o.replace(/CCCallFunc::actionWithTarget\(/g, "CCCallFunc::create(");
        o = o.replace(/CCFadeIn::actionWithDuration\(/g, "CCFadeIn::create(");
        o = o.replace(/CCLabelBMFont::labelWithString\(/g, "CCLabelBMFont::create(");
        o = o.replace(/CCLayerColor::layerWithColor\(/g, "CCLayerColor::create(");
        o = o.replace(/CCMenu::menuWithItems\(/g, "CCMenu::create(");
        o = o.replace(/CCMenuItemSprite::itemWithNormalSprite:\(/g, "CCMenuItemSprite::create(");
        o = o.replace(/CCMoveBy::actionWithDuration\(/g, "CCMoveBy::create(");
        o = o.replace(/CCMoveTo::actionWithDuration\(/g, "CCMoveTo::create(");
        o = o.replace(/CCProgressTimer::progressWithSprite\(/g, "CCProgressTimer::create(");
        o = o.replace(/CCRepeat::actionWithAction\(/g, "CCRepeat::create(");
        o = o.replace(/CCRepeatForever::actionWithAction\(/g, "CCRepeatForever::create(");
        o = o.replace(/CCSequence::actions\(/g, "CCSequence::create(");
        o = o.replace(/CCSprite::spriteWithFile\(/g, "CCSprite::create(");
        o = o.replace(/CCTintTo::actionWithDuration\(/g, "CCTintTo::create(");
        o = o.replace(/CCFadeOut::actionWithDuration\(/g, "CCFadeOut::create(");
        o = o.replace(/STRemoveFromParentAction::actionWithCleanup\(/g, "CCRemoveSelf::create(");
        o = o.replace(/CCShow::action\(/g, "CCShow::create(");
        o = o.replace(/CCHide::action\(/g, "CCHide::create(");
        o = o.replace(/CCBlink::actionWithDuration\(/g, "CCBlink::create(");
        o = o.replace(/CCScaleTo::::actionWithDuration\(/g, "CCScaleTo::create(");
        // REMOVE SYNTAX
        // @class ...
        // @end

        o = o.replace(/@class /g, "class ");
        o = o.replace(/@end/g, "");

        // THIS SHOULD PROB BE A SEPARATE TOOL????
        // - mainly necessary for factories and inits
        // specific CCNode properties
        if(exports.allgetset)
        {
            var capitalize = function(string)
            {
                return string.charAt(0).toUpperCase() + string.slice(1);
            };
            
            var replaceSetterGetter = function(match, varname, propname, value) {
                return varname + "->set" + capitalize(propname) + "(" + varname + "->get" + capitalize(propname) + "() + " + value + ");";
            };
            o = o.replace(/\b([a-zA-Z_][a-zA-Z_0-9]+)\.([a-zA-Z_][a-zA-Z_0-9]+)\s*\+=\s*([^=;]+);/g, replaceSetterGetter);

            var replaceSetterMinusGetter = function(match, varname, propname, value) {
                return varname + "->set" + capitalize(propname) + "(" + varname + "->get" + capitalize(propname) + "() - " + value + ");";
            };
            o = o.replace(/\b([a-zA-Z_][a-zA-Z_0-9]+)\.([a-zA-Z_][a-zA-Z_0-9]+)\s*-=\s*([^=;]+);/g, replaceSetterMinusGetter);

            var replaceSetter = function(match, varname, propname, value) {
                return varname + "->set" + capitalize(propname) + "(" + value + ");";
            };
            o = o.replace(/\b([a-zA-Z_][a-zA-Z_0-9]+)\.([a-zA-Z_][a-zA-Z_0-9]+)\s*=\s*([^=;]+);/g, replaceSetter);

            // after to prevent converting the setter lvalue before it can exec
            // todo: add ability to prevent selecting . inside a string
            var replaceGetter = function(match, varname, propname) {
                if(propname === "width" || propname === "height" || propname === "x" || propname === "y" || propname === "size" || propname === "origin" || propname === "png" || propname === "ccz" || propname === "jpg")
                {
                    return varname + "." + propname;
                }
                return varname + "->get" + capitalize(propname) + "()";
            };
            o = o.replace(/(\)|\b[a-zA-Z_][a-zA-Z_0-9]+)\.([a-zA-Z_][a-zA-Z_0-9]+)\b/g, replaceGetter);

        }
        
        // ....
        o = o.replace(/->isEqualToString\(@?"([^"]+)"\)/g, "->isEqual(ccs(\"$1\"))");

        // todo: figure out how to have getPROPERTY work with regex, maybe after the conversion on a post pass?
        o = o.replace(/\.position\s*=\s*(\w+);/g, "->setPosition($1);");
        o = o.replace(/\.scale\s*=\s*(\w+);/g, "->setScale($1);");
        o = o.replace(/\.anchorPoint\s*=\s*(\w+);/g, "->setAnchorPoint($1);");
        o = o.replace(/\.tag\s*=\s*(\w+);/g, "->setTag($1);");
        o = o.replace(/\.opacity\s*=\s*(\w+);/g, "->setOpacity($1);");
        o = o.replace(/\.zOrder\s*=\s*(\w+);/g, "->setZOrder($1);");
        o = o.replace(/\.vertexZ\s*=\s*(\w+);/g, "->setVertexZ($1);");
        //o = o.replace(/\.opacity\s*=\s*(\w+);/g, "->setOpacity($1);");


        // DO GETS LAST
        o = o.replace(/\.position\b/g, "->getPosition()");
        o = o.replace(/\.scale\b/g, "->getScale()");
        o = o.replace(/\.anchorPoint\b/g, "->setAnchorPoint()");
        o = o.replace(/\.tag\b/g, "->getTag()");
        o = o.replace(/\.opacity\b/g, "->getOpacity()");
        o = o.replace(/\.zOrder\b/g, "->getZOrder()");
        o = o.replace(/\.vertexZ\b/g, "->getVertexZ()");
        //o = o.replace(/\.opacity\s*=\s*(\w+);/g, "->setOpacity($1);");


        // Didn't get around to replacing method calls, so assume it was a value array
        // - it'll look like the message syntax didn't convert otherwise which is fine
        o = o.replace("--*", "[");
        o = o.replace("=--", "]");

        return o;
    };

})(typeof exports === 'undefined' ? this.objc2cpp = {} : exports);