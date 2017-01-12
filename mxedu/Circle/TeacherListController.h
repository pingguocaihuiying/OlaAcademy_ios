//
//  TeacherListController.h
//  mxedu
//
//  Created by 田晓鹏 on 16/12/9.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIBaseViewController.h"
#import "User.h"

@interface TeacherListController : UIBaseViewController

@property (nonatomic, strong) void (^didChooseUser)(User *user);

@end
