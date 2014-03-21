//
//  VolunInfoCell.h
//  VolunteerApp
//
//  Created by zelong zou on 14-3-17.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "PDBaseCell.h"
#import "VolunInfo.h"
@interface VolunInfoCell : PDBaseCell
@property (weak, nonatomic) IBOutlet UIImageView *mBgView;
@property (weak, nonatomic) IBOutlet UILabel *mTitleLb;
@property (weak, nonatomic) IBOutlet UILabel *mTimeLb;

@property (weak, nonatomic) IBOutlet UILabel *mVistorLb;

- (void)setupWithVolunInfo:(VolunInfo *)info;
@end
