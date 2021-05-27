//
//  CMFIPAddressConfig.h
//  CMF-iOS-Core
//
//  Created by mac2019 on 2019/8/22.
//  Copyright © 2019 mac2019. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <sys/sockio.h>
#include <net/if.h>
#include <errno.h>
#include <net/if_dl.h>
#include <ifaddrs.h>
#include <arpa/inet.h>

#define BUFFERSIZE  4000
#define MAXADDRS    32
#define min(a,b)    ((a) < (b) ? (a) : (b))
#define max(a,b)    ((a) > (b) ? (a) : (b))

NS_ASSUME_NONNULL_BEGIN

@interface CMFIPAddressConfig : NSObject
// extern
extern char * _Nonnull if_names[MAXADDRS];
extern char * _Nonnull ip_names[MAXADDRS];
extern char * _Nonnull hw_addrs[MAXADDRS];
extern unsigned long ip_addrs[MAXADDRS];
// Function prototypes
void InitAddresses(void);
void FreeAddresses(void);
void GetIPAddresses(void);
void GetHWAddresses(void);

@end

NS_ASSUME_NONNULL_END
