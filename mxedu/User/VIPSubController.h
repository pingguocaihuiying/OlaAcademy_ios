//
//  OrderSubController.h
//  mxedu
//
//  Created by 田晓鹏 on 16/4/20.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VIPSubController : UIViewController

@property (nonatomic) int isSingleView; //1 独立页面 0 子页面

@property (nonatomic) void(^callbackBlock)();

-(void)updateVIPState;

@end
