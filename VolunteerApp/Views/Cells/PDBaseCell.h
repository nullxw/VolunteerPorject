//
//  PDBaseCell.h
//  QiaoQiaoMovie
//
//  Created by zelong zou on 13-3-22.
//  Copyright (c) 2013年 prdoor. All rights reserved.
//

#import <UIKit/UIKit.h>
#define Font(x) ([UIFont fontWithName:@"Avenir-Medium" size:x])
@interface PDBaseCell : UITableViewCell
+ (UINib *)nib;

+ (id)cellForTableView:(UITableView *)tableView withStyle:(UITableViewCellStyle)style cellID:(NSString*)cellID;
+ (id)cellForTableView:(UITableView *)tableView withStyle:(UITableViewCellStyle)style;
+ (id)cellForTableView:(UITableView *)tableView fromNib:(UINib *)nib;

+ (NSString *)cellIdentifier;

- (void)reset;
+ (CGFloat)cellHeight;
@end
