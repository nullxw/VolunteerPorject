//
//  ProjectMgCell.h
//  VolunteerApp
//
//  Created by zelong zou on 14-3-18.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "PDBaseCell.h"
#import "ProjectInfo.h"

@class ProjectMgCell;
@protocol ProjectMgCellDelegate <NSObject>

- (void)ProjectMgCell:(ProjectMgCell *)cell actionRescruit:(UIButton *)rescruit;
- (void)ProjectMgCell:(ProjectMgCell *)cell actionAttend:(UIButton *)attend;
@end
@interface ProjectMgCell : PDBaseCell

@property (weak, nonatomic) IBOutlet UIButton *mRescruitBtn;
@property (weak, nonatomic) IBOutlet UIButton *mAttendBtn;
@property (weak, nonatomic) IBOutlet UIImageView *mBgView;
@property (weak, nonatomic) IBOutlet UILabel *mTitle;
@property (weak, nonatomic) IBOutlet UILabel *mTime;
@property (weak, nonatomic) IBOutlet UIImageView *mStateImage;
@property (nonatomic,strong)  NSIndexPath  *indexPath;

@property (nonatomic,assign) id<ProjectMgCellDelegate> delegate;
- (IBAction)actionRescruit:(id)sender;
- (IBAction)actionAttend:(UIButton *)sender;

- (void)setupMyWaitCell:(ProjectInfo *)info;
@end
