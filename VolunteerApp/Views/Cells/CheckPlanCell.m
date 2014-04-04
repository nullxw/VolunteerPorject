//
//  CheckPlanCell.m
//  VolunteerApp
//
//  Created by 邹泽龙 on 14-2-28.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "CheckPlanCell.h"
#import "UIColor+Addition.h"
static UIImage *bgimage = nil;
@implementation CheckPlanCell
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
- (void)setupMyPlanCell:(ClassPlanInfo *)info
{
    self.mTtitleLb.text = info.planName;
    
    if (info.flightType ==1) {
        self.mClassType.text = @"(早班)";
    }else if(info.flightType ==2)
    {
        self.mClassType.text = @"(中班)";
    }else if(info.flightType ==3)
    {
        self.mClassType.text = @"(晚班)";
    }
    self.mLimitLb.text = [NSString stringWithFormat:@"人数上限(%d)人",info.personUpperLimit];
    
    if (info.startdate.length>10) {
        info.startdate = [info.startdate substringToIndex:10];
    }
    if (info.enddate.length>10) {
        info.enddate = [info.enddate substringToIndex:10];
    }
    
    self.mStartTimeLb.text = [NSString stringWithFormat:@"%@ %@",info.startdate,info.starttime];
    self.m_endTimeLb.text = [NSString stringWithFormat:@"%@ %@",info.enddate,info.starttime];
    //[[info.startdate substringToIndex:10] stringByAppendingString:info.starttime];
    self.mCaptorLb.text = [NSString stringWithFormat:@"组长(%@)",info.caption];
    
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.bgView.image = bgimage;
    self.mClassType.textColor = [UIColor colorWithHexString:@"#8e8e8e"];
    self.mTtitleLb.textColor = [UIColor colorWithHexString:@"#f13130"];
    self.mLimitLb.textColor = [UIColor colorWithHexString:@"#8e8e8e"];
    self.mCaptorLb.textColor =[UIColor colorWithHexString:@"#8e8e8e"];
    self.mStartTimeLb.textColor = [UIColor colorWithHexString:@"#23b3ac"];
    self.m_endTimeLb.textColor = [UIColor colorWithHexString:@"#23b3ac"];
}
+(CGFloat)cellHeight{
    return 120;
}
@end
