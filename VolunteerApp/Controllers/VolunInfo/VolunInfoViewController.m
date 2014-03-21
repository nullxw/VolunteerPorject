//
//  VolunInfoViewController.m
//  VolunteerApp
//
//  Created by zelong zou on 14-3-17.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "VolunInfoViewController.h"

#import "MyTableView.h"
#import "ZZLHttpRequstEngine.h"
#import "VolunInfo.h"
#import "VolunInfoCell.h"
#import "VolunInfoDetailViewController.h"

@interface VolunInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int curPage;
    NSMutableArray *curList;
    MyTableView    *mytableView;
}

@end

@implementation VolunInfoViewController

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
    [self setTitleWithString:@"志愿资讯"];
    
    curList = [[NSMutableArray alloc]init];
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
    
    __weak VolunInfoViewController *weakSelf = self;
    [mytableView addPullToRefreshWithActionHandler:^{
        [weakSelf refreshData];
    }];
    [mytableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
    mytableView.infiniteScrollingView.enabled = NO;
    if ([curList count]==0) {
        [mytableView triggerPullToRefresh];
    }
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - tableviewDelegate,tableviewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([curList count]>0) {
        VolunInfoCell *cell = [VolunInfoCell cellForTableView:mytableView fromNib:[VolunInfoCell nib]];
        
        cell.backgroundColor = [UIColor clearColor];
        VolunInfo *info = [curList objectAtIndex:indexPath.row];
        [cell setupWithVolunInfo:info];
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
    
    if ([curList count]>0) {
        VolunInfo *info = curList[indexPath.row];
        CGSize size = [info.pageTile sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(280, 2000) lineBreakMode:NSLineBreakByClipping];
        CGFloat height = size.height;
        
        return height+55;
    }else{
        return [VolunInfoCell cellHeight];
    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    VolunInfo *info = curList[indexPath.row];
    VolunInfoDetailViewController *vc = [VolunInfoDetailViewController ViewContorller];
    vc.htmlContent = info.pageCtx;
    [self.flipboardNavigationController pushViewController:vc];
}

#pragma mark -  networkData


- (void)refreshData
{
    
    [self.view showLoadingView];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_current_queue(), ^(void){
        


        
        [[ZZLHttpRequstEngine engine]requestGetVolunteerInfoWithPageSize:mytableView.pageSize pageIndex:1 onSuccess:^(id responseDict) {
            [mytableView.pullToRefreshView stopAnimating];
            NSLog(@"___YYY__%@",responseDict);
            if ([responseDict isKindOfClass:[NSArray class]]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.view hideLoadingView];
                    
                    int itemCount = [responseDict count];
                    if (itemCount == 0 ) {
                        if ([curList count]==0) {
                            [mytableView reloadData];
                            [mytableView addCenterMsgView:@"暂无志愿资讯数据"];
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

    
    
    
    [[ZZLHttpRequstEngine engine]requestGetVolunteerInfoWithPageSize:mytableView.pageSize pageIndex:mytableView.pageIndex+1 onSuccess:^(id responseDict) {
        
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
        VolunInfo *info = [VolunInfo JsonModalWithDictionary:dic];
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
        VolunInfo *info = [VolunInfo JsonModalWithDictionary:dic];
        [curList addObject:info];
        [mytableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:curList.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [mytableView endUpdates];
}

@end
