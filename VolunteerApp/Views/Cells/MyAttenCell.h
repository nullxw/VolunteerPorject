//
//  MyAttenCell.h
//  VolunteerApp
//
//  Created by zelong zou on 14-3-2.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "PDBaseCell.h"
#import "SignInfo.h"
@interface MyAttenCell : PDBaseCell
@property (weak, nonatomic) IBOutlet UIImageView *mbgview;
@property (weak, nonatomic) IBOutlet UILabel *msigin;
@property (weak, nonatomic) IBOutlet UILabel *mysigout;
@property (weak, nonatomic) IBOutlet UILabel *mstate;
@property (weak, nonatomic) IBOutlet UILabel *mendtime;
@property (weak, nonatomic) IBOutlet UILabel *mstarttime;


- (void)setupWithSignInfo:(SignInfo *)info;
@end
