//
//  MDPopupAlertView.m
//  mandarinApp
//
//  Created by weiguang on 2019/5/6.
//  Copyright © 2019 PKL. All rights reserved.
//

#import "MDPopupAlertView.h"


@interface MDPopupAlertView()

@property (nonatomic, strong) UIView *maskView;  //背景
@property (nonatomic,strong) UIImageView *contentView;


@end

@implementation MDPopupAlertView

- (instancetype)initWithType:(PopupAlertViewType)type
{
    self = [super init];
    if (self) {
        _type = type;
        //创建UI视图
        [self createUI];
    }
    return self;
}


#pragma mark ------ 创建UI视图 ------
- (void)createUI {
    self.frame = [UIScreen mainScreen].bounds;
   
    //背景
    [self addSubview:self.maskView];
    
    // 创建contentView,根据不同的type类型创建不同的view
    [self setupAI];
    
}




- (void)setupAI {
    
    
}


- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = [UIColor colorWithRed:102/255 green:102/255 blue:102/255 alpha:0.6];
        _maskView.userInteractionEnabled = YES;
    }
    return _maskView;
}


- (void)drawRect:(CGRect)rect {
    [super layoutSubviews];
    
}


//滑动消失
- (void)dismiss {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)closeBtnClick {
    [self dismiss];
}


- (void)testBtnClick {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        if (self.actionBlock) {
            self.actionBlock();
        }
        
    }];
    
}


- (void)show
{
    self.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}



@end
