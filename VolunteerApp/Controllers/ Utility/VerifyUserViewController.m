//
//  VerifyUserViewController.m
//  VolunteerApp
//
//  Created by zelong zou on 14-3-24.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "VerifyUserViewController.h"
#import "ConfirmPwdViewController.h"
#import "UIView+Additon.h"
@interface VerifyUserViewController ()
{
    NSString *verifyCode;
}
@property (weak, nonatomic) IBOutlet UITextField *mUserNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *mVerityCodeTextFiled;
- (IBAction)actionVerifyCode:(UIButton *)sender;
- (IBAction)actionCommit:(UIButton *)sender;

@end

@implementation VerifyUserViewController

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
    [self setTitleWithString:@"找回密码"];
    verifyCode = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionVerifyCode:(UIButton *)sender {
    [self.mUserNameTextField resignFirstResponder];
    [self.mVerityCodeTextFiled resignFirstResponder];
    if (self.mUserNameTextField.text.length == 0) {
        [self.view showHudMessage:@"用户名不能为空"];
        return;
    }
    [self requestCode];
    
}

- (IBAction)actionCommit:(UIButton *)sender {

    [self.mUserNameTextField resignFirstResponder];
    [self.mVerityCodeTextFiled resignFirstResponder];
    if (self.mUserNameTextField.text.length == 0) {
        [self.view showHudMessage:@"用户名不能为空"];
        return;
    }
    if (self.mVerityCodeTextFiled.text.length == 0) {
        [self.view showHudMessage:@"验证码不能为空"];
        return;
    }
    [self checkVerifyCode];
    
}

- (void)requestCode
{
    if (verifyCode.length>0) {
        return;
    }
    [[ZZLHttpRequstEngine engine] requestCheckAccountWithIdcardCode:self.mUserNameTextField.text onSuccess:^(id responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dic = [responseObject objectAtIndex:0];
            if (dic) {
                verifyCode = [dic objectForKey:@"verifyCode"];
                [self.view showHudMessage:@"验证码已发至您的手机"];
                
                self.mUserNameTextField.enabled = NO;
                NSLog(@"verifycode: %@",verifyCode);
            }
            
            
            
            

            
        });
        
    } onFail:^(NSError *erro) {
        verifyCode = @"";
        [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
    }];
}

- (void)checkVerifyCode
{
    
    if (verifyCode.length>0) {
        if ([verifyCode isEqualToString:self.mVerityCodeTextFiled.text]) {
            ConfirmPwdViewController *vc = [ConfirmPwdViewController ViewContorller];
            vc.userName = self.mUserNameTextField.text;
            [self.flipboardNavigationController pushViewController:vc];
        }else{
            [self.view showHudMessage:@"验证码输入有误"];
            return;
        }
    }

}
@end
