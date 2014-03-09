//
//  AppDelegate.h
//  VolunteerApp
//
//  Created by zelong zou on 14-2-20.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "LoginViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,SinaWeiboDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic)    LoginViewController *loginVc;

- (void)showWithLoginView;
@property (nonatomic,strong) SinaWeibo *weibo;
@end
