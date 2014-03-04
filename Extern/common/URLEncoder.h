//
//  URLEncoder.h
//  FanxingSDK
//
//  Created by xiaogaochao on 13-9-13.
//  Copyright (c) 2013年 kugou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLEncoder : NSObject

+ (NSString *)encode:(NSString *)input;
+ (NSString *)decode:(NSString *)input;

@end
