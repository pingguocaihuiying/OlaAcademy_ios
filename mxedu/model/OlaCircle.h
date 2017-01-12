//
//  VideoHistory.h
//  mxedu
//
//  Created by 田晓鹏 on 16/4/28.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OlaCircle : NSObject

@property (nonatomic) NSString *circleId;
@property (nonatomic) NSString *userName;
@property (nonatomic) NSString *userAvatar;
@property (nonatomic) NSString *videoId;
@property (nonatomic) NSString *courseId;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *content;
@property (nonatomic) NSString *location;
@property (nonatomic) NSString *imageGids;
@property (nonatomic) NSString *praiseNumber;
@property (nonatomic) NSString *readNumber;
@property (nonatomic) NSString *type; // 1 观看记录 2 发帖
@property (nonatomic) NSString *time;

@end
