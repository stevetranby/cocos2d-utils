//
//  STTextBox.m
//
//
//  Created by Steve Tranby on 2/24/13.
//  Copyright (c) 2013 Steve Tranby. All rights reserved.
//

#import "STTextBox.h"
#import "GameConfig.h"
#import "cocos2d.h"

#import "CCNode+Utils.h"

@implementation STTextBoxIOS

+(STTextBoxIOS*)textboxWithLabel:(CCLabelTTF*)label Placeholder:(NSString*)placeholder
{
    STTextBoxIOS *tbox = [[STTextBoxIOS alloc] initWithLabel:label Placeholder:placeholder];
    return [tbox autorelease];
}

+(STTextBoxIOS*)textboxWithLabel:(CCLabelTTF*)label
{
    return [STTextBoxIOS textboxWithLabel:label Placeholder:@""];
}

-(id)initWithLabel:(CCLabelTTF*)label Placeholder:(NSString*)placeholder
{
    if((self = [super init]))
    {

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
		self.touchEnabled = YES;
#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)
		self.isMouseEnabled = YES;
#endif

        // defaults
        _maxLen = 18; // STEVEN TRANBY (13)

        self.textLabel = label;
        self.textPlaceholder = placeholder;
        self.textValue = placeholder;

        _textCursor = [[CCLayerColor layerWithColor:ccc4(255, 255, 255, 255)] retain];
        [_textCursor setContentSize:ccs(2, [[_textLabel parent] contentSize].height/2.0)];
        [_textCursor setAnchorPoint:ccp(0.5,0.5)];
        [_textCursor setIgnoreAnchorPointForPosition:NO];
        [_textCursor setVisible:NO];
        [[_textLabel parent] addChild:_textCursor z:100];

        [_textCursor runAction:
         [CCRepeatForever actionWithAction:
          [CCSequence actions:
           [CCFadeOut actionWithDuration:0.2],
           [CCDelayTime actionWithDuration:0.4],
           [CCFadeIn actionWithDuration:0.2],
           [CCDelayTime actionWithDuration:0.4],
           nil]]];

        // todo: Refactor into UI library/class
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(-1000, -1000,0,0)];
        [_textField setKeyboardType:UIKeyboardTypeASCIICapable];
        [_textField setSpellCheckingType:UITextSpellCheckingTypeNo];
        [_textField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [_textField setDelegate:self];

        [[[[CCDirector sharedDirector] view] window] addSubview:_textField];

        [_textField setText:placeholder];
    }
    return self;
}

#pragma mark

-(void)onEnter
{
    [super onEnter];
}

#pragma mark

-(void)focusTextField
{
    // todo: cache inFocus

    [_textField becomeFirstResponder];

    if([_textLabel.string isEqualToString:_textPlaceholder])
        _textLabel.string = @"";

    // cursor
    [_textCursor setVisible:YES];
    [self updateCursor];

    [_textField setText:_textLabel.string];
}


-(void)updateCursor
{
    // Based on the text font type, font size and line break mode
    // find the actual width and height needed for our text (text1).
    UIFont *font = [UIFont fontWithName:kFontVisitor size:_textLabel.fontSize];
    NSString *text = _textLabel.string;
    CGSize actualSize = [text sizeWithFont:font];

    float scale = 1.0;
	CCNode *parentNode = _textCursor.parent;
	while(parentNode)
	{
		scale *= parentNode.scale;
		parentNode = parentNode.parent;
	}

    CGPoint origin = _textLabel.position;
    CGPoint offset = ccpToRel(actualSize.width / 2.0 / scale, 0.0);
    [_textCursor setPosition:ccpAdd(origin,offset)];
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField*)textField
{
    if(_textField == textField)
    {
        if([[textField text] length] == 0)
            [textField setText:_textPlaceholder];

        [textField endEditing:YES];
        dlog(@"name %@", ccStrFormat(@"entered: %@", textField.text));
        self.textValue = [textField text];
        [_textLabel setString:[textField text]];

        [self updateCursor];
    }
}

-(BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // newString is what the user is trying to input.
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //dlog(@"%@ [%d]", newString, [newString length]);
    if ([newString length] > _maxLen)
    {
        return NO;
    }
    else
    {
        [_textLabel setString:newString];
        self.textValue = newString;
        [self updateCursor];
        return YES;
    }
}

#pragma mark

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED

-(void) registerWithTouchDispatcher
{
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self
                                                              priority:(kTouchPriorityMenu-1) swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    dlog(@"enter");

    // todo: prob use a fake node for touch
    if([_textLabel containsTouch:touch] ||
       [[_textLabel parent] containsTouch:touch])
    {
        [self focusTextField];
        return YES;
    }
    else
    {
        [_textField resignFirstResponder];
    }
	return NO;
}


-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
}


#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)

-(BOOL) ccMouseDragged:(NSEvent *)event
{
	return YES;
}
#endif

@end


#pragma mark

@implementation STTextPrompt

-(id)initWithMessage:(NSString*)msg
    InputPlaceholder:(NSString*)placeholder
        ConfirmTitle:(NSString*)confirmText
         CancelTitle:(NSString*)cancelText
{
    if((self = [super init]))
    {
        float fontSize = 20.0;

        ////////////////////////////////////////////
        // create prompt label
        _messageLabel = [CCLabelTTF labelWithString:msg
                                           fontName:kFontVisitor
                                           fontSize:fontSize*SCALE_LARGE];

        ////////////////////////////////////////////
        // create background touch node
        CCLayerColor *bg = [CCLayerColor layerWithColor:ccc4(40, 40, 40, 220)];
        [bg setAnchorPoint:ccp(0.5,0.5)];
        [bg setIgnoreAnchorPointForPosition:NO];
        [bg setContentSize:ccsToRel(300,120)];

        // create textbox label
        CCLayerColor *textLabelBg = [CCLayerColor layerWithColor:ccc4(200, 200, 200, 220)];
        [textLabelBg setAnchorPoint:ccp(0.5,0.5)];
        [textLabelBg setIgnoreAnchorPointForPosition:NO];
        [textLabelBg setContentSize:ccsToRel(240, fontSize+10)];
        self.textLabel = [CCLabelTTF labelWithString:placeholder
                                            fontName:kFontVisitor
                                            fontSize:fontSize*SCALE_LARGE];
        _textLabel.position = ccpToRel(120,(fontSize+10)/2.0);
        _textLabel.color = ccc3(0, 0, 0);
        [textLabelBg addChild:_textLabel];

        // create textbox
        _textBox = [STTextBoxIOS textboxWithLabel:_textLabel Placeholder:placeholder];

        ////////////////////////////////////////////
        // create the confirm/cancel buttons

        [CCMenuItemFont setFontName:kFontVisitor];
        [CCMenuItemFont setFontSize:fontSize*SCALE_LARGE];
        CCMenu *menu = [CCMenu node];
        CCMenuItemFont *menuItem = nil;
        menuItem = [CCMenuItemFont itemWithString:confirmText target:self selector:@selector(confirmAction:)];
        menuItem.position = ccpToRel(40,0);
        [menu addChild:menuItem];
        menuItem = [CCMenuItemFont itemWithString:cancelText target:self selector:@selector(cancelAction:)];
        menuItem.position = ccpToRel(-40,0);
        [menu addChild:menuItem];

        _textBox.position = ccpToRel(0, 10);
        _messageLabel.position = ccpToRel(0,30);
        menu.position = ccpToRel(0, -40);

        [self addChild:bg];
        [self addChild:textLabelBg];
        [self addChild:_textBox];
        [self addChild:_messageLabel];
        [self addChild:menu];
    }
    return self;
}

+(STTextPrompt*)promptWithMessage:(NSString*)msg
                 InputPlaceholder:(NSString*)placeholder
                     ConfirmTitle:(NSString*)confirmText
                      CancelTitle:(NSString*)cancelText
{
    id prompt = [[STTextPrompt alloc] initWithMessage:msg
                                     InputPlaceholder:placeholder
                                         ConfirmTitle:confirmText
                                          CancelTitle:cancelText];
    return [prompt autorelease];
}

-(void)confirmAction:(id)sender
{
    dlog(@"enter");
    if([_delegate respondsToSelector:@selector(didConfirmWithPrompt:)])
        [_delegate didConfirmWithPrompt:self];
    if([_delegate respondsToSelector:@selector(didCloseWithPrompt:)])
        [_delegate didCloseWithPrompt:self];
}

-(void)cancelAction:(id)sender
{
    dlog(@"enter");
    if([_delegate respondsToSelector:@selector(didCancelWithPrompt:)])
        [_delegate didCancelWithPrompt:self];
    if([_delegate respondsToSelector:@selector(didCloseWithPrompt:)])
        [_delegate didCloseWithPrompt:self];
}

@end