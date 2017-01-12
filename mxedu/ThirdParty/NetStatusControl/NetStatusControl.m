
//
//  NetStatusControl.m
//  NTreat
//
//  Created by 周冉 on 16/4/14.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "NetStatusControl.h"

#import "SysCommon.h"
#import "SUIBoundsRoundButton.h"
#import "UIView+Frame.h"

#define kVSpace                 15

@interface NetStatusControl ()
@property (nonatomic,strong) UIView *viewBg;
@property (nonatomic,strong) UILabel *labelHint;
@property (nonatomic,strong) SUIBoundsRoundButton *retryButton;

@end

@implementation NetStatusControl

- (void)refresh:(SUIButton *)btn
{
    if(_delegate && [_delegate respondsToSelector:@selector(netStatusControlClick)])
    {
        [_delegate netStatusControlClick];
    }
}

- (instancetype)initWithHint:(NSString *)hint imageName:(NSString *)imageName
{
    if(self = [super init])
    {
        self.clipsToBounds = NO;
        _strHint = hint;
        _strImageName = imageName;
    }
    return self;
}

- (instancetype)init
{
    if(self = [super init])
    {
        if(!_strHint)
        {
            _strHint = @"网络出错,请点击重新加载";
        }
        
        if(!_strImageName)
        {
            _strImageName = @"Net_No.png";
        }
        _showRetryBtn = YES;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if(CGRectEqualToRect(self.bounds, CGRectZero))
    {
        return;
    }
    
    if(_viewBg == nil)
    {
        _viewBg = [[UIView alloc] init];
        [_viewBg setBackgroundColor:[UIColor clearColor]];
        [_viewBg setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        _viewBg.userInteractionEnabled = YES;
    }
    if([_viewBg isDescendantOfView:self] == NO)
    {
        [self addSubview:_viewBg];
    }
    
    CGFloat subHeight = 0;
    CGFloat spaceYStart = 0;
    
    // image
    if(_imageHint == nil)
    {
        _imageHint = [[UIImageView alloc] init];
        [_imageHint setBackgroundColor:[UIColor clearColor]];
    }
    if([_imageHint isDescendantOfView:_viewBg] == NO)
    {
        [_viewBg addSubview:_imageHint];
    }
    
    UIImage *image = [UIImage imageNamed:_strImageName];
    [_imageHint setImage:image];
    [_imageHint setFrame:CGRectMake(0, spaceYStart, image.size.width, image.size.height)];
    
    spaceYStart += kVSpace + image.size.height;
    if(spaceYStart > subHeight)
    {
        subHeight = spaceYStart;
    }
    
    // hint
    if(_labelHint == nil)
    {
        _labelHint = [[UILabel alloc]init];
        _labelHint.font = [UIFont systemFontOfSize:15];
        _labelHint.textColor = [UIColor colorWithRed:128/255. green:128/255. blue:128/255. alpha:1] ;
        _labelHint.textAlignment = NSTextAlignmentCenter;
        _labelHint.backgroundColor = [UIColor clearColor];
        _labelHint.numberOfLines = 0;
    }
    if([_labelHint isDescendantOfView:_viewBg] == NO)
    {
        [_viewBg addSubview:_labelHint];
    }
    
    [_labelHint setText:_strHint];
    UIFont *font = [UIFont systemFontOfSize:15];
   _labelHint.frame = CGRectMake(0, spaceYStart,SCREEN_WIDTH, 20);
    
    spaceYStart += kVSpace + _labelHint.height;
    if(spaceYStart > subHeight)
    {
        subHeight = spaceYStart;
    }
    
    // button
    if(_showRetryBtn)
    {
        if(_retryButton == nil)
        {
            _retryButton = [SUIBoundsRoundButton buttonWithType:UIButtonTypeCustom];
            [_retryButton addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
        }
        if([_retryButton isDescendantOfView:_viewBg] == NO)
        {
            [_viewBg addSubview:_retryButton];
        }
        _retryButton.cornerRadios = 3.0;
        _retryButton.strokeColor = [UIColor colorWithRed:219/255. green:219/255. blue:219/255. alpha:1];
        _retryButton.strokeLineWidth = 1.0;
        _retryButton.nomalFillColor = [UIColor colorWithRed:239/255. green:239/255. blue:244/255. alpha:1.0];
        _retryButton.selectFillColor = [UIColor colorWithRed:239/255. green:239/255. blue:244/255. alpha:1.0];
        _retryButton.nomalTextColor = [UIColor colorWithRed:51/255. green:51/255. blue:51/255. alpha:1] ;
        _retryButton.selectTextColor = [UIColor colorWithRed:51/255. green:51/255. blue:51/255. alpha:1] ;
        [[_retryButton titleLabel] setFont:[UIFont systemFontOfSize:15]];
        [_retryButton setTitle:@"重新加载" forState:UIControlStateNormal];
        [_retryButton setFrame:CGRectMake(0, spaceYStart, 105, 35)];
        
        spaceYStart += 35;
        if(spaceYStart > subHeight)
        {
            subHeight = spaceYStart;
        }
    }
    [_imageHint setCenter:CGPointMake(CGRectGetWidth(_viewBg.bounds)/2.0, _imageHint.center.y)];
    [_labelHint setCenter:CGPointMake(CGRectGetWidth(_viewBg.bounds)/2.0, _labelHint.center.y)];
    if(_retryButton)
    {
        [_retryButton setCenter:CGPointMake(CGRectGetWidth(_viewBg.bounds)/2.0, _retryButton.center.y)];
    }
    CGRect frame = [_viewBg frame];
    frame.size.height = subHeight;
    [_viewBg setFrame:frame];
    
    [_viewBg setCenter:CGPointMake(CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds)/2.0)];
}
@end
