//
//  ProjectMgCell.m
//  VolunteerApp
//
//  Created by zelong zou on 14-3-18.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "ProjectMgCell.h"
#import "UIColor+Addition.h"
static UIImage *bgimage = nil;
@implementation ProjectMgCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
+ (void)initialize{
    
    bgimage = [[UIImage imageNamed:@"mypro_cellbg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] ;
    
    
    
}

+ (CGFloat)cellHeight
{
    return 94;
}
- (void)setupMyWaitCell:(ProjectInfo *)info
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
    [self.mTitle sizeThatFits:CGSizeMake(185, 45)];
    self.mTime.text = [NSString stringWithFormat:@"%@ -- %@",startTime,endTime];
    
    if (info.stateId == 35) {
        self.mStateImage.image = [UIImage imageNamed:@"_22.png"];
    }else if (info.stateId == 50)
    {
        self.mStateImage.image = [UIImage imageNamed:@"_03.png"];
    }else if (info.stateId == 100)
    {
        self.mRescruitBtn.hidden = YES;
        self.mAttendBtn.hidden = YES;
        self.mStateImage.image = [UIImage imageNamed:@"_12.png"];
    }else if (info.stateId == 1000)
    {
        self.mRescruitBtn.hidden = YES;
        self.mAttendBtn.hidden = YES;
        self.mStateImage.image = [UIImage imageNamed:@"_12.png"];
    }


    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.mBgView.image = bgimage;
    self.mTitle.textColor = [UIColor colorWithHexString:@"#f13130"];
//    self..textColor = [UIColor colorWithHexString:@"#95c32c"];
    self.mTime.textColor = [UIColor colorWithHexString:@"#23b3ac"];

}

- (IBAction)actionRescruit:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(ProjectMgCell:actionRescruit:)]) {
        [_delegate ProjectMgCell:self actionRescruit:sender];
    }
}

- (IBAction)actionAttend:(UIButton *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(ProjectMgCell:actionAttend:)]) {
        [_delegate ProjectMgCell:self actionAttend:sender];
    }
}
@end
