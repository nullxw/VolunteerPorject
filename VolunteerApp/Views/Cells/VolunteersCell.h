//
//  VolunteersCell.h
//  VolunteerApp
//
//  Created by zelong zou on 14-3-19.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "PDBaseCell.h"
#import "RescruitVolunInfo.h"
#import "AddVolunteerInfo.h"


//typedef enum {
//    kProjectType_35 = 35,
//    kProjectType_50 = 50,
//    kProjectType_100 = 100,
//    kProjectType_1000 = 1000
//}ProjectType;
@class VolunteersCell;
@protocol VolunteersCellDelegate <NSObject>

- (void)VolunteersCell:(VolunteersCell *)cell actionRescruit:(UIButton *)rescruit;
- (void)VolunteersCell:(VolunteersCell *)cell actionDel:(UIButton *)attend;
@end
@interface VolunteersCell : PDBaseCell
@property (weak, nonatomic) IBOutlet UIButton *mRescruitBtn;
@property (weak, nonatomic) IBOutlet UIButton *mDeletaBtn;
@property (weak, nonatomic) IBOutlet UIImageView *mStateImage;
@property (weak, nonatomic) IBOutlet UILabel *mName;

@property (weak, nonatomic) IBOutlet UIImageView *mBgImage;
@property (weak, nonatomic) IBOutlet UILabel *mPhone;
@property (weak, nonatomic) IBOutlet UIImageView *mGenderImage;
@property (nonatomic,weak)  NSIndexPath  *indexPath;
@property (nonatomic,assign) id<VolunteersCellDelegate> delegate;
- (IBAction)actionRescruit:(UIButton *)sender;
- (IBAction)actionDelete:(UIButton *)sender;

- (void)setupWithRescruitVolunInfo:(RescruitVolunInfo *)info;
- (void)setupWithAddVolunteerInfo:(AddVolunteerInfo *)info;
@end
