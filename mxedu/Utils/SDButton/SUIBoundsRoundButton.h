//
//  SUIBoundsRoundButton.h
//  AllinmdProject
//
//  Created by ZhangKaiChao on 15/3/23.
//  Copyright (c) 2015年 Mac_Libin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUIButton.h"

@interface SUIBoundsRoundButton : SUIButton

@property (nonatomic,assign) CGFloat cornerRadios;
@property (nonatomic,strong) UIColor *strokeColor;
@property (nonatomic,assign) CGFloat strokeLineWidth;
@property (nonatomic,strong) UIColor *highlightedColor;

@property (nonatomic,strong) UIColor *selectFillColor;
@property (nonatomic,strong) UIColor *nomalFillColor;

@property (nonatomic,strong) UIColor *selectTextColor;
@property (nonatomic,strong) UIColor *nomalTextColor;

@end
