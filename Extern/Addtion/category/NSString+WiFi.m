//
//  NSString+WiFi.m
//  FastTransfer
//
//  Created by xiaogaochao on 13-6-19.
//  Copyright (c) 2013年 richinfo. All rights reserved.
//

#import "NSString+WiFi.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <arpa/inet.h>
#include <ifaddrs.h>
#include <net/if.h>
#import "NSStringAddition.h"
#define VOLUNTEER_SYS_WEBSERVICE_RC4_KEY @"4387ABD38950D78E7D55A6095CCBBFB3"

//TT_FIX_CATEGORY_BUG(WiFiAdditions)

@implementation NSString (WiFi)

+ (NSString*)getWiFiIPAddress
{
    NSString *localIP=nil;
    struct ifaddrs *addrs;
    if(getifaddrs(&addrs)==0)
    {
        const struct ifaddrs *cursor = addrs;
        while (cursor!=NULL)
        {
            if(cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
            {
                NSString *name=[NSString stringWithUTF8String:cursor->ifa_name];
                if([name isEqualToString:@"en0"])
                {
                    localIP=[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
                    NSLog(@"%@",localIP);
                    break;
                }
            }
            cursor=cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return localIP;
}

+ (NSString*)getDeviceSSID
{
    NSArray *ifs = (id)CNCopySupportedInterfaces();
    
    id info = nil;
    
    for (NSString *ifnam in ifs) {
        
        info = (id)CNCopyCurrentNetworkInfo((CFStringRef)ifnam);
        
        if (info && [info count]) {
            break;
        }
    }
    
    NSDictionary *dctySSID = (NSDictionary *)info;
    
    NSString *ssid = [[dctySSID objectForKey:@"SSID"] lowercaseString];
    
    return ssid;
}

+ (NSString*)getDeviceName:(NSString*)serverName
{
    NSRange pos=[serverName rangeOfString:@"-" options:NSBackwardsSearch];
    if(pos.length>0)
    {
        NSString *deviceName=[serverName substringToIndex:pos.location];
        return deviceName;
    }
    return nil;
}

- (NSDate*)dateWithFormate:(NSString*) formate {
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init]autorelease];
	[formatter setDateFormat:formate];
	NSDate *date = [formatter dateFromString:self];
	return date;
}


- (NSString *)stringWithRC4
{
    NSString *base64Str = [NSString encodeBase64:self];
    NSString *rc4Str = [self rc4Key:VOLUNTEER_SYS_WEBSERVICE_RC4_KEY str:base64Str];

    NSString *hexStr = [[self stringToHexString:rc4Str] uppercaseString];
    
    return hexStr;
}
-(NSString *)stringByEncodeingRC4{
    

    

    NSString *str = [NSString encodeBase64:self];
    NSLog(@"base64 str :%@",str);
    unsigned char s[256] = {0};
    char key[256] = {"4387ABD38950D78E7D55A6095CCBBFB3"};
    rc4_init(s,(unsigned char *)key,strlen(key));
    const char *cstr = [str UTF8String];
    char pData[256] = {0};
    
    for (int i=0; i<strlen(cstr); i++) {
        pData[i] = cstr[i];
    }
    
    rc4_crypt(s,(unsigned char *)pData,strlen(pData));//加密
    printf("cstr :%s\n",pData);
    
    
    NSData *data = [NSData dataWithBytes:pData length:strlen(pData)];
    
    NSString *hexStr = [[self hexStringFromData:data] uppercaseString];
    return hexStr;
}
- (NSString *)hexStringFromData:(NSData *)string{

    //下面是Byte 转换为16进制。
    
    Byte *bytes = (Byte *)[string bytes];
    NSString *hexStr=@"";
    for(int i=0;i<[string length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

- (NSString *)stringByDeCodeingRC4
{
    NSString *str = [NSString stringFromHexString:self];
    
    unsigned char s[256] = {0};
    char key[256] = {"4387ABD38950D78E7D55A6095CCBBFB3"};
    rc4_init(s,(unsigned char *)key,strlen(key));
    const char *cstr = [str UTF8String];
    char pData[256] = {0};
    
    for (int i=0; i<strlen(cstr); i++) {
        pData[i] = cstr[i];
    }
    
    rc4_crypt(s,(unsigned char *)pData,strlen(pData));//加密
    NSData *data = [NSData dataWithBytes:pData length:strlen(pData)];
    
    NSString *basestr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSString *decodeStr = [NSString decodeBase64:basestr];
    
    return decodeStr;
    
}
// 十六进制转换为普通字符串的。
+(NSString *)stringFromHexString:(NSString *)hexString { //
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr] ;
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    NSLog(@"------字符串=======%@",unicodeString);
    return unicodeString;
    
    
}
- (NSString *)stringByRc4
{
    NSString *rc4Str = [self rc4Key:VOLUNTEER_SYS_WEBSERVICE_RC4_KEY str:self];
    
    NSString *hexStr = [self stringToHexString:rc4Str];
    
    return hexStr;
}
- (NSString *)stringToHexString:(NSString *)test
{
    NSString *str = @"";
    for (int i=0; i<test.length; i++) {
        
        int ch = (int)[test characterAtIndex:i];
        str = [str stringByAppendingString:[self ToHex:ch]];
    }
    return str;
}

//将十进制转化为十六进制
- (NSString *)ToHex:(uint16_t)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    uint16_t ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:
                nLetterValue = [NSString stringWithFormat:@"%u",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
        
    }
    return str;
}





-(NSString *) rc4Key:(NSString*) key str:(NSString*) str
{
    int j = 0;
    unichar res[str.length];
    const unichar* buffer = res;
    unsigned char s[256];
    for (int i = 0; i < 256; i++)
    {
        s[i] = i;
    }
    for (int i = 0; i < 256; i++)
    {
        j = (j + s[i] + [key characterAtIndex:(i % key.length)]) % 256;
        unsigned char tmp = s[i];
        s[i] = s[j];
        s[j] = tmp;
    }
    
    int i = j = 0;
    
    for (int z = 0; z < str.length; z++)
    {
        i = (i + 1) % 256;
        j = (j + s[i]) % 256;
        unsigned char tmp = s[i];
        s[i] = s[j];
        s[j] = tmp;
        
        unsigned char f = [str characterAtIndex:z] ^ s[ (s[i] + s[j]) % 256];
        res[z] = f;
    }
    return [NSString stringWithCharacters:buffer length:str.length];
}
typedef unsigned long ULONG;
void rc4_init(unsigned char *s, unsigned char *key, unsigned long Len) //初始化函数
{
    int i =0, j = 0;
    char k[256] = {0};
    unsigned char tmp = 0;
    for(i=0;i<256;i++)
    {
        s[i]=i;
        k[i]=key[i%Len];
    }
    for (i=0; i<256; i++)
    {
        j=(j+s[i]+k[i])%256;
        tmp = s[i];
        s[i] = s[j]; //交换s[i]和s[j]
        s[j] = tmp;
    }
}
void rc4_crypt(unsigned char *s, unsigned char *Data, unsigned long Len) //加解密
{
    int i = 0, j = 0, t = 0;
    unsigned long k = 0;
    unsigned char tmp;
    for(k=0;k<Len;k++)
    {
        i=(i+1)%256;
        j=(j+s[i])%256;
        tmp = s[i];
        s[i] = s[j]; //交换s[x]和s[y]
        s[j] = tmp;
        t=(s[i]+s[j])%256;
        Data[k] ^= s[t];
    }
}


// 十六进制转换为普通字符串的。
- (NSString *)stringFromHexString:(NSString *)hexString {  //
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[[NSScanner alloc] initWithString:hexCharStr] autorelease];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    NSLog(@"------字符串=======%@",unicodeString);
    return unicodeString;
    
    
}

@end
