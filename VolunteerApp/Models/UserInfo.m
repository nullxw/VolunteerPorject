//
//  UserInfo.m
//  VolunteerApp
//
//  Created by zelong zou on 14-2-24.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

static UserInfo *shareInstance = nil;
+(id)share
{
    if (!shareInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            shareInstance = [[[self class]alloc]init];
            
        });
        
    }
    return shareInstance;
}
- (void)setup
{
    self.shouldAutoLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"shouldAutoLogin"]boolValue];
    self.shouldSavePwd = [[[NSUserDefaults standardUserDefaults] objectForKey:@"shouldSave"]boolValue];
    NSString *temp1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"mycache1"];
    self.locaUserName = [NSString decodeBase64:temp1];
    if (self.shouldSavePwd || self.shouldAutoLogin) {
        
        
        NSString *temp2 = [[NSUserDefaults standardUserDefaults] objectForKey:@"mycache2"];
        self.locaPwd = [NSString decodeBase64:temp2];
    }else{
        return;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)handleSuccessLogin
{
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:self.shouldSavePwd] forKey:@"shouldSave"];
    [[NSUserDefaults standardUserDefaults ]setObject:[NSNumber numberWithBool:self.shouldAutoLogin] forKey:@"shouldAutoLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
    if (self.shouldAutoLogin) {
        
         [self saveAccount];
        
    }else{
        if (self.shouldSavePwd) {
            [self saveAccount];
        }else{
            [self removePwd];
        }
    }
    

}
- (void)removePwd
{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mycache2"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
- (void)savePwd
{
    if (self.locaPwd.length>0) {
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString encodeBase64:self.locaPwd] forKey:@"mycache2"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
   
}
- (void)saveLocalUserName
{
    if (self.locaUserName.length>0) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString encodeBase64:self.locaUserName] forKey:@"mycache1"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
- (void)removeLocalUserName
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mycache1"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
- (void)saveAccount
{
    [self saveLocalUserName];
    [self savePwd];
}
- (void)removeAccount
{
    [self removePwd];

}

- (void)updateUserInfoWithDic:(NSDictionary *)dic
{
    /*
     areaId = 8e9715d3444dd11701444dd446fa0008;
     areaName = "\U5730\U5e02";
     email = "123456@qq.com";
     gender = 1;
     head = "";
     idcardCode = bjjtgw;
     idcardType = 0;
     integral = 0;
     mobile = 123456;
     politicalStatus = 0;
     purview = "";
     queryPurview = 1;
     serviceTime = 0;
     token = "";
     userId = bba9a7e236f8858c01370b74946a0082;
     userName = "\U5317\U4eac\U8857\U56e2\U5de5\U59d4";
     userPwd = "";
     userPwdNew = "";
     vvalue = 0;
     */
    self.areaId = [dic objectForKey:@"areaId"];
    self.areaName = [dic objectForKey:@"areaName"];
    self.idcardType = [[dic objectForKey:@"idcardType"]integerValue];
    self.email = [dic objectForKey:@"email"];
    self.gender = [[dic objectForKey:@"gender"]integerValue];
    self.head = [dic objectForKey:@"head"];
    self.idcardCode =[dic objectForKey:@"idcardCode"];
    self.integral = [[dic objectForKey:@"integral"]integerValue];
    self.mobile = [dic objectForKey:@"mobile"];
    self.politicalStatus = [[dic objectForKey:@"politicalStatus"]integerValue];
    self.purview = [dic objectForKey:@"purview"];
    self.queryPurview = [dic objectForKey:@"queryPurview"];
    self.serviceTime = [[dic objectForKey:@"serviceTime"]integerValue];
    self.userId = [dic objectForKey:@"userId"];
    self.userName = [dic objectForKey:@"userName"];
    self.vvalue = [[dic objectForKey:@"vvalue"]integerValue];
    
    self.verifyCode = [dic objectForKey:@"verifyCode"];
    self.createDate = [dic objectForKey:@"createDate"];

}
- (BOOL)isManager
{
    return  [self.purview isEqualToString:@"MANAGER_SHOW"];
}
- (BOOL)isLeader
{
    return  [self.purview isEqualToString:@"LEADER_SHOW"];
}
- (void)clear
{
    self.areaId = @"";
    self.areaName = @"";
    self.idcardType = 0;
    self.email = @"";
    self.gender = 0;
    self.head = @"";
    self.idcardCode =@"";
    self.integral = 0;
    self.mobile = @"";
    self.politicalStatus = 0;
    self.purview = @"";
    self.queryPurview = @"";
    self.serviceTime = 0;
    self.userId = @"";
    self.userName = @"";
    self.vvalue = 0;
    
    self.verifyCode = @"";
    self.createDate = @"";
    [self removePassWord];
}
- (void)removePassWord
{
    [self removePwd];
}
@end
