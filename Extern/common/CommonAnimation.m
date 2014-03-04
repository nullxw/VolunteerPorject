//
//  CommonAnimation.m
//  FanxingSDK
//
//  Created by xiaogaochao on 13-11-20.
//  Copyright (c) 2013年 kugou. All rights reserved.
//

#import "CommonAnimation.h"
#import <QuartzCore/QuartzCore.h>
@implementation CommonAnimation

+ (void)MarqueeAnimationFromRight:(float)timeVal parent:(UIView*)parentView child:(UIView*)subView animationID:(NSString*)animationID delegate:(id)delegate fun:(SEL)func
{
    if(parentView==nil || subView==nil) return;
    parentView.hidden=NO;
    [parentView addSubview:subView];
    [subView release];
    [subView sizeToFit];
    CGRect frame = subView.frame;
    frame.origin.x = 320;
    subView.frame = frame;

    [UIView beginAnimations:animationID context:NULL];
    [UIView setAnimationDuration:timeVal];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    if(nil!=delegate)
    {
        [UIView setAnimationDelegate:delegate];
        if(nil!=func)
        {
            [UIView setAnimationDidStopSelector:func];
        }
    }
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationRepeatCount:1];

    frame = subView.frame;
    frame.origin.x = -frame.size.width;
    subView.frame = frame;
    [UIView commitAnimations];
}

//一个视图，从右边出现
+ (void)AppearFromRight:(float)timeVal Right:(UIView*)rightView animationID:(NSString*)animationID delegate:(id)delegate fun:(SEL)func
{
    CGRect currentRightRect=rightView.frame;
    CGRect rightRect=CGRectOffset(currentRightRect, rightView.frame.size.width,0);
    rightView.frame=rightRect;
    
    [UIView beginAnimations:animationID context:nil];
    [UIView setAnimationDuration:timeVal];
    if(nil!=delegate)
    {
        [UIView setAnimationDelegate:delegate];
        if(nil!=func)
        {
            [UIView setAnimationDidStopSelector:func];
        }
    }
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    rightView.frame=currentRightRect;
    [UIView commitAnimations];
}

//一个视图，从右边消失
+ (void)DisappearFromRight:(float)timeVal Right:(UIView*)rightView animationID:(NSString*)animationID delegate:(id)delegate fun:(SEL)func
{
    CGRect currentRightRect=rightView.frame;
    CGRect rightRect=CGRectOffset(currentRightRect, rightView.frame.size.width,0);
    rightView.frame=currentRightRect;
    
    [UIView beginAnimations:animationID context:nil];
    [UIView setAnimationDuration:timeVal];
    if(nil!=delegate)
    {
        [UIView setAnimationDelegate:delegate];
        if(nil!=func)
        {
            [UIView setAnimationDidStopSelector:func];
        }
    }
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    rightView.frame=rightRect;
    [UIView commitAnimations];
}

//一个视图，从顶部出现
+ (void)AppearFromTop:(float)timeVal Top:(UIView*)topView animationID:(NSString*)animationID delegate:(id)delegate fun:(SEL)func
{
    CGRect currentTopRect=topView.frame;
    CGRect topRect=CGRectOffset(currentTopRect, 0,-topView.frame.size.height);
    topView.frame=topRect;
    
    [UIView beginAnimations:animationID context:nil];
    [UIView setAnimationDuration:timeVal];
    if(nil!=delegate)
    {
        [UIView setAnimationDelegate:delegate];
        if(nil!=func)
        {
            [UIView setAnimationDidStopSelector:func];
        }
    }
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    topView.frame=currentTopRect;
    [UIView commitAnimations];
}

//一个视图，从顶部消失
+ (void)DisappearFromTop:(float)timeVal Top:(UIView*)topView animationID:(NSString*)animationID delegate:(id)delegate fun:(SEL)func
{
    CGRect currentTopRect=topView.frame;
    CGRect topRect=CGRectOffset(currentTopRect, 0,-topView.frame.size.height);
    
    topView.frame=currentTopRect;
    [UIView beginAnimations:animationID context:nil];
    [UIView setAnimationDuration:timeVal];
    if(nil!=delegate)
    {
        [UIView setAnimationDelegate:delegate];
        if(nil!=func)
        {
            [UIView setAnimationDidStopSelector:func];
        }
    }
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    topView.frame=topRect;
    [UIView commitAnimations];
}

//一个视图，从底部出现
+ (void)AppearFromBottom:(float)timeVal Bottom:(UIView*)bottomView animationID:(NSString*)animationID delegate:(id)delegate fun:(SEL)func
{
    CGRect currentRect=bottomView.frame;
    CGRect bottomRect=CGRectOffset(currentRect, 0,currentRect.size.height);
    
    bottomView.frame=bottomRect;
    [UIView beginAnimations:animationID context:nil];
    [UIView setAnimationDuration:timeVal];
    if(nil!=delegate)
    {
        [UIView setAnimationDelegate:delegate];
        if(nil!=func)
        {
            [UIView setAnimationDidStopSelector:func];
        }
    }
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    bottomView.frame=currentRect;
    [UIView commitAnimations];
}


//一个视图，从底部消失
+ (void)DisappearFromBottom:(float)timeVal Bottom:(UIView*)bottomView animationID:(NSString*)animationID delegate:(id)delegate fun:(SEL)func
{
    CGRect currentRect=bottomView.frame;
    CGRect bottomRect=CGRectOffset(currentRect, 0,currentRect.size.height);
    
    bottomView.frame=currentRect;
    [UIView beginAnimations:animationID context:nil];
    [UIView setAnimationDuration:timeVal];
    if(nil!=delegate)
    {
        [UIView setAnimationDelegate:delegate];
        if(nil!=func)
        {
            [UIView setAnimationDidStopSelector:func];
        }
    }
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    bottomView.frame=bottomRect;
    [UIView commitAnimations];
}

//两个视图，分别从顶部和底部出来
+ (void)AppearFromTopAndBottom:(float)timeVal Top:(UIView*)topView bottom:(UIView*)bottomView animationID:(NSString*)animationID delegate:(id)delegate fun:(SEL)func
{
    CGRect currentTopRect=topView.frame;
    CGRect topRect=CGRectOffset(currentTopRect, 0,-topView.frame.size.height);
    topView.frame=topRect;
    
    CGRect currentBottomRect=bottomView.frame;
    CGRect bottomRect=CGRectOffset(currentBottomRect, 0,bottomView.frame.size.height);
    bottomView.frame=bottomRect;
    
    [UIView beginAnimations:animationID context:nil];
    [UIView setAnimationDuration:timeVal];
    if(nil!=delegate)
    {
        [UIView setAnimationDelegate:delegate];
        if(nil!=func)
        {
            [UIView setAnimationDidStopSelector:func];
        }
    }
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    topView.frame=currentTopRect;
    bottomView.frame=currentBottomRect;
    [UIView commitAnimations];
}

//两个视图，分别从顶部和底部消失
+ (void)DisappearFromTopAndBottom:(float)timeVal Top:(UIView*)topView bottom:(UIView*)bottomView animationID:(NSString*)animationID delegate:(id)delegate fun:(SEL)func
{
    CGRect currentTopRect=topView.frame;
    CGRect topRect=CGRectOffset(currentTopRect, 0,-topView.frame.size.height);
    topView.frame=currentTopRect;
    
    CGRect currentBottomRect=bottomView.frame;
    CGRect bottomRect=CGRectOffset(currentBottomRect, 0,bottomView.frame.size.height);
    bottomView.frame=currentBottomRect;
    
    [UIView beginAnimations:animationID context:nil];
    [UIView setAnimationDuration:timeVal];
    if(nil!=delegate)
    {
        [UIView setAnimationDelegate:delegate];
        if(nil!=func)
        {
            [UIView setAnimationDidStopSelector:func];
        }
    }
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    topView.frame=topRect;
    bottomView.frame=bottomRect;
    [UIView commitAnimations];
}

+ (void)FadeInAndOut:(float)timeVal parent:(UIView*)parentView child:(UIView*)popOver animationID:(NSString*)animationID delegate:(id)delegate fun:(SEL)func
{
    if(parentView==nil || popOver==nil) return;
    [parentView addSubview:popOver];
    [popOver release];

    [UIView beginAnimations:animationID context:NULL];
    if(nil!=delegate)
    {
        [UIView setAnimationDelegate:delegate];
        if(nil!=func)
        {
            [UIView setAnimationDidStopSelector:func];
        }
    }
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:timeVal];
    [popOver setAlpha:0.8];
    [UIView commitAnimations];
}

+ (void)performSingleGiftAnimationWithSuperView:(UIView *)view
                            withImageList:(NSArray *)imageArray
                                giftCount:(int)count
                             giftSendName:(NSString *)sendname
                           completeHandle:(void(^)(UIView *view))completeBlock
{
    NSLog(@"_________<<执行礼物单个动画 >>________");
    UIView *animationView = [[UIView alloc]initWithFrame:CGRectMake(40, 0, 240, view.bounds.size.height)];
    animationView.backgroundColor = [UIColor clearColor];

    UIImageView *imageView = [[UIImageView alloc]initWithFrame:animationView.bounds];
    
    imageView.animationImages = [NSArray arrayWithObjects:
                                 [UIImage imageNamed:@"FXApi_IOS_Bundle.bundle/fanxing_gift_m_bg_1.png"],
                                 [UIImage imageNamed:@"FXApi_IOS_Bundle.bundle/fanxing_gift_m_bg_2.png"],
                                 [UIImage imageNamed:@"FXApi_IOS_Bundle.bundle/fanxing_gift_m_bg_3.png"],
                                 nil];
    
    imageView.animationDuration = 0.1f;
    imageView.animationRepeatCount = HUGE_VAL;
    [animationView addSubview:imageView];
    [imageView release];
    
    UIImage *singleImage = imageArray[0];
    CGImageRef cgImage=[singleImage CGImage];
    UIImageView *singleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGImageGetWidth(cgImage), CGImageGetHeight(cgImage))];
    singleImageView.image = singleImage;
    singleImageView.center = animationView.center;
    [animationView addSubview:singleImageView];
    [singleImageView release];
    
    NSString *numberStr = [NSString stringWithFormat:@"X%d",count];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(200, view.bounds.size.height-30, 40, 30)];
    label.lineBreakMode = UILineBreakModeCharacterWrap;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:18.0f];
    label.textAlignment  = UITextAlignmentCenter;
    label.text = numberStr;
    [label sizeToFit];
    label.textColor = [UIColor redColor];
    [animationView addSubview:label];
    [label release];
    
    UILabel *namelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, view.bounds.size.height-30, 240, 30)];
    namelabel.backgroundColor = [UIColor clearColor];
    namelabel.font = [UIFont boldSystemFontOfSize:18.0f];
    namelabel.textAlignment  = UITextAlignmentCenter;
    namelabel.text = sendname;
    namelabel.textColor = [UIColor yellowColor];
    [animationView addSubview:namelabel];
    [namelabel release];
    
    [view addSubview:animationView];
    
    [animationView release];
    
    [imageView startAnimating];
    
    CGRect oldFrame = label.frame;
    oldFrame.origin.y = 0;
    
    CGRect newFrame = label.frame;
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 6.0 ];
    rotationAnimation.duration = 1.5f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 1;
    [label.layer addAnimation:rotationAnimation forKey:nil];
    
    [UIView animateWithDuration:1.5f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        label.frame = oldFrame;
    } completion:^(BOOL finished) {
        [label.layer removeAllAnimations];
        [UIView animateWithDuration:1.0f delay:0.5f options:UIViewAnimationOptionCurveEaseOut animations:^{
            label.frame = newFrame;
            namelabel.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
        } completion:^(BOOL finished) {
            [imageView stopAnimating];
            if (completeBlock) {
                completeBlock(animationView);
            }
        }];
    }];
}

+ (void)performMultipleleGiftAnimationWithSuperView:(UIView *)view
                            withImageList:(NSArray *)imageArray
                                giftCount:(int)count
                             giftSendName:(NSString *)sendname
                           completeHandle:(void(^)(UIView *view))completeBlock
{
    NSLog(@"_________<<执行礼物动画块>>________");
    UIView *animationView = [[UIView alloc]initWithFrame:CGRectMake(40, 0, 240, view.bounds.size.height)];
    animationView.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:animationView.bounds];
    imageview.animationDuration = 5.0f;
    imageview.animationImages = imageArray;
    imageview.animationRepeatCount = 1;
    [animationView addSubview:imageview];
    [imageview release];
    
    NSString *numberStr = [NSString stringWithFormat:@"X%d",count];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(200, view.bounds.size.height-30, 40, 30)];
    label.lineBreakMode = UILineBreakModeCharacterWrap;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:18.0f];
    label.textAlignment  = UITextAlignmentCenter;
    label.text = numberStr;
    label.textColor = [UIColor redColor];
    [label sizeToFit];
    [animationView addSubview:label];
    [label release];
    
    UILabel *namelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, view.bounds.size.height-30, 240, 30)];
    namelabel.backgroundColor = [UIColor clearColor];
    namelabel.font = [UIFont boldSystemFontOfSize:18.0f];
    namelabel.textAlignment  = UITextAlignmentCenter;
    namelabel.text = sendname;
    namelabel.textColor = [UIColor yellowColor];
    [animationView addSubview:namelabel];
    [namelabel release];
    
    [view addSubview:animationView];
    [animationView release];
    
    [imageview startAnimating];
    
    CGRect oldFrame = label.frame;
    oldFrame.origin.y = 0;
    
    CGRect newFrame = label.frame;
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 6.0 ];
    rotationAnimation.duration = 2.5f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 1;
    [label.layer addAnimation:rotationAnimation forKey:nil];
    
    [UIView animateWithDuration:2.5f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        label.frame = oldFrame;
    } completion:^(BOOL finished) {
        [label.layer removeAllAnimations];
        [UIView animateWithDuration:2.0f delay:0.5f options:UIViewAnimationOptionCurveEaseIn animations:^{
            label.frame = newFrame;
            namelabel.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
        } completion:^(BOOL finished) {
            [imageview stopAnimating];
            if (completeBlock) {
                completeBlock(animationView);
            }
        }];
    }];
    
}


@end
