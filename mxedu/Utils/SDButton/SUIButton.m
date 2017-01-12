//
//  SUIButton.m
//  AllinmdProject
//
//  Created by ZhangKaiChao on 15/3/21.
//  Copyright (c) 2015年 Mac_Libin. All rights reserved.
//

#import "SUIButton.h"

@implementation SUIButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init {
    if (self = [super init]) {
        [self setExclusiveTouch:YES];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setExclusiveTouch:YES];
    }
    return self;
}

@end
