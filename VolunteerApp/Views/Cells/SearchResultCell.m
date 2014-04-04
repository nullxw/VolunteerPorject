//
//  SearchResultCell.m
//  VolunteerApp
//
//  Created by zelong zou on 14-4-1.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "SearchResultCell.h"

@implementation SearchResultCell
static UIImage *bgimage = nil;
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
    bgimage = [[UIImage imageNamed:@"mypro_cellbg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] ;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)setupMyResultCell:(SearchResult *)info
{
    
    self.mBgView.image = bgimage;
    NSString *startTime;
    if (info.startDateString.length>10) {
        startTime = [info.startDateString substringToIndex:10];
    }
    NSString *endTime;
    if (info.endDateString.length>10) {
        endTime = [info.endDateString substringToIndex:10];
    }
    CGFloat height = [info.subject sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(285, 100)].height;

    CGFloat contentHeight = [info.summary sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(285, 140)].height;

    self.mTitleLb.height  = MIN(height, 100);
    self.mTitleLb.text = info.subject;
    [self.mTitleLb sizeThatFits:CGSizeMake(285, 100)];
    
    
    self.mTimeLb.top = self.mTitleLb.bottom+3;
    
    self.mTimeLb.text = [NSString stringWithFormat:@"%@ -- %@",startTime,endTime];
    
    self.mContentLb.top  =  self.mTimeLb.bottom+3;
    self.mContentLb.height = MIN(140, contentHeight);
    [self.mContentLb sizeThatFits:CGSizeMake(285, 140)];
    self.mContentLb.text = info.summary;

    
}

+ (CGFloat)caclulateHeightWithInfo:(SearchResult *)info
{
    CGFloat height = [info.subject sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(285, 100)].height;
    
    CGFloat contentHeight = [info.summary sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(285, 140)].height;
    return height+contentHeight+60;
}
@end
