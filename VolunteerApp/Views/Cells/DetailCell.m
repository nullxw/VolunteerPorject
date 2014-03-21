//
//  DetailCell.m
//  VolunteerApp
//
//  Created by zelong zou on 14-3-7.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "DetailCell.h"
#import "UIImageView+WebCache.h"
#import "UrlDefine.h"

@implementation DetailCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setupWithWeiboInfo:(WeiboInfo *)info
{
    self.backgroundColor= [UIColor whiteColor];
    
    [self.mAvator setImageWithURL:[NSURL URLWithString:[IMAGE_URL stringByAppendingString:info.portrain]] placeholderImage:[UIImage imageNamed:@"defaultHeadImage.png"]];
    
    
    if (info.userName.length==0) {
        self.mName.text = @"匿名用户";
    }else{
        self.mName.text = info.userName;
    }

    self.mTime.text = info._createTime;
    
    CGSize size = [info.content sizeWithFont:Font(14) constrainedToSize:CGSizeMake(300, 20000)];
    self.mContent.font = Font(14);
    self.mName.font = Font(15);
    self.mTime.font = Font(13);
    self.mContent.height = size.height+10;
    self.mContent.text = info.content;
    if (info.picOriginal.length>0) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.mContent.left, self.mContent.bottom+5, 120, 80)];
        imageView.userInteractionEnabled = YES;
        [imageView setImageWithURL:[NSURL URLWithString:[IMAGE_URL stringByAppendingString:info.picLittle]] placeholderImage:[UIImage imageNamed:@"DefaultCover.png"]];
        [self.contentView addSubview:imageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapImageView:)];
        
        [imageView addGestureRecognizer:tap];
    }
    
    
}



- (void)handleTapImageView:(UIGestureRecognizer *)gestrue
{
    
    UIImageView *view = (UIImageView *)gestrue.view;
    if (gestrue.state == UIGestureRecognizerStateEnded) {
        if (_delegate && [_delegate respondsToSelector:@selector(DetailCell:actionImageView:)]) {
            [_delegate DetailCell:self actionImageView:view];
        }
    }
}

@end
