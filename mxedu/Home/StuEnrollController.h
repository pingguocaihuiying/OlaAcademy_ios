//
//  StuEnrollController.h
//  mxedu
//
//  Created by 田晓鹏 on 16/11/6.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "UIBaseViewController.h"

#import "LMComBoxView.h"

@interface StuEnrollController : UIBaseViewController<LMComBoxViewDelegate>

@property (nonatomic) int optionIndex; //指定的机构
@property (nonatomic) int nameIndex; //指定的机构下的指定培训

@end
