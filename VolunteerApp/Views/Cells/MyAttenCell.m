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
    
}


@end
