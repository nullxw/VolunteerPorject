//
//  CommentCell.m
//  VolunteerApp
//
//  Created by zelong zou on 14-3-6.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "CommentCell.h"
#import "UIImageView+WebCache.h"
#import "UrlDefine.h"
@implementation CommentCell

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
    self.backgroundColor = [UIColor clearColor];
    
    [self.mAvator setImageWithURL:[NSURL URLWithString:[BASE_URL stringByAppendingString:info.portrain]] placeholderImage:[UIImage imageNamed:@"home_avator.png"]];
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
    
}
@end
