//
//  HomeworkWebController.h
//  mxedu
//
//  Created by 田晓鹏 on 16/9/29.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIBaseViewController.h"

@interface HomeworkWebController : UIBaseViewController

@property (nonatomic) int type; // 1课程 2 题库
@property (nonatomic) NSString *objectId;

@end
