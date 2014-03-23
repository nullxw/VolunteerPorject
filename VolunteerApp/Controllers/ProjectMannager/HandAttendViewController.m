//
//  HandAttendViewController.m
//  VolunteerApp
//
//  Created by zelong zou on 14-3-22.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "HandAttendViewController.h"

@interface HandAttendViewController ()<UITextFieldDelegate>
{
    BOOL isrequest;
}
@property (weak, nonatomic) IBOutlet UIImageView *mBgView;
@property (weak, nonatomic) IBOutlet UILabel *mName;
@property (weak, nonatomic) IBOutlet UILabel *mTime;
@property (weak, nonatomic) IBOutlet UILabel *mTitle;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mSegment;
@property (weak, nonatomic) IBOutlet UITextField *mhourTextField;
@property (weak, nonatomic) IBOutlet UITextField *mMinuteTextFiled;
@property (weak, nonatomic) IBOutlet UIView *mContainerView;
- (IBAction)actionCommit:(UIButton *)sender;
@end

@implementation HandAttendViewController

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
    [self setTitleWithString:@"手工考勤"];
    [self.view sendSubviewToBack:self.mContainerView];
    self.mMinuteTextFiled.delegate = self;
    [self updateUI];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.mhourTextField resignFirstResponder];
    [self.mMinuteTextFiled resignFirstResponder];
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
- (void)updateUI
{
    UIImage *bgimage = [[UIImage imageNamed:@"mypro_cellbg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] ;
    self.mBgView.image = bgimage;
    self.mBgView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapbg:)];
    [self.mBgView addGestureRecognizer:tap];
    
    self.mTitle.text = self.attendInfo.missionName;
    self.mName.text = self.attendInfo._userName;
    self.mTime.text = self.attendInfo._checkOnDate;
    
    
}
- (void)moveUp
{
    if (self.mContainerView.top  != self.navView.bottom-50 ) {
        [UIView animateWithDuration:0.3 animations:^{
            self.mContainerView.top = self.navView.bottom-50;
        }];
    }
}
- (void)moveDown
{
    if (self.mContainerView.top  == self.navView.bottom-50 ) {
        [UIView animateWithDuration:0.3 animations:^{
            self.mContainerView.top = self.navView.bottom;
        }];
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self moveUp];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self moveDown];
}
- (IBAction)actionCommit:(UIButton *)sender {
    
    [self.mhourTextField resignFirstResponder];
    [self.mMinuteTextFiled resignFirstResponder];
    if (!isrequest) {
        UserInfo *user = [UserInfo share];
        isrequest = YES;
        [[ZZLHttpRequstEngine engine]requestProjectMissionSiginWithMobileWithUid:user.userId curId:self.attendInfo.userId missionId:self.mid statue:self.mSegment.selectedSegmentIndex+1 checkOnDate:self.attendInfo._checkOnDate hour:[self.mhourTextField.text integerValue] minute:[self.mMinuteTextFiled.text integerValue] teamId:self.teamId onSuccess:^(id responseObject) {
            NSLog(@"服务器返回:%@",responseObject);
            if ([responseObject isKindOfClass:[NSString class]]) {
                [self.view showHudMessage:responseObject];
            }
            
            isrequest = NO;
        } onFail:^(NSError *erro) {
            [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
            isrequest = NO;
        }];
    }

}
- (void)tapbg:(UITapGestureRecognizer *)gestrue
{
    if (self.mhourTextField.isFirstResponder || self.mMinuteTextFiled.isFirstResponder) {
        [self.mhourTextField resignFirstResponder];
        [self.mMinuteTextFiled resignFirstResponder];
        [self moveDown];
    }
}
@end
