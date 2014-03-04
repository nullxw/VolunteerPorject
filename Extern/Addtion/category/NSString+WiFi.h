//
//  NSString+WiFi.h
//  FastTransfer
//
//  Created by xiaogaochao on 13-6-19.
//  Copyright (c) 2013年 richinfo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WiFi)

+ (NSString*)getWiFiIPAddress;
+ (NSString*)getDeviceSSID;
+ (NSString*)getDeviceName:(NSString*)serverName;
- (NSDate*)dateWithFormate:(NSString*) formate ;

//直接加密，再返回16进制的数据 
- (NSString *)stringByRc4;
//有BASE64再RC4
- (NSString *)stringByEncodeingRC4;
- (NSString *)stringByDeCodeingRC4;
- (NSString *)stringToHexString:(NSString *)test;
- (NSString *)stringWithRC4;
@end
