//
//  NSString+MD5.h
//  itaomagazine
//
//  Created by 肖 高超 on 12-2-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)

+ (NSString *)MD5Hash:(NSString *)fileName;
+ (NSString *)fileMD5:(NSString *)filePath;



@end
