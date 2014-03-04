//
//  ProManagerCell.h
//  VolunteerApp
//
//  Created by zelong zou on 14-2-27.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "PDBaseCell.h"


#import "ProjectInfo.h"
typedef enum {
    kMyprojectCellType_Plan,
    kMyprojectCellType_Manage

    
}MyprojectCellType;

@class ProManagerCell;
@protocol MyProManagerCellDelegate <NSObject>

- (void)actionAttendBtn:(ProManagerCell *)cell AtIndexPath:(NSIndexPath *)ipath withType:(MyprojectCellType)type;
- (void)actionRecruitBtn:(ProManagerCell *)cell AtIndexPath:(NSIndexPath *)ipath withType:(MyprojectCellType)type;
@end
@interface ProManagerCell : PDBaseCell
@property (weak, nonatomic) IBOutlet UILabel *mTitle;
@property (weak, nonatomic) IBOutlet UILabel *mState;
@property (weak, nonatomic) IBOutlet UILabel *mTime;
@property (weak, nonatomic) IBOutlet UILabel *mContent;
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *mStateImage;
- (IBAction)actionAttention:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *mAttenBtn;
@property (weak, nonatomic) IBOutlet UIButton *mRecruitBtn;
- (IBAction)actionRecruit:(UIButton *)sender;

@property (strong, nonatomic)    NSIndexPath        *cellInPath;
@property (nonatomic,assign)     id<MyProManagerCellDelegate> delegate;
@property (nonatomic,assign)    MyprojectCellType  cellType;
- (void)setupMyWaitCell:(ProjectInfo *)info;
@end
