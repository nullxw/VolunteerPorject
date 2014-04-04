//
//  MyProjectViewController.m
//  VolunteerApp
//
//  Created by zelong zou on 14-2-21.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "MyProjectViewController.h"
#import "ZZLHttpRequstEngine.h"
#import "MissionInfo.h"
#import "NSDictionary+NSDictionary2Object.h"
#import "RETableViewManager.h"
#import "MyWaitCell.h"
#import "SVPullToRefresh.h"
#import "MyTableView.h"
#import "ProDetailViewController.h"
#import "MyAttendViewController.h"
@interface MyProjectViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,RETableViewManagerDelegate,MyWaitCellDelegate>
{
    UIScrollView *scrollView;
    MyTableView  *firstTable;
    MyTableView  *secondTable;
    MyTableView  *thridTable;
    
    UIButton     *curBtn;
    UInt16       curpage;


    
    NSMutableArray  *firstList;
    NSMutableArray  *secondList;
    NSMutableArray  *thridList;
    
    NSMutableArray  *requestList;
    
   
    
    


}
@property (weak, nonatomic) IBOutlet UIImageView *topBgView;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;

@property (weak, nonatomic) IBOutlet UIButton *waitBtn;
@property (weak, nonatomic) IBOutlet UIButton *completeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *moveLineView;
- (IBAction)actionFristBtn:(UIButton *)sender;
- (IBAction)actionSecondBtn:(UIButton *)sender;
- (IBAction)actionThridBtn:(UIButton *)sender;
@end

@implementation MyProjectViewController

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
    
    [self setTitleWithString:@"我的项目"];
    [self setupView];
    [self.flipboardNavigationController disEnablePan];
    
}
- (void)setupView
{
    

    UIImage *bgimage = [[UIImage imageNamed:@"mypro_tabbarbg"]resizableImageWithCapInsets:UIEdgeInsetsMake(40, 10, 40, 10)];
    self.topBgView.image = bgimage;
    
    
    firstList = [[NSMutableArray alloc]init];
    secondList = [[NSMutableArray alloc]init];
    thridList = [[NSMutableArray alloc]init];
    
    scrollView  = [[UIScrollView alloc]initWithFrame:CGRectMake(0,self.topBgView.bottom,self.view.width,self.view.height-self.topBgView.bottom)];
    scrollView.contentSize = CGSizeMake(3*scrollView.width, scrollView.height);
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator   = YES;
    scrollView.bounces                        = YES;
    scrollView.pagingEnabled                  = YES;
    scrollView.delegate                       = self;

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
    [self.view insertSubview:scrollView belowSubview:self.topBgView];
    [scrollView addSubview:firstTable];
    
    curBtn = self.joinBtn;
    curBtn.selected = YES;
    

    


    
    __weak MyProjectViewController *weakSelf = self;
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
    
    curpage = 0;

    
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
#pragma mark - view Lifecycle



- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    


}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([firstTable.list count] == 0) {
        [firstTable triggerPullToRefresh];
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
    MyTableView *curTableView = (MyTableView *)tableView;
    if ( [curTableView.list count]>0) {
        MyWaitCell *cell = [MyWaitCell cellForTableView:curTableView fromNib:[MyWaitCell nib]];
        cell.cellInPath = indexPath;
        cell.delegate = self;
        MissionInfo *info = [curTableView.list objectAtIndex:indexPath.row];
        [cell setupMyWaitCell:info WithType:curpage];
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
    
    return [MyWaitCell cellHeight];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTableView *curTableView = (MyTableView *)tableView;

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MissionInfo *temp = curTableView.list[indexPath.row];
    ProDetailViewController *vc = [ProDetailViewController ViewContorller];
    [vc setMissId:temp.mission_id];
    [self.flipboardNavigationController pushViewController:vc completion:^{
        
    }];
    
    
}
#pragma mark - actions
- (IBAction)actionFristBtn:(UIButton *)sender {
    if (curBtn!= sender) {
        [self moveToFrist];
    }
}

- (IBAction)actionSecondBtn:(UIButton *)sender {
    
    if (curBtn != sender) {
        
        [self moveToSecond];
    }

}

- (IBAction)actionThridBtn:(UIButton *)sender {
    
    if (curBtn != sender) {
        

        [self moveToThrid];
    }
}

- (void)moveToFrist
{
    



    [UIView animateWithDuration:0.3 animations:^{
        self.moveLineView.centerX = self.joinBtn.centerX;

    } completion:^(BOOL finished) {
        if (finished) {
            curBtn.selected = NO;
            curBtn = self.joinBtn;
            curBtn.selected = YES;
            curpage = 0;

            
//            if (!CGPointEqualToPoint(scrollView.contentOffset, CGPointMake(0, 0))) {
//                [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//            }
            
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            
            if ([firstTable.list count]==0 && !firstTable.hasRequest) {
                
                [firstTable triggerPullToRefresh];
            }
        }
    }];
    
    
}
- (void)moveToSecond
{
    
 

    [UIView animateWithDuration:0.3 animations:^{
        self.moveLineView.centerX = self.waitBtn.centerX;
        
    } completion:^(BOOL finished) {
        if (finished) {

            curBtn.selected = NO;
            curBtn = self.waitBtn;
            curBtn.selected = YES;
            curpage = 1;
 
            

//            if (!CGPointEqualToPoint(scrollView.contentOffset, CGPointMake(self.view.width, 0))) {
//               
//            }
             [scrollView setContentOffset:CGPointMake(self.view.width, 0) animated:YES];
            
            if ([secondTable.list count] == 0 && !secondTable.hasRequest ) {
                [secondTable triggerPullToRefresh];
            }
            
        }
    }];
    
}
- (void)moveToThrid
{


    [UIView animateWithDuration:0.3 animations:^{
        self.moveLineView.centerX = self.completeBtn.centerX;
        
    } completion:^(BOOL finished) {
        if (finished) {

            curBtn.selected = NO;
            curBtn = self.completeBtn;
            curBtn.selected = YES;

            curpage = 2;

            
//            if (!CGPointEqualToPoint(scrollView.contentOffset, CGPointMake(self.view.width*2, 0))) {
//                [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//            }
            
            [scrollView setContentOffset:CGPointMake(self.view.width*2, 0) animated:YES];
            if ([thridTable.list count]==0 && !thridTable.hasRequest) {
                [thridTable triggerPullToRefresh];
            }
        }
    }];
    

}


#pragma mark -  networkData


- (void)refreshDataWithTableView:(MyTableView *)curTableView
{

    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_global_queue(0, 0), ^(void){
        
        UserInfo *user = [UserInfo share];
        
        NSString *state = @"0";
        int sel = 0;
        NSString *str =@"";
        if (curTableView == firstTable) {
            state = @"35,50";
            sel = 1;
            str = @"无参与中的项目";
        }else if(curTableView == secondTable)
        {
            sel = 4;
            state = @"35,50";
            str = @"无待审批的项目";
        }else{
            sel = 1;
            state = @"100,1000";
            str = @"暂无完成的项目";
        }
        

        
        [[ZZLHttpRequstEngine engine] requestGetMissionlistWithUid:user.userId  selection:sel missionState:state  pageSize:curTableView.pageSize pageIndex:1 onSuccess:^(id responseDict) {
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
                            MissionInfo *info = [MissionInfo JsonModalWithDictionary:dic];
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
            
        }];
    });

}
- (void)loadMoreWithTableView:(MyTableView *)curTableView
{
    UserInfo *user = [UserInfo share];
    
    NSString *state = @"0";
    int sel = 0;

    if (curTableView == firstTable) {
        state = @"35,50";
        sel = 1;

    }else if(curTableView == secondTable)
    {
        sel = 4;
        state = @"35,50";

    }else{
        sel = 1;
        state = @"100,1000";

    }
    

    [[ZZLHttpRequstEngine engine] requestGetMissionlistWithUid:user.userId selection:sel missionState:state pageSize:curTableView.pageSize pageIndex:curTableView.pageIndex+1 onSuccess:^(id responseDict) {
        
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
                        MissionInfo *info = [MissionInfo JsonModalWithDictionary:dic];
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


#pragma mark - scrollview delegate

/*
- (void)scrollViewDidEndDecelerating:(UIScrollView *)ascrollView
{
    CGFloat offsetx = ascrollView.contentOffset.x;
    int page = floor((offsetx - 320 / 2) / 320) ;
    if (curpage == page) {
        return;
    }else{
        curpage = page;
        if (curpage == 0) {
            [self moveToFrist];
        }else if (curpage == 1)
        {
            [self moveToSecond];
            
        }else if(curpage == 2)
        {
            [self moveToThrid];
        }

    }
}
 */
/*
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.flipboardNavigationController disEnablePan];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.flipboardNavigationController enablePan];
}
- (void)scrollViewDidScroll:(UIScrollView *)ascrollView
{

    
    CGFloat offsetx = ascrollView.contentOffset.x;
    int page = floor((offsetx - 320 / 2) / 320) ;
    
    if (curpage == page) {
        return;
    }else{
        curpage = page;
        if (curpage == 0) {
            [self moveToFrist];
        }else if (curpage == 1)
        {
            [self moveToSecond];
            
        }else if(curpage == 2)
        {
            [self moveToThrid];
        }
    }
}
*/
#pragma mark - cell delegate
- (void)actionAttendBtn:(MyWaitCell *)cell AtIndexPath:(NSIndexPath *)ipath
{
    MyTableView *curTableView;
    if (curpage == 0) {
        curTableView = firstTable;
    }else if (curpage == 1)
    {
        curTableView = secondTable;
    }else{
        curTableView = thridTable;
    }
    int row = ipath.row;
    MyAttendViewController *vc = [MyAttendViewController ViewContorller];
    MissionInfo *info = curTableView.list[row];
    vc.missionId = info.mission_id;
    
    if (curTableView == thridTable) {
        vc.type = 2;
    }
    
    [self.flipboardNavigationController pushViewController:vc];
}

@end
