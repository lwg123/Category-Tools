//
//  UIView+Frame.m
//  DuiFuDao
//
//  Created by weiguang on 2018/7/26.
//  Copyright © 2018年 DuiA. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (void)setX:(CGFloat)x {
    self.frame = CGRectMake(x, self.y, self.width, self.height);
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y {
    self.frame = CGRectMake(self.x, y, self.width, self.height);
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width {
    self.frame = CGRectMake(self.x, self.y, width, self.height);
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height {
    self.frame = CGRectMake(self.x, self.y, self.width, height);
}

- (CGFloat)height {
    return self.frame.size.height;
}


- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.centerY);
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.centerX, centerY);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (CGFloat)maxX {
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)minX {
    return CGRectGetMinX(self.frame);
}

- (CGFloat)maxY {
    return CGRectGetMaxY(self.frame);
}

- (CGFloat)minY {
    return CGRectGetMinY(self.frame);
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

-(void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

-(CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}

-(void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}

-(UIColor *)borderColor
{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

-(void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

-(CGFloat)borderWidth
{
    return self.layer.borderWidth;
}

@end
