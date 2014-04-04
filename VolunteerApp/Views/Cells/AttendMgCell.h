//
//  AttendMgCell.h
//  VolunteerApp
//
//  Created by zelong zou on 14-3-29.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "PDBaseCell.h"
#import "UserAttend.h"


@class AttendMgCell;
@protocol AttendMgCellDelegate <NSObject>

- (void)AttendMgCellDelegate:(AttendMgCell *)cell actionWithIndex:(NSInteger)index;

@end





@interface AttendMgCell : PDBaseCell
@property (weak, nonatomic) IBOutlet UIImageView *mBgView;

@property (weak, nonatomic) IBOutlet UILabel *mName;
@property (weak, nonatomic) IBOutlet UILabel *mTitle;
@property (weak, nonatomic) IBOutlet UILabel *mTime;
@property (weak, nonatomic) IBOutlet UIButton *mAttendBtn;
- (IBAction)ActionAttendBtn:(UIButton *)sender;
@property (nonatomic,assign) id<AttendMgCellDelegate> delegate;

@property (nonatomic,assign) int index;
- (void)setupWithUserAttend:(UserAttend *)info;
@end
