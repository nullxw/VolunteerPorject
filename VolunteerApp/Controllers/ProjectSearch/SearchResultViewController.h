//
//  SearchResultViewController.h
//  VolunteerApp
//
//  Created by zelong zou on 14-3-3.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchResultViewController : BaseViewController




@property (nonatomic,strong)  NSString *key;
@property (nonatomic,strong)  NSString *userId;
@property (nonatomic,strong)  NSString *startDate;
@property (nonatomic,strong)  NSString *endDate;
@property (nonatomic)  int distrubutetype;
@property (nonatomic)  int typeindex;
@property (nonatomic,strong)  NSMutableArray *list;
@end
