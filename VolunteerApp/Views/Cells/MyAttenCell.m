//
//  MyAttenCell.m
//  VolunteerApp
//
//  Created by zelong zou on 14-3-2.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "MyAttenCell.h"

@implementation MyAttenCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(void)initialize
{
    
}
+(CGFloat)cellHeight
{
    return 80;
}
- (void)setupWithSignInfo:(SignInfo *)info
{
    UIImage *bgimage = [[UIImage imageNamed:@"mypro_cellbg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] ;
    self.mbgview.image = bgimage;
    
    if (info.isUpdated) {
        self.mstate.text = @"已确认";
    }else{
        self.mstate.text = @"未确认";
    }
    
    self.msigin.text = info._startDatetime;
    if (info._endDatetime.length>0) {
        self.mysigout.text = [NSString stringWithFormat:@"签出: %@",info._endDatetime];
    }else{
        self.mysigout.text = @"无签出记录";
    }
    
}


@end
