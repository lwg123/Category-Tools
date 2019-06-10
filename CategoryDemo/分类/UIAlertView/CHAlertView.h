//
//  CHAlertView.h
//  TouchCPlatform
//
//  Created by dengjc on 16/5/16.
//  Copyright © 2016年 changhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHTextView.h"

#define UIAlertViewStyleTextViewInput  (UIAlertViewStyle)4;
#define UIAlertViewStyleProgress  (UIAlertViewStyle)5;

@interface CHAlertView : UIView<UIAlertViewDelegate,UITextViewDelegate,UITextFieldDelegate>

@property(nonatomic,assign) UIAlertViewStyle alertViewStyle;
@property(nonatomic,weak,nullable) id<UIAlertViewDelegate> delegate;

@property(nonatomic,assign) BOOL textViewEntry;


@property(nonatomic,readonly) NSInteger numberOfButtons;
//@property(nonatomic) NSInteger cancelButtonIndex;      // if the delegate does not implement -alertViewCancel:, we pretend this button was clicked on. default is -1

@property(nonatomic,readonly) NSInteger firstOtherButtonIndex;	// -1 if no otherButtonTitles or initWithTitle:... not used
@property(nonatomic,readonly,getter=isVisible) BOOL visible;

@property(nonatomic,copy)  NSString * __nullable title;
@property(nullable,nonatomic,copy) NSString *message;// secondary explanation text
@property(nonatomic,copy) NSString * __nullable downLoadData; //data has download
@property(nonatomic,copy) NSString * __nullable totalData;
@property(nonatomic,assign) CGFloat dProgress; //download progress

- (nullable instancetype)init;

- (nullable instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message delegate:(nullable id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(nullable NSString *)cancelButtonTitle;

- (nullable instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message delegate:(nullable id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitles:(nullable NSString *)otherButtonTitles, ...;

- (nullable instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message deleagte:(nullable id /*<UIAlertViewDelegate>*/)delegate totalData:(nullable NSString *)totalData downLoadData:(nullable NSString *)downLoadData;

- (nullable instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message deleagte:(nullable id /*<UIAlertViewDelegate>*/)delegate bgDownLoadButtonTitle:(nullable NSString *)title otherButtonTitles:(nullable NSString *)otherButtonTitles,...;

- (void)show;

- (void)setAlertViewStyle:(UIAlertViewStyle)alertViewStyle;

- (nullable UITextField *)textFieldAtIndex:(NSInteger)textFieldIndex;
- (nullable CHTextView *)textViewAtIndex:(NSInteger)textFieldIndex;


// adds a button with the title. returns the index (0 based) of where it was added. buttons are displayed in the order added except for the
// cancel button which will be positioned based on HI requirements. buttons cannot be customized.
- (NSInteger)addButtonWithTitle:(nullable NSString *)title;    // returns index of button. 0 based.
- (nullable NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;

@end
