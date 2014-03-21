//
//  EditCell.h
//  VolunteerApp
//
//  Created by zelong zou on 14-3-10.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "PDBaseCell.h"

@interface EditCell : PDBaseCell

@property (nonatomic,weak) NSIndexPath *cellPath;
@property (weak, nonatomic) IBOutlet UILabel *mTextLb;
@property (weak, nonatomic) IBOutlet UITextField *mTextFiled;
@end
