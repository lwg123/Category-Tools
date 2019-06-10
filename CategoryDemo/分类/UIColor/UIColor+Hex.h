//
//  UIColor+Hex.h
//  TouchCPlatform
//
//  Created by Du on 15-6-3.
//  Copyright (c) 2015年 changhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)
+ (UIColor *)colorWithHex:(long)hexColor;
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity;
+ (UIColor *) colorWithHexString: (NSString *)color;

+(NSString *)hexValuesFromUIColor:(UIColor *)color;
@end
