//
//  CYCustomArcImageView.m
//  ProjectComponentDemo
//
//  Created by Mr.GCY on 2018/4/20.
//  Copyright © 2018年 Mr.GCY. All rights reserved.
//

#import "CYCustomArcImageView.h"
#import "CYAnyCornerRadiusUtil.h"

@interface CYCustomArcImageView()

@property (nonatomic, assign) CornerRadii cornerRadii;

@end

@implementation CYCustomArcImageView

#pragma mark- setter
-(void)setBorderRadius:(CGFloat)borderRadius{
     _borderRadius = borderRadius;
     self.borderBottomRightRadius = borderRadius;
     self.borderBottomLeftRadius = borderRadius;
     self.borderTopRightRadius = borderRadius;
     self.borderTopLeftRadius = borderRadius;
}

#pragma mark- 绘制方法
- (void)drawRect:(CGRect)rect {
     //切圆角
     CAShapeLayer *shapeLayer = [CAShapeLayer layer];
     self.cornerRadii = CornerRadiiMake(self.borderTopLeftRadius, self.borderTopRightRadius, self.borderBottomLeftRadius, self.borderBottomRightRadius);
     CGPathRef path = CYPathCreateWithRoundedRect(self.bounds,self.cornerRadii);
     shapeLayer.path = path;
     CGPathRelease(path);
     self.layer.mask = shapeLayer;

     CGContextRef context = UIGraphicsGetCurrentContext();

     [self drawLineWithContent:context];
}

-(void)drawLineWithContent:(CGContextRef)context{
     //画线
     const CGFloat minX = CGRectGetMinX(self.bounds);
     const CGFloat minY = CGRectGetMinY(self.bounds);
     const CGFloat maxX = CGRectGetMaxX(self.bounds);
     const CGFloat maxY = CGRectGetMaxY(self.bounds);
    
     const CGFloat topLeftCenterX = minX +  self.borderTopLeftRadius;
     const CGFloat topLeftCenterY = minY + self.borderTopLeftRadius;
     
     const CGFloat topRightCenterX = maxX - self.borderTopRightRadius;
     const CGFloat topRightCenterY = minY + self.borderTopRightRadius;
     
     const CGFloat bottomLeftCenterX = minX +  self.borderBottomLeftRadius;
     const CGFloat bottomLeftCenterY = maxY - self.borderBottomLeftRadius;
     
     const CGFloat bottomRightCenterX = maxX -  self.borderBottomRightRadius;
     const CGFloat bottomRightCenterY = maxY - self.borderBottomRightRadius;
     
     CGFloat lineW = self.lineWidth;
     CGFloat topSpaceY = (lineW)/2;
     CGFloat rightSpaceX = (lineW)/2;
     CGFloat bottomSpaceY = (lineW)/2;
     CGFloat leftSpaceX = (lineW)/2;
     
     self.borderTopLeftRadius -=  topSpaceY;
     self.borderTopRightRadius -=  rightSpaceX;
     self.borderBottomLeftRadius -=  bottomSpaceY;
     self.borderBottomRightRadius -=  leftSpaceX;
    
     UIColor *  color = self.lineColor ? : [UIColor whiteColor];
    
     //顶左 画圆弧
     drawLineArc(context, color.CGColor, lineW, CGPointMake(topLeftCenterX, topLeftCenterY), self.borderTopLeftRadius, M_PI, 3 * M_PI_2, NO);
     //顶部划线
     drawLine(context, color.CGColor, lineW, CGPointMake(topLeftCenterX, topSpaceY), CGPointMake(topRightCenterX, topSpaceY));
     //顶右 画圆弧
     drawLineArc(context, color.CGColor, lineW, CGPointMake(topRightCenterX, topRightCenterY), self.borderTopRightRadius, 3 * M_PI_2, 0, NO);
     //右部划线
     drawLine(context, color.CGColor, lineW, CGPointMake(maxX - rightSpaceX, topRightCenterY), CGPointMake(maxX - rightSpaceX, bottomRightCenterY));
     //底右 画圆弧
     drawLineArc(context, color.CGColor, lineW, CGPointMake(bottomRightCenterX, bottomRightCenterY), self.borderBottomRightRadius, 0, M_PI_2, NO);
    
     //底部划线
     drawLine(context, color.CGColor, lineW, CGPointMake(bottomRightCenterX, maxY - bottomSpaceY), CGPointMake(bottomLeftCenterX, maxY - bottomSpaceY));

     //底左 画圆弧
     drawLineArc(context, color.CGColor, lineW, CGPointMake(bottomLeftCenterX, bottomLeftCenterY), self.borderBottomLeftRadius, M_PI_2, M_PI, NO);

     //左边划线
     drawLine(context, color.CGColor, lineW, CGPointMake(minX + leftSpaceX, bottomLeftCenterY), CGPointMake(minX + leftSpaceX, topLeftCenterY));
     
}

@end
