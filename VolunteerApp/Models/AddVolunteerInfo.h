//
//  AddVolunteerInfo.h
//  VolunteerApp
//
//  Created by zelong zou on 14-3-19.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "ZZLBaseJsonObject.h"

@interface AddVolunteerInfo : ZZLBaseJsonObject
@property (nonatomic)        int        integral;

@property (nonatomic,strong) NSString * areaName;

@property (nonatomic)        int        serviceTime;

@property (nonatomic)        int        queryPurview;

@property (nonatomic,strong) NSString * head;

@property (nonatomic,strong) NSString * userId;

@property (nonatomic,strong) NSString * mobile;

@property (nonatomic,strong) NSString * purview;

@property (nonatomic,strong) NSString * idcardCode;

@property (nonatomic)        int        politicalStatus;

@property (nonatomic,strong) NSString * email;

@property (nonatomic,strong) NSString * userName;

@property (nonatomic,strong) NSString * userPwd;

@property (nonatomic,strong) NSString * userPwdNew;

@property (nonatomic,strong) NSString * token;

@property (nonatomic)        int        gender;

@property (nonatomic)        int        vvalue;

@property (nonatomic)        int        idcardType;

@property (nonatomic,strong) NSString * areaId;

@property (nonatomic,strong) NSString * verifyCode;

@property (nonatomic,strong) NSString * createDate;
@end
