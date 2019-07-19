//
//  NSString+MDDate.h
//  mandarinApp
//
//  Created by okerivy on 2017/11/25.
//  Copyright © 2017年 PKL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MDDate)

///  全角转半角
- (NSString *)covertFullToHalfWhitespace;

///  半角转全角
- (NSString *)covertHalfToFullWhiteSpace;

///  去掉空格
- (NSString *)deleteWhiteSpace;

/// 对字符串进行分割
- (NSArray *)splitStringByString:(NSString *)separator;

@end
