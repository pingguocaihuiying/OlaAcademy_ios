//
//  QuestionResultViewController.h
//  mxedu
//
//  Created by 田晓鹏 on 16/3/15.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIBaseViewController.h"

@interface QuestionResultViewController : UIBaseViewController

@property (nonatomic) NSArray *answerArray;
@property (nonatomic) NSString *objectId;
@property (nonatomic) NSString *url; //教材购买链接
@property (nonatomic) int type; // 1课程 2 题库 3作业
@property (nonatomic, strong) void (^analysisCallback)();

@property (nonatomic) void(^callbackBlock)(); //答题完成刷新答题情况

@end
