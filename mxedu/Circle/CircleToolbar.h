//
//  HMStatusToolbar.h
//  黑马微博
//
//  Created by apple on 14-7-14.
//  Copyright (c) 2014年 heima. All rights reserved.
//  封装底部的工具条

#import <UIKit/UIKit.h>

#import "OlaCircle.h"

@class OlaCircle,CircleToolbar;

@protocol CircleToolbarDelegate <NSObject>

- (void)didClickLove:(OlaCircle*)circle;
- (void)didClickShare:(OlaCircle*)circle;
- (void)didClickComment:(OlaCircle*)circle;

@end
@interface CircleToolbar : UIImageView
@property (nonatomic, assign) OlaCircle *circle;
@property (nonatomic,strong)id <CircleToolbarDelegate> delegate;

@end
