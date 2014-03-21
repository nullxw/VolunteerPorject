//
//  DetailCell.h
//  VolunteerApp
//
//  Created by zelong zou on 14-3-7.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "PDBaseCell.h"
#import "WeiboInfo.h"

@class DetailCell;
@protocol DetailCellDelegate <NSObject>

- (void)DetailCell:(DetailCell *)cell actionImageView:(UIImageView *)imageView;

@end
@interface DetailCell : PDBaseCell

@property (weak, nonatomic) IBOutlet UIImageView *mAvator;
@property (weak, nonatomic) IBOutlet UILabel *mName;
@property (weak, nonatomic) IBOutlet UILabel *mTime;
@property (weak, nonatomic) IBOutlet UILabel *mContent;

@property (nonatomic,assign) id<DetailCellDelegate> delegate;
- (void)setupWithWeiboInfo:(WeiboInfo *)info;
@end
