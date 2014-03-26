//
//  LoginViewController.h
//  VolunteerApp
//
//  Created by zelong zou on 14-2-21.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginViewDelegate;

@interface LoginViewController : UIViewController

@property (nonatomic,assign) id<LoginViewDelegate> delegate;

- (void)loginWithUserName:(NSString *)userName password:(NSString *)pwd automic:(BOOL)isAutomic;

- (void)clearPassword;
@end


@protocol LoginViewDelegate <NSObject>

- (void)didLoginSuccess:(LoginViewController *)vc;
- (void)didLoginFailure:(LoginViewController *)vc;
- (void)didLoginWithVisitor:(LoginViewController *)vc;

@end