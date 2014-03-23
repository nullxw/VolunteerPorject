//
//  VerifyUserViewController.m
//  VolunteerApp
//
//  Created by zelong zou on 14-3-24.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "VerifyUserViewController.h"

@interface VerifyUserViewController ()
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
}
@end
