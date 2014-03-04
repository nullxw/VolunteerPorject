//
//  DeviceInfo.h
//  MakeCall
//
//  Created by xiaogaochao on 12-12-19.
//  Copyright (c) 2012年 richinfo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInfo : NSObject

+ (BOOL)isIphone5Device;
+ (BOOL)isIOS7System;
+ (BOOL)isJailbroken;

@end
