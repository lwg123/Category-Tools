//
//  MDTools.m
//  CategoryDemo
//
//  Created by weiguang on 2019/6/10.
//  Copyright © 2019 duia. All rights reserved.
//

#import "MDTools.h"

@implementation MDTools

//设置状态栏颜色
+ (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}


//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentViewController
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        // 根视图为非导航类
        
        currentVC = rootVC;
    }
    
    return currentVC;
}



+ (NSString *)transform:(NSString *)chinese
{
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    return [pinyin lowercaseString];
}

+ (NSString *)angleHalfAngle:(NSString *)string {
    if (!string) {
        return nil;
    }
    NSMutableString *convertedString = [string mutableCopy];
    
    CFStringTransform((CFMutableStringRef)convertedString, NULL, kCFStringTransformFullwidthHalfwidth, false);
    return [convertedString copy];
}

/// 字典转JSON
+ (void )toJsonStr:(id )dic{
    //2、判断是否能转为Json数据
    BOOL isValidJSONObject =  [NSJSONSerialization isValidJSONObject:dic];
    if (isValidJSONObject) {
        NSData *data =  [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        
        //打印JSON数据
        NSLog(@"返回的json数据:\n%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    }
}


+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font constraintSize:(CGSize)constraintSize
{
    CGSize stringSize = CGSizeZero;
    
    NSDictionary *attributes = @{NSFontAttributeName:font};
    NSInteger options = NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
    CGRect stringRect = [string boundingRectWithSize:constraintSize options:options attributes:attributes context:NULL];
    stringSize = stringRect.size;
    
    return stringSize;
}


+ (NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    return html;
}

+(NSString *)TrimmingWhitespaceCacharcter:(NSString *)str{
    NSString* result = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return result;
}

//判断是否纯汉字
+(BOOL)isPureChinese:(NSString*)str{
    BOOL isPure = YES;
    NSString* regStr = @"[\u4e00-\u9fa5]";
    NSPredicate* pureChinese = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regStr];
    for (int i= 0; i<str.length; i++) {
        NSString* single = [str substringWithRange:NSMakeRange(i, 1)];
        isPure = [pureChinese evaluateWithObject:[MDTools TrimmingWhitespaceCacharcter:single]];
        if (isPure==NO) {
            return NO;
        }
    }
    return YES;
}


+(NSString *)getChinese:(NSString *)str{
    NSString* chineseStr = nil;
    for (int i = 0; i<str.length; i++) {
        NSString* charStr = [str substringWithRange:NSMakeRange(i, 1)];
        if ([self isPureChinese:charStr]) {
            chineseStr = [str substringWithRange:NSMakeRange(i, str.length-i)];
            break;
        }
    }
    return chineseStr;
}

//判断是否含有表情
+ (BOOL)isContainsEmoji:(NSString *)string {
    __block BOOL isEomji = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    isEomji = YES;
                }
            }
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                isEomji = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                isEomji = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                isEomji = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                isEomji = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                isEomji = YES;
            }
            if (!isEomji && substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                if (ls == 0x20e3) {
                    isEomji = YES;
                }
            }
        }
    }];
    return isEomji;
}


@end
