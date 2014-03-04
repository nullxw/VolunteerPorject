//
//  MyWaitCell.h
//  VolunteerApp
//
//  Created by zelong zou on 14-2-26.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "PDBaseCell.h"
#import "MissionInfo.h"
#import "SearchResult.h"
typedef enum {
    kMyprojectCellType_Join,
    kMyprojectCellType_Wait,
    kMyprojectCellType_Complete,
    kMyprojectCellType_Apply
    
}MyprojectCellType;

@class MyWaitCell;
@protocol MyWaitCellDelegate <NSObject>

- (void)actionAttendBtn:(MyWaitCell *)cell AtIndexPath:(NSIndexPath *)ipath;

@end
@interface MyWaitCell :PDBaseCell

@property (weak, nonatomic) IBOutlet UILabel *mTitle;
@property (weak, nonatomic) IBOutlet UILabel *mState;
@property (weak, nonatomic) IBOutlet UILabel *mTime;
@property (weak, nonatomic) IBOutlet UILabel *mContent;
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *mStateImage;
- (IBAction)actionAttention:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *mAttenBtn;

@property (strong, nonatomic)    NSIndexPath        *cellInPath;
@property (nonatomic,assign)     id<MyWaitCellDelegate> delegate;
- (void)setupMyWaitCell:(MissionInfo *)info WithType:(MyprojectCellType)type;

- (void)setupMyResultCell:(SearchResult *)info;
@end
