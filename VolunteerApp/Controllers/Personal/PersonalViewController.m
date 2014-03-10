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
#import "TrendDetialViewController.h"
#import "UIAlertView+Blocks.h"
#import "UIImageView+WebCache.h"
#import "UrlDefine.h"
@interface PersonalViewController ()<UITableViewDataSource,UITableViewDelegate,WeiboCellDelegate>
{
    
    NSMutableArray *firstList;
    NSMutableArray *secondList;
    
    MyTableView    *firstTable;
    MyTableView    *secondTable;

    
    UIScrollView   *myScrollView;
    
    int             curPage;
    CGRect         originRect;
    CGSize        ratio;
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
    if ([firstTable.list count]==0) {
        [firstTable triggerPullToRefresh];
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
    dispatch_after(popTime, dispatch_get_global_queue(0, 0), ^(void){
        
        UserInfo *user = [UserInfo share];

        if (curPage == 0) {
            [[ZZLHttpRequstEngine engine]requestGetFriendWeiboWithUid:user.userId curid:@"bba9a7e23897b4cc0138a21fdbd9034b" pageSize:firstTable.pageSize pageIndex:1 createTime:@"" onSuccess:^(id responseObject) {
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
            [[ZZLHttpRequstEngine engine]requestGetWeiboWithUid:user.userId curid:user.userId pageSize:secondTable.pageSize pageIndex:1 createTime:@"" onSuccess:^(id responseObject) {
                [secondTable.pullToRefreshView stopAnimating];
                NSLog(@"\n《我的动态》\n%@",responseObject);
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
        [[ZZLHttpRequstEngine engine]requestGetWeiboWithUid:user.userId curid:user.userId pageSize:secondTable.pageSize pageIndex:secondTable.pageIndex+1 createTime:@"" onSuccess:^(id responseObject){
            
            
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
        [[ZZLHttpRequstEngine engine]requestGetFriendWeiboWithUid:user.userId curid:@"bba9a7e23897b4cc0138a21fdbd9034b" pageSize:firstTable.pageSize pageIndex:firstTable.pageIndex+1 createTime:@"" onSuccess:^(id responseObject){
            
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


 

#pragma mark -
#pragma mark - tableviewDelegate,tableviewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    
    

    MyTableView *curTable = (MyTableView *)tableView;
    if ([curTable.list count]>0) {
        

        WeiBoCell  *cell = [WeiBoCell cellForTableView:curTable fromNib:[WeiBoCell nib]];
        if (cell == nil) {
            cell = [[WeiBoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
           
            
        }
        if (curTable == firstTable) {
            cell.cellType = kWeiboCellTpyeNew;
        }else if(curTable == secondTable)
        {
            cell.cellType = kWeiboCellTpyeMy;
        }
        cell.cellInPath = indexPath;
        cell.delegate = self;
        WeiboInfo *info = [curTable.list objectAtIndex:indexPath.row];
        [cell setupWithWeiboInfo:info];
        return cell;
    }
    return nil;
    
  
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MyTableView *curTable = (MyTableView *)tableView;
    return [curTable.list count];

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTableView *tempTableView = (MyTableView *)tableView;
    WeiboInfo *info = tempTableView.list[indexPath.row];
    if (info) {
        CGSize size = [self caculateStrSize:info.content];
        if (info.picLittle.length>0) {
            return size.height+155+90;
        }
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
    MyTableView *curTable = (MyTableView *)tableView;
    WeiboInfo *info = curTable.list[indexPath.row];
    TrendDetialViewController *vc =[TrendDetialViewController ViewContorller];
    vc.info = info;
    [self.flipboardNavigationController pushViewController:vc];
    
    
}

#pragma mark - weibocell delegate method
- (void)WeiboCell:(WeiBoCell *)cell actionCollectAtIndexPath:(NSIndexPath *)path
{
    MyTableView *curTable ;
    if (curPage == 0) {
        curTable = firstTable;
    }else{
        curTable = secondTable;
    }
    UserInfo *user = [UserInfo share];
    WeiboInfo *info = curTable.list[path.row];

    if (cell.cellType == kWeiboCellTpyeNew) {
        [[ZZLHttpRequstEngine engine]requestCollectWeiboWithUid:user.userId weiboId:[NSString stringWithFormat:@"%d",info.weiboId] onSuccess:^(id responseObject) {
            cell.mCollectBtn.selected = YES;
            NSString *msg = responseObject;
            [self.view showHudMessage:msg];
            
        } onFail:^(NSError *erro) {
            
            [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
        } ];
       
    }else if (cell.cellType == kWeiboCellTpyeMy)
    {
        
        [UIAlertView  showAlertViewWithTitle:@"您确认要删除该条空间动态吗" message:@"" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] onDismiss:^(int btnIndex) {
            [[ZZLHttpRequstEngine engine]requestDelWeiboWithUid:user.userId weiboId:[NSString stringWithFormat:@"%d",info.weiboId] onSuccess:^(id responseObject)
             {
                 NSString *msg = responseObject;
                 [self.view showHudMessage:msg];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [secondList removeObjectAtIndex:path.row];
                     [secondTable reloadData];
                 });
                 
             } onFail:^(NSError *erro) {
                 [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
             }];
            
        } onCancel:^{
            return ;
        }];

    }

}
- (void)WeiboCell:(WeiBoCell *)cell actionCommentAtIndexPath:(NSIndexPath *)path
{
    MyTableView *curTable ;
    if (curPage == 0) {
        curTable = firstTable;
    }else{
        curTable = secondTable;
    }
    WeiboInfo *info = curTable.list[path.row];
    TrendDetialViewController *vc =[TrendDetialViewController ViewContorller];
    vc.info = info;
    [self.flipboardNavigationController pushViewController:vc];
}

- (void)WeiboCell:(WeiBoCell *)cell actionImageView:(UIImageView *)imageView
{
    MyTableView *curTable ;
    if (curPage == 0) {
        curTable = firstTable;
    }else{
        curTable = secondTable;
    }
    
    CGFloat height = imageView.top+cell.top+curTable.top+self.navView.height+self.mTopBgView.height-curTable.contentOffset.y;
    originRect = CGRectMake(imageView.left, height, imageView.width, imageView.height);
    WeiboInfo *info = curTable.list[cell.cellInPath.row];
    
    
    [self checkPoster:imageView withImageUrl:[NSURL URLWithString:[IMAGE_URL stringByAppendingString:info.picMiddle]]];
    
    
}

- (void)checkPoster:(UIImageView *)imageView1 withImageUrl:(NSURL *)url
{


    
    
    
    
    
    UIImage *bigImage = imageView1.image;
    UIView *backView = [[UIView alloc]initWithFrame:self.view.bounds];
    backView.backgroundColor = [UIColor blackColor];
    CGSize size = bigImage.size;
    ratio = CGSizeMake(originRect.size.width/size.width, originRect.size.height/size.height);
    CGFloat height = (self.view.width*size.height)/size.width;
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:originRect];
    [imageview setImageWithURL:url placeholderImage:bigImage];
    //imageview.transform = CGAffineTransformMakeScale(ratio.width, ratio.height);
    
    
    [backView addSubview:imageview];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeBackView:)];
    [backView addGestureRecognizer:tap];

    [self.view addSubview:backView];
    [UIView animateWithDuration:0.5f animations:^{
        imageview.frame= CGRectMake(0, backView.center.y-(height/2), self.view.width, height);
        
    } completion:^(BOOL finished) {
        
    }];
    
}
- (void)removeBackView:(UITapGestureRecognizer *)gestrue
{
    UIView *view = gestrue.view;
    view.backgroundColor = [UIColor clearColor];
    UIImageView *imageview = [[view subviews]lastObject];
    [UIView animateWithDuration:0.3f animations:^{
        
        imageview.frame = originRect;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];

        
    }];
    view = nil;
    
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


            
            if ([firstTable.list count]==0  && !firstTable.hasRequest) {
                
                [firstTable triggerPullToRefresh];
            }
        }
    }];
    
    
}
//59.41.39.98:443/VolunteerService/upload/psn_spac_file/touxiang/201303040901049.jpg
//http://59.41.39.98:443/VolunteerService/
///upload/psn_spac_file/touxiang/201303040901049.jpg
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


            if ([secondTable.list count]==0 && !secondTable.hasRequest) {
                
                [secondTable triggerPullToRefresh];
            }
        }
    }];
    
}
@end
