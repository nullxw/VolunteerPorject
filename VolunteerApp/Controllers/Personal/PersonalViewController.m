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

@property (weak,nonatomic) NSMutableArray *curList;

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
    
    [self.view insertSubview:myScrollView belowSubview:self.mTopBgView];
    [myScrollView addSubview:firstTable];
    [myScrollView addSubview:secondTable];
    
    myScrollView.contentSize = CGSizeMake(320*2, 0);

    
    firstList = [[NSMutableArray alloc]init];
    secondList = [[NSMutableArray alloc]init];
    
    


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
    
    self.curList = firstList;
    
    curPage = 0;
    curTable = firstTable;
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
    if ([self.curList count]==0) {
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
        
        
        NSLog(@"%d",curTable.pageSize);
     
        [[ZZLHttpRequstEngine engine]requestGetWeiboWithUid:user.userId curid:user.userId pageSize:curTable.pageSize pageIndex:1 createTime:@"" onSuccess:^(id responseObject) {
            [curTable.pullToRefreshView stopAnimating];
            NSLog(@"___YYY__%@",responseObject);
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    int itemCount = [responseObject count];
                    if (itemCount == 0 ) {
                        if ([self.curList count]==0) {
                            [curTable reloadData];
                            [curTable addCenterMsgView:@"数据空空～"];
                        }else{
                            [curTable.pullToRefreshView stopAnimating];
                        }
                        
                        return ;
                        
                    }else{
                        [curTable removeCenterMsgView];
                        if ([self.curList count] > 0) {
                            [self.curList removeAllObjects];
                            [curTable reloadData];
                            curTable.pageIndex = 1;
                            
                        }
                        
                        [self insertRowAtTopWithList:responseObject];
                        
                        if (itemCount%curTable.pageSize == 0) {
                            curTable.infiniteScrollingView.enabled = YES;
                        }
                        
                    }
                    
                }) ;
            }
            
        } onFail:^(NSError *erro) {
            NSLog(@"___xxx___%@",[erro.userInfo objectForKey:@"description"]);
            
            
            [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
            [curTable.pullToRefreshView stopAnimating];
            
        }];
    });
    
}
- (void)loadMore
{
    
    UserInfo *user = [UserInfo share];
    
    
    
    [[ZZLHttpRequstEngine engine]requestGetWeiboWithUid:user.userId curid:user.userId pageSize:curTable.pageSize pageIndex:curTable.pageIndex+1 createTime:@"" onSuccess:^(id responseObject){
        
        [curTable.infiniteScrollingView stopAnimating];
        NSLog(@"___YYY__%@",responseObject);
        if ([responseObject isKindOfClass:[NSArray class]]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                int itemCount = [responseObject count];
                if (itemCount == 0 ) {
                    
                    curTable.infiniteScrollingView.enabled = NO;
                }else{
                    
                    [self insertRowAtBottomWithList:responseObject];
                    if (itemCount%curTable.pageSize == 0) {
                        curTable.pageIndex++;
                        curTable.infiniteScrollingView.enabled = YES;
                    }else{
                        curTable.infiniteScrollingView.enabled = NO;
                    }
                    
                }
                
            }) ;
        }
        
    } onFail:^(NSError *erro) {
        NSLog(@"___xxx___%@",[erro.userInfo objectForKey:@"description"]);
        
        
        [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
        [curTable.infiniteScrollingView stopAnimating];
    }];
    
}

- (void)insertRowAtTopWithList:(NSArray *)array
{
    [curTable beginUpdates];
    for (int i=0; i<[array count]; i++) {
        NSMutableDictionary *dic = array[i];
        WeiboInfo *info = [WeiboInfo JsonModalWithDictionary:dic];
        [self.curList addObject:info];
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
        [self.curList addObject:info];
        [curTable insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.curList.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [curTable endUpdates];
}
 

#pragma mark -
#pragma mark - tableviewDelegate,tableviewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    
    

    if ([self.curList count]>0) {
        
     
//        MyWeiBoCell *cell = [curTable dequeueReusableCellWithIdentifier:@"Cell"];
//
//        if (cell == nil) {
//            cell = [[MyWeiBoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
//        }
//        cell.cellInPath = indexPath;
//        cell.delegate = self;
//        WeiboInfo *info = [self.curList objectAtIndex:indexPath.row];
//        [cell setupWithWeiboInfo:info];
//        return cell;
        
        WeiBoCell  *cell = [WeiBoCell cellForTableView:curTable fromNib:[WeiBoCell nib]];
        if (cell == nil) {
            cell = [[WeiBoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
           
            
        }
        cell.cellInPath = indexPath;
        cell.delegate = self;
        WeiboInfo *info = [self.curList objectAtIndex:indexPath.row];
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
    return [self.curList count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiboInfo *info = self.curList[indexPath.row];
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
//    WeiboInfo *temp = self.curList[indexPath.row];
//    ProDetailViewController *vc = [ProDetailViewController ViewContorller];
//    [vc setMissId:temp.mission_id];
//    [self.flipboardNavigationController pushViewController:vc completion:^{
//        
//    }];
    
    
}

#pragma mark - weibocell delegate method
- (void)WeiboCell:(WeiBoCell *)cell actionCollectAtIndexPath:(NSIndexPath *)path
{
    
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
            self.curList = firstList;
            curTable = firstTable;
            
            if ([firstList count]==0) {
                
                [firstTable triggerPullToRefresh];
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
            self.curList = secondList;
            curTable = secondTable;
            
            if ([secondList count]==0) {
                
                [secondTable triggerPullToRefresh];
            }
        }
    }];
    
}
@end
