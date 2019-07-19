//
//  NSString+MDDate.m
//  mandarinApp
//
//  Created by okerivy on 2017/11/25.
//  Copyright © 2017年 PKL. All rights reserved.
//

#import "NSString+MDDate.h"

@implementation NSString (MDDate)


///  全角转半角
- (NSString *)covertFullToHalfWhitespace
{
    NSMutableString *convertedString = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)convertedString, NULL, kCFStringTransformFullwidthHalfwidth, false);
    return [NSString stringWithString:convertedString];
}

///  半角转全角
- (NSString *)covertHalfToFullWhiteSpace
{
    NSMutableString *convertedString = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)convertedString, NULL, kCFStringTransformFullwidthHalfwidth, true);

    return [NSString stringWithString:convertedString];
}


///  去掉空格
- (NSString *)deleteWhiteSpace
{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

/// 对字符串进行分割
- (NSArray *)splitStringByString:(NSString *)separator
{
    NSMutableArray *sepArr = [NSMutableArray array];
    if (separator) {
        //拆分成数组
        NSArray *tempArr = [self componentsSeparatedByString:@"-"];
        
        // 对数据进行过滤操作
        for (NSString *subStr in tempArr) {
            // 过滤空的字符串
            if (![subStr isBlankString]) { continue;}
            
            // 对 @"·" 进行特殊处理。 因为数据库中不规范
            
            NSArray *arr = @[@"·", @"。", @"：", @"，", @"“", @"”", @"？", @"！"];
            
//            NSString *sepS = @"·";

            BOOL isAdd = NO;
            for (NSString *sepS in arr) {
                if (subStr.length > 1 && ([subStr hasPrefix:sepS] || [subStr hasSuffix:sepS])) {
                    
                    if ([subStr hasPrefix:sepS]) {
                        
                        if ([[subStr substringFromIndex:1] hasPrefix:sepS]) {
                            [sepArr addObject:subStr];
                          
                        } else {
                            [sepArr addObject:sepS];
                            [sepArr addObject:[subStr substringFromIndex:1]];
                        
                        }
                        isAdd = YES;
                        break;
                        
                        
                    } else if ([subStr hasSuffix:sepS]) {
                        
                        if ([[subStr substringToIndex:subStr.length-2] hasSuffix:sepS]) {
                            [sepArr addObject:subStr];

                        } else {
                            [sepArr addObject:[subStr substringToIndex:subStr.length-2]];
                            [sepArr addObject:sepS];

                        }
                        isAdd = YES;
                        break;
                    }
                    
                }
                
            }
            
            if (!isAdd) {
                
                [sepArr addObject:subStr];
            }
           
        }
        
    } else {
        
        for (NSInteger i = 0; i < self.length; i++) {
            NSString *subStr = [self substringWithRange:NSMakeRange(i, 1)];
            if (![self isBlankString]) { continue;}
            [sepArr addObject:subStr];
        }
    }
    
    
    return [sepArr copy];
}

/// 判断字符串是否为空字符的方法
- (NSString *) isBlankString {
    if (self == nil || self == NULL) {
        return nil;
    }
    if ([self isKindOfClass:[NSNull class]]) {
        return nil;
    }
    NSString *str = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([str length]!=0) {
        return str;
    }
    return nil;
}



@end
