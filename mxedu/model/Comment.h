//
//  Comment.m
//
//  Created by 田晓鹏 on 14-8-1.
//  Copyright (c) 2014年 com.app. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SysCommon.h"

#import "CommentFrame.h"

typedef enum
{
    NETWORK = 0,
    LOCAL = 1
    
}SoundType;

typedef enum
{
    Ready = 0,
    NeedDown = 1,
    Downloading = 2
    
}FileState;

typedef enum
{
    Playing = 0,
    Paused = 1,
    Stop = 2
    
}PlayState;


@interface Comment : NSObject
@property(nonatomic,copy)NSString *total;
@property(nonatomic,copy)NSString *profile_image;//用户头像

@property(nonatomic,copy)NSString *sex;

@property(nonatomic,copy)NSString *userId;//用户gid

@property(nonatomic,copy)NSString *rpyGdid;

@property(nonatomic,copy)NSString *username;//用户昵称

@property(nonatomic,copy)NSString *opproveStatus;

@property(nonatomic,copy)NSString *content;//评论内容
@property(nonatomic,copy)NSString *postId;//帖子ID
@property(nonatomic,copy)NSString *title;//帖子标题

@property(nonatomic,copy)NSString *imageIds;
@property(nonatomic,copy)NSString *videoUrls;
@property(nonatomic,copy)NSString *videoImgs;
@property(nonatomic,copy)NSString *audioUrls;

@property(nonatomic,copy)NSString *local;//定位信息

@property(nonatomic,copy)NSString *passtime;//发帖时间

@property(nonatomic,copy)NSString *like_count;//点赞数
@property(nonatomic,copy)NSString *subCount;//对评论的回复数
@property(nonatomic,copy)NSString *isPraised; //是否对回复点赞

@property(nonatomic,copy)NSString *data_id;//评论 的ID

@property(nonatomic,copy)NSString *rpyToUserId; //被回复人id
@property(nonatomic,copy)NSString *rpyToUserName;// 被回复人name

@property(nonatomic,copy)NSString *isRead; //是否已读

@property (nonatomic,assign) PlayState playstate;

@property (nonatomic,assign) SoundType type;
@property (nonatomic,copy) NSString * recordPath;
@property (nonatomic,copy) NSString * urlString;
@property (nonatomic,assign) NSInteger currentPalyTime;
@property (nonatomic,assign) BOOL isReset;
@property (nonatomic,assign) PlayState currentState;
@property (nonatomic,assign) FileState fileState;

-(CGFloat)cellHeight;

@end
