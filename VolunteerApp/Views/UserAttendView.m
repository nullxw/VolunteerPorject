//
//  UserAttendView.m
//  VolunteerApp
//
//  Created by zelong zou on 14-3-21.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "UserAttendView.h"

static UIImage *bgimage = nil;
@implementation UserAttendView
{
    void(^actionBlock)(int index);
}
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

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    
}

- (void)addActionBlock:(void (^)(int index))block
{
    actionBlock = [block copy];
}
- (void)setupWithUserAttendInfo:(UserAttend *)item
{
    self.mBgVIew.image = bgimage;
    self.mName.text = item._userName;
    
    self.mTime.text = item._checkOnDate;
    
    CGSize size = [item.missionName sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(150, 30) lineBreakMode:NSLineBreakByCharWrapping];
    self.mTitleView.height = MIN(size.height, 30);
    self.mTitleView.text = item.missionName;
    
    self.mGenderView.left = self.mName.right+5;
}
- (IBAction)ActionAttend:(UIButton *)sender
{
    if (actionBlock) {
        actionBlock(sender.tag);
    }
}
@end
