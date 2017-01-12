//
//  myCustomerImageView.m
//  AllinmdProject
//
//  Created by ZhangTeng on 15/2/27.
//  Copyright (c) 2015年 Mac_Libin. All rights reserved.
//

#import "myCustomerImageView.h"
#import "SysCommon.h"

@implementation myCustomerImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeCenter;
        [self addLabes];
    }
    return self;
}

-(void)addLabes{
    self.textLabes = [[MyCustomerAttributeLabe alloc] init];
    self.textLabes.frame = CGRectMake(100, 195*kScreenScaleHeight,SCREEN_WIDTH , 20*kScreenScaleHeight);
    self.textLabes.font = [UIFont systemFontOfSize:15];
    self.textLabes.textColor = [UIColor colorWithRed:128/255. green:128/255. blue:128/255. alpha:1];
    self.textLabes.textAlignment = NSTextAlignmentCenter;
    self.textLabes.backgroundColor = [UIColor clearColor];
    [self addSubview:self.textLabes];
}

@end
