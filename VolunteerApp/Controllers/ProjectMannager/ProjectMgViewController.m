//
//  ProjectMgViewController.m
//  VolunteerApp
//
//  Created by zelong zou on 14-2-21.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "ProjectMgViewController.h"
#import "ProDetailViewController.h"
#import "MyTableView.h"
#import "ZZLHttpRequstEngine.h"
#import "SVPullToRefresh.h"
#import "ProjectInfo.h"
#import "ProManagerCell.h"
@interface ProjectMgViewController ()<UITableViewDataSource,UITableViewDelegate,MyProManagerCellDelegate>
{
    MyTableView  *projectTable;

    
    int          curPage;
    
    NSMutableArray  *firstList;
    NSMutableArray  *secondList;


}
@property (weak, nonatomic) IBOutlet UIImageView *mTopBgView;
@property (weak, nonatomic) IBOutlet UIButton *classRankBtn;

@property (weak, nonatomic) IBOutlet UIButton *projectRankBtn;


@property (weak, nonatomic) IBOutlet UIImageView *moveLine;
@property (weak, nonatomic) IBOutlet MyTableView *rankTable;
- (IBAction)actionClass:(UIButton *)sender;
- (IBAction)actionProject:(UIButton *)sender;
@end

@implementation ProjectMgViewController

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
    [self commonInit];
    
}
- (void)commonInit
{
    self.classRankBtn.selected = YES;
    self.rankTable.backgroundColor = [UIColor clearColor];
    
    [self setTitleWithString:@"项目管理"];
    UIImage *bgimage = [[UIImage imageNamed:@"mypro_tabbarbg"]resizableImageWithCapInsets:UIEdgeInsetsMake(40, 10, 40, 10)];
    self.mTopBgView.image = bgimage;
    self.rankTable.pageIndex = 0;
    self.rankTable.pageSize = 10;
    
    curPage = 0;
    firstList = [[NSMutableArray alloc]init];
    secondList = [[NSMutableArray alloc]init];

    
    self.rankTable.list = firstList;


    [self setupRefreshControl];
    
    if ([firstList count] == 0) {
        [self.rankTable triggerPullToRefresh];
    }
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

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark - actions
- (void)moveLineToLeft
{
    
    if (self.moveLine.centerX != self.classRankBtn.centerX) {
        
        [self.rankTable removeCenterMsgView];
        [UIView animateWithDuration:0.3 animations:^{
            self.moveLine.centerX = self.classRankBtn.centerX;
            self.rankTable.left = 0;
            projectTable.left = self.rankTable.width;
        } completion:^(BOOL finished) {
            self.projectRankBtn.selected = NO;
            self.classRankBtn.selected = YES;
            curPage = 0;
            self.rankTable.hidden = NO;
            
            if ([self.rankTable.list count]==0 &&!self.rankTable.hasRequest) {
                [self.rankTable triggerPullToRefresh];
            }
        }];
    }

}
- (void)moveLineToRight
{

    
    
    if (self.moveLine.centerX != self.projectRankBtn.centerX) {
        

        

        [UIView animateWithDuration:0.3 animations:^{
            self.moveLine.centerX = self.projectRankBtn.centerX;
            self.rankTable.left = -self.rankTable.width;
            projectTable.left = 0;
        } completion:^(BOOL finished) {
            self.projectRankBtn.selected = YES;
            self.classRankBtn.selected = NO;
            self.rankTable.hidden = YES;
            
            curPage = 1;
            if ([projectTable.list count]==0  && !projectTable.hasRequest) {
                [projectTable triggerPullToRefresh];
            }
        }];
    }

}
- (IBAction)actionClass:(UIButton *)sender {
    
    [self moveLineToLeft];
}

- (IBAction)actionProject:(UIButton *)sender {

    if (!projectTable) {
        
        projectTable = [[MyTableView alloc]initWithFrame:self.rankTable.frame style:UITableViewStylePlain];
        projectTable.backgroundColor = [UIColor clearColor];
        projectTable.dataSource = self;
        projectTable.delegate = self;
        projectTable.pageIndex = 0;
        projectTable.pageSize = 10;
        projectTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        projectTable.left = self.rankTable.right;
        projectTable.list = secondList;
        [self.view addSubview:projectTable];
        
        __weak ProjectMgViewController *weakSelf = self;
        [projectTable addPullToRefreshWithActionHandler:^{
            [weakSelf refreshData];
        }];

        [projectTable addInfiniteScrollingWithActionHandler:^{
            [weakSelf loadMore];
        }];
        projectTable.infiniteScrollingView.enabled = NO;
        
    }
    [self moveLineToRight];
}

#pragma mark -
#pragma mark - tableviewDelegate,tableviewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyTableView *tempTableView;
    if (tableView == self.rankTable) {
        tempTableView = self.rankTable;
    }else{
        tempTableView = projectTable;
    }
    
    if ([tempTableView.list count]>0) {
        ProManagerCell *cell = [ProManagerCell cellForTableView:tempTableView fromNib:[ProManagerCell nib]];
        cell.cellInPath = indexPath;
        cell.delegate = self;
        if (curPage == 0) {
            cell.cellType = kMyprojectCellType_Plan;
        }else{
            cell.cellType = kMyprojectCellType_Manage;
        }
        
        ProjectInfo *info = [tempTableView.list objectAtIndex:indexPath.row];
        [cell setupMyWaitCell:info];
        return cell;
    }

    return nil;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.rankTable) {
        return [self.rankTable.list count];
    }else{
        return [projectTable.list count];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ProManagerCell cellHeight];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ProDetailViewController *vc = [ProDetailViewController ViewContorller];
    [self.flipboardNavigationController pushViewController:vc completion:^{
        
    }];
}

#pragma mark -  networkData

#pragma mark -  networkData
- (void)setupRefreshControl
{
    __weak ProjectMgViewController *weakSelf = self;
    [weakSelf.rankTable addPullToRefreshWithActionHandler:^{
        [weakSelf refreshData];
    }];
    [weakSelf.rankTable addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
    self.rankTable.infiniteScrollingView.enabled = NO;
}

- (void)refreshData
{

    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_global_queue(0, 0), ^(void){
        
        UserInfo *user = [UserInfo share];
         MyTableView *tempTableView;
        int flag = 0;
        if (curPage == 0) {
            flag  = 20;
            tempTableView = self.rankTable;
        }else{
            flag = 50;
            tempTableView = projectTable;
        }
        

       
        
         [[ZZLHttpRequstEngine engine] reqeustManagerGetMissionListWithUid:user.userId missionState:[NSString stringWithFormat:@"%d",flag] managerCategory:curPage+1 pageSize:tempTableView.pageSize pageIndex:tempTableView.pageIndex onSuccess:^(id responseDict) {

            [tempTableView.pullToRefreshView stopAnimating];
            NSLog(@"___YYY__%@",responseDict);
            if ([responseDict isKindOfClass:[NSArray class]]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    int itemCount = [responseDict count];
                    if (itemCount == 0 ) {
                        if ([tempTableView.list count]==0) {
                            [tempTableView reloadData];
                            [tempTableView addCenterMsgView:@"数据空空～"];
                        }else{
                            [tempTableView.pullToRefreshView stopAnimating];
                        }
                        
                        return ;
                        
                    }else{
                        [tempTableView removeCenterMsgView];
                        if ([tempTableView.list count] > 0) {
                            [tempTableView.list removeAllObjects];
                            [tempTableView reloadData];
                            tempTableView.pageIndex = 1;
                            
                        }
                        for (int i=0; i< itemCount; i++) {
                            NSMutableDictionary *dic = responseDict[i];
                            ProjectInfo *info = [ProjectInfo JsonModalWithDictionary:dic];
                            [tempTableView.list addObject:info];
                        
                        }
                        [tempTableView insertRowAtTopWithCount:itemCount];
                        
                        if (itemCount%tempTableView.pageSize == 0) {
                            tempTableView.infiniteScrollingView.enabled = YES;
                        }
                        
                    }
                    
                }) ;
            }
            
        } onFail:^(NSError *erro) {
            NSLog(@"___xxx___%@",[erro.userInfo objectForKey:@"description"]);
            
            
            [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
            [tempTableView.pullToRefreshView stopAnimating];
            
        }];
    });
    
}
- (void)loadMore
{
    UserInfo *user = [UserInfo share];
    

    MyTableView *tempTableView;
    int flag = 0;
    if (curPage == 0) {
        flag  = 20;
        tempTableView = self.rankTable;
    }else{
        flag = 50;
        tempTableView = projectTable;
    }
    
     [[ZZLHttpRequstEngine engine] reqeustManagerGetMissionListWithUid:user.userId missionState:[NSString stringWithFormat:@"%d",flag] managerCategory:curPage+1 pageSize:tempTableView.pageSize pageIndex:tempTableView.pageIndex+1 onSuccess:^(id responseDict) {

         
        [tempTableView.infiniteScrollingView stopAnimating];
        NSLog(@"___YYY__%@",responseDict);
        if ([responseDict isKindOfClass:[NSArray class]]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                int itemCount = [responseDict count];
                if (itemCount == 0 ) {
                    
                    tempTableView.infiniteScrollingView.enabled = NO;
                }else{
                    
                    for (int i=0; i< itemCount; i++) {
                        NSMutableDictionary *dic = responseDict[i];
                        ProjectInfo *info = [ProjectInfo JsonModalWithDictionary:dic];
                        [tempTableView.list addObject:info];
                        
                    }
                    [tempTableView insertRowAtBottomWithCount:itemCount];
                    if (itemCount%tempTableView.pageSize == 0) {
                        tempTableView.pageIndex++;
                        tempTableView.infiniteScrollingView.enabled = YES;
                    }else{
                        tempTableView.infiniteScrollingView.enabled = NO;
                    }
                    
                }
                
            }) ;
        }
        
    } onFail:^(NSError *erro) {
        NSLog(@"___xxx___%@",[erro.userInfo objectForKey:@"description"]);
        
        
        [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
        [tempTableView.infiniteScrollingView stopAnimating];
    }];
}


#pragma mark - action
- (void)actionRecruitBtn:(ProManagerCell *)cell AtIndexPath:(NSIndexPath *)ipath withType:(MyprojectCellType)type
{
    
}
- (void)actionAttendBtn:(ProManagerCell *)cell AtIndexPath:(NSIndexPath *)ipath withType:(MyprojectCellType)type
{
    
}
@end
