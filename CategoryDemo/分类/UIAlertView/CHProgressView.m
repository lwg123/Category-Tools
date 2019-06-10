//
//  CHProgressView.m
//  TouchCPlatform
//
//  Created by 郑红 on 5/17/16.
//  Copyright © 2016 changhong. All rights reserved.
//

#import "CHProgressView.h"

@interface CHProgressView ()
{
    CAShapeLayer * progressLayer;
    CGFloat viewWidth;
    CGFloat viewHeight;
}

@property (nonatomic, strong) UIImage * progressImageCash;
@property (nonatomic, strong) UIImage * trackImageCash;

@end


@implementation CHProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        viewWidth = self.bounds.size.width;
        viewHeight = self.bounds.size.height;
        _trackTintColor = [UIColor lightGrayColor];
        _progressTintColor = [UIColor redColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


#pragma mark -setter
- (void)setTrackImage:(UIImage *)trackImage {
    _trackImage = trackImage;
    [self setNeedsDisplay];
}

- (void)setProgressImage:(UIImage *)progressImage {
    _progressImage = progressImage;
    [self setNeedsDisplay];
}

- (void)setTrackTintColor:(UIColor *)trackTintColor {
    _trackTintColor = trackTintColor;
    [self setNeedsDisplay];
}

- (void)setProgressTintColor:(UIColor *)progressTintColor {
    _progressTintColor = progressTintColor;
    [self setNeedsDisplay];
}

- (void)setPProgress:(CGFloat)pProgress {
    if (pProgress < 0) {
        pProgress = 0;
    }
    if (pProgress > 1) {
        pProgress = 1;
    }
    _pProgress = pProgress;
    [self setNeedsDisplay];
}

#pragma mark - DrawRect

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat width = MIN(viewWidth * _pProgress, viewWidth);
    if (_pProgress == 0) {
        UIBezierPath * trackPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, viewWidth, viewHeight) cornerRadius:viewHeight/2];
        CGContextAddPath(ctx, trackPath.CGPath);
        CGContextSetFillColorWithColor(ctx, self.trackTintColor.CGColor);
        [trackPath fill];
        return;
    }
    if (_trackImage != nil) {
        [self.trackImageCash drawInRect:CGRectMake(width-viewHeight, 0, viewWidth - width+viewHeight, viewHeight)];
    } else {
        UIBezierPath * trackPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(width-viewHeight, 0, viewWidth- width+viewHeight, viewHeight) cornerRadius:viewHeight/2];
        CGContextAddPath(ctx, trackPath.CGPath);
        CGContextSetFillColorWithColor(ctx, self.trackTintColor.CGColor);
        [trackPath fill];
    }
    if (_progressImage != nil) {
        [self.progressImageCash drawInRect:CGRectMake(0, 0, width, viewHeight)];
    } else {
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, width, viewHeight) cornerRadius:viewHeight/2];
        CGContextAddPath(ctx, path.CGPath);
        CGContextSetFillColorWithColor(ctx, self.progressTintColor.CGColor);
        [path fill];
    }
}

#pragma mark - imageCash

- (UIImage *)progressImageCash {
    if (!_progressImageCash) {
        _progressImageCash = [self resizableImage:_progressImage];
    }
    return _progressImageCash;
}

- (UIImage *)trackImageCash {
    if (!_trackImageCash) {
        _trackImageCash = [self resizableImage:_trackImage];
    }
    return _trackImageCash;
}

- (UIImage *)resizableImage:(UIImage *)image {
    UIImage * newImage = [self resizeImage:image];
    CGSize imageSize = image.size;
    UIImage * resizableImage = [newImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, imageSize.height/2, 0, imageSize.height/2) resizingMode:UIImageResizingModeStretch];
    return resizableImage;
}

- (UIImage *)resizeImage:(UIImage *)image {
    CGSize viewSize = self.bounds.size;
    CGSize imgSize = image.size;
    if (imgSize.height < viewSize.height) {
        return image;
    }
    CGImageRef imageRef = image.CGImage;
    CGFloat y = imgSize.height - viewSize.height;
    CGRect newSize = CGRectMake(0, y/2, imgSize.width, viewSize.height);
    CGImageRef newImage = CGImageCreateWithImageInRect(imageRef, newSize);
    return [UIImage imageWithCGImage:newImage];
}


@end