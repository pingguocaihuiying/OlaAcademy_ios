//
//  HMStatusToolbar.m
//  黑马微博
//
//  Created by apple on 14-7-14.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "CircleToolbar.h"
#import "UIView+Extension.h"
#import "UIImage+Extension.h"

@interface CircleToolbar()
@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) NSMutableArray *dividers;
@property (nonatomic, weak) UIButton *repostsBtn;
@property (nonatomic, weak) UIButton *commentsBtn;
@property (nonatomic, weak) UIButton *attitudesBtn;
@end

@implementation CircleToolbar
- (NSMutableArray *)btns
{
    if (_btns == nil) {
        self.btns = [NSMutableArray array];
    }
    return _btns;
}

- (NSMutableArray *)dividers
{
    if (_dividers == nil) {
        self.dividers = [NSMutableArray array];
    }
    return _dividers;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.image = [UIImage resizeImageWithName:@"timeline_card_bottom_background"];
        self.attitudesBtn =[self setupBtnWithIcon:@"ic_praise" title:@"赞"];
        //[self.attitudesBtn setImage:[UIImage imageNamed:@"contributeDingClick"] forState:UIControlStateDisabled];
        [self.attitudesBtn addTarget:self action:@selector(loveClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.commentsBtn = [self setupBtnWithIcon:@"ic_comment" title:@"评论"];
        //[self.commentsBtn setImage:[UIImage imageNamed:@"contributeCommentClick"] forState:UIControlStateDisabled];
        [self.commentsBtn addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
        //        self.commentsBtn.enabled = NO;
        //        [self.commentsBtn setImage:[UIImage imageNamed:@"mainCellCommentN"] forState:UIControlStateDisabled];
        //
        self.repostsBtn = [self setupBtnWithIcon:@"ic_share" title:@"分享"];
        //[self.repostsBtn setImage:[UIImage imageNamed:@"contributeCaiClick"] forState:UIControlStateDisabled];
        [self.repostsBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
        [self setupDivider];
        [self setupDivider];
        
    }
    return self;
}
/**
 *  赞按钮点击监听
 */
- (void)loveClick:(UIButton *)button
{
    if (_delegate) {
        [_delegate didClickLove:_circle];
    }
    NSString *selectText =[NSString stringWithFormat:@"%d",button.titleLabel.text.intValue + 1];
    [button setImage:[UIImage imageNamed:@"contributeDingClick"] forState:UIControlStateDisabled];
    [button setTitle:selectText forState:UIControlStateDisabled];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self setupAddone:CGRectMake(button.center.x, button.center.y*0.3,20, 8)];
    [self.repostsBtn setImage:[UIImage imageNamed:@"contributeShareN"] forState:UIControlStateDisabled];
    [self.repostsBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
}
/**
 *  分享按钮点击监听
 */
- (void)shareClick:(UIButton *)button
{
    if (_delegate) {
        [_delegate didClickShare:_circle];
    }
}
/**
 *  评论按钮点击监听
 */
- (void)commentClick:(UIButton *)button
{
    if (_delegate) {
        [_delegate didClickComment:_circle];
    }
}

//添加点击加一效果
- (void)setupAddone:(CGRect)rect
{
    UILabel *label = [[UILabel alloc] init];
    label.text = @"+1";
    label.textColor = [UIColor redColor];
    label.font = [UIFont systemFontOfSize:10];
    label.backgroundColor = [UIColor clearColor];
    label.frame = rect;
    [self addSubview:label];
    [UIView animateWithDuration:0.5 animations:^{
        label.transform = CGAffineTransformMakeScale(1.8, 1.8);
    } completion:^(BOOL finished) {
        [label removeFromSuperview];
    }];
    
}
/**
 *  分割线
 */
- (void)setupDivider
{
    UIImageView *divider = [[UIImageView alloc] init];
    divider.image = [UIImage imageWithName:@"timeline_card_bottom_line"];
    divider.contentMode = UIViewContentModeCenter;
    [self addSubview:divider];
    
    [self.dividers addObject:divider];
}

/**
 *  添加按钮
 *
 *  @param icon  图标
 *  @param title 标题
 */
- (UIButton *)setupBtnWithIcon:(NSString *)icon title:(NSString *)title
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageWithName:icon] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //[btn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    // 设置高亮时的背景
    [btn setBackgroundImage:[UIImage resizeImageWithName:@"common_card_bottom_background_highlighted"] forState:UIControlStateHighlighted];
    btn.adjustsImageWhenHighlighted = NO;
    
    // 设置间距
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    [self addSubview:btn];
    
    [self.btns addObject:btn];
    
    return btn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置按钮的frame
    NSInteger btnCount = self.btns.count;
    CGFloat btnW = self.frame.size.width / btnCount;
    CGFloat btnH = self.frame.size.height;
    for (int i = 0; i<btnCount; i++) {
        UIButton *btn = self.btns[i];
        btn.frame = CGRectMake(i * btnW,0,btnW,btnH);
    }
    
    // 设置分割线的frame
    NSInteger dividerCount = self.dividers.count;
    for (int i = 0; i<dividerCount; i++) {
        UIImageView *divider = self.dividers[i];
        divider.width = 4;
        divider.height = btnH;
        divider.centerX = (i + 1) * btnW;
        divider.centerY = btnH * 0.5;
    }
}


-(void)setCircle:(OlaCircle *)circle
{
    _circle = circle;

    [self setupBtnTitle:self.attitudesBtn count:circle.praiseNumber.intValue defaultTitle:@"赞"];
//    [self setupBtnTitle:self.repostsBtn count:1 defaultTitle:@"分享"];
//    [self setupBtnTitle:self.commentsBtn count:1 defaultTitle:@"评论"];
    
//    if (channel.isPraised==1) {
//        [self.attitudesBtn setImage:[UIImage imageNamed:@"contributeDingClick"] forState:UIControlStateNormal];
//    }else{
//        [self.attitudesBtn setImage:[UIImage imageNamed:@"contributeDingN"] forState:UIControlStateNormal];
//    }
    
}

/**
 *  设置按钮的文字
 *
 *  @param button       需要设置文字的按钮
 *  @param count        按钮显示的数字
 *  @param defaultTitle 数字为0时显示的默认文字
 */
- (void)setupBtnTitle:(UIButton *)button count:(int)count defaultTitle:(NSString *)defaultTitle
{
    if (count >= 10000) { // [10000, 无限大)
        defaultTitle = [NSString stringWithFormat:@"%.1f万", count / 10000.0];
        // 用空串替换掉所有的.0
        defaultTitle = [defaultTitle stringByReplacingOccurrencesOfString:@".0" withString:@""];
    } else if (count > 0) { // (0, 10000)
        defaultTitle = [NSString stringWithFormat:@"%d", count];
    }
    [button setTitle:defaultTitle forState:UIControlStateNormal];
}
/**
 1.小于1W ： 具体数字，比如9800，就显示9800
 2.大于等于1W：xx.x万，比如78985，就显示7.9万
 3.整W：xx万，比如800365，就显示80万
 */

@end
