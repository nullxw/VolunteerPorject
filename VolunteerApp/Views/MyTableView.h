//
//  MyTableView.h
//  VolunteerApp
//
//  Created by zelong zou on 14-2-26.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZLRequestOperation.h"
#import "SVPullToRefresh.h"
@interface MyTableView : UITableView

@property (nonatomic) int pageSize;
@property (nonatomic) int pageIndex;
@property (nonatomic,strong) NSMutableArray *list;
@property (nonatomic,strong) ZZLRequestOperation *op;
- (void)insertRowAtTopWithCount:(int)count;
- (void)insertRowAtBottomWithCount:(int)count;
@end
