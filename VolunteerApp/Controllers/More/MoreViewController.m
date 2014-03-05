//
//  MoreViewController.m
//  VolunteerApp
//
//  Created by zelong zou on 14-2-21.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "MoreViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "HomePageVC.h"
#import "UIAlertView+Blocks.h"
#import "MyInfoViewController.h"
@interface MoreViewController ()<LoginViewDelegate>
{
    NSArray *itemList;
}

@property (strong, nonatomic) IBOutlet UIButton *quitBtn;
@property (strong, nonatomic) IBOutlet UIView *bottomView;

@property (strong, nonatomic) IBOutlet UIButton *switchBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)switchAccountAction:(UIButton *)sender;
- (IBAction)quitLoginAction:(UIButton *)sender;

@end

@implementation MoreViewController

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
    
    
    [self setTitleWithString:@"更多设置"];
    // Do any additional setup after loading the view from its nib.
    itemList = [NSArray arrayWithObjects:@"我的资料",@"我的求助", @"当前城市",@"广州志愿者项目动态",@"检查更新",@"关于志愿时",@"常见问题与反馈",nil];
    
    self.tableView.tableFooterView = self.bottomView;
    
    UIImage *bgimage1 = [[UIImage imageNamed:@"login_nl.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(15, 8, 15, 8)];
    UIImage *bgimage2 = [[UIImage imageNamed:@"login_hl.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(15, 8, 15, 8)];
    
    [self.quitBtn setBackgroundImage:bgimage1 forState:UIControlStateNormal];
    [self.quitBtn setBackgroundImage:bgimage2 forState:UIControlStateHighlighted];
    
    UIImage *bgimage3 = [[UIImage imageNamed:@"more_switch_hl.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    UIImage *bgimage4 = [[UIImage imageNamed:@"more_switch_nl.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    [self.switchBtn setBackgroundImage:bgimage4 forState:UIControlStateNormal];
    [self.switchBtn setBackgroundImage:bgimage3 forState:UIControlStateHighlighted];
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
//    self.switchBtn.top = self.tableView.bottom+20;
//    
//    self.quitBtn.top = self.switchBtn.bottom+15;
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


#pragma mark -
#pragma mark - tableviewDelegate,tableviewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"cellIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        //create cell
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor clearColor];
        
    }
    cell.textLabel.text = itemList[indexPath.row];
    return cell;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [itemList count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        MyInfoViewController *vc =[MyInfoViewController ViewContorller];
        [self.flipboardNavigationController pushViewController:vc];
    }
}

#pragma mark -  actions

#pragma mark -  actions




- (void)didLoginSuccess:(LoginViewController *)vc
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    HomePageVC *homeVC = [HomePageVC ViewContorller];
    FlipBoardNavigationController *nav = [[FlipBoardNavigationController alloc]initWithRootViewController:homeVC];
//    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    [vc presentViewController:nav animated:YES completion:^{
//        [delegate.window setRootViewController:nav];
//    }];
    [delegate.window setRootViewController:nav];
}
- (void)didLoginFailure:(LoginViewController *)vc
{
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [UIAlertView showAlertViewWithTitle:@"提示" message:@"啊哦，登录失败，请重试！" cancelButtonTitle:@"确定" otherButtonTitles:nil onDismiss:^(int buttonIndex) {
            
        } onCancel:^{
            
        }];
    });

}
- (IBAction)switchAccountAction:(UIButton *)sender {
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    for (BaseViewController *vc in self.flipboardNavigationController.viewControllers) {
        [self.flipboardNavigationController popViewController];
    }
    [delegate showWithLoginView];
    
    
}

- (IBAction)quitLoginAction:(UIButton *)sender {
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    for (BaseViewController *vc in self.flipboardNavigationController.viewControllers) {
        [self.flipboardNavigationController popViewController];
    }
    [delegate showWithLoginView];

    
}

@end
