//
//  VolunInfoCell.m
//  VolunteerApp
//
//  Created by zelong zou on 14-3-17.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "VolunInfoCell.h"

@implementation VolunInfoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//238	0	0
//158 204 48
//51 181 176
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.mTitleLb.textColor = [UIColor colorWithRed:238.0/255.0 green:0.0 blue:0.0 alpha:1.0];
    self.mVistorLb.textColor = [UIColor colorWithRed:158.0/255.0 green:204.0/255.0 blue:48.0/255.0 alpha:1.0];
    self.mTimeLb.textColor = [UIColor colorWithRed:51.0/255.0 green:181.0/255.0 blue:176.0/255.0 alpha:1.0];
    
    UIImage *bgimage = [[UIImage imageNamed:@"mypro_cellbg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] ;
    self.mBgView.image = bgimage;
}

- (void)setupWithVolunInfo:(VolunInfo *)info
{

    
    self.mTitleLb.text = info.pageTile;
    
    [self.mTitleLb sizeToFit];
    
    
    self.mTimeLb.top = self.mTitleLb.bottom+5;
    self.mVistorLb.top = self.mTimeLb.top;
    self.mTimeLb.text = info.addDate;
    self.mVistorLb.text = [NSString stringWithFormat:@"%d人访问",info.browseCount];
    
    
}

@end
