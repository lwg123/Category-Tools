//
//  UIView+Extension.h
//  SinaWeibo
//
//  Created by chensir on 15/10/13.
//  Copyright (c) 2015年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, strong) UIColor *borderColor;

@property (nonatomic, strong) CALayer *shadowLayer;

/// 通用的插入layer
@property (nonatomic, strong) CALayer *insertLayer;

+ (void)addShadowToView:(UIView *)view
            withOpacity:(float)shadowOpacity
           shadowRadius:(CGFloat)shadowRadius
            shadowColor:(UIColor *)shadowColor
           cornerRadius:(CGFloat)cornerRadius;


+ (void)addShadowToView:(UIView *)view
            withOpacity:(float)shadowOpacity
           shadowRadius:(CGFloat)shadowRadius
            shadowColor:(UIColor *)shadowColor
            borderWidth:(CGFloat)borderWidth
            borderColor:(UIColor *)borderColor
        cornerRadius:(CGFloat)cornerRadius;

/**
 周边加阴影，并且同时圆角
 
 @param view 需要设置的view
 @param shadowOpacity 透明度
 @param shadowRadius 阴影radius
 @param shadowColor 阴影颜色
 @param borderWidth 边缘宽度
 @param borderColor 边缘颜色
 @param cornerRadius 圆角
 @param shadowOffset 偏移
 */
+ (void)addShadowToView:(UIView *)view
            withOpacity:(float)shadowOpacity
           shadowRadius:(CGFloat)shadowRadius
            shadowColor:(UIColor *)shadowColor
            borderWidth:(CGFloat)borderWidth
            borderColor:(UIColor *)borderColor
           cornerRadius:(CGFloat)cornerRadius
           shadowOffset:(CGSize )shadowOffset;

/**
 设置圆角

 @param corners
 UIRectCornerTopLeft     左上
 UIRectCornerTopRight    右上
 UIRectCornerBottomLeft  左下
 UIRectCornerBottomRight 右下
 UIRectCornerAllCorners  所有
 
 @param cornerRadius 圆角
 */
- (void)setCorners:(UIRectCorner)corners cornerRadius:(CGFloat )cornerRadius;

- (void)addShadowOpacity:(float)shadowOpacity
            shadowRadius:(CGFloat)shadowRadius
             shadowColor:(UIColor *)shadowColor;

- (void)addShadowOpacity:(float)shadowOpacity
            shadowRadius:(CGFloat)shadowRadius
             shadowColor:(UIColor *)shadowColor
            shadowOffset:(CGSize )shadowOffset;


- (void)addGradientLayer:(UIColor*)startColor endColor:(UIColor*)endColor;

- (void)addGradientLayer:(UIColor*)startColor
                endColor:(UIColor*)endColor
              startPoint:(CGPoint )startPoint
                endPoint:(CGPoint )endPoint;

/**
 设置渐变色
 
 @param startColor  开始颜色
 @param endColor    结束颜色
 @param startPoint  开始位置
 @param endPoint    结束位置
 @param locations   渐变范围
 */
- (void)addGradientLayer:(UIColor*)startColor
                endColor:(UIColor*)endColor
              startPoint:(CGPoint )startPoint
                endPoint:(CGPoint )endPoint
               locations:(NSArray *)locations;

/**
 六边形
 
 @param cornerRadius  圆角
 */
- (void)hexagonClip:(CGFloat )cornerRadius;

/**
 六边形
 
 @param cornerRadius  圆角
 @param lineWidth  边框宽度
 @param lineColor      边框颜色
 */
- (void)hexagonWith:(CGFloat )cornerRadius lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor;

@end
