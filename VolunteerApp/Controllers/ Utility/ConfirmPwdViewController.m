//
//  ConfirmPwdViewController.m
//  VolunteerApp
//
//  Created by zelong zou on 14-3-25.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "ConfirmPwdViewController.h"
#import "AppDelegate.h"
@interface ConfirmPwdViewController ()
{
    BOOL isRequest;
}
@property (weak, nonatomic) IBOutlet UITextField *mPasswordTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *mConfirmPasswordFiled;
- (IBAction)actionCommit:(UIButton *)sender;

@end

@implementation ConfirmPwdViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionCommit:(UIButton *)sender {
    
    [self.mPasswordTextFiled resignFirstResponder];
    [self.mConfirmPasswordFiled resignFirstResponder];
    
    if (isRequest) {
        return;
    }
    [self requestCommit];
    
}
- (void)requestCommit
{
    
    
    if (self.mPasswordTextFiled.text.length == 0 ) {
        [self.view showHudMessage:@"密码不能为空"];
        return;
    }
    if (self.mConfirmPasswordFiled.text.length == 0) {
        [self.view showHudMessage:@"确认密码不能为空"];
        return;
    }
    
    if (![self.mPasswordTextFiled.text isEqualToString:self.mConfirmPasswordFiled.text]) {
        [self.view showHudMessage:@"两次输入的密码不一致"];
        return;
    }
    
    isRequest = YES;
    UserInfo *user = [UserInfo share];
    [[ZZLHttpRequstEngine engine]requestUpdatePwdbyUserId:user.userId password:self.mPasswordTextFiled.text surePassword:self.mConfirmPasswordFiled.text onSuccess:^(id responseObject) {
        
        isRequest = NO;
        if ([responseObject isKindOfClass:[NSString class]]) {
            [self.view showHudMessage:responseObject];
            
        }
        [self performSelector:@selector(quitToLogin) withObject:nil afterDelay:2];
        
    } onFail:^(NSError *erro) {
        isRequest = NO;
        [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
        
    }];
}

- (void)quitToLogin
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    for (BaseViewController *vc in self.flipboardNavigationController.viewControllers) {
        [self.flipboardNavigationController popViewController];
    }
    UserInfo *user = [UserInfo share];
    [user clear];
    [delegate showWithLoginView];
}

@end
