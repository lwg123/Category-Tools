//
//  UIButton+TitleImageSpace.h
//  MiDou
//
//  Created by midou on 2018/9/26.
//  Copyright © 2018年 WJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WJButtonEdgeInsetsStyle)
{    WJButtonEdgeInsetsStyleTop, // image在上，label在下
     WJButtonEdgeInsetsStyleLeft, // image在左，label在右
     WJButtonEdgeInsetsStyleBottom, // image在下，label在上
     WJButtonEdgeInsetsStyleRight // image在右，label在左
     
};

@interface UIButton (TitleImageSpace)
/** *  设置button的titleLabel和imageView的布局样式，及间距
 * *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(WJButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;

@end
