//
//  VolunInfo.h
//  VolunteerApp
//
//  Created by zelong zou on 14-3-17.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "ZZLBaseJsonObject.h"

@interface VolunInfo : ZZLBaseJsonObject
@property (nonatomic)        int        browseCount;

@property (nonatomic,strong) NSString * pageCtx;

@property (nonatomic,strong) NSString * pageNo;

@property (nonatomic,strong) NSString * addDate;

@property (nonatomic,strong) NSString * pageTile;
@end
