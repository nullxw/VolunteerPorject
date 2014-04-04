//
//  VolunteersViewController.m
//  VolunteerApp
//
//  Created by zelong zou on 14-3-18.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "VolunteersViewController.h"
#import "MyTableView.h"
#import "MyTabView.h"
#import "VolunteersCell.h"
#import "UIAlertView+Blocks.h"
#import "AddVolunViewController.h"

@interface VolunteersViewController ()<MyTabViewDelegate,UITableViewDataSource,UITableViewDelegate,VolunteersCellDelegate>
{
    UIScrollView *scrollView;
    MyTableView  *firstTable;
    MyTableView  *secondTable;
    MyTableView  *thridTable;
    
    UIButton     *curBtn;
    UInt16       curpage;
    UIButton     *rightBtn;
    
    
    
    NSMutableArray  *firstList;
    NSMutableArray  *secondList;
    NSMutableArray  *thridList;
    
    int             missionId;
    BOOL            shouldActive;
}
@end

@implementation VolunteersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)setmissionId:(int)mid active:(BOOL)isActive;
{
    missionId = mid;
    shouldActive = isActive;
}
#pragma mark - view Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleWithString:@"志愿者"];
    
    
    //right btn
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(265, self.navView.bottom - 37, 30, 30);
    [rightBtn setImage:[UIImage imageNamed:@"add_volunteer.png"] forState:UIControlStateNormal];
    
    [rightBtn addTarget:self action:@selector(actionAdd:) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:rightBtn];
    MyTabView *tabView = [[MyTabView alloc]initWithFrame:CGRectMake(0, self.navView.bottom, self.view.width, 44) delegate:self];

    [self.view addSubview:tabView];
    
    firstList = [[NSMutableArray alloc]init];
    secondList = [[NSMutableArray alloc]init];
    thridList = [[NSMutableArray alloc]init];
    
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
    
    
    
    
    
    
    __weak VolunteersViewController *weakSelf = self;
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
    
    
    [firstTable triggerPullToRefresh];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!shouldActive) {
        rightBtn.hidden = YES;
    }
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


#pragma mark -  networkData


- (void)refreshDataWithTableView:(MyTableView *)curTableView
{
    
    
    [curTableView removeCenterMsgView];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_global_queue(0, 0), ^(void){
        
        UserInfo *user = [UserInfo share];
 
        NSString *str =@"";
        NSString *selections = @"";
        if (curTableView == firstTable) {
            
            selections = @"4";
            str = @"暂无新报名的志愿者";
        }else if(curTableView == secondTable)
        {
            
            str = @"暂无录用的志愿者";
            selections = @"1";
        }else{
            
            
            str = @"暂无未录用的志愿者";
            selections = @"0,4";
        }
        
//        pageSize:curTableView.pageSize pageIndex:<#(int)#> onSuccess:<#^(id responseObject)successBlock#> onFail:<#^(NSError *erro)errorBlock#>;
        
        [[ZZLHttpRequstEngine engine]requestRecruitListWithUid:user.userId missionid:missionId userName:@"" moblieno:@"" selections:selections  pageSize:curTableView.pageSize pageIndex:1 onSuccess:^(id responseDict) {
            curTableView.hasRequest = YES;
            [curTableView.pullToRefreshView stopAnimating];
            NSLog(@"___YYY__%@",responseDict);
            if ([responseDict isKindOfClass:[NSArray class]]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    int itemCount = [responseDict count];
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
                            NSMutableDictionary *dic = responseDict[i];
                            RescruitVolunInfo *info = [RescruitVolunInfo JsonModalWithDictionary:dic];
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
    });
    
}
- (void)loadMoreWithTableView:(MyTableView *)curTableView
{
    UserInfo *user = [UserInfo share];
    
    NSString *str =@"";
    NSString *selections = @"";
    if (curTableView == firstTable) {
        
        selections = @"4";
        str = @"暂无新报名的志愿者";
    }else if(curTableView == secondTable)
    {
        
        str = @"暂无录用的志愿者";
        selections = @"1";
    }else{
        
        
        str = @"暂无未录用的志愿者";
        selections = @"0,4";
    }
    
    //        pageSize:curTableView.pageSize pageIndex:<#(int)#> onSuccess:<#^(id responseObject)successBlock#> onFail:<#^(NSError *erro)errorBlock#>;
    
    [[ZZLHttpRequstEngine engine]requestRecruitListWithUid:user.userId missionid:missionId userName:@"" moblieno:@"" selections:selections pageSize:curTableView.pageSize pageIndex:curTableView.pageIndex+1 onSuccess:^(id responseDict) {
        
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
                        RescruitVolunInfo *info = [RescruitVolunInfo JsonModalWithDictionary:dic];
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

#pragma mark -
#pragma mark - tableviewDelegate,tableviewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTableView *curTableView = (MyTableView *)tableView;
    if ( [curTableView.list count]>0) {
        VolunteersCell *cell = [VolunteersCell cellForTableView:curTableView fromNib:[VolunteersCell nib]];
        cell.delegate = self;
        cell.index = indexPath.row;

        
        RescruitVolunInfo *info = [curTableView.list objectAtIndex:indexPath.row];
        [cell setupWithRescruitVolunInfo:info];
        if (!shouldActive) {
            cell.mRescruitBtn.hidden = YES;
            cell.mDeletaBtn.hidden = YES;
        }
        return cell;
    }else{
        return nil;
    }
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MyTableView *curTableView = (MyTableView *)tableView;
    return [curTableView.list count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [VolunteersCell cellHeight];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    

    
    
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

}
- (NSArray *)MyTabViewTitleForTabView:(MyTabView *)tabview
{
    return @[@"新报名",@"已录用",@"未录用"];
}

#pragma mark - 
//delete
- (void)VolunteersCell:(VolunteersCell *)cell actionDel:(UIButton *)attend
{
 
    UserInfo *user = [UserInfo share];
    
    NSMutableArray *tempList;
    MyTableView    *curTable;
    if (curpage == 0) {
        tempList = firstList;
        curTable = firstTable;
    }else if (curpage == 1)
    {
        curTable = secondTable;
        tempList = secondList;
    }else if (curpage == 2)
    {
        curTable = thridTable;
        tempList = thridList;
    }
    
    
    RescruitVolunInfo *info = tempList[cell.index];
    
    [UIAlertView  showAlertViewWithTitle:@"您确认要删除该志愿者吗" message:@"" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] onDismiss:^(int btnIndex) {
        [[ZZLHttpRequstEngine engine]requestRecruitDelPersonWithUid:user.userId personaIdGroups:[NSString stringWithFormat:@"%d",info.missionPersonlId] missionId:missionId onSuccess:^(id responseObject) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [tempList removeObject:info];
                [curTable reloadData];
                [self.view showHudMessage:@"删除成功!"];
            });
            
            
        } onFail:^(NSError *erro) {
            [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
            
        }];
    } onCancel:^{
        
    }];

}
//rescruit
- (void)VolunteersCell:(VolunteersCell *)cell actionRescruit:(UIButton *)rescruit
{
    UserInfo *user = [UserInfo share];
    
    NSMutableArray *tempList;
    if (curpage == 0) {
        tempList = firstList;
    }else if (curpage == 1)
    {
        tempList = secondList;
    }else if (curpage == 2)
    {
        tempList = thridList;
    }
//    [NSString stringWithFormat:@"%d",info.missionPersonlId]
    
    
    

    
    RescruitVolunInfo *info = tempList[cell.index];
    
        [[ZZLHttpRequstEngine engine]requestRecruitHirePersonWithUid:user.userId personaIdGroups:[NSString stringWithFormat:@"%d",info.missionPersonlId] missionId:missionId onSuccess:^(id responseObject) {
            
            [self.view showHudMessage:@"录用成功!"];
            [rescruit setTitle:@"已录用" forState:UIControlStateNormal];
            rescruit.enabled = NO;
        } onFail:^(NSError *erro) {
                    [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
        }];
//    [[ZZLHttpRequstEngine engine]requestRecruitUserWithUid:user.userId ugroupId:info._userId missionid:missionId onSuccess:^(id responseObject) {
//
//    } onFail:^(NSError *erro) {
//
//    }];
}

- (void)actionAdd:(UIButton *)btn
{
    AddVolunViewController *vc = [AddVolunViewController ViewContorller];
    vc.missionID = missionId;
    [self.flipboardNavigationController pushViewController:vc];
}
@end
