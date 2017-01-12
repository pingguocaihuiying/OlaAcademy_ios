//
//  QuestionResultViewController.h
//  mxedu
//
//  Created by 田晓鹏 on 16/3/15.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionResultViewController : UIViewController

@property (nonatomic) NSArray *answerArray;
@property (nonatomic) NSString *objectId;
@property (nonatomic) NSString *url; //教材购买链接
@property (nonatomic) int type; // 1课程 2 题库
@property (nonatomic, strong) void (^analysisCallback)();

@end
