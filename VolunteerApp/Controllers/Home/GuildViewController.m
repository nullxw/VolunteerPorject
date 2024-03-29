//
//  GuildViewController.m
//  VolunteerApp
//
//  Created by 邹泽龙 on 14-3-4.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "GuildViewController.h"


#import  "AppDelegate.h"
#import "EAIntroView.h"
@interface GuildViewController ()<EAIntroDelegate>

@end

@implementation GuildViewController

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
	// Do any additional setup after loading the view.
    
    self.view.frame = [UIScreen mainScreen].bounds;

    

}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self showIntroWithCrossDissolve];
}
- (void)showIntroWithCrossDissolve {

    
     NSMutableArray *list = [[NSMutableArray alloc]init];
    for (int i=0; i<6; i++) {
        

        UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"guildImage%d.png",i+1]];
        EAIntroPage *page = [EAIntroPage pageWithCustomView:imageView];
        
        [list addObject:page];

    }
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:list];
    
    [intro setDelegate:self];
    [intro showInView:self.view animateDuration:0.3];
}
#pragma mark - MYIntroduction Delegate


- (void)introDidFinish {


    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"hasLanuch"];
    AppDelegate *adelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [adelegate showWithLoginView];
}

@end
