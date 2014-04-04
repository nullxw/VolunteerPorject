//
//  SearchResultCell.h
//  VolunteerApp
//
//  Created by zelong zou on 14-4-1.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "PDBaseCell.h"
#import "SearchResult.h"
@interface SearchResultCell : PDBaseCell
@property (weak, nonatomic) IBOutlet UIImageView *mBgView;
@property (weak, nonatomic) IBOutlet UILabel *mTitleLb;

@property (weak, nonatomic) IBOutlet UILabel *mTimeLb;
@property (weak, nonatomic) IBOutlet UILabel *mContentLb;
@property (nonatomic) int index;

- (void)setupMyResultCell:(SearchResult *)info;
+ (CGFloat)caclulateHeightWithInfo:(SearchResult *)info;
@end
