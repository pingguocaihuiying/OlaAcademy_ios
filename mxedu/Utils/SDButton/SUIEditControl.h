//
//  SUIEditControl.h
//  AllinmdProject
//
//  Created by ZhangKaiChao on 15/3/23.
//  Copyright (c) 2015年 Mac_Libin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SUIControl.h"

@interface SUIEditControl : SUIControl

@property (nonatomic,copy) NSString *labelText;

- (void)setLabelText:(NSString *)labelText font:(UIFont *)font andTextColor:(UIColor *)color;
@end
