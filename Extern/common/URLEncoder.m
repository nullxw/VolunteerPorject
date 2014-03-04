//
//  URLEncoder.m
//  FanxingSDK
//
//  Created by xiaogaochao on 13-9-13.
//  Copyright (c) 2013年 kugou. All rights reserved.
//

#import "URLEncoder.h"

@implementation URLEncoder

+ (NSString *)encode:(NSString *)input
{

    NSString *outputStr=(NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)input, NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"), kCFStringEncodingUTF8);
    return [outputStr autorelease];
}

+ (NSString *)decode:(NSString *)input
{
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@""
                               withString:@""
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
