//
//  MyAttendViewController.m
//  VolunteerApp
//
//  Created by zelong zou on 14-3-2.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "MyAttendViewController.h"
#import "MyTableView.h"
#import "MyAttenCell.h"
#import "ZZLHttpRequstEngine.h"
#import "SiginCell.h"
@interface MyAttendViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    MyTableView *mytableView;
    
    NSMutableArray *curList;
}
@property (strong, nonatomic) IBOutlet UIView *mBottomView;
- (IBAction)actionSignIn:(UIButton *)sender;
- (IBAction)actionSignOut:(UIButton *)sender;
@end

@implementation MyAttendViewController

#pragma mark - view Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleWithString:@"我的考勤"];
    
    
    curList = [[NSMutableArray alloc]init];
    
    mytableView                                = [[MyTableView alloc]
                                                 initWithFrame:
                                                  CGRectMake(0, self.navView.bottom, 320, self.view.height-self.navView.height-self.mBottomView.height)
                                                 style:
                                                 UITableViewStylePlain];
    mytableView.backgroundColor =[UIColor clearColor];
    mytableView.dataSource                     = self;
    mytableView.delegate                       = self;
    mytableView.separatorStyle                 = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mytableView];
    __weak MyAttendViewController *weakSelf = self;
    [mytableView addPullToRefreshWithActionHandler:^{
        
        [weakSelf refreshData];
    }];
    
    
    [mytableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
    mytableView.infiniteScrollingView.enabled = NO;
    
    self.mBottomView.top = self.view.height - self.mBottomView.height;
    [self.view addSubview:self.mBottomView];
    self.mBottomView.hidden = YES;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([curList count]==0) {
        [mytableView triggerPullToRefresh];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark -
#pragma mark - tableviewDelegate,tableviewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if ([curList count]>0) {
            MyAttenCell *cell = [MyAttenCell cellForTableView:mytableView fromNib:[MyAttenCell nib]];
            
            
            SignInfo *info = [curList objectAtIndex:indexPath.row];
            [cell setupWithSignInfo:info];
            return cell;
        }
    }else{
        
            SiginCell *cell = [SiginCell cellForTableView:mytableView fromNib:[SiginCell nib]];
//            SignInfo *info = [curList objectAtIndex:indexPath.row];
//            cell.mTitleLb.text = info.missionName;
            return cell;
        
        
    }
    
    
    return nil;
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"今天";
    }else{
        return @"以前";
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return [curList count];
    }else{
        return 1;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 62;
    }
    return [MyAttenCell cellHeight];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

#pragma mark -  networkData


- (void)refreshData
{
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        UserInfo *user = [UserInfo share];
        
        

        
        
  
        [[ZZLHttpRequstEngine engine]requestServiceLogWithUid:user.userId otherUid:user.userId isUpdated:YES pageIndex:1 pageSize:mytableView.pageSize missionId:self.missionId onSuccess:^(id responseDict){
            [mytableView.pullToRefreshView stopAnimating];
            NSLog(@"___YYY__%@",responseDict);
            if ([responseDict isKindOfClass:[NSArray class]]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    int itemCount = [responseDict count];
                    if (itemCount == 0 ) {
                        if ([curList count]==0) {
                            [mytableView reloadData];
                            [mytableView addCenterMsgView:@"暂无考勤记录"];
                        }else{
                            [mytableView.pullToRefreshView stopAnimating];
                        }
                        
                        
                    }else{
                        [mytableView removeCenterMsgView];
                        self.mBottomView.hidden = NO;
                        if ([curList count] > 0) {
                            [curList removeAllObjects];
                            [mytableView reloadData];
                            mytableView.pageIndex = 1;
                            
                        }
                        
                        [self insertRowAtTopWithList:responseDict];
                        
                        if ((itemCount%mytableView.pageSize) == 0) {
                            mytableView.infiniteScrollingView.enabled = YES;
                        }
                        
                    }
                    
                }) ;
            }
            
        } onFail:^(NSError *erro) {
            NSLog(@"___xxx___%@",[erro.userInfo objectForKey:@"description"]);
            
            
            [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
            [mytableView.pullToRefreshView stopAnimating];
            
        }];
    });
    
}
- (void)loadMore
{
    UserInfo *user = [UserInfo share];
    
    
    
    [[ZZLHttpRequstEngine engine]requestServiceLogWithUid:user.userId otherUid:user.userId isUpdated:YES pageIndex:mytableView.pageIndex+1 pageSize:mytableView.pageSize missionId:self.missionId onSuccess:^(id responseDict) {
        
        [mytableView.infiniteScrollingView stopAnimating];
        NSLog(@"___YYY__%@",responseDict);
        if ([responseDict isKindOfClass:[NSArray class]]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                int itemCount = [responseDict count];
                if (itemCount == 0 ) {
                    
                    mytableView.infiniteScrollingView.enabled = NO;
                }else{
                    
                    [self insertRowAtBottomWithList:responseDict];
                    if ((itemCount%mytableView.pageSize) == 0) {
                        mytableView.pageIndex++;
                        mytableView.infiniteScrollingView.enabled = YES;
                    }else{
                        mytableView.infiniteScrollingView.enabled = NO;
                    }
                    
                }
                
            }) ;
        }
        
    } onFail:^(NSError *erro) {
        NSLog(@"___xxx___%@",[erro.userInfo objectForKey:@"description"]);
        
        
        [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
        [mytableView.infiniteScrollingView stopAnimating];
    }];
}

- (void)insertRowAtTopWithList:(NSArray *)array
{
    [mytableView beginUpdates];
    for (int i=0; i<[array count]; i++) {
        NSMutableDictionary *dic = array[i];
        SignInfo *info = [SignInfo JsonModalWithDictionary:dic];
        [curList addObject:info];
        [mytableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [mytableView endUpdates];
    
}
- (void)insertRowAtBottomWithList:(NSArray *)array
{
    [mytableView beginUpdates];
    for (int i=0; i< [array count]; i++) {
        NSMutableDictionary *dic = array[i];
        SignInfo *info = [SignInfo JsonModalWithDictionary:dic];
        [curList addObject:info];
        [mytableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:curList.count-1 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [mytableView endUpdates];
}
#pragma mark - actions
- (IBAction)actionSignIn:(UIButton *)sender {
    if ([curList count]==0) {
        [self.view showHudMessage:@"无记录，不能签到"];
    }
    UserInfo *user = [UserInfo share];
    SignInfo *info = curList[0];
    
    [[ZZLHttpRequstEngine engine]requestProjectMissionSiginWithUid:user.userId curId:user.userId missionID:info._missionId onSuccess:^(id responseObject) {
        [self.view showHudMessage:responseObject];
        [mytableView triggerPullToRefresh];
    } onFail:^(NSError *erro) {
        [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
    }];
}

- (IBAction)actionSignOut:(UIButton *)sender {
    if ([curList count]==0) {
        [self.view showHudMessage:@"无记录，不能签出"];
    }
    UserInfo *user = [UserInfo share];
    SignInfo *info = curList[0];
    [[ZZLHttpRequstEngine engine]requestProjectMissionSiginOutWithUid:user.userId curId:user.userId missionID:info._missionId onSuccess:^(id responseObject) {
        [self.view showHudMessage:responseObject];
        [mytableView triggerPullToRefresh];
    } onFail:^(NSError *erro) {
        [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
    }];
    
}
@end
