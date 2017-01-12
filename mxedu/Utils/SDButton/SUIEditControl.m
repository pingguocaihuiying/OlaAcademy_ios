//
//  SUIEditControl.m
//  AllinmdProject
//
//  Created by ZhangKaiChao on 15/3/23.
//  Copyright (c) 2015年 Mac_Libin. All rights reserved.
//

#import "SUIEditControl.h"

@interface SUIEditControl ()
@property (nonatomic,strong) UILabel *labelEdit;
@end

@implementation SUIEditControl

- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:0.0];
    //[kCellLineColor setStroke];
    [path stroke];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if(_labelEdit == nil)
    {
        _labelEdit = [[UILabel alloc] init];
        _labelEdit.backgroundColor = [UIColor clearColor];
//        [_labelEdit setFont:Font_Hei(14)];
//        [_labelEdit setTextColor:kColumTextColor];
        _labelEdit.numberOfLines = 0;
        _labelEdit.textAlignment = NSTextAlignmentLeft;
//        [_labelEdit setFrame:self.bounds];
        [_labelEdit setFrame:CGRectMake(10, 0, CGRectGetWidth(self.bounds)-20, CGRectGetHeight(self.bounds))];
    }
    if([_labelEdit isDescendantOfView:self] == NO)
    {
        [self addSubview:_labelEdit];
    }
    
    if(_labelText)
    {
        [_labelEdit setText:_labelText];
    }
}

- (void)setLabelText:(NSString *)labelText font:(UIFont *)font andTextColor:(UIColor *)color
{
    _labelText = labelText;
    
    if(_labelEdit)
    {
        [_labelEdit setFont:font];
        [_labelEdit setText:_labelText];
        [_labelEdit setTextColor:color];
    }
}

@end
