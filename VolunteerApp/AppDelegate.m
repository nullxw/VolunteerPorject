//
//  AppDelegate.m
//  VolunteerApp
//
//  Created by zelong zou on 14-2-20.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "AppDelegate.h"
#import "HomePageVC.h"
#import "FlipBoardNavigationController.h"

#import "ZZLHttpRequstEngine.h"

#import "UserInfo.h"

#import "UIAlertView+Blocks.h"
#import "NSString+WiFi.h"
@interface AppDelegate ()<LoginViewDelegate>
{

}
@end
@implementation AppDelegate

+ (void)initialize{
    
    UserInfo *user = [UserInfo share];
    [user setup];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
  


    

//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
//    {
////        [application setStatusBarStyle:UIStatusBarStyleLightContent];
//        self.window.clipsToBounds =YES;
//        self.window.frame =  CGRectMake(0,20,self.window.frame.size.width,self.window.frame.size.height-20);
//    }
    // Override point for customization after application launch.
    
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor blackColor];
    

    self.loginVc = [[LoginViewController alloc]initWithNibName:NSStringFromClass([LoginViewController class]) bundle:nil];
    FlipBoardNavigationController *nav = [[FlipBoardNavigationController alloc]initWithRootViewController:self.loginVc];
    self.loginVc.delegate = self;
    [self.window setRootViewController:nav];
    
    [self.window makeKeyAndVisible];
    
    [self justTest];
   // [self autoLogin];
    
    return YES;
}
- (void)justTest{

    
    

     
    
    

}


- (void)autoLogin
{
    
    UserInfo *user = [UserInfo share];
    if (user.shouldAutoLogin) {
        
        [self.loginVc loginWithUserName:user.locaUserName password:user.locaPwd automic:YES];

    }
}



#pragma mark - login delegate
- (void)didLoginSuccess:(LoginViewController *)vc
{
    HomePageVC *homeVC = [HomePageVC ViewContorller];
    FlipBoardNavigationController *nav = [[FlipBoardNavigationController alloc]initWithRootViewController:homeVC];
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [vc presentViewController:nav animated:YES completion:^{
        [self.window setRootViewController:nav];
    }];

}
- (void)didLoginFailure:(LoginViewController *)vc
{
    
//    [UIAlertView showAlertViewWithTitle:@"提示" message:@"啊哦，登录失败，请重试！" cancelButtonTitle:@"确定" otherButtonTitles:nil onDismiss:^(int buttonIndex) {
//
//    } onCancel:^{
//        
//    }];
}




- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end