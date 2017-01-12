//
//  Comment.m
//
//  Created by 田晓鹏 on 14-8-1.
//  Copyright (c) 2014年 com.app. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SysCommon.h"

@interface Comment : NSObject
@property(nonatomic,copy)NSString *total;
@property(nonatomic,copy)NSString *profile_image;//用户头像

@property(nonatomic,copy)NSString *sex;

@property(nonatomic,copy)NSString *userId;//用户gid

@property(nonatomic,copy)NSString *rpyGdid;

@property(nonatomic,copy)NSString *username;//用户昵称

@property(nonatomic,copy)NSString *opproveStatus;

@property(nonatomic,copy)NSString *content;//评论内容

@property(nonatomic,copy)NSString *local;//定位信息

@property(nonatomic,copy)NSString *passtime;//发帖时间

@property(nonatomic,copy)NSString *like_count;//点赞数

@property(nonatomic,copy)NSString *data_id;//评论 的ID

@property(nonatomic,copy)NSString *rpyToUserId; //被回复人id
@property(nonatomic,copy)NSString *rpyToUserName;// 被回复人name
@property(nonatomic,copy)NSString *isPraised; //是否对回复点赞
-(CGFloat)cellHeight;

@end
