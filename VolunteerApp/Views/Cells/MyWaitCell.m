//
//  MyWaitCell.m
//  VolunteerApp
//
//  Created by zelong zou on 14-2-26.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "MyWaitCell.h"
#import "UIColor+Addition.h"

static UIImage *bgimage = nil;
static UIImage *bgimage1 = nil;
static UIImage *bgimage2 = nil;
static NSDictionary *dict = nil;
static NSDictionary *imageDict = nil;
@implementation MyWaitCell
{
    MyprojectCellType cellType;

}
+ (void)initialize{
    
    bgimage = [[UIImage imageNamed:@"mypro_cellbg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] ;
//    0:未知；1:立项；20:待审批25:审批通过（旧）；26:审批不通过35:审批通过；50:正在进行；100:已完成；1000:已结项
    dict = [NSDictionary dictionaryWithObjectsAndKeys:@"未知",@"0",@"立项",@"1",@"待审批",@"20",@"审批通过",@"35",@"审批不通过",@"26",@"正在进行",@"50",@"已完成",@"100",@"已结项",@"1000", nil];
    
    imageDict = [NSDictionary dictionaryWithObjectsAndKeys:@"ico_wait.png",@"50",@"ico_nonconfirm.png",@"0",@"ico_complete.png",@"100",@"ico_complete.png",@"1000",@"ico_nonconfirm.png",@"1" ,@"ico_sel.png",@"35" ,nil];
    bgimage1 = [[UIImage imageNamed:@"login_nl.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(15, 8, 15, 8)];
    bgimage2 = [[UIImage imageNamed:@"login_hl.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(15, 8, 15, 8)];

    
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (CGFloat)cellHeight
{
    return 120;
}
- (void)setupMyWaitCell:(MissionInfo *)info WithType:(MyprojectCellType)type
{
    NSString *startTime;
    if (info.startDate.length>10) {
        startTime = [info.startDate substringToIndex:10];
    }
    NSString *endTime;
    if (info.endDate.length>10) {
        endTime = [info.endDate substringToIndex:10];
    }
    

    self.mTitle.text = info.subject;
    self.mTime.text = startTime;
    self.mContent.text = endTime;
    self.mState.text = info.state;
    if (type == kMyprojectCellType_Join) {
        self.mStateImage.image = [UIImage imageNamed:@"mypro_join.png"];
        [self.mAttenBtn setImage:[UIImage imageNamed:@"mypro_atten_nl.png"] forState:UIControlStateNormal];
        [self.mAttenBtn setImage:[UIImage imageNamed:@"mypro_atten_hl.png"] forState:UIControlStateHighlighted];
    }else if (type == kMyprojectCellType_Wait)
    {
        self.mStateImage.image = [UIImage imageNamed:@"mypro_wait.png"];
        self.mAttenBtn.hidden = YES;

    
    }else if (type == kMyprojectCellType_Complete)
    {
        self.mStateImage.image = [UIImage imageNamed:@"mypro_complete.png"];
        self.mAttenBtn.hidden = YES;
    }


}

- (void)setupMyResultCell:(SearchResult *)info
{
    NSString *startTime;
    if (info.startDateString.length>10) {
        startTime = [info.startDateString substringToIndex:10];
    }
    NSString *endTime;
    if (info.endDateString.length>10) {
        endTime = [info.endDateString substringToIndex:10];
    }
    
    self.mTitle.text = info.subject;
    self.mTime.text = startTime;
    self.mContent.text = endTime;
    self.mState.left = self.mTime.left;
    self.mStateImage.image = [UIImage imageNamed:[imageDict objectForKey:info.state]];
    self.mState.text = [dict objectForKey:info.state];
    

    [self.mAttenBtn setBackgroundImage:bgimage1 forState:UIControlStateNormal];
    [self.mAttenBtn setBackgroundImage:bgimage2 forState:UIControlStateHighlighted];
    [self.mAttenBtn setTitle:@"报名" forState:UIControlStateNormal];
    [self.mAttenBtn setTitle:@"取消报名" forState:UIControlStateSelected];
    if (info.isJoined == 0) {
        
        self.mAttenBtn.selected = NO;
    }else{
        self.mAttenBtn.selected = YES;
    }
    


}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.bgView.image = bgimage;
    self.mTitle.textColor = [UIColor colorWithHexString:@"#f13130"];
    self.mState.textColor = [UIColor colorWithHexString:@"#95c32c"];
    self.mTime.textColor = [UIColor colorWithHexString:@"#23b3ac"];
    self.mContent.textColor = [UIColor colorWithHexString:@"#23b3ac"];
}
- (IBAction)actionAttention:(UIButton *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(actionAttendBtn:AtIndexPath:)]) {
        [_delegate actionAttendBtn:self AtIndexPath:self.cellInPath];
    }

}
@end
