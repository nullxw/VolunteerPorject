//
//  MyInfoCell.h
//  VolunteerApp
//
//  Created by zelong zou on 14-3-1.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "PDBaseCell.h"

@interface MyInfoCell : PDBaseCell

@property (weak, nonatomic) IBOutlet UILabel *mTitleLb;
@property (weak, nonatomic) IBOutlet UILabel *mInfoLb;
- (void)setupWithInfo:(NSString *)info detailInfo:(NSString *)detail;
@end
