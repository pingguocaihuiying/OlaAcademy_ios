//
//  MistakeViewController.h
//  mxedu
//
//  Created by 田晓鹏 on 16/5/3.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MistakeViewController : UIViewController

@property (nonatomic) NSString *objectId;
@property (nonatomic) NSString *type; //1 考点 2 模考或真题

@property (nonatomic, strong) void (^updateSuccess)();

@end
