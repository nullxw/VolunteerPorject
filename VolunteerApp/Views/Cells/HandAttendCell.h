//
//  HandAttendCell.h
//  VolunteerApp
//
//  Created by zelong zou on 14-3-20.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "PDBaseCell.h"


@class HandAttendCell;
@protocol HandAttendCellDelegate <NSObject>

- (void)HandAttendCellDelegate:(HandAttendCell *)cell actionWithIndex:(NSInteger)index;

@end
@interface HandAttendCell : PDBaseCell
@property (weak, nonatomic) IBOutlet UIView *mContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *mBgVIew;
@property (weak, nonatomic) IBOutlet UILabel *mName;

@property (weak, nonatomic) IBOutlet UIImageView *mGenderView;
@property (weak, nonatomic) IBOutlet UILabel *mTime;
@property (weak, nonatomic) IBOutlet UIImageView *mSeplineView;
@property (weak, nonatomic) IBOutlet UILabel *mTitleView;

@property (nonatomic,assign) int index;
@property (nonatomic,assign) id<HandAttendCellDelegate> delegate;

- (IBAction)ActionAttend:(UIButton *)sender;
@end
