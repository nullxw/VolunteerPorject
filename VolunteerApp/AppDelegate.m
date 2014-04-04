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
#import "GuildViewController.h"
#import "MobClick.h"
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
    

    BOOL hasLanuch = [[[NSUserDefaults standardUserDefaults] objectForKey:@"hasLanuch"]boolValue];
    if (hasLanuch) {
        [self showWithLoginView];
    }else{
        [self showGuildView];
    }
//    [self setupWeiBo];
    [self autoLogin];
    [self startUM];
    return YES;
}
- (void)setupWeiBo
{
    
    self.weibo = [[SinaWeibo alloc] initWithAppKey:@"2959917823" appSecret:@"771761e2e9e6b863fd9b56e16ce009e2" appRedirectURI:@"" ssoCallbackScheme:@"VolunteerApop"  andDelegate:self];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
    {
        NSLog(@"sina wei bo data is saved!");
        self.weibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
        self.weibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
        self.weibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
    }

    
}
- (void)startUM
{
    [MobClick startWithAppkey:@"533dfed656240bbcf908f38b"];
//    + (void)checkUpdateWithDelegate:(id)delegate selector:(SEL)callBackSelectorWithDictionary;
    [MobClick checkUpdate:@"有新版本" cancelButtonTitle:@"取消" otherButtonTitles:@"去下载"];
    
    [MobClick updateOnlineConfig];
    
    NSString *check = [MobClick getConfigParams:@"CheckUpdate"];
    
    if (![check isEqualToString:@"YES"]) {
        
    }
    
}

- (void)showGuildView
{
    GuildViewController *vc = [[GuildViewController alloc]init];
    [self.window setRootViewController:vc];
    [self.window makeKeyAndVisible];
}
- (void)showWithLoginView{

    
    if(!self.loginVc)
    {
        self.loginVc = [[LoginViewController alloc]initWithNibName:NSStringFromClass([LoginViewController class]) bundle:nil];
        

    }
    [self.loginVc clearPassword];

    FlipBoardNavigationController *nav = [[FlipBoardNavigationController alloc]initWithRootViewController:self.loginVc];
    self.loginVc.delegate = self;
    [self.window setRootViewController:nav];
    
    [self.window makeKeyAndVisible];
    
    
    

}


- (void)autoLogin
{
    
    UserInfo *user = [UserInfo share];
    if (user.shouldAutoLogin && user.locaUserName.length>0 && user.locaPwd.length>0) {
        
        [self.loginVc loginWithUserName:user.locaUserName password:user.locaPwd automic:YES];

    }
}

- (void)handleNotLoginWithBaseViewController:(BaseViewController *)targetVc
{
    
    [UIAlertView showAlertViewWithTitle:@"提示" message:@"您需要登录才能继续操作！" cancelButtonTitle:@"取消" otherButtonTitles:@[@"去登录"] onDismiss:^(int buttonIndex) {
        
        for (BaseViewController *vc in targetVc.flipboardNavigationController.viewControllers) {
            [targetVc.flipboardNavigationController popViewController];
        }
        UserInfo *user = [UserInfo share];
        [user clear];
        [self showWithLoginView];
        
    } onCancel:^{
        
    }];
    
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

- (void)didLoginWithVisitor:(LoginViewController *)vc
{
    HomePageVC *homeVC = [HomePageVC ViewContorller];
    FlipBoardNavigationController *nav = [[FlipBoardNavigationController alloc]initWithRootViewController:homeVC];
    nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [vc presentViewController:nav animated:YES completion:^{
        [self.window setRootViewController:nav];
    }];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    NSLog(@"调用的URL 是:%@",url);
    if ([sourceApplication isEqualToString:@"com.sina.weibo"]) {
        return  [self.weibo handleOpenURL:url];
    }
    return YES;

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
