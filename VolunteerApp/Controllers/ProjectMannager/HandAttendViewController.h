//
//  HandAttendViewController.h
//  VolunteerApp
//
//  Created by zelong zou on 14-3-22.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "BaseViewController.h"
#import "UserAttend.h"
@interface HandAttendViewController : BaseViewController
@property (nonatomic,strong) UserAttend *attendInfo;
@property (nonatomic,assign) int mid;
@property (nonatomic,assign) int teamId;
@end
