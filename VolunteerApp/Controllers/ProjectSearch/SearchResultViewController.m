//
//  SearchResultViewController.m
//  VolunteerApp
//
//  Created by zelong zou on 14-3-3.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "SearchResultViewController.h"
#import "MyTableView.h"
#import "ZZLHttpRequstEngine.h"
#import "MyWaitCell.h"
#import "SearchResult.h"
#import "SearchResultCell.h"
#import "ProDetailViewController.h"
#import "UrlDefine.h"
@interface SearchResultViewController ()<UITableViewDataSource,UITableViewDelegate,MyWaitCellDelegate>
{
    int curPage;
    NSMutableArray *curList;
    MyTableView    *mytableView;
}
@end

@implementation SearchResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - view Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleWithString:@"搜索结果"];
    
   
    mytableView =    [[MyTableView alloc]
                      initWithFrame:
                      CGRectMake(0, self.navView.bottom, 320, self.view.height-self.navView.bottom)
                      style:
                      UITableViewStylePlain];
    mytableView.backgroundColor =[UIColor clearColor];
    mytableView.dataSource                     = self;
    mytableView.delegate                       = self;
    mytableView.separatorStyle                 = UITableViewCellSeparatorStyleNone;
    
    
    
    [self.view addSubview:mytableView];
    
    __weak SearchResultViewController *weakSelf = self;
    [mytableView addPullToRefreshWithActionHandler:^{
        [weakSelf refreshData];
    }];
    [mytableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
    mytableView.infiniteScrollingView.enabled = NO;
    
    curPage = 0;
    curList = [[NSMutableArray alloc]init];

}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([curList count]==0) {
        [self refreshData];
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


#pragma mark -
#pragma mark - tableviewDelegate,tableviewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([curList count]>0) {
        SearchResultCell *cell = [SearchResultCell cellForTableView:mytableView fromNib:[SearchResultCell nib]];
//        cell.cellInPath = indexPath;
        cell.backgroundColor = [UIColor clearColor];
        cell.index = indexPath.row;
        SearchResult *info = [curList objectAtIndex:indexPath.row];
        [cell setupMyResultCell:info];
        return cell;
    }
    
    return nil;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [curList count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (curList.count>0) {
        SearchResult *info = [curList objectAtIndex:indexPath.row];
        return [SearchResultCell caclulateHeightWithInfo:info];
    }else{
        return 44;
    }
    

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([curList count]>0) {
        SearchResult *info = curList[indexPath.row];
        ProDetailViewController *vc = [ProDetailViewController ViewContorller];
        [vc setMissId:info.missionId];
        [self.flipboardNavigationController pushViewController:vc completion:^{
            
        }];
    }

    
}

#pragma mark -  networkData


- (void)refreshData
{
    [self.view showLoadingViewWithString:@"正在搜索"];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_current_queue(), ^(void){
        
        
        NSString *arearId = @"b0dc9771d14211e18718000aebf5352e";
        if (global_districtId.length>0) {
            arearId = global_districtId;
        }
        [[ZZLHttpRequstEngine engine]requestSearchProjectListWithUid:self.userId isAllowJoin:YES title:self.key startDate:self.startDate endDate:self.endDate missionType:self.typeindex arearId:arearId distributeDate:self.distrubutetype pageSize:mytableView.pageSize pageIndex:1 onSuccess:^(id responseDict) {
            [mytableView.pullToRefreshView stopAnimating];
            [self.view hideLoadingView];
            NSLog(@"___YYY__%@",responseDict);
            if ([responseDict isKindOfClass:[NSArray class]]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    int itemCount = [responseDict count];
                    if (itemCount == 0 ) {
                        if ([curList count]==0) {
                            [mytableView reloadData];
                            [mytableView addCenterMsgView:@"无搜索结果"];
                        }else{
                            [mytableView.pullToRefreshView stopAnimating];

                        }
                        
                        
                    }else{
                        [mytableView removeCenterMsgView];
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
            
            [self.view hideLoadingView];
            
            [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
            [mytableView.pullToRefreshView stopAnimating];
            
        }];
    });
    
}
- (void)loadMore
{

    NSString *arearId = @"b0dc9771d14211e18718000aebf5352e";
    if (global_districtId.length>0) {
        arearId = global_districtId;
    }
    
    [[ZZLHttpRequstEngine engine]requestSearchProjectListWithUid:self.userId isAllowJoin:YES title:self.key startDate:self.startDate endDate:self.endDate missionType:self.typeindex arearId:arearId distributeDate:self.distrubutetype pageSize:mytableView.pageSize pageIndex:mytableView.pageIndex+1 onSuccess:^(id responseDict)  {
        
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
        SearchResult *info = [SearchResult JsonModalWithDictionary:dic];
        [curList addObject:info];
        [mytableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [mytableView endUpdates];
    
}
- (void)insertRowAtBottomWithList:(NSArray *)array
{
    [mytableView beginUpdates];
    for (int i=0; i< [array count]; i++) {
        NSMutableDictionary *dic = array[i];
        SearchResult *info = [SearchResult JsonModalWithDictionary:dic];
       [curList addObject:info];
        [mytableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:curList.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [mytableView endUpdates];
}

// 点击报名
- (void)actionAttendBtn:(MyWaitCell *)cell AtIndexPath:(NSIndexPath *)ipath
{
    int index = ipath.row;
    SearchResult *info = curList[index];

    
    NSString *str = @"报名成功";
    NSString *str1 = @"取消报名成功";
    
    UserInfo *user = [UserInfo share];
    [[ZZLHttpRequstEngine engine]requestProjectApplyWithUid:user.userId missionID:info.missionId applyOrNOT:info.isJoined onSuccess:^(id responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (info.isJoined) {
                
                info.isJoined = 0;
                cell.mAttenBtn.selected = NO;
                [self.view showHudMessage:str1];
                
                
            }else{
                
                info.isJoined = 1;
                cell.mAttenBtn.selected = YES;
                [self.view showHudMessage:str];
            }
        });

        
        NSLog(@"报名>>>>:%@",responseObject);
        
    } onFail:^(NSError *erro) {
        [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
    }];
}

@end
