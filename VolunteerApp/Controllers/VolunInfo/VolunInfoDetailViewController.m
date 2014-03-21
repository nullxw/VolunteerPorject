//
//  VolunInfoDetailViewController.m
//  VolunteerApp
//
//  Created by zelong zou on 14-3-17.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "VolunInfoDetailViewController.h"

@interface VolunInfoDetailViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *mWebView;

@end

@implementation VolunInfoDetailViewController

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
    [self setTitleWithString:@"志愿资讯详情"];

    self.mWebView.delegate = self;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view showLoadingView];
    [self.mWebView loadHTMLString:self.htmlContent baseURL:nil];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self performSelector:@selector(dismissLoadingView) withObject:nil afterDelay:2.0f];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)dismissLoadingView
{
    [self.view hideLoadingView];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    webView.scrollView.contentSize = CGSizeMake(webView.scrollView.contentSize.width, webView.scrollView.contentSize.height+self.navView.height);
}
@end
