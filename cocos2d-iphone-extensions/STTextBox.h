//
//  STTextBox.h
//
//
//  Created by Steve Tranby on 2/24/13.
//  Copyright (c) 2013 Steve Tranby. All rights reserved.
//

#import "CCLayer.h"

@class CCLayerColor, CCLabelTTF;

@interface STTextBoxIOS : CCLayer <UITextFieldDelegate>
{
    UITextField *_textField;
    CCLayerColor *_textCursor;
}

@property (nonatomic,assign) int maxLen;

@property (nonatomic,retain) CCLabelTTF *textLabel;
@property (nonatomic,copy) NSString *textValue;
@property (nonatomic,copy) NSString *textPlaceholder;

+(STTextBoxIOS*)textboxWithLabel:(CCLabelTTF*)label Placeholder:(NSString*)placeholder;
+(STTextBoxIOS*)textboxWithLabel:(CCLabelTTF*)label;

-(void)focusTextField;

@end

#pragma mark

@class STTextPrompt;

@protocol STTextPromptDelegate <NSObject>
@optional
-(void)didConfirmWithPrompt:(STTextPrompt*)prompt;
-(void)didCancelWithPrompt:(STTextPrompt*)prompt;
-(void)didCloseWithPrompt:(STTextPrompt*)prompt;
@end

@interface STTextPrompt : CCNode
{
    CCLabelTTF *_messageLabel;
}

@property (nonatomic,retain) id<STTextPromptDelegate> delegate;
@property (nonatomic,retain) STTextBoxIOS *textBox;
@property (nonatomic,retain) CCLabelTTF *textLabel;
@property (nonatomic,retain) NSString *message;

+(STTextPrompt*)promptWithMessage:(NSString*)msg
                 InputPlaceholder:(NSString*)placeholder
                     ConfirmTitle:(NSString*)confirmText
                      CancelTitle:(NSString*)cancelText;

@end


