//
//  MyInfoCell.m
//  VolunteerApp
//
//  Created by zelong zou on 14-3-1.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "MyInfoCell.h"

@implementation MyInfoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)setupWithInfo:(NSString *)info detailInfo:(NSString *)detail{
    
    self.mTitleLb.text =  info;
    
    self.mInfoLb.adjustsFontSizeToFitWidth = YES;
    self.mInfoLb.text = detail;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
+(CGFloat)cellHeight
{
    return 44;
}
@end
