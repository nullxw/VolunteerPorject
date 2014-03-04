//
//  CommonAnimation.h
//  FanxingSDK
//
//  Created by xiaogaochao on 13-11-20.
//  Copyright (c) 2013年 kugou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonAnimation : NSObject

+ (void)MarqueeAnimationFromRight:(float)timeVal parent:(UIView*)parentView child:(UIView*)subView animationID:(NSString*)animationID delegate:(id)delegate fun:(SEL)func;

+ (void)AppearFromRight:(float)timeVal Right:(UIView*)rightView animationID:(NSString*)animationID delegate:(id)delegate fun:(SEL)func;

+ (void)DisappearFromRight:(float)timeVal Right:(UIView*)rightView animationID:(NSString*)animationID delegate:(id)delegate fun:(SEL)func;

+ (void)AppearFromBottom:(float)timeVal Bottom:(UIView*)bottomView animationID:(NSString*)animationID delegate:(id)delegate fun:(SEL)func;

+ (void)DisappearFromBottom:(float)timeVal Bottom:(UIView*)bottomView animationID:(NSString*)animationID delegate:(id)delegate fun:(SEL)func;

+ (void)AppearFromTop:(float)timeVal Top:(UIView*)topView animationID:(NSString*)animationID delegate:(id)delegate fun:(SEL)func;

+ (void)DisappearFromTop:(float)timeVal Top:(UIView*)topView animationID:(NSString*)animationID delegate:(id)delegate fun:(SEL)func;

+ (void)AppearFromTopAndBottom:(float)timeVal Top:(UIView*)topView bottom:(UIView*)bottomView animationID:(NSString*)animationID delegate:(id)delegate fun:(SEL)func;

+ (void)DisappearFromTopAndBottom:(float)timeVal Top:(UIView*)topView bottom:(UIView*)bottomView animationID:(NSString*)animationID delegate:(id)delegate fun:(SEL)func;

+ (void)FadeInAndOut:(float)timeVal parent:(UIView*)parentView child:(UIView*)popOver animationID:(NSString*)animationID delegate:(id)delegate fun:(SEL)func;


//单个礼物动画
+ (void)performSingleGiftAnimationWithSuperView:(UIView *)view
                                  withImageList:(NSArray *)imageArray
                                      giftCount:(int)count
                                   giftSendName:(NSString *)sendname
                                 completeHandle:(void(^)(UIView *view))completeBlock;

//多个礼物的动画
+ (void)performMultipleleGiftAnimationWithSuperView:(UIView *)view
                                      withImageList:(NSArray *)imageArray
                                          giftCount:(int)count
                                       giftSendName:(NSString *)sendname
                                     completeHandle:(void(^)(UIView *view))completeBlock;
@end
