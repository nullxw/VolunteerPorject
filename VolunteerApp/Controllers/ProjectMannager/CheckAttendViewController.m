//
//  CheckAttendViewController.m
//  VolunteerApp
//
//  Created by zelong zou on 14-3-20.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "CheckAttendViewController.h"
#import "MyTableView.h"
#import "MyTabView.h"
#import "HandAttendCell.h"
#import "UserAttend.h"
#import "HandAttendViewController.h"
@interface CheckAttendViewController () <MyTabViewDelegate,UITableViewDataSource,UITableViewDelegate,HandAttendCellDelegate>
{
    UIScrollView *scrollView;
    MyTableView  *firstTable;
    MyTableView  *secondTable;
    MyTableView  *thridTable;
    MyTableView  *fourthTable;
    
    UIButton     *curBtn;
    UInt16       curpage;
    
    
    
    NSMutableArray  *firstList;
    NSMutableArray  *secondList;
    NSMutableArray  *thridList;
    NSMutableArray  *fourthList;
    
    int             missionId;
    int             teamId;
    NSString        *checkDate;
}
@end

@implementation CheckAttendViewController



- (void)setmissionId:(int)mid
{
    missionId = mid;
}
#pragma mark - view Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleWithString:@"考勤管理"];
    
    MyTabView *tabView = [[MyTabView alloc]initWithFrame:CGRectMake(0, self.navView.bottom, self.view.width, 44) delegate:self];
    
    [self.view addSubview:tabView];
    
    firstList = [[NSMutableArray alloc]init];
    secondList = [[NSMutableArray alloc]init];
    thridList = [[NSMutableArray alloc]init];
    fourthList = [[NSMutableArray alloc]init];
    
    
    scrollView  = [[UIScrollView alloc]initWithFrame:CGRectMake(0,tabView.bottom,self.view.width,self.view.height-tabView.bottom)];
    scrollView.contentSize = CGSizeMake(3*scrollView.width, scrollView.height);
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator   = YES;
    scrollView.bounces                        = YES;
    scrollView.pagingEnabled                  = YES;
    
    
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
    scrollView.scrollEnabled = NO;
    
    firstTable                                = [[MyTableView alloc]
                                                 initWithFrame:
                                                 scrollView.bounds
                                                 style:
                                                 UITableViewStylePlain];
    firstTable.backgroundColor =[UIColor clearColor];
    firstTable.dataSource                     = self;
    firstTable.delegate                       = self;
    firstTable.separatorStyle                 = UITableViewCellSeparatorStyleNone;
    
    
    
    firstTable.list = firstList;
    [self.view insertSubview:scrollView belowSubview:tabView];
    [scrollView addSubview:firstTable];
    
    
    curBtn.selected = YES;
    
    
    
    
    
    
    __weak CheckAttendViewController *weakSelf = self;
    [firstTable addPullToRefreshWithActionHandler:^{
        
        [weakSelf refreshFristData];
    }];
    
    
    [firstTable addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadFristMore];
    }];
    firstTable.infiniteScrollingView.enabled = NO;
    
    
    secondTable = [[MyTableView alloc]initWithFrame:scrollView.bounds style:UITableViewStylePlain];
    secondTable.backgroundColor = [UIColor clearColor];
    secondTable.dataSource = self;
    secondTable.delegate = self;
    secondTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    secondTable.list = secondList;
    secondTable.left = firstTable.width;
    scrollView.contentSize = CGSizeMake(2*scrollView.width, scrollView.height);
    [scrollView addSubview:secondTable];
    
    
    [secondTable addPullToRefreshWithActionHandler:^{
        [weakSelf refreshSecondData];
    }];
    [secondTable addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadSecondMore];
    }];
    secondTable.infiniteScrollingView.enabled = NO;
    
    thridTable = [[MyTableView alloc]initWithFrame:scrollView.bounds style:UITableViewStylePlain];
    thridTable.backgroundColor = [UIColor clearColor];
    thridTable.dataSource = self;
    thridTable.delegate = self;
    thridTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    thridTable.left = scrollView.width*2;
    thridTable.list = thridList;
    [scrollView addSubview:thridTable];
    
    [thridTable addPullToRefreshWithActionHandler:^{
        [weakSelf refreshThridData];
    }];
    
    [thridTable addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadThridMore];
    }];
    thridTable.infiniteScrollingView.enabled = NO;
    
    
    fourthTable = [[MyTableView alloc]initWithFrame:scrollView.bounds style:UITableViewStylePlain];
    fourthTable.backgroundColor = [UIColor clearColor];
    fourthTable.dataSource = self;
    fourthTable.delegate = self;
    fourthTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    fourthTable.left = scrollView.width*3;
    fourthTable.list = fourthList;
    [scrollView addSubview:fourthTable];
    
    [fourthTable addPullToRefreshWithActionHandler:^{
        [weakSelf refreshFourthData];
    }];
    
    [fourthTable addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadFourthMore];
    }];
    fourthTable.infiniteScrollingView.enabled = NO;
    
    [firstTable triggerPullToRefresh];
}
- (void)setupMissionId:(int)mid date:(NSString *)date teamId:(int)tid
{
    missionId  = mid;
    checkDate = date;
    teamId = tid;
}
- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
- (void)refreshFristData
{
    [self refreshDataWithTableView:firstTable];
}
- (void)refreshSecondData
{
    [self refreshDataWithTableView:secondTable];
    
}
- (void)refreshThridData
{
    [self refreshDataWithTableView:thridTable];
}
- (void)loadFristMore
{
    [self loadMoreWithTableView:firstTable];
}
- (void)loadSecondMore
{
    [self loadMoreWithTableView:secondTable];
}
- (void)loadThridMore
{
    [self loadMoreWithTableView:thridTable];
}

- (void)refreshFourthData
{
    [self refreshDataWithTableView:fourthTable];
}
- (void)loadFourthMore
{
    [self loadMoreWithTableView:fourthTable];
}

#pragma mark -  networkData


- (void)refreshDataWithTableView:(MyTableView *)curTableView
{
    
    
    [curTableView removeCenterMsgView];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_global_queue(0, 0), ^(void){
        
        UserInfo *user = [UserInfo share];
        
        NSString *str =@"暂无数据";
        
        if (curTableView == firstTable) {
            [[ZZLHttpRequstEngine engine]requestTeamAttendanceWaitCheckListWithUid:user.userId checkOnDate:checkDate missionid:missionId teamID:teamId pageSize:curTableView.pageSize pageIndex:curTableView.pageIndex onSuccess:^(id responseObject) {
                curTableView.hasRequest = YES;
                [curTableView.pullToRefreshView stopAnimating];
                NSLog(@"___YYY__%@",responseObject);
                if ([responseObject isKindOfClass:[NSArray class]]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                        int itemCount = [responseObject count];
                        if (itemCount == 0 ) {
                            if ([curTableView.list count]==0) {
                                [curTableView reloadData];
                                [curTableView addCenterMsgView:str];
                            }else{
                                [curTableView.pullToRefreshView stopAnimating];
                            }
                            return ;
                            
                        }else{
                            [curTableView removeCenterMsgView];
                            if ([curTableView.list count] > 0) {
                                [curTableView.list removeAllObjects];
                                
                                curTableView.pageIndex = 1;
                                
                            }
                            for (int i=0; i<itemCount; i++) {
                                NSMutableDictionary *dic = responseObject[i];
                                UserAttend *info = [UserAttend JsonModalWithDictionary:dic];
                                [curTableView.list addObject:info];
                                
                            }
                            [curTableView reloadData];
                            
                            
                            if (itemCount%curTableView.pageSize == 0) {
                                curTableView.infiniteScrollingView.enabled = YES;
                            }
                            
                        }
                        
                    }) ;
                }
                
            } onFail:^(NSError *erro) {
                NSLog(@"___xxx___%@",[erro.userInfo objectForKey:@"description"]);
                
                
                
                [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
                [curTableView.pullToRefreshView stopAnimating];
                [curTableView removeCenterMsgView];
            }];
        }else if (curTableView == secondTable)
        {
            [[ZZLHttpRequstEngine engine]requestTeamAttendanceWaitCheckOutListWithUid:user.userId checkOnDate:checkDate missionid:missionId teamID:teamId pageSize:curTableView.pageSize pageIndex:curTableView.pageIndex onSuccess:^(id responseObject) {
                curTableView.hasRequest = YES;
                [curTableView.pullToRefreshView stopAnimating];
                NSLog(@"___YYY__%@",responseObject);
                if ([responseObject isKindOfClass:[NSArray class]]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                        int itemCount = [responseObject count];
                        if (itemCount == 0 ) {
                            if ([curTableView.list count]==0) {
                                [curTableView reloadData];
                                [curTableView addCenterMsgView:str];
                            }else{
                                [curTableView.pullToRefreshView stopAnimating];
                            }
                            return ;
                            
                        }else{
                            [curTableView removeCenterMsgView];
                            if ([curTableView.list count] > 0) {
                                [curTableView.list removeAllObjects];
                                
                                curTableView.pageIndex = 1;
                                
                            }
                            for (int i=0; i<itemCount; i++) {
                                NSMutableDictionary *dic = responseObject[i];
                                UserAttend *info = [UserAttend JsonModalWithDictionary:dic];
                                [curTableView.list addObject:info];
                                
                            }
                            [curTableView reloadData];
                            
                            
                            if (itemCount%curTableView.pageSize == 0) {
                                curTableView.infiniteScrollingView.enabled = YES;
                            }
                            
                        }
                        
                    }) ;
                }
                
            } onFail:^(NSError *erro) {
                NSLog(@"___xxx___%@",[erro.userInfo objectForKey:@"description"]);
                
                
                
                [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
                [curTableView.pullToRefreshView stopAnimating];
                [curTableView removeCenterMsgView];
            }];
        }else
        {
            int isupdate =0;
            if (curTableView == fourthTable) {
                isupdate = 1;
            }
            
            [[ZZLHttpRequstEngine engine]requestTeamAttendanceDidCheckOutWithUid:user.userId checkOnDate:checkDate missionid:missionId teamID:teamId isUpdate:isupdate pageSize:curTableView.pageSize pageIndex:curTableView.pageIndex onSuccess:^(id responseObject) {
                curTableView.hasRequest = YES;
                [curTableView.pullToRefreshView stopAnimating];
                NSLog(@"___YYY__%@",responseObject);
                if ([responseObject isKindOfClass:[NSArray class]]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                        int itemCount = [responseObject count];
                        if (itemCount == 0 ) {
                            if ([curTableView.list count]==0) {
                                [curTableView reloadData];
                                [curTableView addCenterMsgView:str];
                            }else{
                                [curTableView.pullToRefreshView stopAnimating];
                            }
                            return ;
                            
                        }else{
                            [curTableView removeCenterMsgView];
                            if ([curTableView.list count] > 0) {
                                [curTableView.list removeAllObjects];
                                
                                curTableView.pageIndex = 1;
                                
                            }
                            for (int i=0; i<itemCount; i++) {
                                NSMutableDictionary *dic = responseObject[i];
                                UserAttend *info = [UserAttend JsonModalWithDictionary:dic];
                                [curTableView.list addObject:info];
                                
                            }
                            [curTableView reloadData];
                            
                            
                            if (itemCount%curTableView.pageSize == 0) {
                                curTableView.infiniteScrollingView.enabled = YES;
                            }
                            
                        }
                        
                    }) ;
                }
                
            } onFail:^(NSError *erro) {
                NSLog(@"___xxx___%@",[erro.userInfo objectForKey:@"description"]);
                
                
                
                [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
                [curTableView.pullToRefreshView stopAnimating];
                [curTableView removeCenterMsgView];
            }];
        }


        

    });
    
}
- (void)loadMoreWithTableView:(MyTableView *)curTableView
{
    UserInfo *user = [UserInfo share];
    


    

    
    if (curTableView == firstTable) {
        [[ZZLHttpRequstEngine engine]requestTeamAttendanceWaitCheckListWithUid:user.userId checkOnDate:checkDate missionid:missionId teamID:teamId pageSize:curTableView.pageSize pageIndex:curTableView.pageIndex+1 onSuccess:^(id responseDict) {
            
            [curTableView.infiniteScrollingView stopAnimating];
            NSLog(@"___YYY__%@",responseDict);
            if ([responseDict isKindOfClass:[NSArray class]]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    int itemCount = [responseDict count];
                    if (itemCount == 0 ) {
                        
                        curTableView.infiniteScrollingView.enabled = NO;
                    }else{
                        for (int i=0; i<itemCount; i++) {
                            NSMutableDictionary *dic = responseDict[i];
                            UserAttend *info = [UserAttend JsonModalWithDictionary:dic];
                            [curTableView.list addObject:info];
                        }
                        [curTableView reloadData];
                        if (itemCount%curTableView.pageSize == 0) {
                            curTableView.pageIndex++;
                            curTableView.infiniteScrollingView.enabled = YES;
                        }else{
                            curTableView.infiniteScrollingView.enabled = NO;
                        }
                        
                    }
                    
                }) ;
            }
            
        } onFail:^(NSError *erro) {
            NSLog(@"___xxx___%@",[erro.userInfo objectForKey:@"description"]);
            
            
            [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
            [curTableView.infiniteScrollingView stopAnimating];
        }];
    }else if (curTableView == secondTable)
    {
       [[ZZLHttpRequstEngine engine]requestTeamAttendanceWaitCheckOutListWithUid:user.userId checkOnDate:checkDate missionid:missionId teamID:teamId pageSize:curTableView.pageSize pageIndex:curTableView.pageIndex+1 onSuccess:^(id responseDict) {
            
            [curTableView.infiniteScrollingView stopAnimating];
            NSLog(@"___YYY__%@",responseDict);
            if ([responseDict isKindOfClass:[NSArray class]]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    int itemCount = [responseDict count];
                    if (itemCount == 0 ) {
                        
                        curTableView.infiniteScrollingView.enabled = NO;
                    }else{
                        for (int i=0; i<itemCount; i++) {
                            NSMutableDictionary *dic = responseDict[i];
                            UserAttend *info = [UserAttend JsonModalWithDictionary:dic];
                            [curTableView.list addObject:info];
                        }
                        [curTableView reloadData];
                        if (itemCount%curTableView.pageSize == 0) {
                            curTableView.pageIndex++;
                            curTableView.infiniteScrollingView.enabled = YES;
                        }else{
                            curTableView.infiniteScrollingView.enabled = NO;
                        }
                        
                    }
                    
                }) ;
            }
            
        } onFail:^(NSError *erro) {
            NSLog(@"___xxx___%@",[erro.userInfo objectForKey:@"description"]);
            
            
            [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
            [curTableView.infiniteScrollingView stopAnimating];
        }];

    }else{
        int isupadate = 0;
        if (curTableView == fourthTable) {
            isupadate = 1;
        }
        
        
        [[ZZLHttpRequstEngine engine]requestTeamAttendanceDidCheckOutWithUid:user.userId checkOnDate:checkDate missionid:missionId teamID:teamId isUpdate:isupadate pageSize:curTableView.pageSize pageIndex:curTableView.pageIndex+1 onSuccess:^(id responseDict) {
            
            [curTableView.infiniteScrollingView stopAnimating];
            NSLog(@"___YYY__%@",responseDict);
            if ([responseDict isKindOfClass:[NSArray class]]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    int itemCount = [responseDict count];
                    if (itemCount == 0 ) {
                        
                        curTableView.infiniteScrollingView.enabled = NO;
                    }else{
                        for (int i=0; i<itemCount; i++) {
                            NSMutableDictionary *dic = responseDict[i];
                            UserAttend *info = [UserAttend JsonModalWithDictionary:dic];
                            [curTableView.list addObject:info];
                        }
                        [curTableView reloadData];
                        if (itemCount%curTableView.pageSize == 0) {
                            curTableView.pageIndex++;
                            curTableView.infiniteScrollingView.enabled = YES;
                        }else{
                            curTableView.infiniteScrollingView.enabled = NO;
                        }
                        
                    }
                    
                }) ;
            }
            
        } onFail:^(NSError *erro) {
            NSLog(@"___xxx___%@",[erro.userInfo objectForKey:@"description"]);
            
            
            [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
            [curTableView.infiniteScrollingView stopAnimating];
        }];

    }
    

}

#pragma mark -
#pragma mark - tableviewDelegate,tableviewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTableView *curTableView = (MyTableView *)tableView;
    if ( [curTableView.list count]>0) {
        HandAttendCell *cell = [HandAttendCell cellForTableView:curTableView fromNib:[HandAttendCell nib]];
        cell.delegate = self;

        int len = 2;
        if ((indexPath.row+1)*2>curTableView.list.count) {
            len = 1;
        }
        NSRange range = NSMakeRange(indexPath.row*2, len);
        NSArray *array = [curTableView.list subarrayWithRange:range];
    
        [cell setupWithUserAttendInfo:array index:indexPath.row*2];


        return cell;
    }else{
        return nil;
    }
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MyTableView *curTableView = (MyTableView *)tableView;
    if (curTableView.list.count%2 == 0) {
        return curTableView.list.count/2;
    }else{
        return curTableView.list.count/2+1;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [HandAttendCell cellHeight];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
}

#pragma mark -
- (void)MytableView:(MyTabView *)tabView moveAtIndex:(int)index
{
    [scrollView setContentOffset:CGPointMake(index*scrollView.width, 0) animated:YES];
    curpage = index;
    if (index == 1 && secondList.count == 0) {
        
        [secondTable triggerPullToRefresh];
    }
    if (index == 0 && firstList.count == 0) {
        [firstTable triggerPullToRefresh];
    }
    if (index == 2 && thridList.count == 0) {
        [thridTable triggerPullToRefresh];
    }
    if (index == 3 && fourthList.count == 0) {
        [fourthTable triggerPullToRefresh];
    }
    
}
- (NSArray *)MyTabViewTitleForTabView:(MyTabView *)tabview
{
    return @[@"待签到",@"待签出",@"未确认",@"已确认"];
}


- (void)HandAttendCellDelegate:(HandAttendCell *)cell actionWithIndex:(NSInteger)index
{
    NSLog(@"inndex is :<%d>  ",index);

    MyTableView *temp ;
    if (curpage == 0) {
        temp =firstTable;
    }else if (curpage == 1)
    {
        temp =secondTable;
    }else if (curpage == 2)
    {
        temp =thridTable;
    }else if (curpage == 3)
    {
        temp =fourthTable;
    }
    
    UserAttend *tempInfo = [temp.list objectAtIndex:index];
    HandAttendViewController *vc = [HandAttendViewController ViewContorller];
    vc.attendInfo = tempInfo;
    [self.flipboardNavigationController pushViewController:vc];
}
@end
