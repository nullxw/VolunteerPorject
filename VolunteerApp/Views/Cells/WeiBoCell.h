//
//  WeiBoCell.h
//  VolunteerApp
//
//  Created by zelong zou on 14-3-2.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "PDBaseCell.h"
#import "WeiboInfo.h"


typedef enum WeiboCellType
{
    kWeiboCellTpyeNew,
    kWeiboCellTpyeMy
}WeiboCellType;
@class WeiBoCell;
@protocol WeiboCellDelegate <NSObject>

- (void)WeiboCell:(WeiBoCell *)cell actionCollectAtIndexPath:(NSIndexPath *)path;
- (void)WeiboCell:(WeiBoCell *)cell actionCommentAtIndexPath:(NSIndexPath *)path;
- (void)WeiboCell:(WeiBoCell *)cell actionImageView:(UIImageView *)imageView;
@end
@interface WeiBoCell : PDBaseCell
{
    
}
@property (weak, nonatomic) IBOutlet UIImageView *mLeftIcon;

@property (weak, nonatomic) IBOutlet UIImageView *mRightIcon;
@property (nonatomic) WeiboCellType  cellType;
@property (strong, nonatomic)    NSIndexPath        *cellInPath;
@property (weak, nonatomic) IBOutlet UILabel *mNameLb;
@property (weak, nonatomic) IBOutlet UILabel *mTimeLb;
@property (weak, nonatomic) IBOutlet UIImageView *mbgView;

@property (weak, nonatomic) IBOutlet UIImageView *mAvatorView;
@property (weak, nonatomic) IBOutlet UIImageView *mSepLineView;
@property (weak, nonatomic) IBOutlet UILabel *mContentLb;
@property (weak, nonatomic) IBOutlet UIView *mBottomView;
@property (weak, nonatomic) IBOutlet UIButton *mCollectBtn;
@property (weak, nonatomic) IBOutlet UIButton *mCommentBtn;
@property (nonatomic,assign) id<WeiboCellDelegate> delegate;
- (IBAction)actionCollect:(UIButton *)sender;
- (IBAction)actionComment:(UIButton *)sender;

- (void)setupWithWeiboInfo:(WeiboInfo *)info;

@end
