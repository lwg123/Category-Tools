//
//  UIImage+CMF.h
//  CMF-Core
//
//  Created by Wang Liu on 2018/10/29.
//  Copyright © 2018 cmbchina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CMF)


/**
 以传入的颜色改变图片的颜色

 @param tintColor 目标颜色
 @return 改变颜色后的图片
 */
- (UIImage *)imageWithTintColor:(UIColor *)tintColor;


/**
 给定颜色和大小生成纯色图片

 @param color 颜色
 @param size 大小
 @return 纯色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 压缩图片，默认分辨率 1024*1024

 @param sourceImage 源图片
 @param maxLength 压缩后的最大大小（单位KB）
 @return 压缩后的图片数据
 */
+ (UIImage *)compressImage:(UIImage *)sourceImage
               maxKiloByte:(CGFloat)maxLength;


/**
 以指定分辨率压缩图片
 
 @param sourceImage 源图片
 @param maxLength 压缩后的最大大小（单位KB）
 @param resolution 指定分辨率
 @return 压缩后的图片数据
 */
+ (UIImage *)compressImage:(UIImage *)sourceImage
               maxKiloByte:(CGFloat)maxLength
               resolution:(CGSize)resolution;


/**
 以指定分大小将图片压缩成data
 */
+ (NSData *)compressImageToData:(UIImage *)sourceImage maxKiloByte:(CGFloat)maxLength;

/**
 以指定分辨率和大小将图片压缩成data
 */
+ (NSData *)compressImageToData:(UIImage *)sourceImage
                    maxKiloByte:(CGFloat)maxLength
                     resolution:(CGSize)resolution;

/**
 图片转 base64 编码
 */
- (NSString *)image2Base64;

/**
 图片转 base64 编码，不区分图片类型，统一 image*
 */
- (NSString *)image2Base64IgnoreType;

/**
 以指定压缩质量将图片转 base64 编码，不区分图片类型，统一 image*
 */
- (NSString *)image2Base64IgnoreTypeByCompressionQuality:(CGFloat)compressionQuality;

+ (UIImage *)imageWithBase64:(NSString *)baseString;

/**
 处理图片旋转与镜像，还原图片原始状态
 */
- (UIImage *)fixOrientation;

@end

