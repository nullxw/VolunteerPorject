//
//  UserInfo.h
//  VolunteerApp
//
//  Created by zelong zou on 14-2-24.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "ZZLBaseJsonObject.h"

@interface UserInfo : ZZLBaseJsonObject
@property (nonatomic) int  integral;

@property (nonatomic,strong) NSString * areaName;

@property (nonatomic)  int serviceTime;

@property (nonatomic,strong) NSString * head;

@property (nonatomic,strong) NSString * queryPurview;

@property (nonatomic,strong) NSString * userId;

@property (nonatomic,strong) NSString * mobile;

@property (nonatomic,strong) NSString * purview;

@property (nonatomic,strong) NSString * idcardCode;

@property (nonatomic) int  politicalStatus;

@property (nonatomic,strong) NSString * email;

@property (nonatomic,strong) NSString * userName;

@property (nonatomic,strong) NSString * userPwd;

@property (nonatomic,strong) NSString * userPwdNew;

@property (nonatomic,strong) NSString * token;

@property (nonatomic) int gender;

@property (nonatomic) int  vvalue;

@property (nonatomic) int  idcardType;

@property (nonatomic,strong) NSString * areaId;

@property (nonatomic) BOOL shouldAutoLogin;

@property (nonatomic) BOOL shouldSavePwd;

@property (nonatomic,strong) NSString * locaPwd;

@property (nonatomic,strong) NSString * locaUserName;

+(id)share;

- (BOOL)isManager;
- (BOOL)isLeader;
- (void)handleSuccessLogin;

- (void)setup;
- (void)updateUserInfoWithDic:(NSDictionary *)dic;

- (void)updateNewPwd;
@end
