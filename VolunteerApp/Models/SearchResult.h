//
//  SearchResult.h
//  VolunteerApp
//
//  Created by zelong zou on 14-3-3.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "ZZLBaseJsonObject.h"

@interface SearchResult : ZZLBaseJsonObject
@property (nonatomic,strong) NSString * subject;

@property (nonatomic)        int        isAllowJoin;

@property (nonatomic,strong) NSString * endDateString;

@property (nonatomic)        int        missionId;

@property (nonatomic,strong) NSString * summary;

@property (nonatomic,strong) NSString * startDateString;

@property (nonatomic,strong) NSString * state;

@property (nonatomic)        int        isJoined;
@end
