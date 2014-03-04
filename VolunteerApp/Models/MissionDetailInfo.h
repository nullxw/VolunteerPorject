//
//  MissionDetailInfo.h
//  VolunteerApp
//
//  Created by zelong zou on 14-2-27.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "ZZLBaseJsonObject.h"

@interface MissionDetailInfo : ZZLBaseJsonObject
@property (nonatomic)        int        isJoined;

@property (nonatomic,strong) NSString * venueAddress;

@property (nonatomic,strong) NSString * districtName;

@property (nonatomic,strong) NSString * contactPhone;

@property (nonatomic,strong) NSString * applyDeadlineString;

@property (nonatomic)        int        isAllowJoin;

@property (nonatomic,strong) NSString * state;

@property (nonatomic,strong) NSString * detailInfo;

@property (nonatomic,strong) NSString * summary;

@property (nonatomic,strong) NSString * startDateString;

@property (nonatomic,strong) NSString * endDateString;

@property (nonatomic,strong) NSString * subject;

@property (nonatomic,strong) NSString * contactName;

@property (nonatomic,strong) NSString * venue;
@end
