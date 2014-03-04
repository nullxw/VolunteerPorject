//
//  MyInfoViewController.m
//  VolunteerApp
//
//  Created by zelong zou on 14-3-1.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "MyInfoViewController.h"
#import "MyInfoCell.h"
#import "ZZLHttpRequstEngine.h"
@interface MyInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *list;
    NSArray *infoList;
    UITableView *myTableView;
}
@end

@implementation MyInfoViewController

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
    [self setTitleWithString:@"我的资料"];
    list = [NSArray arrayWithObjects:@"姓名",@"性别",@"邮箱",@"手机号码",@"归属单位",@"个人排名",@"志愿时长", nil];
    UserInfo *user = [UserInfo share];
    NSString *gender;
    if (user.gender == 0) {
        gender = @"未知";
    }
    if (user.gender == 1) {
        gender = @"男";
    }
    if (user.gender == 2) {
        gender = @"女";
    }
    
    
    
    NSString *serverTime = [NSString stringWithFormat:@"%d 小时",user.serviceTime/3600];
    infoList = [NSArray arrayWithObjects:user.userName,gender,user.email,user.mobile,user.areaName,@"",serverTime,nil];
    
    
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.navView.bottom, 320, self.view.height-self.navView.bottom) style:UITableViewStyleGrouped];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    myTableView.dataSource = self;
    myTableView.delegate = self;
    [self.view addSubview:myTableView];
    
    

}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self requestRank];

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
    if ([list count]>0) {
        MyInfoCell *cell = [MyInfoCell cellForTableView:tableView fromNib:[MyInfoCell nib]];
        [cell setupWithInfo:list[indexPath.row] detailInfo:infoList[indexPath.row]];
        return cell;
    }
    return nil;
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [list count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MyInfoCell cellHeight];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (void)requestRank
{
    UserInfo *user = [UserInfo share];
    self.request = [[ZZLHttpRequstEngine engine]requestPersonalRankWithUid:user.userId otherUid:user.userId onSuccess:^(id responseObject) {
        NSLog(@"个人排名 %@",responseObject);
    } onFail:^(NSError *erro) {
        NSLog(@"%@",[erro.userInfo objectForKey:@"description"]);
        [self.view showHudMessage:@"获取个人排名失败"];
    }];
}
@end
