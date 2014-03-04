//
//  WeiboInfo.h
//  VolunteerApp
//
//  Created by zelong zou on 14-3-2.
//  Copyright (c) 2014年 XiaoWoNiu2014. All rights reserved.
//

#import "ZZLBaseJsonObject.h"

@interface WeiboInfo : ZZLBaseJsonObject

@property (nonatomic)        int        countReply;

 @property (nonatomic)        int        weiboId;

@property (nonatomic,strong) NSString * picMiddle;

@property (nonatomic,strong) NSString * userId;

@property (nonatomic,strong) NSString * _createTime;

@property (nonatomic,strong) NSString * content;

@property (nonatomic,strong) NSString * picLittle;

@property (nonatomic,strong) NSString * portrain;

@property (nonatomic,strong) NSString * userName;

@property (nonatomic,strong) NSString * picOriginal;
@end
