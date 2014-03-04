//
//  UIImage+BundleImage.h
//  FanxingPadSDK
//
//  Created by xiaogaochao on 14-1-10.
//  Copyright (c) 2014年 kugou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BundleImage)
//非缓存
//导入ipad和iphone通用
+ (UIImage *)commonImageNamedFromCustomBundle:(NSString*)name;
+ (UIImage *)commonImageNamedCacheFromCustomBundle:(NSString*)name;

//导入ipad的图片
+ (UIImage *)ipadImageNamedFromCustomBundle:(NSString*)name;
+ (UIImage *)ipadStarImageNameFromCustomBundle:(NSString*)name;
+ (UIImage *)ipadRichImageNameFromCustomBundle:(NSString*)name;

//导入iphone图片
+ (UIImage *)iphoneImageNamedFromCustomBundle:(NSString*)name;
+ (UIImage *)iphoneStarImageNameFromCustomBundle:(NSString*)name;
+ (UIImage *)iphoneRichImageNameFromCustomBundle:(NSString*)name;

//缓存
+ (UIImage *)richImageNamedCacheFromCustomBundle:(NSString*)name;
+ (UIImage *)starImageNamedCacheFromcustomBundle:(NSString*)name;

+ (UIImage *)ipadImageNamedCacheFromCustomBundle:(NSString*)name;
+ (UIImage *)iphoneImageNamedCacheFromCustomBundle:(NSString*)name;
@end
