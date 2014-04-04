//
//  VolunteersCell.m
//  VolunteerApp
//
//  Created by zelong zou on 14-3-19.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "VolunteersCell.h"
static UIImage *bgimage = nil;
static UIImage *hasApplyimage = nil;
static UIImage *noRescruitimage = nil;
static UIImage *newApplyimage = nil;

@implementation VolunteersCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (void)initialize{
    
    bgimage = [[UIImage imageNamed:@"mypro_cellbg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] ;
    
    hasApplyimage = [UIImage imageNamed:@"_18.png"];
    noRescruitimage = [UIImage imageNamed:@"_24.png"];
    newApplyimage = [UIImage imageNamed:@"_16.png"];
}

+ (CGFloat)cellHeight
{
    return 82;
}
- (void)setupWithRescruitVolunInfo:(RescruitVolunInfo *)info
{
    
    self.mName.text = info.userName;
    [self.mName sizeToFit];
    self.mPhone.text = info.mobile;
    
    if (info._sex == 1 ) {
        self.mGenderImage.image = [UIImage imageNamed:@"ic_male.png"];
    }else if(info._sex == 2)
    {
        self.mGenderImage.image = [UIImage imageNamed:@"ic_female.png"];
    }
    self.mGenderImage.left = self.mName.right+10;
    if (info.selection == 1) {
        
        self.mStateImage.image = hasApplyimage;
        self.mRescruitBtn.hidden = YES;
        
    }else if (info.selection == 4)
    {
        self.mStateImage.image = newApplyimage;
        
        [self.mDeletaBtn setImage:nil forState:UIControlStateNormal];
        [self.mDeletaBtn setImage:nil forState:UIControlStateHighlighted];
        [self.mDeletaBtn setBackgroundColor:[UIColor redColor]];
        [self.mDeletaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.mDeletaBtn setTitle:@"拒绝" forState:UIControlStateNormal];
        
        
    }else if(info.selection == 0)
    {
        self.mStateImage.image = noRescruitimage;
    }
    
}
- (void)setupWithAddVolunteerInfo:(AddVolunteerInfo *)info
{
    self.mName.text = info.userName;
    self.mPhone.text = info.mobile;
    
    [self.mName sizeToFit];
    
    self.mGenderImage.left = self.mName.right+10;
    if (info.gender == 1 ) {
        self.mGenderImage.image = [UIImage imageNamed:@"ic_male.png"];
    }else if(info.gender == 2)
    {
        self.mGenderImage.image = [UIImage imageNamed:@"ic_female.png"];
    }
    self.mStateImage.image = noRescruitimage;
    self.mDeletaBtn.hidden = YES;
    self.mRescruitBtn.top = 20;
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.mBgImage.image = bgimage;
    
    

    
}




- (IBAction)actionRescruit:(UIButton *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(VolunteersCell:actionRescruit:)]) {
        [_delegate VolunteersCell:self actionRescruit:sender];
    }
}

- (IBAction)actionDelete:(UIButton *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(VolunteersCell:actionDel:)]) {
        [_delegate VolunteersCell:self actionDel:sender];
    }
}
@end
