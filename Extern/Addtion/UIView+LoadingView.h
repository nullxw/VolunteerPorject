//
//  UIView+LoadingView.h
//  FanxingSDK
//
//  Created by 邹泽龙 on 13-12-23.
//  Copyright (c) 2013年 kugou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LoadingView)
- (void)showLoadingViewWithString:(NSString *)str;
- (void)showLoadingView;
- (void)hideLoadingView;
- (void)showHudMessage:(NSString *)message;

- (void)addCenterMsgView:(NSString *)msg;
- (void)removeCenterMsgView;
@end
