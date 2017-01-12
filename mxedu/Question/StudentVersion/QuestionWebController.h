//
//  QuestionWebController.h
//  mxedu
//
//  Created by 田晓鹏 on 16/3/7.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Course.h"

@interface QuestionWebController : UIViewController

@property (nonatomic) NSString *titleName;
@property (nonatomic) NSString *objectId;
@property (nonatomic) Course *course;
@property (nonatomic) int type; // 1课程 2 题库 3 作业
@property (nonatomic) int showAnswer; // 1 全部解析时显示答案
@property (nonatomic) int hasArticle; // 1 英语类阅读理解

@property (nonatomic) void(^callbackBlock)(); //答题完成刷新答题情况

@end
