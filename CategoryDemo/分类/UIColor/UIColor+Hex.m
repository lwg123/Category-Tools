//
//  UIColor+Hex.m
//  TouchCPlatform
//
//  Created by Du on 15-6-3.
//  Copyright (c) 2015年 changhong. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (UIColor*) colorWithHex:(long)hexColor;
{
    return [UIColor colorWithHex:hexColor alpha:1.];
}

+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity
{
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:opacity];
}

#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

// 由colorComponents生成UIColor
// 若格式错误则返回nil
+ (instancetype)colorWithComponent:(NSString *)colorComponents {
    UIColor *color = nil;
    NSScanner *scanner = [NSScanner scannerWithString:colorComponents];
    scanner.charactersToBeSkipped = [NSCharacterSet whitespaceCharacterSet];
    NSString *colorType = nil;
    
    if ([self isScanSuccess:scanner colorType:&colorType]) {
        NSUInteger length = colorType.length;
        if (length <= 4) {
            NSInteger components[4] = {-1, -1, -1, 255};
            for (NSUInteger index = 0; index < length; ++index) {
                if (index > 0) {
                    [scanner scanString:@"," intoString:nil];
                }
                [scanner scanInteger:&components[index]];
            }
            if ([self isValidWithColorType:colorType components:components]) {
                color = [UIColor colorWithRed:(components[0] / 255.f)
                                        green:(components[1] / 255.f)
                                         blue:(components[2] / 255.f)
                                        alpha:(components[3] / 255.f)];
            }
        }
    }

    if (color == nil) {
        NSLog(@"Unknown color: %@", colorComponents);
    }

    return color;
}

+ (BOOL)isScanSuccess:(NSScanner *)scanner colorType:(NSString **)colorType {
    return [scanner scanUpToString:@"(" intoString:colorType] && (*colorType)
            && scanner.scanLocation < (scanner.string.length - 1) && ++scanner.scanLocation && !scanner.atEnd;
}

+ (BOOL)isValidWithColorType:(NSString *)colorType components:(const NSInteger *)components {
    return components[0] >= 0 && components[1] >= 0 && components[2] >= 0 && components[3] >= 0
                    && [colorType hasPrefix:@"rgb"];
}

#pragma - 颜色转换 Color转换为十六进制颜色字符串
+(NSString *)hexValuesFromUIColor:(UIColor *)color {
    
    if (!color) {
        return nil;
    }
    
    if (color == [UIColor whiteColor]) {
        // Special case, as white doesn't fall into the RGB color space
        return @"ffffff";
    }
    
    CGFloat red;
    CGFloat blue;
    CGFloat green;
    CGFloat alpha;
    
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    int redDec = (int)(red * 255);
    int greenDec = (int)(green * 255);
    int blueDec = (int)(blue * 255);
    
    NSString *returnString = [NSString stringWithFormat:@"%02x%02x%02x", (unsigned int)redDec, (unsigned int)greenDec, (unsigned int)blueDec];
    
    return returnString;
    
}



@end
