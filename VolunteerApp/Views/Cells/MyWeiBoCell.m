//
//  MyWeiBoCell.m
//  VolunteerApp
//
//  Created by zelong zou on 14-3-2.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "MyWeiBoCell.h"
#import "UIImageView+WebCache.h"
#import "UIColor+Addition.h"
@implementation MyWeiBoCell
{
        UILabel *mNameLb;
        UILabel *mTimeLb;
        UIImageView *mbgView;
            
        UIImageView *mAvatorView;
        UIImageView *mSepLineView;
        UILabel *mContentLb;
        UIView *mBottomView;
        UIButton *mCollectBtn;
        UIButton *mCommentBtn;
    
    
}
+(void)initialize
{
    bgimage = [[UIImage imageNamed:@"mypro_cellbg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] ;
    sepcolor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"prodetail_line.png"]]; ;
    font = [UIFont fontWithName:@"Avenir-Medium" size:14.0f];
}

static UIImage *bgimage = nil;
static UIColor *sepcolor= nil;
static UIFont  *font = nil;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        mbgView = [[UIImageView alloc]initWithFrame:CGRectInset(self.bounds, 5, 5)];
        mbgView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
        mbgView.backgroundColor = [UIColor clearColor];
        mbgView.image = bgimage;
        [self.contentView addSubview:mbgView];
        
        mAvatorView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 54, 54)];
        [self.contentView addSubview:mAvatorView];
        
        
        
        mNameLb = [[UILabel alloc]initWithFrame:CGRectMake(85, 16, 215, 21)];
        mNameLb.backgroundColor = [UIColor clearColor];
        mNameLb.textColor = [UIColor colorWithHexString:@"#95c32c"];
        mNameLb.lineBreakMode = UILineBreakModeCharacterWrap;
        mNameLb.font = font;
        [self.contentView addSubview:mNameLb];
        
        mTimeLb = [[UILabel alloc]initWithFrame:CGRectMake(85, 38, 215, 21)];
        mTimeLb.backgroundColor = [UIColor clearColor];
        mTimeLb.lineBreakMode = UILineBreakModeCharacterWrap;
        mTimeLb.font = font;
        [self.contentView addSubview:mTimeLb];
        
        mSepLineView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 67, 300, 2)];
        mSepLineView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
        mSepLineView.backgroundColor = sepcolor;
        [self.contentView addSubview:mSepLineView];
        
        mContentLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 77, 300, 15)];
        mContentLb.backgroundColor = [UIColor clearColor];
        mContentLb.textColor = [UIColor colorWithHexString:@"#8e8e8e"];
        mContentLb.lineBreakMode = UILineBreakModeCharacterWrap;
        mContentLb.font = font;
        mContentLb.numberOfLines = 0;
        [self.contentView addSubview:mContentLb];
        
        
        mBottomView = [[UIView alloc]initWithFrame:CGRectMake(10, 90, 300, 34)];
        mBottomView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
        [self.contentView addSubview:mBottomView];
        
        mCollectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        mCollectBtn.frame = CGRectMake(52, 6, 86, 26);
        [mCollectBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [mCollectBtn addTarget:self action:@selector(actionCollectBtn:) forControlEvents:UIControlEventTouchUpInside];
        [mBottomView addSubview:mCollectBtn];
        
        mCommentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        mCommentBtn.frame = CGRectMake(189, 5, 81, 26);
        [mCommentBtn setTitle:@"评论" forState:UIControlStateNormal];
        [mCommentBtn addTarget:self action:@selector(actionCommentBtn:) forControlEvents:UIControlEventTouchUpInside];
        [mBottomView addSubview:mCommentBtn];
        
        UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 5, 24, 24)];

        image1.backgroundColor = [UIColor clearColor];
        image1.image = [UIImage imageNamed:@"ico_collect.png"];
        [mBottomView addSubview:image1];
        
        UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(159, 5, 24, 24)];
        
        image2.backgroundColor = [UIColor clearColor];
        image2.image = [UIImage imageNamed:@"plan_comment.png"];
        [mBottomView addSubview:image2];
        
    }
    return self;
}

- (void)setupWithWeiboInfo:(WeiboInfo *)info
{
    
    CGSize size = [info.content sizeWithFont:[UIFont fontWithName:@"Avenir-Medium" size:14.0f] constrainedToSize:CGSizeMake(300, 2000) lineBreakMode:NSLineBreakByCharWrapping];
    
    mContentLb.height = size.height+10;
    mTimeLb.text = info._createTime;
    mContentLb.text = info.content;
    
    
    
    [mAvatorView setImageWithURL:[NSURL URLWithString:info.portrain] placeholderImage:[UIImage imageNamed:@"home_avator.png"]];
    
    if (info.userName.length==0) {
        mNameLb.text = @"匿名用户";
    }else{
        mNameLb.text = info.userName;
    }
    
    
    
    [mCommentBtn setTitle:[NSString stringWithFormat:@"评论(%d)",info.countReply] forState:UIControlStateNormal];
    
    
    
    
}

- (void)actionCollectBtn:(UIButton *)btn
{
    if (_delegate &&[_delegate respondsToSelector:@selector(WeiboCell:actionCollectAtIndexPath:)]) {
        [_delegate WeiboCell:self actionCollectAtIndexPath:self.cellInPath];
    }
}
- (void)actionCommentBtn:(UIButton *)btn
{
    if (_delegate &&[_delegate respondsToSelector:@selector(WeiboCell:actionCommentAtIndexPath:)]) {
        [_delegate WeiboCell:self actionCommentAtIndexPath:self.cellInPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
