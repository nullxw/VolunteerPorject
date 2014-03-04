//
//  CheckPlanCell.h
//  VolunteerApp
//
//  Created by 邹泽龙 on 14-2-28.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "PDBaseCell.h"
#import "ClassPlanInfo.h"
@interface CheckPlanCell : PDBaseCell
@property (strong, nonatomic) IBOutlet UILabel *mClassType;

@property (strong, nonatomic) IBOutlet UILabel *mLimitLb;
@property (strong, nonatomic) IBOutlet UILabel *mCaptorLb;
@property (strong, nonatomic) IBOutlet UILabel *mStartTimeLb;
@property (strong, nonatomic) IBOutlet UILabel *m_endTimeLb;
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (strong, nonatomic) IBOutlet UILabel *mTtitleLb;
- (void)setupMyPlanCell:(ClassPlanInfo *)info;
@end
