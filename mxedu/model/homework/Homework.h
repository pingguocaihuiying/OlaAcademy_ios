//
//  Homework.h
//  mxedu
//
//  Created by 田晓鹏 on 16/8/3.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Homework : NSObject

@property (nonatomic) NSString *homeworkId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *userName;
@property (nonatomic) NSString *avatar;
@property (nonatomic) NSString *groupId;
@property (nonatomic) NSString *groupName;
@property (nonatomic) NSString *count;
@property (nonatomic) NSString *finishedCount;
@property (nonatomic) NSString *finishedPercent;
@property (nonatomic) NSString *time;

@property (nonatomic, copy) NSString *month;
@property (nonatomic, copy) NSString *day;

@end
