//
//  AddSubPostViewController.h
//  NTreat
//
//  Created by 田晓鹏 on 16/2/29.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIBaseViewController.h"

@interface DeployViewController : UIBaseViewController

@property (nonatomic, copy) NSMutableArray* pendingUploadImages;
@property (nonatomic, copy) NSArray* pendingUploadImageInfos;

@property (nonatomic, copy) NSString* postGid;
@property (nonatomic, strong) void (^doneAction)();

@end
