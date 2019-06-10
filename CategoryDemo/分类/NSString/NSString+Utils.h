//
//  NSString+Utils.h
//  DuiFuDao
//
//  Created by weiguang on 2018/8/7.
//  Copyright © 2018年 DuiA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Utils)

// 判断是否为手机号
- (BOOL)isPhoneNumber;

//是否是中文字符
- (BOOL)isChinese;

// 判断字符串是否为空包含空格
+ (BOOL)isBlank:(NSString *)judgmentString;


//计算字符串size
- (CGSize)boundingRectWithSize:(CGSize)_size font:(UIFont *)_font;


/// 通过numFloat得到对应的字符串
+ (NSString *)formatFloat:(float)numFloat;


// 获取字符长度,汉字两个，英文是一个
- (int)getByteNum;

//截取字符长度，index是字符位置,中文是2个，英文是1个
- (NSString *)subStringByByteWithIndex:(NSInteger)index;

//截取字符长度，index是字符位置,中文是2个，英文是1个
- (NSString *)subStringByByteWithFromIndex:(NSInteger)index;

/// 将url和parameters拼接成完整的get请求的url
+ (NSString *)URLStringPrefixUrl:(NSString *)prefixUrl urlstr:(NSString *)urlstr parameters:(NSDictionary *)parameters;


/**
 * 身份证
 */
+ (BOOL)isIDCardNumber:(NSString *)cardNumber;

/**
 *  银行卡号正则表达式
 *
 *  @param cardNumber 银行卡号
 *
 *  @return
 */
+ (BOOL)isBankCard:(NSString *)cardNumber;

@end
