//
//  UIView+LoadingView.m
//  FanxingSDK
//
//  Created by 邹泽龙 on 13-12-23.
//  Copyright (c) 2013年 kugou. All rights reserved.
//

#import "UIView+LoadingView.h"
#import "MBProgressHUD.h"
#define loadingViewTag 3455899
#define defaultViewTag 4445554
@implementation UIView (LoadingView)
- (void)addCenterMsgView:(NSString *)msg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UILabel *label = (UILabel *)[self viewWithTag:defaultViewTag];
        
        if (!label) {

            CGSize strSize = [msg sizeWithFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:CGSizeMake(self.bounds.size.width-120, self.bounds.size.height) lineBreakMode:NSLineBreakByWordWrapping];
            label = [[UILabel alloc]initWithFrame:CGRectMake(60, 100, MIN(strSize.width+20, 200) , strSize.height+10)];
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment  = NSTextAlignmentCenter;
            label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = [UIColor blackColor];
            label.text = msg;
            label.center  = self.center;
            [self addSubview:label];

        }


    });

}
- (void)removeCenterMsgView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UILabel *label = (UILabel *)[self viewWithTag:defaultViewTag];
        if (label) {
            [label removeFromSuperview];
        }
    });

}
- (void)showLoadingView
{
    
    [self showLoadingViewWithString:@"正在载入..."];

}
- (void)showLoadingViewWithString:(NSString *)str
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *loadingView = [self viewWithTag:loadingViewTag];
        if (!loadingView) {
            
            CGSize strSize = [str sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:CGSizeMake(self.bounds.size.width-100, self.bounds.size.height) lineBreakMode:NSLineBreakByWordWrapping];
            loadingView = [[UIView alloc]initWithFrame:self.bounds];
            loadingView.backgroundColor = [UIColor clearColor];
            loadingView.tag = loadingViewTag;
            [self addSubview:loadingView];
            
            
            CGFloat centerX = (self.bounds.size.width - (20+strSize.width))/2;
            
            //创建加载条
            UIActivityIndicatorView *aivWaiting = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [aivWaiting startAnimating];
            aivWaiting.frame = CGRectMake(centerX, loadingView.center.y-10, 20, 20);
            [loadingView addSubview:aivWaiting];
            
            
            UILabel *textLabel=[[UILabel alloc] initWithFrame:CGRectMake(aivWaiting.frame.origin.x+aivWaiting.frame.size.width+5, aivWaiting.frame.origin.y, 90, 20)];
            textLabel.textColor=[UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0];
            [textLabel setFont:[UIFont systemFontOfSize:13.0f]];
            textLabel.backgroundColor=[UIColor clearColor];
            textLabel.textAlignment=NSTextAlignmentLeft;
            textLabel.text= str;
            [loadingView addSubview:textLabel];
            
        }
    });

}
- (void)hideLoadingView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *loadingView = [self viewWithTag:loadingViewTag];
        if (!loadingView) {
            return;
        }else
        {
            [loadingView removeFromSuperview];
        }
    });

}
- (void)showHudMessage:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 10.f;
    hud.yOffset = 40.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.5];
}
@end
