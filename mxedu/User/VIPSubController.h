//
//  OrderSubController.h
//  mxedu
//
//  Created by 田晓鹏 on 16/4/20.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIBaseViewController.h"

@interface VIPSubController : UIBaseViewController

@property (nonatomic) void(^callbackBlock)();

@end
