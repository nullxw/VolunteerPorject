//
//  UserAttendView.h
//  VolunteerApp
//
//  Created by zelong zou on 14-3-21.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserAttend.h"

@interface UserAttendView : UIView
@property (weak, nonatomic) IBOutlet UIView *mContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *mBgVIew;
@property (weak, nonatomic) IBOutlet UILabel *mName;

@property (weak, nonatomic) IBOutlet UIImageView *mGenderView;
@property (weak, nonatomic) IBOutlet UILabel *mTime;
@property (weak, nonatomic) IBOutlet UIImageView *mSeplineView;
@property (weak, nonatomic) IBOutlet UILabel *mTitleView;
@property (weak, nonatomic) IBOutlet UIButton *mAttendBtn;

- (IBAction)ActionAttend:(UIButton *)sender;

- (void)setupWithUserAttendInfo:(UserAttend *)item;

- (void)addActionBlock:(void (^)(int index))block;
@end
