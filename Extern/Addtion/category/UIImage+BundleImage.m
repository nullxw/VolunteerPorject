//
//  UIImage+BundleImage.m
//  FanxingPadSDK
//
//  Created by xiaogaochao on 14-1-10.
//  Copyright (c) 2014年 kugou. All rights reserved.
//

#import "UIImage+BundleImage.h"

@implementation UIImage (BundleImage)

//非缓存
+ (UIImage *)commonImageNamedFromCustomBundle:(NSString*)name
{
    NSString *star_images_dir_path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"FXApi_IPAD_Bundle.bundle/common"];
    NSString *image_path = [star_images_dir_path stringByAppendingPathComponent:name];
    return [UIImage imageWithContentsOfFile:image_path];
}

//缓存
+ (UIImage *)commonImageNamedCacheFromCustomBundle:(NSString*)name
{
    NSString *star_images_dir_path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"FXApi_IPAD_Bundle.bundle/common"];
    NSString *image_path = [star_images_dir_path stringByAppendingPathComponent:name];
    return [UIImage imageNamed:image_path];
}

//非缓存ipad
+ (UIImage *)ipadRichImageNameFromCustomBundle:(NSString*)name
{
    NSString *rich_images_dir_path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"FXApi_IPAD_Bundle.bundle/ipad/fanxingrich"];
    NSString *image_path = [rich_images_dir_path stringByAppendingPathComponent:name];
    return [UIImage imageWithContentsOfFile:image_path];
}

+ (UIImage *)ipadStarImageNameFromCustomBundle:(NSString*)name
{
    NSString *star_images_dir_path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"FXApi_IPAD_Bundle.bundle/ipad/fanxingstar"];
    NSString *image_path = [star_images_dir_path stringByAppendingPathComponent:name];
    return [UIImage imageWithContentsOfFile:image_path];
}

+ (UIImage *)ipadImageNamedFromCustomBundle:(NSString*)name
{
    NSString *ipad_images_dir_path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"FXApi_IPAD_Bundle.bundle/ipad"];
    NSString *image_path = [ipad_images_dir_path stringByAppendingPathComponent:name];
    return [UIImage imageWithContentsOfFile:image_path];
}

//非缓存iphone
+ (UIImage *)iphoneRichImageNameFromCustomBundle:(NSString*)name
{
    NSString *rich_images_dir_path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"FXApi_IPAD_Bundle.bundle/iphone/fanxingrich"];
    NSString *image_path = [rich_images_dir_path stringByAppendingPathComponent:name];
    return [UIImage imageWithContentsOfFile:image_path];
}

+ (UIImage *)iphoneStarImageNameFromCustomBundle:(NSString*)name
{
    NSString *star_images_dir_path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"FXApi_IPAD_Bundle.bundle/iphone/fanxingstar"];
    NSString *image_path = [star_images_dir_path stringByAppendingPathComponent:name];
    return [UIImage imageWithContentsOfFile:image_path];
}

+ (UIImage *)iphoneImageNamedFromCustomBundle:(NSString*)name
{
    NSString *iphone_images_dir_path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"FXApi_IPAD_Bundle.bundle/iphone"];
    NSString *image_path = [iphone_images_dir_path stringByAppendingPathComponent:name];
    return [UIImage imageWithContentsOfFile:image_path];
}


//缓存

+ (UIImage *)richImageNamedCacheFromCustomBundle:(NSString*)name
{
    NSString *rich_images_dir_path = @"FXApi_IPAD_Bundle.bundle/ipad/fanxingrich";
    NSString *image_path = [rich_images_dir_path stringByAppendingPathComponent:name];
    return [UIImage imageNamed:image_path];
}
+ (UIImage *)starImageNamedCacheFromcustomBundle:(NSString*)name
{
    NSString *star_images_dir_path = @"FXApi_IPAD_Bundle.bundle/ipad/fanxingstar";
    NSString *image_path = [star_images_dir_path stringByAppendingPathComponent:name];
    return [UIImage imageNamed:image_path];
}
+ (UIImage *)ipadImageNamedCacheFromCustomBundle:(NSString*)name
{
    NSString *ipad_images_dir_path = @"FXApi_IPAD_Bundle.bundle/ipad";
    NSString *image_path = [ipad_images_dir_path stringByAppendingPathComponent:name];
    return [UIImage imageNamed:image_path];
}
+ (UIImage *)iphoneImageNamedCacheFromCustomBundle:(NSString*)name
{
    NSString *iphone_images_dir_path = @"FXApi_IPAD_Bundle.bundle/iphone";
    NSString *image_path = [iphone_images_dir_path stringByAppendingPathComponent:name];
    return [UIImage imageNamed:image_path];
}
@end
