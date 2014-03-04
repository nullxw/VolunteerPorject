//
//  NSString+MD5.m
//  itaomagazine
//
//  Created by 肖 高超 on 12-2-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSString+MD5.h"
#import "CommonCrypto/CommonDigest.h"

//TT_FIX_CATEGORY_BUG(MD5Additions)

@implementation NSString (MD5)

+ (NSString *)MD5Hash:(NSString *)fileName
{
    const char *cStr = [fileName UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
	
    CC_MD5( cStr, strlen(cStr), result );
	
	return [NSString stringWithFormat: @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
}

+ (NSString *)fileMD5:(NSString *)filePath
{
    NSFileHandle *handle=[NSFileHandle fileHandleForReadingAtPath:filePath];
    if( handle==nil ) return nil;
    
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    
    BOOL done = NO;
    while(!done)
    {
        NSData *fileData = [handle readDataOfLength:1024*1024];
        CC_MD5_Update(&md5, [fileData bytes], [fileData length]);
        if( [fileData length]==0 ) done=YES;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString *filemd5 = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0], digest[1],
                   digest[2], digest[3],
                   digest[4], digest[5],
                   digest[6], digest[7],
                   digest[8], digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    return filemd5;
}




@end
