//
//  FXImage.h
//  FanxingSDK
//
//  Created by 邹泽龙 on 13-12-21.
//  Copyright (c) 2013年 kugou. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDWebImageCompat.h"
#import "SDWebImageManager.h"

@interface FXImage : NSObject


- (void)initWithImageUrlStr:(NSString *)urlStr defalutImage:(UIImage *)image target:(id)target;

/**
 * Cancel the current download
 */
- (void)drawInRect:(CGRect)rect;
- (void)drawInRect:(CGRect)rect withRoundedsize:(CGSize)size radius:(NSInteger)r;

@end
