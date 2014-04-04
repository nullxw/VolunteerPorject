//
//  HomePageVC.m
//  VolunteerApp
//
//  Created by zelong zou on 14-2-20.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "HomePageVC.h"
#import "FlipBoardNavigationController.h"
#import "MyProjectViewController.h"
#import "PersonalViewController.h"
#import "ProjectMgViewController.h"
#import "ProjectSearchViewController.h"
#import "MoreViewController.h"
#import "LoginViewController.h"
#import "UIImageView+WebCache.h"
#import "VolunInfoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ProTrendViewController.h"
#import "MyInfoViewController.h"
#import "ZZLHttpRequstEngine.h"
#import "UrlDefine.h"
#import "AppDelegate.h"
#import "UIAlertView+Blocks.h"
#import "NSString+WiFi.h"
@interface HomePageVC ()
{
    BOOL isManager;
    BOOL isLogin;
    NSArray *btnlist;
    NSArray *btnHighlist;
    NSArray *titlelist;
}
//properties:
@property (weak, nonatomic) IBOutlet UIView *mPersonView;
@property (weak, nonatomic) IBOutlet UIImageView *mAvatorImage;
@property (weak, nonatomic) IBOutlet UILabel *mNameLb;
@property (weak, nonatomic) IBOutlet UILabel *mTimeLb;
@property (weak, nonatomic) IBOutlet UILabel *mLvValuelb;
@property (weak, nonatomic) IBOutlet UILabel *mScroeLb;
@property (weak, nonatomic) IBOutlet UIButton *mPerRoomBtn;
@property (weak, nonatomic) IBOutlet UIImageView *mPersonBg;
@property (weak, nonatomic) IBOutlet UIButton *mProMgBtn;
@property (weak, nonatomic) IBOutlet UIButton *mMyProBtn;
@property (weak, nonatomic) IBOutlet UIButton *mProSearchBtn;
@property (weak, nonatomic) IBOutlet UIButton *mMoreBtn;
@property (weak, nonatomic) IBOutlet UIButton *mProTrendBtn;
@property (weak, nonatomic) IBOutlet UILabel *mProTrendText;
@property (weak, nonatomic) IBOutlet UILabel *mMyProText;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *mStarImageView;

//actions:
- (IBAction)goPersonal:(UIButton *)sender;

- (IBAction)goProManager:(UIButton *)sender;

- (IBAction)goMyPro:(UIButton *)sender;


- (IBAction)goProSearch:(UIButton *)sender;


- (IBAction)goMore:(UIButton *)sender;
- (IBAction)goVolunInfo:(UIButton *)sender;

- (IBAction)goMyInfo:(UIButton *)sender;
@end

@implementation HomePageVC
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
+(id)ViewContorller
{
    if (DEVICE_IS_IPHONE5) {
        return [[HomePageVC alloc]initWithNibName:@"HomePageVC-5" bundle:nil];
    }else{
        return [[HomePageVC alloc]initWithNibName:@"HomePageVC" bundle:nil];
    }
}

- (void)updateData:(BOOL)islogin
{
    isLogin = islogin;
}

#pragma mark - view Lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    titlelist = @[@"志愿资讯",@"项目动态",@"项目搜索",@"我的项目",@"我的资料",@"更多选项",@""];
    
    UserInfo *user = [UserInfo share];
    
    isLogin = user.islogin;
    if ([user.purview isEqualToString:@"MANAGER_SHOW"]) {
        isManager = YES;
        
        self.mProTrendText.text = @"项目管理";
//        [self.mMyProBtn setImage:[UIImage imageNamed:@"home_register_nl"] forState:UIControlStateNormal];
//        [self.mMyProBtn setImage:[UIImage imageNamed:@"home_register_hl"] forState:UIControlStateHighlighted];
        self.mMyProText.text = @"我的项目";
    }
    self.mScrollView.clipsToBounds =YES;
    
    [self setUpView];
    [self setTitleWithString:@"广东志愿者"];
    [self setBackBtnHidden];
    
    if (isLogin) {
        [self requestUserInfo];
    }else{
        [self updateVisitorInfo];
    }
    

}
- (void)awakeFromNib
{
    [super awakeFromNib];
    
}
- (void)viewDidUnload {
    [super viewDidUnload];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    if (self.mScrollView.contentSize.height != 750) {
//        self.mScrollView.contentSize = CGSizeMake(self.view.width, 750);
//        
//    }

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
- (void)setUpView
{
    UIImage *bgImage = [[UIImage imageNamed:@"home_bg"]
                        stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    self.mPersonBg.image = bgImage;
    
    UIImage *proomBtnNLBg = [[UIImage imageNamed:@"home_proom_nl.png"]stretchableImageWithLeftCapWidth:6 topCapHeight:22];
    UIImage *proomBtnHLBg = [[UIImage imageNamed:@"home_proom_hl.png"]stretchableImageWithLeftCapWidth:6 topCapHeight:22];
    [self.mPerRoomBtn setBackgroundImage:proomBtnNLBg forState:UIControlStateNormal];
    [self.mPerRoomBtn setBackgroundImage:proomBtnHLBg forState:UIControlStateHighlighted];
    
    UIImage *btn1NLbg = [[UIImage imageNamed:@"home_promg_nl"]stretchableImageWithLeftCapWidth:10 topCapHeight:60];
    UIImage *btn1Hlbg = [[UIImage imageNamed:@"home_promg_hl.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:60];
    [self.mProMgBtn setBackgroundImage:btn1NLbg forState:UIControlStateNormal];
    [self.mProMgBtn setBackgroundImage:btn1Hlbg forState:UIControlStateHighlighted];
    
    UIImage *btn2NLbg = [[UIImage imageNamed:@"home_my_nl"]stretchableImageWithLeftCapWidth:10 topCapHeight:60];
    UIImage *btn2Hlbg = [[UIImage imageNamed:@"home_my_hl"]stretchableImageWithLeftCapWidth:10 topCapHeight:60];
    [self.mMyProBtn setBackgroundImage:btn2NLbg forState:UIControlStateNormal];
    [self.mMyProBtn setBackgroundImage:btn2Hlbg forState:UIControlStateHighlighted];
    
    
    UIImage *btn3NLbg = [[UIImage imageNamed:@"home_search_nl.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:60];
    UIImage *btn3Hlbg = [[UIImage imageNamed:@"home_search_hl.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:60];
    [self.mProSearchBtn setBackgroundImage:btn3NLbg forState:UIControlStateNormal];
    [self.mProSearchBtn setBackgroundImage:btn3Hlbg forState:UIControlStateHighlighted];
    
    UIImage *btn4NLbg = [[UIImage imageNamed:@"home_more_nl.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:60];
    UIImage *btn4Hlbg = [[UIImage imageNamed:@"home_more_hl.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:60];
    [self.mMoreBtn setBackgroundImage:btn4NLbg forState:UIControlStateNormal];
    [self.mMoreBtn setBackgroundImage:btn4Hlbg forState:UIControlStateHighlighted];
    
    self.mAvatorImage.layer.cornerRadius = 10.0f;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goPersonal:(UIButton *)sender {
    
    if (!isLogin) {
        [self handleNotLogin];
        return;
    }
    PersonalViewController *vc = [PersonalViewController ViewContorller];
    [self.flipboardNavigationController pushViewController:vc];
}

- (IBAction)goProManager:(UIButton *)sender {

    if (!isLogin) {
        ProTrendViewController *vc = [ProTrendViewController ViewContorller];
        [self.flipboardNavigationController pushViewController:vc];
        return;
    }
    
    if (isManager) {
        
        ProjectMgViewController *vc = [ProjectMgViewController ViewContorller];
        [self.flipboardNavigationController pushViewController:vc];
    }else{
        ProTrendViewController *vc = [ProTrendViewController ViewContorller];
        [self.flipboardNavigationController pushViewController:vc];
    }
    
}

- (IBAction)goMyPro:(UIButton *)sender {
    
    if (!isLogin) {
        [self handleNotLogin];
        return;
    }
//    if (isManager) {
//        ProTrendViewController *vc = [ProTrendViewController ViewContorller];
//        [self.flipboardNavigationController pushViewController:vc];
//    }else{
        MyProjectViewController *vc = [MyProjectViewController ViewContorller];
        [self.flipboardNavigationController pushViewController:vc];
//    }

}

- (IBAction)goProSearch:(UIButton *)sender {
    ProjectSearchViewController *vc = [ProjectSearchViewController ViewContorller];
    [self.flipboardNavigationController pushViewController:vc];
}

- (IBAction)goMore:(UIButton *)sender {
//    if (!isLogin) {
//        [self handleNotLogin];
//        return;
//    }
    MoreViewController *vc = [MoreViewController ViewContorller];
    [self.flipboardNavigationController pushViewController:vc];

}

- (IBAction)goVolunInfo:(UIButton *)sender {
    
    VolunInfoViewController *vc = [VolunInfoViewController ViewContorller];
    [self.flipboardNavigationController pushViewController:vc];
    
}

- (IBAction)goMyInfo:(UIButton *)sender {
    
    if (!isLogin) {
        [self handleNotLogin];
        return;
    }
    MyInfoViewController *vc = [MyInfoViewController ViewContorller];
    [self.flipboardNavigationController pushViewController:vc];

}

- (void)handleNotLogin
{
    
    [UIAlertView showAlertViewWithTitle:@"提示" message:@"您需要登录才能继续操作！" cancelButtonTitle:@"取消" otherButtonTitles:@[@"去登录"] onDismiss:^(int buttonIndex) {
        
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        for (BaseViewController *vc in self.flipboardNavigationController.viewControllers) {
            [self.flipboardNavigationController popViewController];
        }
        UserInfo *user = [UserInfo share];
        [user clear];
        [delegate showWithLoginView];

    } onCancel:^{
        
    }];

}

#pragma mark -  updat ui
- (void)requestUserInfo
{
    UserInfo *user = [UserInfo share];
    [[ZZLHttpRequstEngine engine] requestUserGetUserInfoWithUid:[user valueForKey:@"userId"] curid:[user valueForKey:@"userId"] onSuccess:^(NSMutableDictionary *responseDict) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"info :---->>>>%@",responseDict);
            [user updateUserInfoWithDic:responseDict];
            [self updateUI];
        });

    } onFail:^(NSError *erro) {
        NSLog(@"error2222:%@",[erro.userInfo objectForKey:@"description"]);
    }];
}
- (void)updateUI
{
    UserInfo *user = [UserInfo share];
    self.mNameLb.text = user.userName;
    
    self.mStarImageView.left = self.mNameLb.right+5;
    self.mTimeLb.left = self.mStarImageView.right+5;
    

    [self.mAvatorImage setImageWithURL:[NSURL URLWithString:[user.head checkUrl]] placeholderImage:[UIImage imageNamed:@"home_avator.png"]];
    self.mLvValuelb.text = [NSString stringWithFormat:@"%d",user.vvalue];
    self.mTimeLb.text = [[NSString stringWithFormat:@"%d",user.serviceTime/60] stringByAppendingString:@"小时"];
    self.mScroeLb.text = [[NSString stringWithFormat:@"%d",user.integral ]stringByAppendingString:@"分"];
    
}
- (void)updateVisitorInfo
{
    self.mNameLb.text = @"游客";
    self.mStarImageView.left = self.mNameLb.right+5;
    self.mTimeLb.left = self.mStarImageView.right+5;
    self.mAvatorImage.image = [UIImage imageNamed:@"home_avator.png"];

    
    
    
    self.mLvValuelb.text = [NSString stringWithFormat:@"%d",0];
    self.mTimeLb.text = [[NSString stringWithFormat:@"%d",0] stringByAppendingString:@"小时"];
    self.mScroeLb.text = [[NSString stringWithFormat:@"%d",0]stringByAppendingString:@"分"];
}
@end
