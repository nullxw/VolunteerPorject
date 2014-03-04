//
//  ClassPlanInfo.h
//  VolunteerApp
//
//  Created by 邹泽龙 on 14-2-28.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "ZZLBaseJsonObject.h"

@interface ClassPlanInfo : ZZLBaseJsonObject


@property (nonatomic,strong) NSString * startdate;

@property (nonatomic,strong) NSString * enddate;

@property (nonatomic)        int        personUpperLimit;

@property (nonatomic)        int        rangeType;

@property (nonatomic,strong) NSString * planName;

@property (nonatomic)        int        flightType;

@property (nonatomic,strong) NSString * endtime;

@property (nonatomic,strong) NSString * starttime;

@property (nonatomic,strong) NSString * caption;

@property (nonatomic)        int        planId;


@end
