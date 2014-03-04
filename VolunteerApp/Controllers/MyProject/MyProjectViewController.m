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
    NSMutableArray *curList;
    MyTableView  *curTableView;
    
    NSMutableArray  *firstList;
    NSMutableArray  *secondList;
    NSMutableArray  *thridList;
    
    


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
    
}
- (void)setupView
{
    

    UIImage *bgimage = [[UIImage imageNamed:@"mypro_tabbarbg"]resizableImageWithCapInsets:UIEdgeInsetsMake(40, 10, 40, 10)];
    self.topBgView.image = bgimage;
    
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


    
    [self.view insertSubview:scrollView belowSubview:self.topBgView];
    [scrollView addSubview:firstTable];
    
    curBtn = self.joinBtn;
    curBtn.selected = YES;
    
    firstList = [[NSMutableArray alloc]init];
    secondList = [[NSMutableArray alloc]init];
    thridList = [[NSMutableArray alloc]init];
    


    
    __weak MyProjectViewController *weakSelf = self;
    [firstTable addPullToRefreshWithActionHandler:^{
        
        [weakSelf refreshData];
    }];
    
    
    [firstTable addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
    firstTable.infiniteScrollingView.enabled = NO;

    
    secondTable = [[MyTableView alloc]initWithFrame:scrollView.bounds style:UITableViewStylePlain];
    secondTable.backgroundColor = [UIColor clearColor];
    secondTable.dataSource = self;
    secondTable.delegate = self;
    secondTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    secondTable.left = firstTable.width;
    scrollView.contentSize = CGSizeMake(2*scrollView.width, scrollView.height);
    [scrollView addSubview:secondTable];


    [secondTable addPullToRefreshWithActionHandler:^{
        [weakSelf refreshData];
    }];
    [secondTable addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
    secondTable.infiniteScrollingView.enabled = NO;
    
    thridTable = [[MyTableView alloc]initWithFrame:scrollView.bounds style:UITableViewStylePlain];
    thridTable.backgroundColor = [UIColor clearColor];
    thridTable.dataSource = self;
    thridTable.delegate = self;
    thridTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    thridTable.left = scrollView.width*2;
    
    [scrollView addSubview:thridTable];

    [thridTable addPullToRefreshWithActionHandler:^{
        [weakSelf refreshData];
    }];
    
    [thridTable addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
    thridTable.infiniteScrollingView.enabled = NO;
    
    curpage = 0;
    curList = firstList;
    curTableView = firstTable;
    
    
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
    if ([firstList count] == 0) {
        [curTableView triggerPullToRefresh];
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
    if ( [curList count]>0) {
        MyWaitCell *cell = [MyWaitCell cellForTableView:curTableView fromNib:[MyWaitCell nib]];
        cell.cellInPath = indexPath;
        cell.delegate = self;
        MissionInfo *info = [curList objectAtIndex:indexPath.row];
        [cell setupMyWaitCell:info WithType:curpage];
        return cell;
    }else{
        return nil;
    }

    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [curList count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [MyWaitCell cellHeight];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MissionInfo *temp = curList[indexPath.row];
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
            curList = firstList;
            curTableView = firstTable;
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            if ([curList count]==0) {
                
                [curTableView triggerPullToRefresh];
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
            curList = secondList;
            curTableView = secondTable;
            [scrollView setContentOffset:CGPointMake(self.view.width, 0) animated:YES];
            if ([curList count] == 0) {
                [curTableView triggerPullToRefresh];
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
            curList = thridList;
            curpage = 2;
            curTableView = thridTable;
            [scrollView setContentOffset:CGPointMake(self.view.width*2, 0) animated:YES];
            if ([curList count]==0) {
                [curTableView triggerPullToRefresh];
            }
        }
    }];
    

}


#pragma mark -  networkData


- (void)refreshData
{

    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        UserInfo *user = [UserInfo share];
        
        int state = 0;
        if (curpage == 0) {
            state = 50;
        }else if(curpage == 1)
        {
            state = 20;
        }else{
            state = 100;
        }
        
        NSLog(@"%d",curTableView.pageSize);
        
        [[ZZLHttpRequstEngine engine] requestGetMissionlistWithUid:user.userId missionState:state pageSize:curTableView.pageSize pageIndex:1 onSuccess:^(id responseDict) {
            [curTableView.pullToRefreshView stopAnimating];
            NSLog(@"___YYY__%@",responseDict);
            if ([responseDict isKindOfClass:[NSArray class]]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    int itemCount = [responseDict count];
                    if (itemCount == 0 ) {
                        if ([curList count]==0) {
                            [curTableView reloadData];
                            [curTableView addCenterMsgView:@"数据空空～"];
                        }else{
                            [curTableView.pullToRefreshView stopAnimating];
                        }
                        return ;
                        
                    }else{
                        [curTableView removeCenterMsgView];
                        if ([curList count] > 0) {
                            [curList removeAllObjects];
                            
                            curTableView.pageIndex = 1;
                            
                        }
                        [curTableView reloadData];
                        [self insertRowAtTopWithList:responseDict];
                        
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
- (void)loadMore
{
    UserInfo *user = [UserInfo share];
    
    int state = 0;
    if (curpage == 0) {
        state = 50;
    }else if(curpage == 1)
    {
        state = 20;
    }else{
        state = 100;
    }
    
    [[ZZLHttpRequstEngine engine] requestGetMissionlistWithUid:user.userId missionState:state pageSize:curTableView.pageSize pageIndex:curTableView.pageIndex+1 onSuccess:^(id responseDict) {
        
        [curTableView.infiniteScrollingView stopAnimating];
        NSLog(@"___YYY__%@",responseDict);
        if ([responseDict isKindOfClass:[NSArray class]]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                int itemCount = [responseDict count];
                if (itemCount == 0 ) {
                    
                    curTableView.infiniteScrollingView.enabled = NO;
                }else{
                    
                    [self insertRowAtBottomWithList:responseDict];
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
- (void)insertRowAtTopWithList:(NSArray *)array
{
    [curTableView beginUpdates];
    for (int i=0; i<[array count]; i++) {
        NSMutableDictionary *dic = array[i];
        MissionInfo *info = [MissionInfo JsonModalWithDictionary:dic];
        [curList addObject:info];
        [curTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    }
    [curTableView endUpdates];

}
- (void)insertRowAtBottomWithList:(NSArray *)array
{
    [curTableView beginUpdates];
    for (int i=0; i< [array count]; i++) {
        NSMutableDictionary *dic = array[i];
        MissionInfo *info = [MissionInfo JsonModalWithDictionary:dic];
        [curList addObject:info];
        [curTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:curList.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
    }
    [curTableView endUpdates];
}

#pragma mark - scrollview delegate
/*
- (void)scrollViewDidScroll:(UIScrollView *)ascrollView
{

    CGFloat offsetx = ascrollView.contentOffset.x;
    int page = floor((offsetx - 320 / 2) / 320) ;
    self.moveLineView.left = (offsetx/3)+13;
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
    int row = ipath.row;
    MyAttendViewController *vc = [MyAttendViewController ViewContorller];
    MissionInfo *info = curList[row];
    vc.missionId = info.mission_id;
    [self.flipboardNavigationController pushViewController:vc];
}

@end
