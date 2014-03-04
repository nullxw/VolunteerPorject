//
//  ProjectInfo.h
//  VolunteerApp
//
//  Created by zelong zou on 14-2-27.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "ZZLBaseJsonObject.h"

@interface ProjectInfo : ZZLBaseJsonObject
@property (nonatomic)        int        stateId;

@property (nonatomic,strong) NSString * mobile;

@property (nonatomic,strong) NSString * startDate;

@property (nonatomic)        int        mission_id;

@property (nonatomic)        int        longitude;

@property (nonatomic,strong) NSString * state;

@property (nonatomic)        int        latitude;

@property (nonatomic,strong) NSString * _userId;

@property (nonatomic)        int        selection;

@property (nonatomic,strong) NSString * userName;

@property (nonatomic)        int        missionPersonlId;

@property (nonatomic,strong) NSString * subject;

@property (nonatomic,strong) NSString * endDate;

@property (nonatomic)        int        _sex;
@end
