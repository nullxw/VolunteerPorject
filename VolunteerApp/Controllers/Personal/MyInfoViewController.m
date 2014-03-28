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
#import "EditInfoViewController.h"
@interface MyInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    NSArray *list;
    NSMutableArray *infoList;
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
    list = [NSArray arrayWithObjects:@"姓名",@"性别",@"邮箱",@"手机号码",@"归属单位",/*@"个人排名",*/@"志愿时长", nil];
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
    infoList = [NSMutableArray arrayWithObjects:user.userName,gender,user.email,user.mobile,user.areaName,@"",serverTime,nil];
    
    
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.navView.bottom, 320, self.view.height-self.navView.bottom) style:UITableViewStyleGrouped];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    myTableView.dataSource = self;
    myTableView.delegate = self;
    [self.view addSubview:myTableView];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(265, self.navView.bottom - 44, 46, 46);
    [btn setImage:[UIImage imageNamed:@"nav_edit.png"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(actionEdit:) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:btn];
}
- (void)actionEdit:(UIButton *)btn
{
//    for (UITextField *item in editFieldList) {
//        item.enabled = YES;
//    }
//    
//    UITextField *item1 = [editFieldList objectAtIndex:0];
//    [item1 becomeFirstResponder];
    
    EditInfoViewController *vc  = [EditInfoViewController ViewContorller];
    [self.flipboardNavigationController pushViewController:vc];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self requestRank];

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
        int row = indexPath.row;
        MyInfoCell *cell = [MyInfoCell cellForTableView:tableView fromNib:[MyInfoCell nib]];
        [cell setupWithInfo:list[row] detailInfo:infoList[row]];
        if (row>4) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
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
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int row = indexPath.row;
//    if (row == 1) {
//        [self hideEditActions];
//        [self showAction];
//    }
    if (row>=4) {
        return;
    }
    
}
- (void)hideEditActions
{
//    for (UITextField *item in editFieldList) {
//        if ([item isFirstResponder]) {
//            [item resignFirstResponder];
//        }
//    }
}


- (void)requestRank
{
    UserInfo *user = [UserInfo share];
    self.request = [[ZZLHttpRequstEngine engine]requestPersonalRankWithUid:user.userId otherUid:user.userId onSuccess:^(id responseObject) {
        NSLog(@"个人排名 %@",responseObject);
        int rank = [responseObject integerValue];
        [infoList replaceObjectAtIndex:5 withObject:[NSString stringWithFormat:@"%d",rank]];
        [myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    } onFail:^(NSError *erro) {
        NSLog(@"%@",[erro.userInfo objectForKey:@"description"]);
        
        [self.view showHudMessage:@"获取个人排名失败"];
        [infoList replaceObjectAtIndex:5 withObject:@"未知"];
        [myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}
@end
