//
//  UserAttend.h
//  VolunteerApp
//
//  Created by zelong zou on 14-3-21.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "ZZLBaseJsonObject.h"

@interface UserAttend : ZZLBaseJsonObject
@property (nonatomic)        int        totalIntegral;

@property (nonatomic)        int        _teamId;

@property (nonatomic)        int        noSureLogCount;

@property (nonatomic,strong) NSString * userId;

@property (nonatomic,strong) NSString * _userName;

@property (nonatomic)        int        _missionId;

@property (nonatomic,strong) NSString * _endDatetime;

@property (nonatomic)        int        sureLogCount;

@property (nonatomic,strong) NSString * _checkOnDate;

@property (nonatomic,strong) NSString * _startDatetime;

@property (nonatomic)        int        isUpdated;

@property (nonatomic)        int        missionServiceLogId;

@property (nonatomic)        int        serviceMinute;

@property (nonatomic,strong) NSString * missionName;
@end
