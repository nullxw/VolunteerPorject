//
//  CheckClassViewController.m
//  VolunteerApp
//
//  Created by zelong zou on 14-2-23.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "CheckClassViewController.h"
#import "MyTableView.h"
#import "ZZLHttpRequstEngine.h"
#import "ClassPlanInfo.h"
#import "CheckPlanCell.h"
@interface CheckClassViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int curPage;
    NSMutableArray *curList;
    MyTableView    *mytableView;
}

@end

@implementation CheckClassViewController

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
    [self setTitleWithString:@"查看班次"];

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

    __weak CheckClassViewController *weakself = self;
    [mytableView addPullToRefreshWithActionHandler:^{
        [weakself refreshData];
    }];
    
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
    NSLog(@"<><<>%@",curList);
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
        CheckPlanCell *cell = [CheckPlanCell cellForTableView:mytableView fromNib:[CheckPlanCell nib]];


        ClassPlanInfo *info = [curList objectAtIndex:indexPath.row];
        [cell setupMyPlanCell:info];
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
    return [CheckPlanCell cellHeight];
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
        
//        UserInfo *user = [UserInfo share];
        
        

        
        
        

        [[ZZLHttpRequstEngine engine]requestClassPlanPlaneListWithUid:@"" missionID:self.missionId pageSize:10 pageIndex:1 onSuccess:^(id responseDict) {
            [mytableView.pullToRefreshView stopAnimating];
            NSLog(@"___YYY__%@",responseDict);
            if ([responseDict isKindOfClass:[NSArray class]]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    int itemCount = [responseDict count];
                    if (itemCount == 0 ) {
                        if ([curList count]==0) {
                            [mytableView reloadData];
                            [mytableView addCenterMsgView:@"暂无班次计划"];
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
            
            
            [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
            [mytableView.pullToRefreshView stopAnimating];
            
        }];
    });
    
}
- (void)loadMore
{
//    UserInfo *user = [UserInfo share];
    


   [[ZZLHttpRequstEngine engine]requestClassPlanPlaneListWithUid:@"" missionID:self.missionId pageSize:mytableView.pageSize pageIndex:mytableView.pageIndex+1 onSuccess:^(id responseDict) {
        
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
        ClassPlanInfo *info = [ClassPlanInfo JsonModalWithDictionary:dic];
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
        ClassPlanInfo *info = [ClassPlanInfo JsonModalWithDictionary:dic];
        [curList addObject:info];
        [mytableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:curList.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [mytableView endUpdates];
}

@end
