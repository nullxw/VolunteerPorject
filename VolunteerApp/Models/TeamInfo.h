//
//  TeamInfo.h
//  VolunteerApp
//
//  Created by zelong zou on 14-3-21.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "ZZLBaseJsonObject.h"

@interface TeamInfo : ZZLBaseJsonObject
@property (nonatomic,strong) NSString * _leaderId;

@property (nonatomic,strong) NSString * _missionName;

@property (nonatomic)        int        _teamPid;

@property (nonatomic)        int        _missionId;

@property (nonatomic,strong) NSString * missionTeamname;

@property (nonatomic,strong) NSString * _createTime;

@property (nonatomic)        int        teamLevel;

@property (nonatomic,strong) NSString * _leaderName;

@property (nonatomic)        int        count;

@property (nonatomic)        int        missionTeamId;
@end
