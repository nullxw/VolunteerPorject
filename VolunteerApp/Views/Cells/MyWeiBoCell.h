//
//  MyWeiBoCell.h
//  VolunteerApp
//
//  Created by zelong zou on 14-3-2.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboInfo.h"
@class MyWeiBoCell;
@protocol WeiboCellDelegate <NSObject>

- (void)WeiboCell:(MyWeiBoCell *)cell actionCollectAtIndexPath:(NSIndexPath *)path;
- (void)WeiboCell:(MyWeiBoCell *)cell actionCommentAtIndexPath:(NSIndexPath *)path;
@end
@interface MyWeiBoCell : UITableViewCell
@property (strong, nonatomic)    NSIndexPath        *cellInPath;
@property (nonatomic,assign) id<WeiboCellDelegate> delegate;
- (void)setupWithWeiboInfo:(WeiboInfo *)info;
@end
