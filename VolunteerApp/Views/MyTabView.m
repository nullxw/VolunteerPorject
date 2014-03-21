//
//  MyTabView.m
//  VolunteerApp
//
//  Created by zelong zou on 14-3-18.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "MyTabView.h"

@implementation MyTabView
{
    NSArray *array;
    NSMutableArray *btnList;
    NSMutableArray *titleList;
    
    UIImageView    *moveLineView;
    
    id<MyTabViewDelegate> delegate;
}
- (id)initWithFrame:(CGRect)frame delegate:(id<MyTabViewDelegate>)adelegate
{
    self = [super initWithFrame:frame];
    if (self) {
        delegate = adelegate;
        if (delegate && [delegate respondsToSelector:@selector(MyTabViewTitleForTabView:)]) {
            array = [delegate MyTabViewTitleForTabView:self];
            int itmeCount = [array count];
            btnList = [[NSMutableArray alloc]initWithCapacity:itmeCount];
            
            
            UIImage *bgimage = [[UIImage imageNamed:@"mypro_tabbarbg"]resizableImageWithCapInsets:UIEdgeInsetsMake(40, 10, 40, 10)];
            
            UIImageView *backGroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, 44)];
            backGroundView.image = bgimage;
            [self addSubview:backGroundView];
            
            
            CGFloat width = frame.size.width/itmeCount;
            for (int i=0; i<itmeCount; i++) {
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                if (i == 0) {
                    button.selected = YES;
                }
                button.backgroundColor = [UIColor clearColor];
                button.tag = i+2233;
                button.frame = CGRectMake(i*width, 0, width, 44);
                [button setTitle:array[i] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
                
                [button addTarget:self action:@selector(actionTab:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:button];
                [btnList addObject:button];
                
                
            }
            
            CGFloat imageWidth = width*3/4;
            CGFloat left = width/8;
            
            moveLineView = [[UIImageView alloc]initWithFrame:CGRectMake(left, frame.size.height-8, imageWidth, 4)];
            moveLineView.backgroundColor = [UIColor redColor];
            [self addSubview:moveLineView];
            
            
            
        }
    }
    return self;
}

- (void)actionTab:(UIButton *)btn
{
    if (btn.selected) {
        return;
    }
    int index = btn.tag - 2233;

    [UIView animateWithDuration:0.3f animations:^{
        moveLineView.centerX = btn.centerX;
    } completion:^(BOOL finished) {
        
        for (UIButton *item in btnList) {
            item.selected = NO;
        }
        btn.selected = YES;
        if (delegate  && [delegate respondsToSelector:@selector(MytableView:moveAtIndex:)]) {
            [delegate MytableView:self moveAtIndex:index];
        }
    }];
}


@end
