//
//  UIView+Extension.m
//  SinaWeibo
//
//  Created by chensir on 15/10/13.
//  Copyright (c) 2015年 ZT. All rights reserved.
//

#import "UIView+Extension.h"
#import <objc/runtime.h>
#import "CYAnyCornerRadiusUtil.h"

static NSString *_TYShadowLayer = @"_TYShadowLayer";

static NSString *_TYInsertLayer = @"_TYInsertLayer";

@implementation UIView (Extension)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
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


- (void)setShadowLayer:(CALayer *)shadowLayer{
    objc_setAssociatedObject(self, &_TYShadowLayer, shadowLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CALayer *)shadowLayer {
    return objc_getAssociatedObject(self, &_TYShadowLayer);
}

- (void)setInsertLayer:(CALayer *)insertLayer{
    objc_setAssociatedObject(self, &_TYInsertLayer, insertLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(CALayer *)insertLayer{
    return objc_getAssociatedObject(self, &_TYInsertLayer);
}

+ (void)addShadowToView:(UIView *)view
            withOpacity:(float)shadowOpacity
           shadowRadius:(CGFloat)shadowRadius
            shadowColor:(UIColor *)shadowColor
        cornerRadius:(CGFloat)cornerRadius{
    [self addShadowToView:view withOpacity:shadowOpacity shadowRadius:shadowRadius shadowColor:shadowColor borderWidth:0 borderColor:nil cornerRadius:cornerRadius];
}

/*
 周边加阴影，并且同时圆角
 */
+ (void)addShadowToView:(UIView *)view
            withOpacity:(float)shadowOpacity
           shadowRadius:(CGFloat)shadowRadius
            shadowColor:(UIColor *)shadowColor
            borderWidth:(CGFloat)borderWidth
            borderColor:(UIColor *)borderColor
           cornerRadius:(CGFloat)cornerRadius{
    [self addShadowToView:view withOpacity:shadowOpacity shadowRadius:shadowRadius shadowColor:shadowColor borderWidth:borderWidth borderColor:borderColor cornerRadius:cornerRadius shadowOffset:CGSizeMake(0, 0)];
}
/*
 周边加阴影，并且同时圆角
 */
+ (void)addShadowToView:(UIView *)view
            withOpacity:(float)shadowOpacity
           shadowRadius:(CGFloat)shadowRadius
            shadowColor:(UIColor *)shadowColor
            borderWidth:(CGFloat)borderWidth
            borderColor:(UIColor *)borderColor
        cornerRadius:(CGFloat)cornerRadius
           shadowOffset:(CGSize )shadowOffset
{
    //////// shadow /////////
    CALayer *shadowLayer;
    if (view.superview.shadowLayer){
        [view.superview.shadowLayer removeFromSuperlayer];
        shadowLayer = view.superview.shadowLayer;
    }else{
        shadowLayer = [CALayer layer];
        view.superview.shadowLayer = shadowLayer;
    }
    shadowLayer.frame = view.layer.frame;

    shadowLayer.shadowColor = shadowColor.CGColor;//shadowColor阴影颜色
    shadowLayer.shadowOffset = shadowOffset;//shadowOffset阴影偏移，默认(0, 0)
    shadowLayer.shadowOpacity = shadowOpacity;//阴影透明度，默认0
    shadowLayer.shadowRadius = shadowRadius;//阴影半径，默认0
    
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    float width = shadowLayer.bounds.size.width;
    float height = shadowLayer.bounds.size.height;
    float x = shadowLayer.bounds.origin.x;
    float y = shadowLayer.bounds.origin.y;
    
    CGPoint topLeft      = shadowLayer.bounds.origin;
    CGPoint topRight     = CGPointMake(x + width, y);
    CGPoint bottomRight  = CGPointMake(x + width, y + height);
    CGPoint bottomLeft   = CGPointMake(x, y + height);
    
    CGFloat offset = -1.f;
    [path moveToPoint:CGPointMake(topLeft.x - offset, topLeft.y + cornerRadius)];
    [path addArcWithCenter:CGPointMake(topLeft.x + cornerRadius, topLeft.y + cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI endAngle:M_PI_2 * 3 clockwise:YES];
    [path addLineToPoint:CGPointMake(topRight.x - cornerRadius, topRight.y - offset)];
    [path addArcWithCenter:CGPointMake(topRight.x - cornerRadius, topRight.y + cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI_2 * 3 endAngle:M_PI * 2 clockwise:YES];
    [path addLineToPoint:CGPointMake(bottomRight.x + offset, bottomRight.y - cornerRadius)];
    [path addArcWithCenter:CGPointMake(bottomRight.x - cornerRadius, bottomRight.y - cornerRadius) radius:(cornerRadius + offset) startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [path addLineToPoint:CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y + offset)];
    [path addArcWithCenter:CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y - cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [path addLineToPoint:CGPointMake(topLeft.x - offset, topLeft.y + cornerRadius)];
    
    //设置阴影路径
    shadowLayer.shadowPath = path.CGPath;
    
    //////// cornerRadius /////////
    if (cornerRadius != 0){
        view.layer.cornerRadius = cornerRadius;
        view.layer.masksToBounds = YES;
        view.layer.shouldRasterize = YES;
        view.layer.rasterizationScale = [UIScreen mainScreen].scale;
    }

    if (borderWidth != 0){
        view.layer.borderWidth = borderWidth;
    }
    
    if (borderColor != nil){
        view.layer.borderColor = borderColor.CGColor;
    }

    [view.superview.layer insertSublayer:shadowLayer below:view.layer];
}

- (void)setCorners:(UIRectCorner)corners cornerRadius:(CGFloat )cornerRadius{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(cornerRadius,cornerRadius)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    
    self.layer.mask = maskLayer;
}


- (void)addShadowOpacity:(float)shadowOpacity
            shadowRadius:(CGFloat)shadowRadius
             shadowColor:(UIColor *)shadowColor{
    [self addShadowOpacity:shadowOpacity shadowRadius:shadowRadius shadowColor:shadowColor shadowOffset:CGSizeMake(0, 0)];
}

- (void)addShadowOpacity:(float)shadowOpacity
           shadowRadius:(CGFloat)shadowRadius
            shadowColor:(UIColor *)shadowColor
           shadowOffset:(CGSize )shadowOffset{
    self.layer.shadowColor = shadowColor.CGColor;
    self.layer.shadowOffset = shadowOffset;
    self.layer.shadowRadius = shadowRadius;
    self.layer.shadowOpacity = shadowOpacity;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)addGradientLayer:(UIColor*)startColor endColor:(UIColor*)endColor{
    [self addGradientLayer:startColor endColor:endColor startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1) locations:@[@(0.5f), @(1.0f)]];
}

- (void)addGradientLayer:(UIColor*)startColor endColor:(UIColor*)endColor startPoint:(CGPoint )startPoint endPoint:(CGPoint )endPoint{
    [self addGradientLayer:startColor endColor:endColor startPoint:startPoint endPoint:endPoint locations:@[@(0.5f), @(1.0f)]];
}

- (void)addGradientLayer:(UIColor*)startColor endColor:(UIColor*)endColor startPoint:(CGPoint )startPoint endPoint:(CGPoint )endPoint locations:(NSArray *)locations{
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [self.layer addSublayer:gradientLayer];
    
    //设置渐变区域的起始和终止位置（范围为0-1）
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    
    //设置颜色数组
    gradientLayer.colors = @[(__bridge id)startColor.CGColor,
                             (__bridge id)endColor.CGColor];
    
    //设置颜色分割点（范围：0-1）
    gradientLayer.locations = locations;
    
    [self.layer insertSublayer:gradientLayer atIndex:0];
}

- (void)hexagonClip:(CGFloat )cornerRadius{
    [self hexagonWith:cornerRadius lineWidth:0 lineColor:nil];
}

- (void)hexagonWith:(CGFloat )cornerRadius lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor {

    CAShapeLayer *shapeLayer;
    if (self.insertLayer){
        [self.insertLayer removeFromSuperlayer];
        shapeLayer = (CAShapeLayer *)self.insertLayer;
    }else{
        shapeLayer = [CAShapeLayer layer];
        self.insertLayer = shapeLayer;
    }
    
    UIBezierPath *shapePath = [self roundedPolygonPathWithRect:self.bounds lineWidth:lineWidth sides:6 cornerRadius:cornerRadius];
    shapeLayer.path = shapePath.CGPath;
    if (lineColor){
        shapeLayer.strokeColor = lineColor.CGColor;
    }
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = MIN(0, lineWidth);
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = shapePath.CGPath;
    self.layer.mask = maskLayer;

    [self.layer insertSublayer:shapeLayer above:maskLayer];
}

- (UIBezierPath *)roundedPolygonPathWithRect:(CGRect)rect
                                   lineWidth:(CGFloat)lineWidth
                                       sides:(NSInteger)sides
                                cornerRadius:(CGFloat)cornerRadius
{
    /// 减少的比例
    static const CGFloat cutRation = 0.02;
    
    UIBezierPath *path  = [UIBezierPath bezierPath];
    
    CGFloat theta = 2.0 * M_PI / sides;
    CGFloat offset      = cornerRadius * tanf(theta / 2.0);
    CGFloat squareWidth = MIN(rect.size.width, rect.size.height)*(1 - cutRation);
    
    CGFloat offsetX = ((rect.size.width*(1 - cutRation/2) - squareWidth)/2);
    CGFloat offsetY = ((rect.size.height*(1 - cutRation/2) - squareWidth)/2);

    CGFloat length      = squareWidth - lineWidth;
    if (sides % 4 != 0) {
        length = length * cosf(theta / 2.0) + offset/2.0;//length * cosf(theta / 2.0)== 短的轴长，
    }
    CGFloat sideLength = length * tanf(theta / 2.0);//单边长
    
    CGPoint point = CGPointMake(2*sideLength - offset + offsetX, offset + sideLength/2 + offsetY - squareWidth * cutRation);
    
    CGFloat angle = M_PI_2;
    [path moveToPoint:point];

    for (NSInteger side = 0; side < sides; side++) {
        point = CGPointMake(point.x + (sideLength - offset * 2.0) * cosf(angle), point.y + (sideLength - offset * 2.0) * sinf(angle));
        [path addLineToPoint:point];
        
        CGPoint center = CGPointMake(point.x + cornerRadius * cosf(angle + M_PI_2), point.y + cornerRadius * sinf(angle + M_PI_2));
        
        [path addArcWithCenter:center radius:cornerRadius startAngle:angle - M_PI_2 endAngle:angle + theta - M_PI_2 clockwise:YES];
        
        point = path.currentPoint;
        angle += theta;
    }
    
    [path closePath];
    
    return path;
}
@end
