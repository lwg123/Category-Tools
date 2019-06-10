//
//  MDTools.h
//  CategoryDemo
//
//  Created by weiguang on 2019/6/10.
//  Copyright © 2019 duia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDTools : NSObject

/*
 * 设置状态栏颜色
 */
+ (void)setStatusBarBackgroundColor:(UIColor *)color;

/*
 * 获取当前显示的controller
 */
+ (UIViewController *)getCurrentViewController;

/**
 汉字转拼音
 
 @param chinese 汉字
 @return 拼音
 */
+ (NSString *)transform:(NSString *)chinese;

/**
 全角转半角
 
 @param string 全角字符串
 @return 半角字符串
 */
+ (NSString *)angleHalfAngle:(NSString *)string;


/*
 字典转JSON
 */
+(void )toJsonStr:(id )dic;


/*
 * 获取字符串的长度
 */
+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font constraintSize:(CGSize)constraintSize;

// 过滤html的特殊字符
+ (NSString *)filterHTML:(NSString *)html;


//字符串去除首位空格
+ (NSString*)TrimmingWhitespaceCacharcter:(NSString*)str;

//判断是否纯汉字
+ (BOOL)isPureChinese:(NSString*)str;
+ (NSString*)getChinese:(NSString*)str;

//判断是否含有表情
+ (BOOL)isContainsEmoji:(NSString *)string;


@end

NS_ASSUME_NONNULL_END
