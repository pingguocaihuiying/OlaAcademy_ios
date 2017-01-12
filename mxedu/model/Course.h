//
//  Course.h
//  mxedu
//
//  Created by 田晓鹏 on 15/10/20.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Course : NSObject

@property (nonatomic, copy) NSString* courseId;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* pid;
@property (nonatomic, copy) NSString* profile;
@property (nonatomic, copy) NSString* type;
@property (nonatomic, copy) NSString* address;
@property (nonatomic, copy) NSString* playcount;
@property (nonatomic) NSArray *subList;
@property (nonatomic, copy) NSString* subNum;  //已完成答题数
@property (nonatomic, copy) NSString* subAllNum; // 题目或视频总数
@property (nonatomic, copy) NSString* totalTime;
@property (nonatomic, copy) NSString* bannerPic;

@end
