//
//  HandAttendCell.m
//  VolunteerApp
//
//  Created by zelong zou on 14-3-20.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "HandAttendCell.h"

static UIImage *bgimage = nil;
@implementation HandAttendCell

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
    bgimage = [[UIImage imageNamed:@"mypro_cellbg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.mBgVIew.image = bgimage;
    

}
+ (CGFloat)cellHeight
{
    return 160;
}

- (IBAction)ActionAttend:(UIButton *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(HandAttendCellDelegate:actionWithIndex:)]) {
        [_delegate HandAttendCellDelegate:self actionWithIndex:self.index];
    }
}
@end
