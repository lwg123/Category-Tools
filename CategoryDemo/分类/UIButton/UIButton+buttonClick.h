//
//  UIButton+buttonClick.h
//  DuiaTest
//
//  Created by weiguang on 2018/9/15.
//  Copyright © 2018年 weiguang. All rights reserved.
//

#import <UIKit/UIKit.h>

// 避免button重复点击
#define defaultInterval 0.5//默认时间间隔
@interface UIButton (buttonClick)

@property(nonatomic,assign)NSTimeInterval timeInterval;//用这个给重复点击加间隔
@property(nonatomic,assign)BOOL isIgnoreEvent;//YES不允许点击NO允许点击

@end
