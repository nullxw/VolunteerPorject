//
//  DeviceInfo.m
//  MakeCall
//
//  Created by xiaogaochao on 12-12-19.
//  Copyright (c) 2012年 richinfo. All rights reserved.
//

#import "DeviceInfo.h"

enum {
	UIDeviceResolution_Unknown			= 0,
    UIDeviceResolution_iPhoneStandard	= 1,    // iPhone 1,3,3GS Standard Display	(320x480px)
    UIDeviceResolution_iPhoneRetina35	= 2,    // iPhone 4,4S Retina Display 3.5"	(640x960px)
    UIDeviceResolution_iPhoneRetina4	= 3,    // iPhone 5 Retina Display 4"		(640x1136px)
    UIDeviceResolution_iPadStandard		= 4,    // iPad 1,2 Standard Display		(1024x768px)
    UIDeviceResolution_iPadRetina		= 5     // iPad 3 Retina Display			(2048x1536px)
}; typedef NSUInteger UIDeviceResolution;

@implementation DeviceInfo

NSUInteger DeviceSystemMajorVersion();
NSUInteger DeviceSystemMajorVersion() {
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return _deviceSystemMajorVersion;
}

#define MY_SYS_NAME (DeviceSystemMajorVersion() >= 7)

+ (BOOL)isIOS7System
{
    return MY_SYS_NAME;
}

UIDeviceResolution resolution();
UIDeviceResolution resolution() {
	static UIDeviceResolution resolution = UIDeviceResolution_Unknown;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
            UIScreen *mainScreen = [UIScreen mainScreen];
            CGFloat scale = ([mainScreen respondsToSelector:@selector(scale)] ? mainScreen.scale : 1.0f);
            CGFloat pixelHeight = (CGRectGetHeight(mainScreen.bounds) * scale);
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
                if (scale == 2.0f) {
                    if (pixelHeight == 960.0f)
                        resolution = UIDeviceResolution_iPhoneRetina35;
                    else if (pixelHeight == 1136.0f)
                        resolution = UIDeviceResolution_iPhoneRetina4;
                    
                } else if (scale == 1.0f && pixelHeight == 480.0f)
                    resolution = UIDeviceResolution_iPhoneStandard;
                
            } else {
                if (scale == 2.0f && pixelHeight == 2048.0f) {
                    resolution = UIDeviceResolution_iPadRetina;
                    
                } else if (scale == 1.0f && pixelHeight == 1024.0f) {
                    resolution = UIDeviceResolution_iPadStandard;
                }
            }
    });
	return resolution;
}

#define MY_DEVICE_NAME (resolution() == UIDeviceResolution_iPhoneRetina4)

+ (BOOL)isIphone5Device
{
    return MY_DEVICE_NAME;
}

+(BOOL)isJailbroken
{
    BOOL jailbroken = NO;
    NSString *cydiaPath = @"/Applications/Cydia.app";
    NSString *aptPath = @"/private/var/lib/apt/";
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]) {
        jailbroken = YES;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath]) {
        jailbroken = YES;
    }
    return jailbroken;
}

//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//    #define IS_IPOD ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])
//if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@end
