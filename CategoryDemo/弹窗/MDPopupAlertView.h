//
//  MDPopupAlertView.h
//  mandarinApp
//
//  Created by weiguang on 2019/5/6.
//  Copyright © 2019 PKL. All rights reserved.
//

// 弹窗
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, PopupAlertViewType) {
    PopupAlertView_VIP = 0,     // VIP服务
    PopupAlertView_Coupon,      // 用户补贴
    PopupAlertView_AI,          // AI智能测试
    PopupAlertView_Mock,        // 模考大赛进行中
    PopupAlertView_Register,    // 注册
    PopupAlertView_BuyVIPSuccess, //购买VIP服务成功的弹窗
    PopupAlertView_LoadingView    // 购买VIP充值过程中的遮罩层
};

typedef void(^AlertViewBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface MDPopupAlertView : UIView

@property (nonatomic,assign) PopupAlertViewType type;

// 点击事件需要实现此block
@property (nonatomic,copy) AlertViewBlock actionBlock;

- (instancetype)initWithType:(PopupAlertViewType)type;


- (void)show;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
