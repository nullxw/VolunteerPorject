//
//  LoginViewController.m
//  VolunteerApp
//
//  Created by zelong zou on 14-2-21.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "LoginViewController.h"
#import "CustomUITextField.h"
#import "QCheckBox.h"
#import "FlipBoardNavigationController.h"
#import "ZZLHttpRequstEngine.h"
#import "UserInfo.h"
#import "RegisterViewController.h"
//#import "VolunInfoViewController.h"
#import "VerifyUserViewController.h"
//#import "ProTrendViewController.h"
//#import "HomePageVC.h"
#define check1Tage   39430
#define check2Tage   90098
@interface LoginViewController ()<QCheckBoxDelegate,UITextFieldDelegate>
{
  

}
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *lgoinBgView;
@property (weak, nonatomic) IBOutlet UIButton *lgoinBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet CustomUITextField *mUserNameTextFiled;
@property (weak, nonatomic) IBOutlet CustomUITextField *mPasswordTextFiled;
@property (weak, nonatomic) IBOutlet QCheckBox *mRemeberPwdBtn;
@property (weak, nonatomic) IBOutlet QCheckBox *mAutoLoginBtn;
- (IBAction)loginAction:(UIButton *)sender;
- (IBAction)actionRegsiter:(UIButton *)sender;
- (IBAction)actionAutoLogin:(QCheckBox *)sender;
- (IBAction)actionRemberPwd:(QCheckBox *)sender;
- (IBAction)actionBrowser:(UIButton *)sender;
- (IBAction)actionGetPwd:(UIButton *)sender;
@end

@implementation LoginViewController

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
    
    if (DEVICE_IS_IPHONE5) {
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
            self.view.height+=108;
        }else{
            self.view.height+=88;
        }
        
    }
    QCheckBox *_check1 = [[QCheckBox alloc] initWithDelegate:self];
    _check1.frame = CGRectMake(34, self.topView.bottom+30, 150, 40);
    [_check1 setTitle:@" 记住密码          |" forState:UIControlStateNormal];
    [_check1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_check1.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    _check1.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _check1.tag = check1Tage;
    [self.view addSubview:_check1];


    UserInfo *user = [UserInfo share];
    _check1.checked = user.shouldSavePwd;
    _check1.checked = YES;
    _check1.hidden = YES;
    
    QCheckBox *_check2 = [[QCheckBox alloc] initWithDelegate:self];
    _check2.frame = CGRectMake(188, _check1.top, 80, 40);
    [_check2 setTitle:@" 自动登录" forState:UIControlStateNormal];
    [_check2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_check2.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    _check2.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _check2.tag = check2Tage;
    [self.view addSubview:_check2];
    _check2.checked = user.shouldAutoLogin;
    _check2.checked = YES;
    _check2.hidden = YES;
    
    
    self.mUserNameTextFiled.rightViewMode = UITextFieldViewModeNever;

    self.mUserNameTextFiled.rightView = nil;
    self.mUserNameTextFiled.isCustom = NO;
    self.mPasswordTextFiled.isCustom = NO;
    self.mPasswordTextFiled.rightView = nil;
    self.mPasswordTextFiled.rightViewMode = UITextFieldViewModeNever;

    
    
    [self.mUserNameTextFiled setFieldType:kXHUserNameField];
    [self.mPasswordTextFiled setFieldType:kXHPasswordField];
    
    self.mPasswordTextFiled.delegate = self;
    
    if (user.shouldSavePwd || user.shouldAutoLogin) {
        self.mUserNameTextFiled.text = user.locaUserName;
        self.mPasswordTextFiled.text = user.locaPwd;
    }
    
    if (!user.shouldAutoLogin && !user.shouldSavePwd) {
        
        self.mUserNameTextFiled.text = user.locaUserName;
    }
//35 72/ 26 26

    UIImage *bgimage1 = [[UIImage imageNamed:@"login_nl.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(15, 8, 15, 8)];
    UIImage *bgimage2 = [[UIImage imageNamed:@"login_hl.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(15, 8, 15, 8)];
    [self.lgoinBtn setBackgroundImage:bgimage1 forState:UIControlStateNormal];
    [self.lgoinBtn setBackgroundImage:bgimage2 forState:UIControlStateHighlighted];
    
    //
    UIImage *bgimage3 = [[UIImage imageNamed:@"login_winbg.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    self.lgoinBgView.image = bgimage3;
    
    UIImage *bgimage4 = [[UIImage imageNamed:@"home_proom_nl.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(15, 8, 15, 8)];
    UIImage *bgimage5 = [[UIImage imageNamed:@"home_proom_hl.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(15, 8, 15, 8)];
    [self.registerBtn setBackgroundImage:bgimage4 forState:UIControlStateNormal];
    [self.registerBtn setBackgroundImage:bgimage5 forState:UIControlStateHighlighted];
    
    
    


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.mPasswordTextFiled) {
        [UIView animateWithDuration:0.3 animations:^{
            self.topView.top = 70;
        }];
    }

}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == self.mPasswordTextFiled) {
        [UIView animateWithDuration:0.3 animations:^{
            self.topView.top = 130;
        }];
    }
 
}
#pragma mark - QCheckBoxDelegate

- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked {

    UserInfo *user = [UserInfo share];
    if (checkbox.tag == check1Tage) {

        
        
        if (checked) {
            
            user.shouldSavePwd = YES;
            
        }else{
            
            user.shouldSavePwd = NO;
            
        }
        
    }else {
        if (checked) {
            
            user.shouldAutoLogin = YES;
            
        }else{
            
            user.shouldAutoLogin = NO;
        }
    }
}

//bjjtgw
//123456
/*
 areaId = 402800e24448445a0144489d02850008;
 areaName = "\U5730\U5e02";
 email = "";
 gender = 0;
 head = "";
 idcardCode = "";
 idcardType = 0;
 integral = 0;
 mobile = "";
 politicalStatus = 0;
 purview = "MANAGER_SHOW";
 queryPurview = 0;
 serviceTime = 0;
 token = 97113ABA7025BDDDEEBD3789A06CDA7D96E3C48E78B7D14D6897F0164B2BCA9F;
 userId = bba9a7e236f8858c01370b74946a0082;
 userName = "";
 userPwd = "";
 userPwdNew = "";
 vvalue = 0;
 */
- (void)clearPassword
{
    if (self.mPasswordTextFiled.text.length>0) {
        self.mPasswordTextFiled.text = @"";
    }
}
- (IBAction)loginAction:(UIButton *)sender {
 
    

    [self hideActions];
    if ([self.mUserNameTextFiled.text trimmedWhitespaceString].length == 0) {
        [self.view showHudMessage:@"用户名不能为空"];
        return;
    }
    if ([self.mPasswordTextFiled.text trimmedWhitespaceString].length == 0) {
        [self.view showHudMessage:@"密码不能为空"];
        return;
    }


    [self loginWithUserName:self.mUserNameTextFiled.text password:self.mPasswordTextFiled.text automic:NO];
    //44522419910504515X
     //860101
        //[self loginWithUserName:@"44522419910504515X" password:@"860101" automic:NO];

}
- (void)loginWithUserName:(NSString *)userName password:(NSString *)pwd automic:(BOOL)isAutomic
{
    
    ZZLHttpRequstEngine *engine = [ZZLHttpRequstEngine engine];
    [self.view showLoadingViewWithString:@"登录中..."];
    [engine loginWithUserName:userName
                     password:pwd
                    onSuccess:^(NSMutableDictionary *responseDict)
    {
        [self.view hideLoadingView];
        NSLog(@"---->>>>%@",responseDict);
                        
        UserInfo *user = [[UserInfo share] setUpWithJsonDictionary:responseDict];
                        if (!isAutomic) {
                            user.locaUserName = userName;
                            user.locaPwd = pwd;
                        }
        [engine setAccessToken:user.token];
        [user handleSuccessLogin];
                        if (_delegate &&[_delegate respondsToSelector:@selector(didLoginSuccess:)]) {
                            [_delegate didLoginSuccess:self];
                        }

    } onFail:^(NSError *erro) {
        if (_delegate &&[_delegate respondsToSelector:@selector(didLoginFailure:)]) {
            [_delegate didLoginFailure:self];
        }
        [self.view hideLoadingView];
        [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
        NSLog(@"error:%@",[erro.userInfo objectForKey:@"description"]);
    }];

}
- (IBAction)actionRegsiter:(UIButton *)sender {
    RegisterViewController *vc = [[RegisterViewController alloc]init];
//    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [self presentViewController:vc animated:YES completion:^{
//        
//    }];
    [self.flipboardNavigationController pushViewController:vc];
    
}

- (IBAction)actionAutoLogin:(QCheckBox *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)actionRemberPwd:(QCheckBox *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)actionBrowser:(UIButton *)sender {
    
//    VolunInfoViewController *vc = [VolunInfoViewController ViewContorller];
//    [self.flipboardNavigationController pushViewController:vc];
    
//    ProTrendViewController *vc = [ProTrendViewController ViewContorller];
//    [self.flipboardNavigationController pushViewController:vc];
//    HomePageVC *vc = [HomePageVC ViewContorller];
//    [self.flipboardNavigationController pushViewController:vc];
    
    if (_delegate && [_delegate respondsToSelector:@selector(didLoginWithVisitor:)]) {
        [_delegate didLoginWithVisitor:self];
    }
    
}

- (IBAction)actionGetPwd:(UIButton *)sender {
    
    VerifyUserViewController *vc = [VerifyUserViewController ViewContorller];
    [self.flipboardNavigationController pushViewController:vc];
}

- (void)hideActions
{
    [self.mUserNameTextFiled resignFirstResponder];
    [self.mPasswordTextFiled resignFirstResponder];
}
@end
