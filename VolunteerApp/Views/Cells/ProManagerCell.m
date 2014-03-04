//
//  ProManagerCell.m
//  VolunteerApp
//
//  Created by zelong zou on 14-2-27.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "ProManagerCell.h"
#import "UIColor+Addition.h"
static UIImage *bgimage = nil;
@implementation ProManagerCell
{
    MyprojectCellType type;
}

+ (void)initialize{
    
    bgimage = [[UIImage imageNamed:@"mypro_cellbg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] ;
    
    
    
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
    self.mTime.text = startTime;
    self.mContent.text = endTime;
    self.mState.text = info.state;
    if (self.cellType == kMyprojectCellType_Plan)
    {
        
        [self.mAttenBtn setImage:[UIImage imageNamed:@"promg_classmg_nl.png"] forState:UIControlStateNormal];
        [self.mAttenBtn setImage:[UIImage imageNamed:@"promg_classmg_hl.png"] forState:UIControlStateHighlighted];
        [self.mRecruitBtn setImage:[UIImage imageNamed:@"promg_plan_nl.png"] forState:UIControlStateNormal];
        [self.mRecruitBtn setImage:[UIImage imageNamed:@"promg_plan_hl.png"] forState:UIControlStateHighlighted];
    }else{
        [self.mAttenBtn setImage:[UIImage imageNamed:@"mypro_atten_nl.png"] forState:UIControlStateNormal];
        [self.mAttenBtn setImage:[UIImage imageNamed:@"mypro_atten_hl.png"] forState:UIControlStateHighlighted];
        [self.mRecruitBtn setImage:[UIImage imageNamed:@"mypro_recruit_nl.png"] forState:UIControlStateNormal];
        [self.mRecruitBtn setImage:[UIImage imageNamed:@"mypro_recruit_hl.png"] forState:UIControlStateHighlighted];
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
    
    if (_delegate && [_delegate respondsToSelector:@selector(actionAttendBtn:AtIndexPath:withType:)]) {
        [_delegate actionAttendBtn:self AtIndexPath:self.cellInPath withType:self.cellType];
    }
    
}
- (IBAction)actionRecruit:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(actionRecruitBtn:AtIndexPath:withType:)]) {
        [_delegate actionRecruitBtn:self AtIndexPath:self.cellInPath withType:self.cellType];
    }
    
}
@end
