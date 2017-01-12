//
//  UIBackButton.m
//  AllinmdProject
//
//  Created by ZhangTeng on 15/8/18.
//  Copyright (c) 2015年 Mac_Libin. All rights reserved.
//

#import "UIBackButton.h"

@implementation UIBackButton


+ (id)buttonWithType:(UIButtonType)buttonType{
    
    UIBackButton * backButton = [super buttonWithType:UIButtonTypeCustom];
    UIImage *img =  [UIImage imageNamed:@"Tab_BackImage.png"];
//    [backButton setBackgroundColor:[UIColor colorWithRed:248.0/255.0f green:248.0/255.0f blue:248.0/255.0f alpha:1.0f]];
//    //返回图标
//    [backButton setImage:img forState:UIControlStateNormal];
//    [backButton setImage:img forState:UIControlStateHighlighted];
//    //按钮名称
//    [backButton setTitle:@"返回" forState:UIControlStateNormal];
//    [backButton setTitle:@"返回" forState:UIControlStateHighlighted];
//    //字号颜色
//    [backButton setTitleColor:kNavBgColor forState:UIControlStateNormal];
//    [backButton setTitleColor:kNavBgColor forState:UIControlStateHighlighted];
//    //字体以及大小
//    backButton.titleLabel.font = [UIFont fontWithName:kText_Font_FZLTXH size:(16)];
//    backButton.titleLabel.backgroundColor = [UIColor clearColor];
//
//    CGFloat titleLabeWidth = [backButton.titleLabel.text sizeWithFontCompatible:[UIFont fontWithName:kText_Font_FZLTXH size:(16)]].width;
//    
//   // backButton.frame = CGRectMake(0, PHONE_HEIGH-kTabBarHeight, PHONE_WIDTH, kTabBarHeight);
////    backButton.frame = CGRectZero;
//
//    CGFloat len = (PHONE_WIDTH-(img.size.width+3+titleLabeWidth))/2;
//    
//    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, len, 0, len+3)];
//    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, len+3, 0, len)];
//
//    //线
//    UIView *labe = [[UIView alloc]init];
//    labe.backgroundColor = [UIColor colorWithRed:172./255.0f green:172./255.0f blue:172./255.0f alpha:1.0f];
//    labe.frame = CGRectMake(0, 0,PHONE_WIDTH, 0.5);
//    [backButton addSubview:labe];
    
    return backButton;
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    [self updateConstraintsIfNeeded];
    [self needsUpdateConstraints];
}

- (void)updateConstraints{
    [super updateConstraints];
//    [self mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.superview).with.offset(0);
//        make.right.equalTo(self.superview).with.offset(0);
//        make.bottom.equalTo(self.superview).with.offset(0);
//        make.height.mas_equalTo(kVCBottomBackBarHeight);
//    
//    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
