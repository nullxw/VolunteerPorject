//
//  ProDetailViewController.m
//  VolunteerApp
//
//  Created by zelong zou on 14-2-23.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "ProDetailViewController.h"
#import "CheckClassViewController.h"
#import "ZZLHttpRequstEngine.h"
#import "MissionDetailInfo.h"
#import "SVPullToRefresh.h"
#import  "UIAlertView+Blocks.h"
@interface ProDetailViewController ()
{
    int missionId;
    MissionDetailInfo *modelInfo;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *topImageView;
@property (strong, nonatomic) IBOutlet UIView *ActivView;
@property (strong, nonatomic) IBOutlet UILabel *activTitleLb;
@property (weak, nonatomic) IBOutlet UIImageView *activBgView;
@property (weak, nonatomic) IBOutlet UILabel *activIntroLb;
@property (strong, nonatomic) IBOutlet UILabel *activeContentDescLb;
@property (weak, nonatomic) IBOutlet UIImageView *activSepLineView;
@property (weak, nonatomic) IBOutlet UILabel *activContentLb;

@property (weak, nonatomic) IBOutlet UIImageView *bottomBgView;
@property (strong, nonatomic) IBOutlet UIButton *mJoinBtn;
@property (strong, nonatomic) IBOutlet UIButton *mCheckClassBtn;

@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLb;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLb;
@property (weak, nonatomic) IBOutlet UILabel *placeLb;
@property (weak, nonatomic) IBOutlet UILabel *partyLb;
@property (weak, nonatomic) IBOutlet UILabel *activStatuesLb;
@property (weak, nonatomic) IBOutlet UILabel *mContactLb;
@property (weak, nonatomic) IBOutlet UILabel *proIdLb;
@property (strong, nonatomic) IBOutlet UIView *mBottomBar;

@property (weak, nonatomic) IBOutlet UILabel *mDetailAddrLb;
- (IBAction)joinBtnAction:(UIButton *)sender;
- (IBAction)viewClassAction:(UIButton *)sender;
@end

@implementation ProDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)setMissId:(int)mid
{
    missionId = mid;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.scrollView.scrollEnabled = YES;
    [self setTitleWithString:@"项目详情"];

    self.scrollView.contentSize = CGSizeMake(self.view.width, self.view.height);
    __weak ProDetailViewController *weakSelf = self;
    [self.scrollView addPullToRefreshWithActionHandler:^{
        if (modelInfo == nil) {
            [weakSelf refresh];
        }else{
            [weakSelf.scrollView.pullToRefreshView stopAnimating];
        }
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - view Lifecycle

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.scrollView.top = self.navView.bottom;
//    self.scrollView.contentSize = CGSizeMake(self.view.width, self.ActivView.bottom+self.bottomView.height+30);
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (modelInfo == nil) {
        [self.scrollView triggerPullToRefresh];
        
    }

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark -  actions
- (IBAction)joinBtnAction:(UIButton *)sender {
    
    if (modelInfo.isJoined) {
        [self applyMissionWithFlag:0];
    }else{
        [self applyMissionWithFlag:1];
    }
    
}

- (IBAction)viewClassAction:(UIButton *)sender {

    [self goCheckClassPlanView];

}
- (void)goCheckClassPlanView
{
    CheckClassViewController *vc = [CheckClassViewController ViewContorller];
    vc.missionId = missionId;
    [self.flipboardNavigationController pushViewController:vc completion:^{
        
    }];
}

- (void)refresh
{
    
    [self.view showLoadingView];
    double delayInSeconds = 1.0;
    NSLog(@"missid:%d",missionId);
    UserInfo *user = [UserInfo share];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_current_queue(), ^(void){

        [[ZZLHttpRequstEngine engine] requestGetProjectDetailWithUid:user.userId MissionID:missionId onSuccess:^(id responseObject) {
            [self.view hideLoadingView];
            [self.scrollView.pullToRefreshView stopAnimating];
            NSMutableDictionary *dic = (NSMutableDictionary *)responseObject;
            NSLog(@">>>>>dic<<<<<%@",dic);
            modelInfo = [MissionDetailInfo JsonModalWithDictionary:dic];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self updateUI];
            });
            
            
        } onFail:^(NSError *erro) {
            NSLog(@"___xxx___%@",[erro.userInfo objectForKey:@"description"]);
            
            
            [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
            [self.scrollView.pullToRefreshView stopAnimating];

            [self.view hideLoadingView];
        }];
    });
}


//@property (nonatomic)        int        isJoined;
//
//@property (nonatomic,strong) NSString * venueAddress;
//
//@property (nonatomic,strong) NSString * districtName;
//
//@property (nonatomic,strong) NSString * contactPhone;
//
//@property (nonatomic,strong) NSString * applyDeadlineString;
//
//@property (nonatomic)        int        isAllowJoin;
//
//@property (nonatomic,strong) NSString * state;
//
//@property (nonatomic,strong) NSString * detailInfo;
//
//@property (nonatomic,strong) NSString * summary;
//
//@property (nonatomic,strong) NSString * startDateString;
//
//@property (nonatomic,strong) NSString * endDateString;
//
//@property (nonatomic,strong) NSString * subject;
//
//@property (nonatomic,strong) NSString * contactName;
//
//@property (nonatomic,strong) NSString * venue;
- (void)updateUI
{
    
    
    self.scrollView.height = self.view.height - self.mBottomBar.height- self.navView.height;
    
    UIFont *font = [UIFont fontWithName:@"Avenir-Medium" size:14.0f];
    self.activTitleLb.font = [UIFont fontWithName:@"Avenir-Medium" size:16];
    self.activStatuesLb.font= font;
    self.activIntroLb.font = font;
    self.activContentLb.font = font;
  
//    self.scrollView.hidden = NO;
    CGFloat scrollerHeight = 0.0f;
    NSLog(@"update ui --->");

    self.activSepLineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"prodetail_line.png"]];
    

    

    CGFloat activViewHeight = [self caculateStrSize:modelInfo.summary].height;
    CGFloat detailHeight= [self caculateStrSize:modelInfo.detailInfo].height;
    
    self.activTitleLb.text = modelInfo.subject;
    
    self.activIntroLb.height = activViewHeight+10;
    
    self.activIntroLb.text = modelInfo.summary;
    
    self.activSepLineView.top = self.activIntroLb.bottom+10;
    
    
    self.activeContentDescLb.top = self.activSepLineView.bottom + 10;
    
    
    

    
    self.activContentLb.top = self.activeContentDescLb.bottom+5;
    
    
    self.activContentLb.height = detailHeight +10;
    self.activContentLb.text = modelInfo.detailInfo;
    
    self.ActivView.frame = CGRectMake(0, self.topImageView.height, self.view.width, self.activContentLb.bottom+20);
    //
    

    UIImage  *bgimage = [[UIImage imageNamed:@"prodetail_abg.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(2, 40, 40, 2)];
    self.activBgView.image = bgimage;

    
    [self.scrollView addSubview:self.ActivView];

    //>>>>>>>---------------------------------< view:"bottom">----------------------------<<<<<<<
    //<<<<<<<---------------------------------</view>------------------------------------->>>>>>>
    self.startTimeLb.font = font;
    self.endTimeLb.font = font;
    self.placeLb.font = font;
    self.partyLb.font = font;
    self.activStatuesLb.font = font;
    self.proIdLb.font = font;
    self.mContactLb.font = font;
    self.mDetailAddrLb.font = font;
    
    NSString *str1 = [modelInfo.startDateString substringToIndex:10];
    NSString *str2 = [modelInfo.endDateString substringToIndex:10];
    self.startTimeLb.text = [NSString stringWithFormat:@"%@ - %@",str1,str2];
    self.endTimeLb.text = modelInfo.applyDeadlineString;
    self.placeLb.text = modelInfo.venueAddress;
    self.partyLb.text = modelInfo.districtName;

    
    if (modelInfo.isAllowJoin == 0) {
        self.activStatuesLb.text = @"停止报名";
    }else{
        self.activStatuesLb.text = @"正在报名";
    }
    
    self.proIdLb.text = modelInfo.venue;
    
    self.mDetailAddrLb.text = modelInfo.venueAddress;
    

    
    self.mContactLb.userInteractionEnabled = YES;
    NSMutableAttributedString *contact = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@",modelInfo.contactName,modelInfo.contactPhone]];
    NSRange contentRange = {0,[contact length]};
    [contact addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    self.mContactLb.attributedText = contact;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToPhone:)];
    [self.mContactLb addGestureRecognizer:tap];
    
    self.bottomView.top = self.ActivView.bottom;
    [self.scrollView addSubview:self.bottomView];
    
    scrollerHeight = (self.topImageView.height + self.ActivView.height + self.bottomView.height +20);
    self.scrollView.contentSize = CGSizeMake(self.view.width, scrollerHeight);
    
    
    if (modelInfo.isJoined) {
        [self.mJoinBtn setTitle:@"已报名" forState:UIControlStateNormal];
    }
    

    
    if ([modelInfo.state isEqualToString:@"100"] ||[modelInfo.state isEqualToString:@"1000"] || [modelInfo.state isEqualToString:@"1003"]) {
        self.mJoinBtn.enabled = NO;
    }
    self.mBottomBar.top = self.view.height - self.mBottomBar.height;
    [self.view addSubview:self.mBottomBar];
    
    
    
}
- (CGSize)caculateStrSize:(NSString *)str
{
    return [str sizeWithFont:[UIFont fontWithName:@"Avenir-Medium" size:14.0f] constrainedToSize:CGSizeMake(300, 2000)];
}

- (void)applyMissionWithFlag:(int)flag
{
    NSString *str = @"报名成功";
    NSString *str1 = @"取消报名成功";
    
    UserInfo *user = [UserInfo share];
    [[ZZLHttpRequstEngine engine]requestProjectApplyWithUid:user.userId missionID:missionId applyOrNOT:flag onSuccess:^(id responseObject) {
        
        if (flag) {
            
            modelInfo.isJoined = 0;
            [self.view showHudMessage:str];
            
        }else{
            
            modelInfo.isJoined = 1;
            [self.view showHudMessage:str1];
        }
        
        NSLog(@"报名>>>>:%@",responseObject);
        
    } onFail:^(NSError *erro) {
        [self.view showHudMessage:[erro.userInfo objectForKey:@"description"]];
    }];
}

- (void)tapToPhone:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        NSString *phoneno = [NSString stringWithFormat:@"tel://%@",modelInfo.contactPhone];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:phoneno]]) {
            [UIAlertView showAlertViewWithTitle:@"是否拨打电话" message:self.mContactLb.text cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] onDismiss:^(int buttonIndex) {
                
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneno]];
                
                
            } onCancel:^{
                
            }];
            
        }else{
            [UIAlertView showAlertViewWithTitle:@"提示" message:@"无效的电话 或者（您的设备不支持打电话）" cancelButtonTitle:@"取消" otherButtonTitles:nil onDismiss:^(int buttonIndex) {
                
                
            } onCancel:^{
                
            }];
        }
    }
    

    
}
@end
