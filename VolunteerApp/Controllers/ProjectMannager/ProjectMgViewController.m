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
#import "ProjectMgCell.h"
#import "VolunteersViewController.h"
#import "MgAttendViewController.h"
@interface ProjectMgViewController ()<UITableViewDataSource,UITableViewDelegate,ProjectMgCellDelegate>
{
    MyTableView  *projectTable;

    

    

    NSMutableArray  *secondList;


}
@property (weak, nonatomic) IBOutlet UIImageView *mTopBgView;
@property (weak, nonatomic) IBOutlet UIButton *classRankBtn;

@property (weak, nonatomic) IBOutlet UIButton *projectRankBtn;


@property (weak, nonatomic) IBOutlet UIImageView *moveLine;

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

    
    [self setTitleWithString:@"项目管理"];
    UIImage *bgimage = [[UIImage imageNamed:@"mypro_tabbarbg"]resizableImageWithCapInsets:UIEdgeInsetsMake(40, 10, 40, 10)];
    self.mTopBgView.image = bgimage;



    secondList = [[NSMutableArray alloc]init];

    




    
    projectTable = [[MyTableView alloc]initWithFrame:CGRectMake(0, self.navView.bottom,self.view.width , self.view.height-self.navView.bottom) style:UITableViewStylePlain];
    projectTable.backgroundColor = [UIColor clearColor];
    projectTable.dataSource = self;
    projectTable.delegate = self;
    projectTable.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    
    if ([secondList count] == 0) {
        [projectTable triggerPullToRefresh];
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



#pragma mark -
#pragma mark - tableviewDelegate,tableviewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyTableView *tempTableView;
    
    tempTableView = projectTable;
    
    
    if ([tempTableView.list count]>0) {
        ProjectMgCell *cell = [ProjectMgCell cellForTableView:tempTableView fromNib:[ProjectMgCell nib]];

        cell.delegate = self;
        

        cell.indexPath = indexPath;
        
        ProjectInfo *info = [tempTableView.list objectAtIndex:indexPath.row];
        [cell setupMyWaitCell:info];
        return cell;
    }

    return nil;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
        return [projectTable.list count];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ProjectMgCell cellHeight];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ProDetailViewController *vc = [ProDetailViewController ViewContorller];
    ProjectInfo *info = [projectTable.list objectAtIndex:indexPath.row];
    [vc setMissId:info.mission_id];
    [self.flipboardNavigationController pushViewController:vc completion:^{
        
    }];
}

#pragma mark -  networkData

#pragma mark -  networkData
- (void)refreshData
{

    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_global_queue(0, 0), ^(void){
        
        UserInfo *user = [UserInfo share];
         MyTableView *tempTableView;
        int flag = 0;
        
        flag = 50;
        tempTableView = projectTable;
        
        

       
        
         [[ZZLHttpRequstEngine engine] reqeustManagerGetMissionListWithUid:user.userId missionState:@"35,50,100,1000" managerCategory:1 pageSize:tempTableView.pageSize pageIndex:tempTableView.pageIndex onSuccess:^(id responseDict) {

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
    
    flag = 50;
    tempTableView = projectTable;
    
    
     [[ZZLHttpRequstEngine engine] reqeustManagerGetMissionListWithUid:user.userId missionState:@"35,50,100,1000" managerCategory:1 pageSize:tempTableView.pageSize pageIndex:tempTableView.pageIndex+1 onSuccess:^(id responseDict) {

         
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
- (void)ProjectMgCell:(ProjectMgCell *)cell actionAttend:(UIButton *)attend
{
    ProjectInfo *info = [projectTable.list objectAtIndex:cell.indexPath.row];
    MgAttendViewController *vc = [MgAttendViewController ViewContorller];
    vc.mid = info.mission_id;
    NSLog(@"<><><><><cell.indexPath.row:%d >>>",cell.indexPath.row);
    NSLog(@"<><><><><mission id:%d >>>",info.mission_id);
    [self.flipboardNavigationController pushViewController:vc];
}
- (void)ProjectMgCell:(ProjectMgCell *)cell actionRescruit:(UIButton *)rescruit
{
    VolunteersViewController *vc = [VolunteersViewController ViewContorller];

    ProjectInfo *info = [projectTable.list objectAtIndex:cell.indexPath.row];

    [vc setmissionId:info.mission_id];
    [self.flipboardNavigationController pushViewController:vc];
}
@end
