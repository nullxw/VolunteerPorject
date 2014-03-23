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



@property (nonatomic,assign) id<HandAttendCellDelegate> delegate;



- (void)setupWithUserAttendInfo:(NSArray *)list index:(NSInteger)idx;

- (void)setupWithUserAttendInfo:(NSArray *)list;
@end
