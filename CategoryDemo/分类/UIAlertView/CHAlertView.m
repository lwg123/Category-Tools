//
//  CHAlertView.m
//  TouchCPlatform
//
//  Created by dengjc on 16/5/16.
//  Copyright © 2016年 changhong. All rights reserved.
//

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


#import "CHAlertView.h"
#include <stdarg.h>
#import "CHProgressView.h"
#import "UIColor+Hex.h"

#define kButtonHeight       45
//#define kDistanceBT         25      //distance between bound and title
#define kDistanceTM         18      //distance between title and message
//#define kDistanceMB         25      //distance between message and button
#define kTextViewMinHeight  88
#define kMinSecureHeight    157     //密码输入框最小高度
#define kMinHeight          128
#define kMinPlainHeight     200     //文本框最小高度
#define kWidth              270

#define PlainTextViewTag    1000
#define SecureTextFieldTag  1001
#define LoginTextFieldTag   1002
#define PassTextFieldTag    1003

@interface CHAlertView()<UITextViewDelegate>
{
    UIView *maskView;
    UILabel *titleLabel;
    UILabel *messageLabel;
    NSMutableArray *btnTitleArr;
    NSMutableArray *textFieldArr;
    CHTextView *_textView;
    int startPos;
    
    CGRect originRect;
    
}

@property (nonatomic,strong) UILabel * proTitleLabel;
@property (nonatomic,strong) UILabel * proMsgLabel;
@property (nonatomic,strong) CHProgressView * progressView;
@property (nonatomic,strong) UILabel * totalDataLabel;
@property (nonatomic,strong) UILabel * doneLoadLabel;
//@property (nonatomic,strong) UIButton * backgroundDownloadBtn;
//@property (nonatomic,strong) UIButton * cancelDownloadBTn;
@property (nonatomic,strong) UIView * alContentView;

@end

@implementation CHAlertView



- (nullable instancetype)init {
    if (self = [super init]) {
        [self setupEnv];
    }
    return self;
}

- (nullable instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message delegate:(nullable id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(nullable NSString *)cancelButtonTitle {
    if (self == [super initWithFrame:CGRectMake(0, 0, kWidth, kMinHeight)]) {
        _delegate = delegate;
        [self setupEnv];
        _title = title;
        _message = message;
        
        if (cancelButtonTitle) {
            [btnTitleArr addObject:cancelButtonTitle];
        }
    }
    return self;

}


- (nullable instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message delegate:(nullable id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitles:(nullable NSString *)otherButtonTitles, ... {
    if (self == [super initWithFrame:CGRectMake(0, 0, kWidth, kMinHeight)]) {
        _delegate = delegate;
        [self setupEnv];
        _title = title;
        _message = message;
        
        va_list args;
        va_start(args, otherButtonTitles);
        if (otherButtonTitles) {
            [btnTitleArr addObject:otherButtonTitles];
            NSString *other;
            while (1) {
                other = va_arg(args, NSString*);
                if (other == nil) {
                    break;
                } else {
                    [btnTitleArr addObject:other];
                }
            }
        }
        va_end(args);
        if (cancelButtonTitle) {
            [btnTitleArr addObject:cancelButtonTitle];
        }
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title message:(nullable NSString *)message deleagte:(nullable id)delegate totalData:(nullable NSString *)totalData downLoadData:(nullable NSString *)downLoadData {
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self) {
        btnTitleArr = [NSMutableArray array];
        _alertViewStyle = UIAlertViewStyleProgress;
        _delegate = delegate;
        _title  = title;
        _message = message;
        _downLoadData = downLoadData;
        _totalData = totalData;
//        [self addObserver];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message deleagte:(id)delegate bgDownLoadButtonTitle:(NSString *)bgTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self) {
        btnTitleArr = [NSMutableArray array];
        _alertViewStyle = UIAlertViewStyleProgress;
        _delegate = delegate;
        _title  = title;
        _message = message;
        _dProgress = 0;
        
        va_list args;
        va_start(args, otherButtonTitles);
        if (otherButtonTitles) {
            [btnTitleArr addObject:otherButtonTitles];
            NSString *other;
            while (1) {
                other = va_arg(args, NSString*);
                if (other == nil) {
                    break;
                } else {
                    [btnTitleArr addObject:other];
                }
            }
        }
        va_end(args);
        if (bgTitle) {
            [btnTitleArr addObject:bgTitle];
        }

//        [self addObserver];
    }
    return self;
}


- (void)setAlertViewStyle:(UIAlertViewStyle)alertViewStyle {
    _alertViewStyle = alertViewStyle;
    [self setupTextField];
}

- (NSInteger) numberOfButtons {
    return btnTitleArr.count;
}

- (void)setTitle:(NSString *)title {
    _title = title;
}

- (void)setMessage:(NSString *)message {
    _message = message;
}

- (void)setDownLoadData:(NSString *)downLoadData{
    _downLoadData = downLoadData;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.doneLoadLabel.text = _downLoadData;;
    });
    
}

- (void)setTotalData:(NSString *)totalData {
    _totalData = totalData;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.totalDataLabel.text = _totalData;;
    });
}

- (void)setDProgress:(CGFloat)dProgress {
    if (dProgress > 1.0) {
        _dProgress = 1.0;
        return;
    }
    if (dProgress < 0) {
        dProgress = 0;
    }
    if (dProgress == 1.0) {
        _dProgress = 1.0;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismiss];
        });
        return; 
    }
    _dProgress = dProgress;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressView.pProgress = _dProgress;
    });
}

- (void)show {
    switch (_alertViewStyle) {
        case 0://UIAlertViewStyleDefault
        {
            self.frame = CGRectMake(0, 0, kWidth, kMinHeight);
            startPos = 25;
            [self setupTitleLabel:_title distance:25];
            [self setupMessageLabel:_message distance:25];
            [self setupBtn:kMinHeight];
            
            if (startPos + kButtonHeight>kMinHeight) {
                CGRect rect = self.frame;
                rect.size.height = startPos + kButtonHeight;
                self.frame = rect;
            }
            
            if (!_title||_title.length == 0) {
                messageLabel.center = CGPointMake(kWidth/2, (self.frame.size.height - kButtonHeight)/2);
            }
            
            if (!_message||_message.length == 0) {
                titleLabel.center = CGPointMake(kWidth/2, (self.frame.size.height - kButtonHeight)/2);
            }
        }
            break;
        case 1: //UIAlertViewStyleSecureTextInput
        {
            self.frame = CGRectMake(0, 0, kWidth, kMinSecureHeight);
            startPos = 17;
            [self setupTitleLabel:_title distance:17];
            [self setupMessageLabel:_message distance:17];
            [self setupSecureTextField:YES];
            [self setupBtn:kMinSecureHeight];
            if (startPos + kButtonHeight>kMinSecureHeight) {
                CGRect rect = self.frame;
                rect.size.height = startPos + kButtonHeight;
                self.frame = rect;
            }
        }
            break;
        case 2://UIAlertViewStylePlainTextInput
        {
            self.frame = CGRectMake(0, 0, kWidth, kMinSecureHeight);
            startPos = 17;
            [self setupTitleLabel:_title distance:17];
            [self setupMessageLabel:_message distance:17];
            [self setupSecureTextField:NO];
            [self setupBtn:kMinSecureHeight];
            
            if (startPos + kButtonHeight>kMinSecureHeight) {
                CGRect rect = self.frame;
                rect.size.height = startPos + kButtonHeight;
                self.frame = rect;
            }
        }
            break;
        case 3://UIAlertViewStyleLoginAndPasswordInput
        {
            self.frame = CGRectMake(0, 0, kWidth, kMinSecureHeight);
            startPos = 17;
            [self setupTitleLabel:_title distance:17];
            [self setupMessageLabel:_message distance:17];
            [self setupLoginTextField];
            [self setupPasswordTextField];
            [self setupBtn:kMinSecureHeight];
            
            if (startPos + kButtonHeight>kMinSecureHeight) {
                CGRect rect = self.frame;
                rect.size.height = startPos + kButtonHeight;
                self.frame = rect;
            }
        }
            break;
        case 4://UIAlertViewStyleTextViewInput
        {
            self.frame = CGRectMake(0, 0, kWidth, kMinPlainHeight);
            startPos = 17;
            [self setupTitleLabel:_title distance:17];
            [self setupMessageLabel:_message distance:17];
            [self setupPlainTextView];
            [self setupBtn:kMinPlainHeight];
            
            if (startPos + kButtonHeight>kMinPlainHeight) {
                CGRect rect = self.frame;
                rect.size.height = startPos + kButtonHeight;
                self.frame = rect;
            }

        }
            break;
        case 5:
        {
            for (UIView * view in _alContentView.subviews) {
                [view removeFromSuperview];
            }
            
            [self setupProgressUI];
//            for (UIView * view in _alContentView.subviews) {
//                if (view.tag == 100) {
//                    [view removeFromSuperview];
//                }
//            }
            
        }
            break;
            
        default:
            break;
    }
    
    UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
    maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    maskView.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard:)];
    [maskView addGestureRecognizer:tapGes];
    [keyWindow addSubview:maskView];
    self.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    
    self.alpha = 0;
    maskView.alpha = 0;
    self.transform = CGAffineTransformMakeScale(1.1, 1.1);
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
        maskView.alpha = 0.5;
        self.transform = CGAffineTransformIdentity;
    }completion:nil];
    

    
//    CATransition *applicationLoadViewIn =[CATransition animation];
//    [applicationLoadViewIn setDuration:0.2];
//    [applicationLoadViewIn setType:kCATransitionFade];
//    [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
//    //you view need to replace
//    [[keyWindow layer]addAnimation:applicationLoadViewIn forKey:kCATransitionFade];
    [keyWindow addSubview:self];
    originRect = self.frame;
}

- (void)dismiss {
//    if (_alertViewStyle == (UIAlertViewStyle)5) {
//        [self removeObserver:self forKeyPath:@"self.progressView.pProgress"];
//    }
    [maskView removeFromSuperview];
    [self removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)setupEnv {
    startPos = 25;
    _alertViewStyle = UIAlertViewStyleDefault;
    btnTitleArr = [[NSMutableArray alloc]init];
    textFieldArr = [[NSMutableArray alloc]init];
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 5;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)  name:UIKeyboardWillShowNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:)  name:UIKeyboardWillHideNotification object:nil];
}

- (void)setupTitleLabel:(NSString*)title distance:(NSInteger)distance{
    if (!title||title.length==0) {
        return;
    }
    titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:19];
    [titleLabel sizeToFit];
    titleLabel.center = CGPointMake(kWidth/2, distance + titleLabel.frame.size.height/2);
    
    [self addSubview:titleLabel];
    startPos = titleLabel.frame.origin.y + titleLabel.frame.size.height + distance;
}

- (void)setupMessageLabel:(NSString*)message distance:(NSInteger)distance{
    if (!message||message.length==0) {
        return;
    }
    messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, startPos, kWidth - 50, 0)];
    messageLabel.text = message;
    messageLabel.textColor = [UIColor blackColor];
//    if (!titleLabel.text||titleLabel.text.length==0) {
//
//    } else {
//        messageLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
//    }
    messageLabel.font = [UIFont systemFontOfSize:14];
    messageLabel.numberOfLines = 0;
    
    //    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:message];
    //    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //    [paragraphStyle setLineSpacing:5];
    //    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [message length])];
    //    messageLabel.attributedText = attributedString;
    
    [messageLabel sizeToFit];
    //    CGRect rect=[message boundingRectWithSize:messageLabel.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:messageLabel.font,NSFontAttributeName, nil] context:nil];
    
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.center = CGPointMake(kWidth/2, titleLabel.frame.origin.y + titleLabel.frame.size.height + messageLabel.frame.size.height/2 + kDistanceTM);
    
    [self addSubview:messageLabel];
    startPos = messageLabel.frame.origin.y + messageLabel.frame.size.height + distance;
}

- (void)setupBtn:(NSInteger)minHeight {
    if (btnTitleArr.count==0) {
        return;
    }
    if (btnTitleArr.count == 1) {
        NSString *btnTitle = [btnTitleArr objectAtIndex:0];
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.layer.cornerRadius = 5;
        cancelBtn.tag = 0;
        [cancelBtn setTitle:btnTitle forState:UIControlStateNormal];
        
        //        [cancelBtn setTitleColor:[UIColor colorWithRed:49/255.0 green:49/255.0 blue:49/255.0 alpha:1] forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithRed:0xff/255.0 green:0x61/255.0 blue:0x5d/255.0 alpha:1] forState:UIControlStateNormal];
        
        [cancelBtn addTarget:self action:@selector(btnClickNormal:) forControlEvents:UIControlEventTouchDown];
        [cancelBtn addTarget:self action:@selector(btnClickHighlighted:) forControlEvents:UIControlEventTouchUpInside];
        if (startPos + kButtonHeight <minHeight) {
            cancelBtn.frame = CGRectMake(0, minHeight - kButtonHeight, self.frame.size.width, kButtonHeight);
        } else {
            cancelBtn.frame = CGRectMake(0, startPos, kWidth, kButtonHeight);
        }
        
        //        [btnArr addObject:cancelBtn];
        UILabel *sepLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWidth, 0.5)];
        sepLine.backgroundColor = [UIColor lightGrayColor];
        
        [cancelBtn addSubview:sepLine];
        [self addSubview:cancelBtn];
        
        
    } else if (btnTitleArr.count == 2) {
        NSString *cancelBtnTitle = [btnTitleArr objectAtIndex:0];
        NSString *conformBtnTitle = [btnTitleArr objectAtIndex:1];
        
        //firstBtn
        UIButton *firstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        firstBtn.layer.cornerRadius = 5;
        firstBtn.tag = 1;
        [firstBtn setTitle:conformBtnTitle forState:UIControlStateNormal];
        
        //        [firstBtn setTitleColor:[UIColor colorWithRed:49/255.0 green:49/255.0 blue:49/255.0 alpha:1] forState:UIControlStateNormal];
        [firstBtn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
        
        [firstBtn addTarget:self action:@selector(btnClickNormal:) forControlEvents:UIControlEventTouchDown];
        [firstBtn addTarget:self action:@selector(btnClickHighlighted:) forControlEvents:UIControlEventTouchUpInside];
        
        //secondBtn
        UIButton *secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        secondBtn.layer.cornerRadius = 5;
        secondBtn.tag = 0;
        [secondBtn setTitle:cancelBtnTitle forState:UIControlStateNormal];
        
        [secondBtn setTitleColor:[UIColor colorWithHex:0x2396FA] forState:UIControlStateNormal];
        //        [secondBtn setTitleColor:[UIColor colorWithRed:0xff/255.0 green:0x61/255.0 blue:0x5d/255.0 alpha:1] forState:UIControlStateHighlighted];
        
        [secondBtn addTarget:self action:@selector(btnClickNormal:) forControlEvents:UIControlEventTouchDown];
        [secondBtn addTarget:self action:@selector(btnClickHighlighted:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if (startPos + kButtonHeight <minHeight) {
            firstBtn.frame = CGRectMake(0, minHeight - kButtonHeight, kWidth/2, kButtonHeight);
            
            secondBtn.frame = CGRectMake(kWidth/2,minHeight - kButtonHeight, kWidth/2, kButtonHeight);
        } else {
            firstBtn.frame = CGRectMake(0, startPos, kWidth/2, kButtonHeight);
            
            secondBtn.frame = CGRectMake(kWidth/2,firstBtn.frame.origin.y, kWidth/2, kButtonHeight);
        }
        
        [self addSubview:firstBtn];
        [self addSubview:secondBtn];
        
        UILabel *horLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWidth, 0.5)];
        horLine.backgroundColor = [UIColor lightGrayColor];
        UILabel *verLine = [[UILabel alloc]initWithFrame:CGRectMake(kWidth/2 - 0.5, 0, 0.5, kButtonHeight)];
        verLine.backgroundColor = [UIColor lightGrayColor];
        [firstBtn addSubview:horLine];
        [firstBtn addSubview:verLine];
    } else {
        for (int i=0; i<btnTitleArr.count; i++) {
            NSString *btnTitle = [btnTitleArr objectAtIndex:i];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.layer.cornerRadius = 5;
            btn.tag = (i+1)%btnTitleArr.count;
            [btn setTitle:btnTitle forState:UIControlStateNormal];
            
            //            [btn setTitleColor:[UIColor colorWithRed:67/255.0 green:67/255.0 blue:67/255.0 alpha:1] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithRed:0xff/255.0 green:0x61/255.0 blue:0x5d/255.0 alpha:1] forState:UIControlStateNormal];
            if (i==btnTitleArr.count-1) {
                [btn setTitleColor:[UIColor colorWithRed:49/255.0 green:49/255.0 blue:49/255.0 alpha:1] forState:UIControlStateNormal];
            }
            
            [btn addTarget:self action:@selector(btnClickNormal:) forControlEvents:UIControlEventTouchDown];
            [btn addTarget:self action:@selector(btnClickHighlighted:) forControlEvents:UIControlEventTouchUpInside];
            
            btn.frame = CGRectMake(0,startPos + kButtonHeight*i, kWidth, kButtonHeight);
            UILabel *sepLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWidth, 0.5)];
            sepLine.backgroundColor = [UIColor lightGrayColor];
            [btn addSubview:sepLine];
            [self addSubview:btn];
        }
        startPos += kButtonHeight*(btnTitleArr.count - 1);
    }
}

- (void)setupTextField {
    if (!_alertViewStyle) {
        return;
    }
    switch (_alertViewStyle) {
        case 0://UIAlertViewStyleDefault
            break;
        case 1://UIAlertViewStyleSecureTextInput
            [self setupSecureTextField:YES];
            break;
        case 2://UIAlertViewStylePlainTextInput
            [self setupSecureTextField:NO];
            break;
        case 3://UIAlertViewStyleLoginAndPasswordInput
        {
            [self setupLoginTextField];
            [self setupPasswordTextField];
        }
            break;
        case 4://UIAlertViewStyleTextViewInput
        {
            [self setupPlainTextView];
        }
            break;
        case 5:
        {
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - inner method
- (void)setupPlainTextView {
    _textView = [self viewWithTag:PlainTextViewTag];
    if (!_textView) {
        _textView = [[CHTextView alloc]initWithFrame:CGRectMake(15, startPos, kWidth - 30, kTextViewMinHeight)];
        _textView.delegate = self;
        _textView.tag = PlainTextViewTag;
        _textView.delegate = self;
        _textView.layer.cornerRadius = 2;
        _textView.backgroundColor = [UIColor colorWithRed:0xee/255.0 green:0xee/255.0 blue:0xee/255.0 alpha:1];
        
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.textColor = [UIColor colorWithRed:0x66/255.0 green:0x66/255.0 blue:0x66/255.0 alpha:1];
        
        [self addSubview:_textView];
        return;
    }
    _textView.frame = CGRectMake(15, startPos, kWidth - 30, kTextViewMinHeight);
    startPos = _textView.frame.origin.y + _textView.frame.size.height + 15;
}

- (void)setupSecureTextField:(BOOL)secyreEntry {
    
    UITextField *textField = [self viewWithTag:SecureTextFieldTag];
    if (!textField) {
        textField = [[UITextField alloc]initWithFrame:CGRectMake(15, startPos, kWidth - 30, 45)];
        textField.delegate = self;
        textField.tag = SecureTextFieldTag;
        textField.layer.cornerRadius = 2;
        textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 12, 45)];
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.backgroundColor = [UIColor colorWithRed:0xee/255.0 green:0xee/255.0 blue:0xee/255.0 alpha:1];
        textField.textColor = [UIColor colorWithRed:0x66/255.0 green:0x66/255.0 blue:0x66/255.0 alpha:1];
        textField.secureTextEntry = secyreEntry;
        
        [self addSubview:textField];
        [textFieldArr addObject:textField];
        return;
    }
    textField.frame = CGRectMake(15, startPos, kWidth - 30, 45);
    startPos = textField.frame.origin.y + textField.frame.size.height + 15;
}

- (void)setupLoginTextField {
    UITextField *loginField = [self viewWithTag:LoginTextFieldTag];
    if (!loginField) {
        loginField = [[UITextField alloc]initWithFrame:CGRectMake(15, startPos, kWidth - 30, 45)];
        loginField.delegate = self;
        loginField.tag = LoginTextFieldTag;
        loginField.layer.cornerRadius = 2;
        loginField.backgroundColor = [UIColor colorWithRed:0xee/255.0 green:0xee/255.0 blue:0xee/255.0 alpha:1];
        loginField.textColor = [UIColor colorWithRed:0x66/255.0 green:0x66/255.0 blue:0x66/255.0 alpha:1];
        loginField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 12, 45)];
        loginField.leftViewMode = UITextFieldViewModeAlways;
        [self addSubview:loginField];
        [textFieldArr addObject:loginField];
        return;
    }
    loginField.frame = CGRectMake(15, startPos, kWidth - 30, 45);
    startPos = loginField.frame.origin.y + loginField.frame.size.height + 10;
}

- (void)setupPasswordTextField {
    
    UITextField *passwordField = [self viewWithTag:PassTextFieldTag];
    if (!passwordField) {
        passwordField = [[UITextField alloc]initWithFrame:CGRectMake(15, startPos, kWidth - 30, 45)];
        passwordField.delegate = self;
        passwordField.tag = PassTextFieldTag;
        passwordField.layer.cornerRadius = 2;
        passwordField.backgroundColor = [UIColor colorWithRed:0xee/255.0 green:0xee/255.0 blue:0xee/255.0 alpha:1];
        passwordField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 12, 45)];
        passwordField.leftViewMode = UITextFieldViewModeAlways;
        passwordField.textColor = [UIColor colorWithRed:0x66/255.0 green:0x66/255.0 blue:0x66/255.0 alpha:1];
        passwordField.secureTextEntry = YES;
        [self addSubview:passwordField];
        [textFieldArr addObject:passwordField];
        return;
    }
    passwordField.frame = CGRectMake(15, startPos, kWidth - 30, 45);
    startPos = passwordField.frame.origin.y + passwordField.frame.size.height + 15;
}

- (void)setupProgressUI {
    CALayer * coverLayer = [CALayer layer];
    coverLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    coverLayer.opacity = 0.5;
    coverLayer.backgroundColor = [UIColor blackColor].CGColor;
//    [self.layer addSublayer:coverLayer];
    
    _alContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 127)];
    _alContentView.layer.cornerRadius = 5;
    _alContentView.layer.masksToBounds = YES;
    _alContentView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    _alContentView.backgroundColor = [UIColor whiteColor];
    
    
    [_alContentView addSubview:self.proTitleLabel];
    [_alContentView addSubview:self.proMsgLabel];
    [_alContentView addSubview:self.progressView];
    [_alContentView addSubview:self.totalDataLabel];
    [_alContentView addSubview:self.doneLoadLabel];
    
//    [_alContentView addSubview:self.backgroundDownloadBtn];
//    [_alContentView addSubview:self.cancelDownloadBTn];
    [self addProgressButton];
    
    [self addSubview:_alContentView];
    
}

- (void)addProgressButton {
    if (btnTitleArr.count == 0) {
        return;
    }
    if (btnTitleArr.count == 1) {
        CGRect frame = CGRectMake(0, 127, 260, 45);
        UIButton * button = [self buttonWithFrame:frame text:btnTitleArr[0] tag:0];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self addLayerFrame:CGRectMake(0, 126, 260, 1)];
        [_alContentView addSubview:button];
        _alContentView.bounds = CGRectMake(0, 0, 260, 172);
    }
    else if (btnTitleArr.count == 2) {
        CGRect frameOne = CGRectMake(0, 127,130, 45);
        UIButton * buttonOne = [self buttonWithFrame:frameOne text:btnTitleArr[1] tag:0];
        [buttonOne setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_alContentView addSubview:buttonOne];
        
        CGRect frameTwo = CGRectMake(130, 127, 130, 45);
        UIButton * buttonTwo = [self buttonWithFrame:frameTwo text:btnTitleArr[0] tag:1];
        [_alContentView addSubview:buttonTwo];
        [self addLayerFrame:CGRectMake(0, 126, 260, 1)];
        [self addLayerFrame:CGRectMake(130, 127, 1, 45)];
        _alContentView.bounds = CGRectMake(0, 0, 260, 172);
    }
    else {
        __block CGFloat height = 127;
        [btnTitleArr enumerateObjectsUsingBlock:^(NSString * title, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addLayerFrame:CGRectMake(0, height-1, 260, 1)];
            CGRect frame = CGRectMake(0, height, 260, 45);
            UIButton * button = [self buttonWithFrame:frame text:title tag:idx+1];
            [_alContentView addSubview:button];
            if (idx == btnTitleArr.count-1) {
                [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                button.tag = 0;
            }
            height += 46;
        }];
        _alContentView.bounds = CGRectMake(0, 0, 260, height-1);
    }
    
}

- (void)addLayerFrame:(CGRect)frame {
    CALayer * layer = [CALayer layer];
    layer.frame = frame;
    layer.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"].CGColor;
    [_alContentView.layer addSublayer:layer];
}

- (nullable UITextField *)textFieldAtIndex:(NSInteger)textFieldIndex {
    return [textFieldArr objectAtIndex:textFieldIndex];
}
- (nullable UITextView *)textViewAtIndex:(NSInteger)textFieldIndex {
    return  _textView;
}

- (NSInteger)addButtonWithTitle:(nullable NSString *)title {
    if (btnTitleArr.count == 0) {
        [btnTitleArr addObject:title];
        return 0;
    } else {
        [btnTitleArr insertObject:title atIndex:btnTitleArr.count-1];
        return btnTitleArr.count-2;
    }
}

- (nullable NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex {
    return [btnTitleArr objectAtIndex:buttonIndex];
}

#pragma mark - response method
- (void)hideKeyboard:(UIGestureRecognizer*)sender {
    for (UITextField* textField in textFieldArr) {
        [textField resignFirstResponder];
    }
    if (_textView) {
        [_textView resignFirstResponder];
    }
}

- (void)btnClickNormal:(UIButton*)sender {
    //    [sender setBackgroundColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1]];
}

- (void)btnClickHighlighted:(UIButton*)sender {
    //    [sender setBackgroundColor:[UIColor colorWithRed:0xff/255.0 green:0xff/255.0 blue:0xff/255.0 alpha:1]];
    
    if ([_delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        //        [_delegate performSelector:@selector(alertView: clickedButtonAtIndex:) withObject:sender withObject:@(sender.tag)];
        [_delegate alertView:self clickedButtonAtIndex:sender.tag];
    }
    if ([_delegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)]) {
        //        [_delegate performSelector:@selector(alertView: clickedButtonAtIndex:) withObject:sender withObject:@(sender.tag)];
        [_delegate alertView:self clickedButtonAtIndex:sender.tag];
    }
    [self dismiss];
}

- (void)changeButtonBg:(UIButton *)sender {
    CGRect frame = sender.frame;
//    CALayer * coverLayer = [CALayer layer];
//    coverLayer.frame = CGRectMake(xValue, 127, 130, 45);
//    coverLayer.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1].CGColor;
//    
    UIView * coverView = [[UIView alloc] initWithFrame:frame];
    coverView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
    coverView.tag = 100;
    
    [_alContentView insertSubview:coverView belowSubview:sender];
//    [_alContentView.layer insertSublayer:coverLayer below:sender.layer];
    
}



#pragma mark - UITextView delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    textView.text = @"";
    textView.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    //    CGRect line = [textView caretRectForPosition:
    //                   textView.selectedTextRange.start];
    //    CGFloat overflow = line.origin.y + line.size.height
    //    - ( textView.contentOffset.y + textView.bounds.size.height
    //       - textView.contentInset.bottom - textView.contentInset.top );
    //    if ( overflow > 0 ) {
    //        // We are at the bottom of the visible text and introduced a line feed, scroll down (iOS 7 does not do it)
    //        // Scroll caret to visible area
    //        CGPoint offset = textView.contentOffset;
    //        offset.y += overflow + 7; // leave 7 pixels margin
    //        // Cannot animate with setContentOffset:animated: or caret will not appear
    //        [UIView animateWithDuration:.2 animations:^{
    //            [textView setContentOffset:offset];
    //        }];
    //    }
    
    /////////////////////////////////////////////////////////////////////////
    //
    CGRect frame = textView.frame;
    
    CGSize originSize = textView.frame.size;
    CGSize size = [textView sizeThatFits:CGSizeMake(kWidth - 30, MAXFLOAT)];
    size.height = MAX(size.height, kTextViewMinHeight);
    size.width = kWidth - 30;
    
    CGFloat delta = size.height - originSize.height;
    //调整self frame
    CGRect selfFrame = self.frame;
    selfFrame.size.height += delta;
    if (selfFrame.size.height>SCREEN_HEIGHT/2) {
        selfFrame.size.height = SCREEN_HEIGHT/2;
        delta = 0;
    }
    self.frame = selfFrame;
    size.height = originSize.height + delta;
    frame.size = size;
    textView.frame = frame;
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            CGRect rect = view.frame;
            rect.origin.y += delta;
            view.frame = rect;
        }
    }
}

#pragma mark - UITextField delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.layer.borderWidth = 0.5;
    textField.layer.borderColor = [UIColor colorWithRed:0xd5/255.0 green:0xd5/255.0 blue:0xd5/255.0 alpha:1].CGColor;
    textField.backgroundColor = [UIColor whiteColor];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    textField.layer.borderWidth = 0;
    textField.backgroundColor = [UIColor colorWithRed:0xee/255.0 green:0xee/255.0 blue:0xee/255.0 alpha:1];
}


#pragma mark - ProgressAlertViewUI

- (UILabel*)proTitleLabel {
    if (!_proTitleLabel) {
        CGRect frame = CGRectMake(15, 17, 230, 18);
        _proTitleLabel = [self labelWithFrame:frame Text:self.title font:18];
        _proTitleLabel.textColor = [UIColor colorWithHexString:@"313131"];
    }
    return _proTitleLabel;
}

- (UILabel *)proMsgLabel {
    if (!_proMsgLabel) {
        CGRect frame = CGRectMake(15, 48, 230, 12);
        _proMsgLabel = [self labelWithFrame:frame Text:self.message font:12];
        _proMsgLabel.textColor = [UIColor colorWithHexString:@"cccccc"];
    }
    return _proMsgLabel;
}

- (UILabel *)totalDataLabel {
    if (!_totalDataLabel) {
        CGRect frame = CGRectMake(15, 93, 115, 12);
        _totalDataLabel = [self labelWithFrame:frame Text:_totalData font:12];
        _totalDataLabel.textColor = [UIColor colorWithHexString:@"666666"];
    }
    return _totalDataLabel;
}

- (UILabel *)doneLoadLabel {
    if (!_doneLoadLabel) {
        CGRect frame = CGRectMake(130, 93, 115, 12);
        _doneLoadLabel = [self labelWithFrame:frame Text:_downLoadData font:12];
        _doneLoadLabel.textColor = [UIColor colorWithHexString:@"666666"];
    }
    return _doneLoadLabel;
}

//- (UIButton *)backgroundDownloadBtn {
//    if (!_backgroundDownloadBtn) {
//        CGRect frame = CGRectMake(0, 127, 130, 45);
//        UIColor * color = [UIColor redColor];
//        _backgroundDownloadBtn = [self buttonWithFrame:frame text:@"后台下载" titleColor:color];
//        _backgroundDownloadBtn.tag = 0;
//    }
//    return _backgroundDownloadBtn;
//}
//
//- (UIButton *)cancelDownloadBTn {
//    if (!_cancelDownloadBTn) {
//        CGRect frame = CGRectMake(130, 127, 130, 45);
//        UIColor * color = [UIColor colorWithHexString:@"313131"];
//        _cancelDownloadBTn =[self buttonWithFrame:frame text:@"取消下载" titleColor:color];
//        _cancelDownloadBTn.tag = 1;
//    }
//    return _cancelDownloadBTn;
//}

- (CHProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[CHProgressView alloc] initWithFrame:CGRectMake(15, 72, 230, 10)];
        _progressView.progressTintColor = [UIColor colorWithHexString:@"ff4e4e"];
        _progressView.trackTintColor = [UIColor colorWithHexString:@"eeeeee"];
    }
    return _progressView;
}


- (UILabel *)labelWithFrame:(CGRect)frame Text:(NSString *)title font:(NSInteger)font {
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.text = title;
    label.font = [UIFont systemFontOfSize:font];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    return label;
}

- (UIButton *)buttonWithFrame:(CGRect)frame text:(NSString*)title tag:(NSInteger)tag{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame =frame;
    UIColor * color = [UIColor colorWithHexString:@"313131"];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    button.backgroundColor = [UIColor clearColor];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    button.tag = tag;
    [button addTarget:self action:@selector(changeButtonBg:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(btnClickHighlighted:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}



#pragma mark - ProgressAlertViewKVO

- (void)addObserver {
    [self addObserver:self forKeyPath:@"self.progressView.pProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"self.progressView.pProgress"]) {
        CGFloat progress = self.progressView.pProgress;
        if (progress == 1.0) {
            self.message = @"下载完成";
            [self dismiss];
        }
    }
}

#pragma mark - keyboard notification
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary* keyboardInfo = [notification userInfo];
    CGRect keyboardFrame = [[keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    double animationDuration = [[keyboardInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if (CGRectGetMaxY(self.frame) + keyboardFrame.size.height + 45> SCREEN_HEIGHT) {
        [UIView animateWithDuration:animationDuration animations:^{
            CGRect rect = self.frame;
            rect.origin.y = SCREEN_HEIGHT - keyboardFrame.size.height - self.frame.size.height  - 45;
            self.frame = rect;
        }];
    }
}

- (void)keyboardDidHide:(NSNotification *)notification {
    NSDictionary* keyboardInfo = [notification userInfo];
    double animationDuration = [[keyboardInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animationDuration animations:^{
        self.frame = originRect;
    }];
}


@end
