//
//  MyTabView.h
//  VolunteerApp
//
//  Created by zelong zou on 14-3-18.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyTabView;
@protocol MyTabViewDelegate <NSObject>

- (NSArray *)MyTabViewTitleForTabView:(MyTabView *)tabview;
- (void)MytableView:(MyTabView *)tabView moveAtIndex:(int)index;
@end
@interface MyTabView : UIView
- (id)initWithFrame:(CGRect)frame delegate:(id<MyTabViewDelegate>)adelegate;
@end
