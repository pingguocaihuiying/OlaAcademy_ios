//
//  CourseVideo.h
//  mxedu
//
//  Created by 田晓鹏 on 15/10/21.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourseVideo : NSObject

@property (nonatomic) NSString *videoId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *content;
@property (nonatomic) NSString *address;
@property (nonatomic) NSString *playCount;
@property (nonatomic) NSString *timeSpan;
@property (nonatomic) NSString *weight;
@property (nonatomic) NSString *orgName;
@property (nonatomic) NSString *teacherName;
@property (nonatomic) NSString *pic;
@property (nonatomic) int isfree;
@property (nonatomic) int isChosen; //当前选中播放

@end
