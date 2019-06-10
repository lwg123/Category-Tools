//
//  UIImage+MDGif.h
//  mandarinApp
//
//  Created by WJ on 2019/4/26.
//  Copyright © 2019年 PKL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MDGif)

+ (UIImage *)md_animatedGIFNamed:(NSString *)name;

+ (UIImage *)md_animatedGIFWithData:(NSData *)data;

- (UIImage *)md_animatedImageByScalingAndCroppingToSize:(CGSize)size;


@end
