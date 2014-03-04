//
//  BaseViewController.h
//  VolunteerApp
//
//  Created by zelong zou on 14-2-21.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlipBoardNavigationController.h"
#import "UIColor+Addition.h"
#import "UserInfo.h"
#import "ZZLHttpRequstEngine.h"

@interface BaseViewController : UIViewController


@property (nonatomic,strong) UIView *navView;
@property (nonatomic,weak) ZZLRequestOperation *request;
- (id)initWithNibFile;
+ (id)ViewContorller;

- (void)setTitleWithString:(NSString *)str;
- (void)setBackBtnHidden;
- (void)backAction:(UIButton *)btn;
@end
