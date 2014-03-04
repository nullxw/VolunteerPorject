//
//  DistrictModel.h
//  VolunteerApp
//
//  Created by 邹泽龙 on 14-2-28.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "ZZLBaseJsonObject.h"

@interface DistrictModel : ZZLBaseJsonObject

@property (nonatomic,strong) NSString * districtName;

@property (nonatomic,strong) NSString * districtId;

@property (nonatomic)        int        districtLevel;
@end
