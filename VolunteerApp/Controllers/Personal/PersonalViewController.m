//
//  PersonalViewController.m
//  VolunteerApp
//
//  Created by zelong zou on 14-2-21.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "PersonalViewController.h"
#import "MyTableView.h"
#import "WeiBoCell.h"
#import "ZZLHttpRequstEngine.h"
#import "MyWeiBoCell.h"
#import "SendWeiboViewController.h"
@interface PersonalViewController ()<UITableViewDataSource,UITableViewDelegate,WeiboCellDelegate>
{
    
    NSMutableArray *firstList;
    NSMutableArray *secondList;
    
    MyTableView    *firstTable;
    MyTableView    *secondTable;
    MyTableView    *curTable;
    
    UIScrollView   *myScrollView;
    
    int             curPage;
}
@property (weak, nonatomic) IBOutlet UIImageView *mTopBgView;
@property (weak, nonatomic) IBOutlet UIButton *classRankBtn;

@property (weak, nonatomic) IBOutlet UIButton *projectRankBtn;



- (IBAction)actionFirst:(UIButton *)sender;

- (IBAction)actionSecond:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIImageView *moveLine;
@end

@implementation PersonalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitleWithString:@"个人空间"];
    self.classRankBtn.selected = YES;

    
    UIImage *bgimage = [[UIImage imageNamed:@"mypro_tabbarbg"]resizableImageWithCapInsets:UIEdgeInsetsMake(40, 10, 40, 10)];
    self.mTopBgView.image = bgimage;

    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(265, self.navView.bottom - 44, 46, 46);
    [btn setImage:[UIImage imageNamed:@"nav_edit.png"] forState:UIControlStateNormal];

    [btn addTarget:self action:@selector(actionSend:) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:btn];
    
    firstList = [[NSMutableArray alloc]init];
    secondList = [[NSMutableArray alloc]init];
    //scrollview
    myScrollView  = [[UIScrollView alloc]initWithFrame:CGRectMake(0,self.mTopBgView.bottom,self.view.width,self.view.height-self.mTopBgView.bottom)];

    myScrollView.backgroundColor = [UIColor clearColor];
    myScrollView.showsHorizontalScrollIndicator = NO;
    myScrollView.showsVerticalScrollIndicator   = YES;
    myScrollView.bounces                        = YES;
    myScrollView.pagingEnabled                  = YES;
    myScrollView.delegate                       = self;
    
    myScrollView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
    myScrollView.scrollEnabled = NO;
    //
    
    firstTable                                = [[MyTableView alloc]
                                                 initWithFrame:
                                                 myScrollView.bounds
                                                 style:
                                                 UITableViewStylePlain];
    firstTable.backgroundColor =[UIColor clearColor];
    firstTable.dataSource                     = self;
    firstTable.delegate                       = self;
    firstTable.separatorStyle                 = UITableViewCellSeparatorStyleNone;
    firstTable.list = firstList;
    
    //
    secondTable                                = [[MyTableView alloc]
                                                 initWithFrame:
                                                 myScrollView.bounds
                                                 style:
                                                 UITableViewStylePlain];
    secondTable.left = firstTable.right;
    secondTable.backgroundColor =[UIColor clearColor];
    secondTable.dataSource                     = self;
    secondTable.delegate                       = self;
    secondTable.separatorStyle                 = UITableViewCellSeparatorStyleNone;
    secondTable.list = secondList;
    [self.view insertSubview:myScrollView belowSubview:self.mTopBgView];
    [myScrollView addSubview:firstTable];
    [myScrollView addSubview:secondTable];
    
    myScrollView.contentSize = CGSizeMake(320*2, 0);

    curTable = firstTable;
    

    
    


    __weak PersonalViewController *weakSelf = self;
    [firstTable addPullToRefreshWithActionHandler:^{
        [weakSelf refreshData];
    }];
    [firstTable addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
    firstTable.infiniteScrollingView.enabled = NO;
    
    
    [secondTable addPullToRefreshWithActionHandler:^{
        [weakSelf refreshData];
    }];
    [secondTable addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
    secondTable.infiniteScrollingView.enabled = NO;
    

    
    curPage = 0;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - view Lifecycle



- (void)viewDidUnload {
    [super viewDidUnload];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([curTable.list count]==0) {
        [curTable triggerPullToRefresh];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)actionSend:(UIButton *)btn
{
    SendWeiboViewController *vc=  [SendWeiboViewController ViewContorller];
    [self.flipboardNavigationController pushViewController:vc];
}

- (void)refreshData
{
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        UserInfo *user = [UserInfo share];

        if (curPage == 0) {
            [[ZZLHttpRequstEngine engine]requestGetFriendWeiboWithUid:user.userId curid:@"bba9a7e23897b4cc0138a21fdbd9034b" pageSize:curTable.pageSize pageIndex:1 createTime:@"" onSuccess:^(id responseObject) {
                [firstTable.pullToRefreshView stopAnimating];
                NSLog(@"___YYY__%@",responseObject);
                if ([responseObject isKindOfClass:[NSArray class]]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                        int itemCount = [responseObject count];
                        if (itemCount == 0 ) {
                            if ([firstTable.list count]==0) {
                                [firstTable reloadData];
                                [firstTable addCenterMsgView:@"无最新动态"];
                            }else{
                                [firstTable.pullToRefreshView stopAnimating];
                            }
                            
                            return ;
                            
                        }else{
                            [firstTable removeCenterMsgView];
                            if ([firstTable.list count] > 0) {
                                [firstTable.list removeAllObjects];
                                [firstTable reloadData];
                                firstTable.pageIndex = 1;
                                
                            }
                            
                            for (int i=0; i<[responseObject count]; i++) {
                                NSMutableDictionary *dic = responseObject[i];
                                WeiboInfo *info = [WeiboInfo JsonModalWithDictionary:dic];
                                [firstTable.list addObject:info];
                            }
                            
                            [firstTable insertRowAtTopWithCount:[responseObject count]];
                            
                            if (itemCount%firstTable.pageSize == 0) {
                                firstTable.infiniteScrollingView.enabled = YES;
                            }
                            
                        }
                        
                    }) ;
                }
                
            } onFail:^(NSError *erro) {
                NSLog(@"___xxx___%@",[erro.userInfo objectForKey:@"description"]);
                
                
                [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
                [firstTable.pullToRefreshView stopAnimating];
                
            }];
        }else{
            [[ZZLHttpRequstEngine engine]requestGetWeiboWithUid:user.userId curid:user.userId pageSize:curTable.pageSize pageIndex:1 createTime:@"" onSuccess:^(id responseObject) {
                [secondTable.pullToRefreshView stopAnimating];
                NSLog(@"___YYY__%@",responseObject);
                if ([responseObject isKindOfClass:[NSArray class]]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                        int itemCount = [responseObject count];
                        if (itemCount == 0 ) {
                            if ([secondTable.list count]==0) {
                                [secondTable reloadData];
                                [secondTable addCenterMsgView:@"暂无动态哦，赶紧去发布一条吧"];
                            }else{
                                [secondTable.pullToRefreshView stopAnimating];
                            }
                            
                            return ;
                            
                        }else{
                            [secondTable removeCenterMsgView];
                            if ([secondTable.list count] > 0) {
                                [secondTable.list removeAllObjects];
                                [secondTable reloadData];
                                secondTable.pageIndex = 1;
                                
                            }
                            
                            for (int i=0; i<[responseObject count]; i++) {
                                NSMutableDictionary *dic = responseObject[i];
                                WeiboInfo *info = [WeiboInfo JsonModalWithDictionary:dic];
                                [secondTable.list addObject:info];
                            }
                            
                            [secondTable insertRowAtTopWithCount:[responseObject count]];
                            
                            if (itemCount%secondTable.pageSize == 0) {
                                secondTable.infiniteScrollingView.enabled = YES;
                            }
                            
                        }
                        
                    }) ;
                }
                
            } onFail:^(NSError *erro) {
                NSLog(@"___xxx___%@",[erro.userInfo objectForKey:@"description"]);
                
                
                [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
                [secondTable.pullToRefreshView stopAnimating];
                
            }];
        }

     

    });
    
}
- (void)loadMore
{
    
    UserInfo *user = [UserInfo share];

    if (curPage == 1) {
        [[ZZLHttpRequstEngine engine]requestGetWeiboWithUid:user.userId curid:user.userId pageSize:curTable.pageSize pageIndex:curTable.pageIndex+1 createTime:@"" onSuccess:^(id responseObject){
            
            
            [secondTable.infiniteScrollingView stopAnimating];
            NSLog(@"___YYY__%@",responseObject);
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    int itemCount = [responseObject count];
                    if (itemCount == 0 ) {
                        
                        secondTable.infiniteScrollingView.enabled = NO;
                    }else{
                        
                        for (int i=0; i<[responseObject count]; i++) {
                            NSMutableDictionary *dic = responseObject[i];
                            WeiboInfo *info = [WeiboInfo JsonModalWithDictionary:dic];
                            [secondTable.list addObject:info];
                        }
                        
                        [secondTable insertRowAtBottomWithCount:[responseObject count]];
                        if (itemCount%secondTable.pageSize == 0) {
                            secondTable.pageIndex++;
                            secondTable.infiniteScrollingView.enabled = YES;
                        }else{
                            secondTable.infiniteScrollingView.enabled = NO;
                        }
                        
                    }
                    
                }) ;
            }
            
        } onFail:^(NSError *erro) {
            NSLog(@"___xxx___%@",[erro.userInfo objectForKey:@"description"]);
            
            
            [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
            [secondTable.infiniteScrollingView stopAnimating];
        }];
    }else{
        [[ZZLHttpRequstEngine engine]requestGetFriendWeiboWithUid:user.userId curid:@"bba9a7e23897b4cc0138a21fdbd9034b" pageSize:curTable.pageSize pageIndex:curTable.pageIndex+1 createTime:@"" onSuccess:^(id responseObject){
            
            [firstTable.infiniteScrollingView stopAnimating];
            NSLog(@"___YYY__%@",responseObject);
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    int itemCount = [responseObject count];
                    if (itemCount == 0 ) {
                        
                        firstTable.infiniteScrollingView.enabled = NO;
                    }else{
                        for (int i=0; i<[responseObject count]; i++) {
                            NSMutableDictionary *dic = responseObject[i];
                            WeiboInfo *info = [WeiboInfo JsonModalWithDictionary:dic];
                            [firstTable.list addObject:info];
                        }
                        
                        [firstTable insertRowAtBottomWithCount:[responseObject count]];
                        if (itemCount%firstTable.pageSize == 0) {
                            firstTable.pageIndex++;
                            firstTable.infiniteScrollingView.enabled = YES;
                        }else{
                            firstTable.infiniteScrollingView.enabled = NO;
                        }
                        
                    }
                    
                }) ;
            }
            
        } onFail:^(NSError *erro) {
            NSLog(@"___xxx___%@",[erro.userInfo objectForKey:@"description"]);
            
            
            [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
            [firstTable.infiniteScrollingView stopAnimating];
        }];
    }
    

    
}

- (void)insertRowAtTopWithList:(NSArray *)array
{

    [curTable beginUpdates];
    for (int i=0; i<[array count]; i++) {
        NSMutableDictionary *dic = array[i];
        WeiboInfo *info = [WeiboInfo JsonModalWithDictionary:dic];
        [curTable.list addObject:info];
        [curTable insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [curTable endUpdates];
    
}
- (void)insertRowAtBottomWithList:(NSArray *)array
{

    [curTable beginUpdates];
    for (int i=0; i< [array count]; i++) {
        NSMutableDictionary *dic = array[i];
        WeiboInfo *info = [WeiboInfo JsonModalWithDictionary:dic];
        [curTable.list addObject:info];
        [curTable insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[curTable.list count]-1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [curTable endUpdates];
}
 

#pragma mark -
#pragma mark - tableviewDelegate,tableviewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    
    

    if ([curTable.list count]>0) {
        

        WeiBoCell  *cell = [WeiBoCell cellForTableView:curTable fromNib:[WeiBoCell nib]];
        if (cell == nil) {
            cell = [[WeiBoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
           
            
        }
        cell.cellInPath = indexPath;
        cell.delegate = self;
        WeiboInfo *info = [curTable.list objectAtIndex:indexPath.row];
        [cell setupWithWeiboInfo:info];
        return cell;
    }else{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defaultCell" forIndexPath:indexPath];
        if (cell == nil) {
                 cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defaultCell"];
        }

        return cell;
    }
    
    
  
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [curTable.list count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiboInfo *info = curTable.list[indexPath.row];
    if (info) {
        CGSize size = [self caculateStrSize:info.content];
        return size.height+155;
    }else{
        return 44;
    }
    
}
- (CGSize)caculateStrSize:(NSString *)str
{
    return [str sizeWithFont:[UIFont fontWithName:@"Avenir-Medium" size:14.0f] constrainedToSize:CGSizeMake(300, 2000) lineBreakMode:NSLineBreakByCharWrapping];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    WeiboInfo *temp = curTable.list[indexPath.row];
//    ProDetailViewController *vc = [ProDetailViewController ViewContorller];
//    [vc setMissId:temp.mission_id];
//    [self.flipboardNavigationController pushViewController:vc completion:^{
//        
//    }];
    
    
}

#pragma mark - weibocell delegate method
- (void)WeiboCell:(WeiBoCell *)cell actionCollectAtIndexPath:(NSIndexPath *)path
{
    UserInfo *user = [UserInfo share];
    WeiboInfo *info = curTable.list[path.row];
//    [self.view showLoadingViewWithString:@"正在收藏..."];
    [[ZZLHttpRequstEngine engine]requestCollectWeiboWithUid:user.userId weiboId:[NSString stringWithFormat:@"%d",info.weiboId] onSuccess:^(id responseObject) {
        cell.mCollectBtn.selected = YES;
        NSString *msg = responseObject;
        [self.view showHudMessage:msg];
//        [self.view hideLoadingView];
    } onFail:^(NSError *erro) {
//        [self.view hideLoadingView];
        [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
    } ];
}
- (void)WeiboCell:(WeiBoCell *)cell actionCommentAtIndexPath:(NSIndexPath *)path
{
    
}
- (IBAction)actionFirst:(UIButton *)sender {
    if (!sender.selected) {
        [self moveToFrist];
    }
}

- (IBAction)actionSecond:(UIButton *)sender {
    if (!sender.selected) {
        [self moveToSecond];
    }
}
- (void)moveToFrist
{
    
    
    
    [myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.moveLine.centerX = self.classRankBtn.centerX;
        
    } completion:^(BOOL finished) {
        if (finished) {
            self.projectRankBtn.selected = NO;

            self.classRankBtn.selected = YES;
            curPage = 0;

            curTable = firstTable;
            
            if ([curTable.list count]==0) {
                
                [curTable triggerPullToRefresh];
            }
        }
    }];
    
    
}
- (void)moveToSecond
{
 
    [myScrollView setContentOffset:CGPointMake(self.view.width, 0) animated:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.moveLine.centerX = self.projectRankBtn.centerX;
        
    } completion:^(BOOL finished) {
        if (finished) {
            self.projectRankBtn.selected = YES;
            
            self.classRankBtn.selected = NO;
            curPage = 1;

            curTable = secondTable;
            if ([curTable.list count]==0) {
                
                [curTable triggerPullToRefresh];
            }
        }
    }];
    
}
@end
