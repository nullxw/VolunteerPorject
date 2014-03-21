//
//  HandAttendCell.m
//  VolunteerApp
//
//  Created by zelong zou on 14-3-20.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "HandAttendCell.h"
#import "UserAttendView.h"

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

    
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    

}
+ (CGFloat)cellHeight
{
    return 160;
}
- (void)setupWithUserAttendInfo:(NSArray *)list index:(NSInteger)idx
{
    self.backgroundColor = [UIColor clearColor];
    for (int i=0 ;i<list.count;i++) {
        UserAttend *item = list[i];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserAttendView" owner:self options:nil];
        UserAttendView *view = [nib objectAtIndex:0];
        view.left = i*160;
        [view setupWithUserAttendInfo:item];
        
        [view addActionBlock:^(int a) {
            [self doActionAtIndex:idx+i];
        }];
        [self.contentView addSubview:view];
    }
}
- (void)doActionAtIndex:(int)idx {
    
    if (_delegate && [_delegate respondsToSelector:@selector(HandAttendCellDelegate:actionWithIndex:)]) {
        [_delegate HandAttendCellDelegate:self actionWithIndex:idx];
    }
}
@end
