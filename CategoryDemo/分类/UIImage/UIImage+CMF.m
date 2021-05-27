//
//  UIImage+CMF.m
//  CMF-Core
//
//  Created by Wang Liu on 2018/10/29.
//  Copyright © 2018 cmbchina. All rights reserved.
//

#import "UIImage+CMF.h"

@implementation UIImage (CMF)

- (UIImage *)imageWithTintColor:(UIColor *)tintColor {
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *)imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    [self drawInRect:bounds blendMode:blendMode alpha:1.f];
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tintedImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark 压缩图片

+ (UIImage *)compressImage:(UIImage *)sourceImage maxKiloByte:(CGFloat)maxLength {
    return [UIImage compressImage:sourceImage
                      maxKiloByte:maxLength
                       resolution:CGSizeMake(1024, 1024)];
}

+ (UIImage *)compressImage:(UIImage *)sourceImage
               maxKiloByte:(CGFloat)maxLength
                resolution:(CGSize)resolution {
    NSData *imageData = [UIImage compressImageToData:sourceImage
                                         maxKiloByte:maxLength
                                          resolution:resolution];
    return [UIImage imageWithData:imageData];
}


+ (NSData *)compressImageToData:(UIImage *)sourceImage maxKiloByte:(CGFloat)maxLength {
    return [UIImage compressImageToData:sourceImage
                      maxKiloByte:maxLength
                       resolution:CGSizeMake(1024, 1024)];
}

+ (NSData *)compressImageToData:(UIImage *)sourceImage
                    maxKiloByte:(CGFloat)maxLength
                     resolution:(CGSize)resolution {
    // 判断当前质量是否满足要求，不满足再进行压缩
    __block NSData *finalImageData = UIImageJPEGRepresentation(sourceImage, 1.0);
    NSUInteger sizeOrigin = finalImageData.length;
    NSUInteger sizeOriginKB = sizeOrigin / 1024;
    NSLog(@"初始图片文件大小 %lu kb", sizeOriginKB);

    if (sizeOriginKB <= maxLength && sourceImage.size.width <= resolution.width && sourceImage.size.height <= resolution.height) {
        return finalImageData;
    }

    // 1.调整分辨率
    CGSize defaultSize = resolution;
    UIImage *newImage = [self compressImageQuality:sourceImage toSize:defaultSize];

    // 2.压缩文件大小
    finalImageData = UIImageJPEGRepresentation(newImage, 1.0);
    // 2.1 压缩系数数组，压缩间隔 1/1000
    NSMutableArray *compressionQualityArr = [NSMutableArray array];
    CGFloat avg = 1.0 / 1000;
    CGFloat value = 1.0 / 1000;
    for (int i = 1000; i >= 1; i--) {
        value = i * avg;
        [compressionQualityArr addObject:@(value)];
    }

    // 2.2 使用二分法搜索压缩系数调整拍照大小，压缩系数数组compressionQualityArr是从大到小存储
    finalImageData = [self halfFuntion:compressionQualityArr image:newImage maxKiloByte:maxLength];

    // 2.3 如果还是未能压缩到指定大小，则进行降分辨率
    while (finalImageData.length == 0) {
        // 每次降 100 分辨率
        if (defaultSize.width - 100 <= 0 || defaultSize.height - 100 <= 0) {
            break;
        }
        defaultSize = CGSizeMake(defaultSize.width - 100, defaultSize.height - 100);
        UIImage *image = [self compressImageQuality:[UIImage imageWithData:UIImageJPEGRepresentation(newImage, [[compressionQualityArr lastObject] floatValue])] toSize:defaultSize];
        finalImageData = [self halfFuntion:compressionQualityArr
                                     image:image
                               maxKiloByte:maxLength];
    }

    return finalImageData;
}

#pragma mark 调整图片分辨率/尺寸（等比例缩放）

+ (UIImage *)compressImageQuality:(UIImage *)sourceImage toSize:(CGSize)size {
    CGSize newSize = CGSizeMake(sourceImage.size.width, sourceImage.size.height);

    CGFloat tempHeight = newSize.height / size.height;
    CGFloat tempWidth = newSize.width / size.width;

    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempWidth, sourceImage.size.height / tempWidth);
    } else if (tempHeight > 1.0 && tempWidth < tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempHeight, sourceImage.size.height / tempHeight);
    } else if (tempWidth > 1.0 && tempWidth == tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempWidth, sourceImage.size.height / tempWidth);
    }

    UIGraphicsBeginImageContext(newSize);
    [sourceImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark 调整图片文件大小

+ (UIImage *)compressImageQuality:(UIImage *)originImage toKiloByte:(CGFloat)maxLength {
    // 压缩系数
    CGFloat compression = 1;
    NSData *imageData = UIImageJPEGRepresentation(originImage, compression);
    // 压缩前图片大小，KB
    CGFloat imageLength = imageData.length / 1024.0;
    // 压缩目标大小，范围 maxLength * 0.9 ~ maxLength
    CGFloat targetLength = maxLength * 0.9;
    if (imageLength < maxLength) return originImage;
    CGFloat maxCompression = 1.0;
    CGFloat minCompression = 0;
    NSLog(@"压缩前的质量：%.2f KB", imageLength);

    NSInteger index = 1;
    while ((imageLength > maxLength || imageLength < targetLength) && maxCompression > minCompression) {
        compression = (maxCompression + minCompression) / 2;
        imageData = UIImageJPEGRepresentation(originImage, compression);
        imageLength = imageData.length / 1024.0;
#ifdef DEBUG
        NSLog(@"\n");
        NSLog(@"\n");
        NSLog(@"--------------");
        NSLog(@"\n 第 %ld 次 min:%f max:%f  \n压缩系数：%lf", (long) index, minCompression, maxCompression, compression);
        NSLog(@"当前降到的质量：%.2f KB", imageLength);
#endif

        if (imageLength < maxLength * 0.9) {
            minCompression = compression;
        } else if (imageLength > maxLength) {
            maxCompression = compression;
        } else {
            break;
        }
        index++;
    }
    NSLog(@"压缩后的质量：%.2f", imageData.length / 1024.0);
    UIImage *resultImage = [UIImage imageWithData:imageData];
    return resultImage;
}

// 二分法调整图片大小，
+ (NSData *)halfFuntion:(NSArray *)compressArray
                  image:(UIImage *)image
            maxKiloByte:(NSInteger)maxSize {
    // 最终压缩图片数据
    NSData *finalImageData = UIImageJPEGRepresentation(image, 1.0);
    NSLog(@"压缩前的质量：%ld kb", finalImageData.length / 1024);
    NSUInteger start = 0;
    NSUInteger end = compressArray.count - 1;
    NSUInteger index = 0;
    // 限定两次压缩图片后的差距不会大于上一次压缩图片的大小差距，保存最接近的那次压缩
    NSUInteger difference = NSIntegerMax;
    NSInteger compressCount = 0;
    while (start <= end) {
        index = start + (end - start) / 2;
        // 压缩过程临时图片数据
        NSData *tempData = UIImageJPEGRepresentation(image, [compressArray[index] floatValue]);
        NSUInteger compressedSize = tempData.length;
        NSUInteger compressedSizeKB = compressedSize / 1024;

#ifdef DEBUG
        NSLog(@"\n");
        NSLog(@"\n");
        NSLog(@"--------------");
        NSLog(@"第 %ld 次压缩:: start：%zd  end：%zd  index：%zd\n压缩系数：%lf", (long) compressCount, start, end, (unsigned long) index, [compressArray[index] floatValue]);
        NSLog(@"当前降到的质量：%ld kb", (unsigned long) compressedSizeKB);
#endif
        // 压缩后比目标大小更大，压缩系数要变小，压缩更多
        if (compressedSizeKB > maxSize) {
            start = index + 1;
            // 压缩后比目标大小更小，压缩系数要变大,压缩更少
        } else if (compressedSizeKB < maxSize) {
            // 根据两次压缩之间和目标压缩大小的差距 difference，只保存差距更小的那次压缩
            if (maxSize - compressedSizeKB <= difference) {
                difference = maxSize - compressedSizeKB;
                finalImageData = tempData;
                NSLog(@"difference：：： %lu", difference);
            }
            if (index <= 0) {
                break;
            }
            end = index - 1;
        } else {
            break;
        }
        compressCount++;
    }

    NSLog(@"压缩后的质量：%ld kb", finalImageData.length / 1024);
    return finalImageData;
}

// 图片转 base64 编码
- (NSString *)image2Base64 {
    NSData *imageData = nil;
    NSString *imageType = @"*";
    if ([self isImageHasAlpha]) {
        imageData = UIImagePNGRepresentation(self);
        imageType = @"png";
    } else {
        imageData = UIImageJPEGRepresentation(self, 1.0f);
        imageType = @"jpeg";
    }
    NSString *imageBase64String = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return [NSString stringWithFormat:@"data:image/%@;base64,%@", imageType, imageBase64String];
}

// 图片是否有透明通道
- (BOOL)isImageHasAlpha {
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(self.CGImage);
    return (alphaInfo == kCGImageAlphaFirst ||
            alphaInfo == kCGImageAlphaLast ||
            alphaInfo == kCGImageAlphaPremultipliedFirst ||
            alphaInfo == kCGImageAlphaPremultipliedLast);
}

- (NSString *)image2Base64IgnoreType {
    return [self image2Base64IgnoreTypeByCompressionQuality:1.0f];
}

- (NSString *)image2Base64IgnoreTypeByCompressionQuality:(CGFloat)compressionQuality {
    NSData *imageData = UIImageJPEGRepresentation(self, compressionQuality);
    NSString *imageBase64String = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return [NSString stringWithFormat:@"data:image/*;base64,%@", imageBase64String];
}

+ (UIImage *)imageWithBase64:(NSString *)baseString {
    NSString *imageString = [baseString componentsSeparatedByString:@"base64,"].lastObject;
    if (!imageString || imageString.length == 0) {
        return nil;
    }
    NSData *imageData = [[NSData alloc] initWithBase64EncodedString:imageString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [[UIImage alloc] initWithData:imageData];

}

// 处理图片旋转与镜像，还原图片原始状态
- (UIImage *)fixOrientation {
    UIImage *aImage = self;
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = [self rotateImage:aImage transform:transform];
    transform = [self scaleImage:aImage transform:transform];

    CGContextRef cgContext = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
            CGImageGetBitsPerComponent(aImage.CGImage), 0,
            CGImageGetColorSpace(aImage.CGImage),
            CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(cgContext, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(cgContext, CGRectMake(0, 0, aImage.size.height, aImage.size.width), aImage.CGImage);
            break;

        default:
            CGContextDrawImage(cgContext, CGRectMake(0, 0, aImage.size.width, aImage.size.height), aImage.CGImage);
            break;
    }
    CGImageRef cgImage = CGBitmapContextCreateImage(cgContext);
    UIImage *img = [UIImage imageWithCGImage:cgImage];
    CGContextRelease(cgContext);
    CGImageRelease(cgImage);
    return img;
}

- (CGAffineTransform)rotateImage:(UIImage *)aImage transform:(CGAffineTransform)transform {
    CGAffineTransform tempTransform = transform;
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            tempTransform = CGAffineTransformTranslate(tempTransform, aImage.size.width, aImage.size.height);
            tempTransform = CGAffineTransformRotate(tempTransform, M_PI);
            break;

        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            tempTransform = CGAffineTransformTranslate(tempTransform, aImage.size.width, 0);
            tempTransform = CGAffineTransformRotate(tempTransform, M_PI_2);
            break;

        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            tempTransform = CGAffineTransformTranslate(tempTransform, 0, aImage.size.height);
            tempTransform = CGAffineTransformRotate(tempTransform, -M_PI_2);
            break;
        default:
            break;
    }
    return tempTransform;
}

- (CGAffineTransform)scaleImage:(UIImage *)aImage transform:(CGAffineTransform)transform {
    CGAffineTransform tempTransform = transform;
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            tempTransform = CGAffineTransformTranslate(tempTransform, aImage.size.width, 0);
            tempTransform = CGAffineTransformScale(tempTransform, -1, 1);
            break;

        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            tempTransform = CGAffineTransformTranslate(tempTransform, aImage.size.height, 0);
            tempTransform = CGAffineTransformScale(tempTransform, -1, 1);
            break;
        default:
            break;
    }
    return tempTransform;
}


@end
