//
//  WeiBoCell.m
//  VolunteerApp
//
//  Created by zelong zou on 14-3-2.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "WeiBoCell.h"
#import "UIImageView+WebCache.h"
#import "UIColor+Addition.h"
#import "UrlDefine.h"
#import <QuartzCore/QuartzCore.h>
#import "NSString+WiFi.h"
@implementation WeiBoCell

static UIImage *bgimage = nil;
static UIColor *sepcolor= nil;
static UIFont  *font = nil;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
+(void)initialize
{
    bgimage = [[UIImage imageNamed:@"mypro_cellbg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] ;
    sepcolor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"prodetail_line.png"]]; ;
    font = [UIFont fontWithName:@"Avenir-Medium" size:14.0f];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
//    self.mBottomView.backgroundColor = [UIColor colorWithHexString:@"#95c32c"];
    self.mbgView.image = bgimage;
    self.mSepLineView.backgroundColor = sepcolor;
    
    self.mContentLb.numberOfLines = 0;
    self.mContentLb.lineBreakMode = UILineBreakModeCharacterWrap;

    self.mNameLb.textColor = [UIColor colorWithHexString:@"#95c32c"];
    self.mNameLb.font = font;
    self.mTimeLb.font = font;
    self.mContentLb.font = font;
    self.mContentLb.textColor = [UIColor colorWithHexString:@"#8e8e8e"];
}

- (void)setupWithWeiboInfo:(WeiboInfo *)info
{
    

    CGSize size = [info.content sizeWithFont:[UIFont fontWithName:@"Avenir-Medium" size:14.0f] constrainedToSize:CGSizeMake(300, 2000) lineBreakMode:NSLineBreakByCharWrapping];
    
    self.mContentLb.height = size.height+10;
    self.mTimeLb.text = info._createTime;
    self.mContentLb.text = info.content;

//    if ([info.portrain hasPrefix:@"http"]) {
//        [self.mAvatorView setImageWithURL:[NSURL URLWithString:info.portrain] placeholderImage:[UIImage imageNamed:@"defaultHeadImage.png"]];
//    }else{
//        [self.mAvatorView setImageWithURL:[NSURL URLWithString:[IMAGE_URL stringByAppendingString:info.portrain]] placeholderImage:[UIImage imageNamed:@"defaultHeadImage.png"]];
//    }
    
    [self.mAvatorView setImageWithURL:[NSURL URLWithString:[info.portrain checkUrl] ] placeholderImage:[UIImage imageNamed:@"defaultHeadImage.png"]];

    
    
    if (info.userName.length==0) {
        self.mNameLb.text = @"匿名用户";
    }else{
        self.mNameLb.text = info.userName;
    }

    
    if (self.cellType == kWeiboCellTpyeNew) {
        [self.mCollectBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [self.mCollectBtn setTitle:@"已收藏" forState:UIControlStateSelected];
        self.mCollectBtn.selected = NO;
    }else if (self.cellType == kWeiboCellTpyeMy)
    {
        [self.mCollectBtn setTitle:@"删除" forState:UIControlStateNormal];

    }


    
    [self.mCommentBtn setTitle:[NSString stringWithFormat:@"评论(%d)",info.countReply] forState:UIControlStateNormal];

    if (info.picLittle.length>0) {
    
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(self.mContentLb.left, self.mContentLb.bottom+5, 120, 80)];
//        [imageview setImageWithURL:[NSURL URLWithString:[IMAGE_URL stringByAppendingString:info.picLittle]] placeholderImage:[UIImage imageNamed:@"DefaultCover.png"]];
        [imageview setImageWithURL:[NSURL URLWithString:[info.picLittle checkUrl]] placeholderImage:[UIImage imageNamed:@"DefaultCover.png"]];
        imageview.userInteractionEnabled = YES;
        imageview.layer.borderColor = [UIColor whiteColor].CGColor;
        imageview.layer.borderWidth = 2.0f;
        [self.contentView addSubview:imageview];
        

        

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapImageView:)];
        
        [imageview addGestureRecognizer:tap];
    }
    
    
}



- (void)handleTapImageView:(UIGestureRecognizer *)gestrue
{
    
    UIImageView *view = (UIImageView *)gestrue.view;
    if (gestrue.state == UIGestureRecognizerStateEnded) {
        if (_delegate && [_delegate respondsToSelector:@selector(WeiboCell:actionImageView:)]) {
            [_delegate WeiboCell:self actionImageView:view];
        }
    }
}
- (IBAction)actionCollect:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(WeiboCell:actionCollectAtIndexPath:)]) {
        [_delegate WeiboCell:self actionCollectAtIndexPath:self.cellInPath];
    }
}

- (IBAction)actionComment:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(WeiboCell:actionCommentAtIndexPath:)]) {
        [_delegate WeiboCell:self actionCommentAtIndexPath:self.cellInPath];
    }
}
@end
