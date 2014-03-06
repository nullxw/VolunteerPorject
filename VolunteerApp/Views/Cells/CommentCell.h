//
//  CommentCell.h
//  VolunteerApp
//
//  Created by zelong zou on 14-3-6.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "PDBaseCell.h"
#import "WeiboInfo.h"
@interface CommentCell : PDBaseCell
@property (weak, nonatomic) IBOutlet UIImageView *mAvator;

@property (weak, nonatomic) IBOutlet UILabel *mName;
@property (weak, nonatomic) IBOutlet UILabel *mTime;
@property (weak, nonatomic) IBOutlet UILabel *mContent;
- (void)setupWithWeiboInfo:(WeiboInfo *)info;
@end
