//
//  AttendMgCell.m
//  VolunteerApp
//
//  Created by zelong zou on 14-3-29.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "AttendMgCell.h"
static UIImage *bgimage = nil;
@implementation AttendMgCell
+ (void)initialize
{
    bgimage = [[UIImage imageNamed:@"mypro_cellbg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)setupWithUserAttend:(UserAttend *)info
{
    self.mBgView.image = bgimage;
    self.mName.text = info._userName;
    self.mTitle.text = info.missionName;
    self.mTime.text = [NSString stringWithFormat:@"%@ 服务时长%d小时",info._checkOnDate,(info.serviceMinute/60)];
}


- (IBAction)ActionAttendBtn:(UIButton *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(AttendMgCellDelegate:actionWithIndex:)]) {
        [_delegate AttendMgCellDelegate:self actionWithIndex:self.index];
    }
}
@end
