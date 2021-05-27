//
//  CMFGetIPAddress.h
//  CMF-iOS-Core
//
//  Created by mac2019 on 2019/8/22.
//  Copyright © 2019 mac2019. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMFGetIPAddress : NSObject
/*
 * 获取设备IP地址
 */
+ (NSString *)getIPAddress:(BOOL)preferIPv4;

@end

NS_ASSUME_NONNULL_END
