//
//  BaseViewController.m
//  VolunteerApp
//
//  Created by zelong zou on 14-2-21.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
{
    UILabel  *titleLabel;
}
@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibFile
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {


    }
    return self;
}
- (void)setBackBtnHidden
{
    UIButton *back = (UIButton *)[self.navView viewWithTag:22333];
    back.hidden = YES;
}
#pragma mark - view Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (DEVICE_IS_IPHONE5) {
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
            self.view.height+=108;
        }else{
            self.view.height+=88;
        }
        
    }
    self.view.backgroundColor = [UIColor colorWithHexString:@"#ece6e8"];
    // Custom initialization
    self.navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
        self.navView.height = 64;
    }
    self.navView.backgroundColor = [UIColor colorWithHexString:@"#e1655b"];
    [self.view addSubview:self.navView];
    
    
    
    UIButton *backBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.tag = 22333;
    backBtn.frame = CGRectMake(10, self.navView.height-44, 44, 44);
    
    [backBtn setImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateHighlighted];
    
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:backBtn];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, self.navView.height-37,200, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    
    titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    
    [self.navView addSubview:titleLabel];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
        [self.view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIView *subview = (UIView *)obj;
            if (subview!=self.navView && ![subview isDescendantOfView:self.navView]) {
                subview.top+=64;
            }
        }];
    }else{
        [self.view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIView *subview = (UIView *)obj;
            if (subview!=self.navView && ![subview isDescendantOfView:self.navView]) {
                subview.top+=44;
            }
        }];
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    


}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.request) {
        [self.request cancel];
    }

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


+ (id)ViewContorller
{
    return [[[self class]alloc]initWithNibFile];
}



- (void)setTitleWithString:(NSString *)str
{
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.text = str;
    
}
- (void)backAction:(UIButton *)btn
{
    [self.flipboardNavigationController popViewController];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
