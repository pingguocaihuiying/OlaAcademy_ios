//
//  NetStatusControl.m
//  NTreat
//
//  Created by 周冉 on 16/4/14.
//  Copyright © 2016年 田晓鹏. All rights reserved.

#import <UIKit/UIKit.h>

@protocol NetStatusControlDelegate;
@interface NetStatusControl : UIView

@property (nonatomic,copy) NSString *strHint;
@property (nonatomic,copy) NSString *strImageName;
@property (nonatomic,assign) BOOL showRetryBtn;
@property (nonatomic,strong) UIImageView *imageHint;
@property (nonatomic,weak) id <NetStatusControlDelegate> delegate;

- (instancetype)initWithHint:(NSString *)hint imageName:(NSString *)imageName;

@end


@protocol NetStatusControlDelegate <NSObject>

- (void)netStatusControlClick;

@end
