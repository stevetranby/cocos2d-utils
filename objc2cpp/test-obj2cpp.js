//
// Author: Steve Tranby
//
// Todo:
// - utilize a real test framework to handle this

var objc2cpp = require('./objc2cpp.js');

var assertions = [

// method declaration
"-(void )method:(id ) param1 Two : (CGPoint)param2 Three : ( int ) param3",
"void method(void* param1, CCPoint param2, int param3);",
"+(CCScene*)scene;",
"static cocos2d::CCScene* scene();",
// method signature
"+(CCScene*)scene {",
"static cocos2d::CCScene* scene()\n{",

//
"done","done"
];

// was going to use node's assert.equal(), but will have to reformat into using a map method to make sure
// assert failures don't block the rest of the assertions to execute
for(var i=0; i< assertions.length; i+=2) {
  var test = assertions[i];
  var correct = assetions[i+1];
  var result = obj2cpp.convert(test);
  if(result !== correct)
    console.log("FAIL: " + result);
  else
    console.log("GOOD: " + result);
}