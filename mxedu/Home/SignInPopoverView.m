//
//  SignInPopoverView.m
//  签到
//
//  Created by 田晓鹏 on 6/2/13.
//  Copyright (c) 2013 田晓鹏. All rights reserved.
//

#import "SignInPopoverView.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

#import "SysCommon.h"
#import "Masonry.h"

static const char * const kZSYPopoverListButtonClickForCancel = "kZSYPopoverListButtonClickForCancel";

@interface SignInPopoverView ()

@property (nonatomic, retain) UIImageView *backIV;
@property (nonatomic, retain) UIButton *cancelButton;
@property (nonatomic, retain) UILabel *coinCount;
@property (nonatomic, retain) UILabel *signCount;

//初始化界面 
- (void)initTheInterface;

//动画进入
- (void)animatedIn;

//动画消失
- (void)animatedOut;

//展示界面
- (void)show;

//消失界面
- (void)dismiss;
@end

@implementation SignInPopoverView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initTheInterface];
    }
    return self;
}

- (void)initTheInterface
{
    self.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.6];
    
    _backIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_signIn"]];
    _backIV.userInteractionEnabled = YES;
    [self addSubview:_backIV];
    
    [_backIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-GENERAL_SIZE(80));
    }];
    
    UIImageView *avatarIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_scholar"]];
    [self addSubview:avatarIV];
    
    [avatarIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_backIV);
        make.centerY.equalTo(_backIV).offset(-GENERAL_SIZE(10));
    }];
    
    UIImageView *tipIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_signIn_tip"]];
    [self addSubview:tipIV];
    
    [tipIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(avatarIV);
        make.bottom.equalTo(avatarIV).offset(-GENERAL_SIZE(20));
    }];
    
    UILabel *signL = [[UILabel alloc] init];
    signL.text = @"签到获得欧拉币";
    signL.textColor = [UIColor whiteColor];
    signL.font = LabelFont(20);
    [tipIV addSubview:signL];
    
    [signL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(tipIV);
    }];
    
    UILabel *signCountL = [[UILabel alloc]init];
    signCountL.text = @"累计打卡";
    signCountL.textColor = [UIColor whiteColor];
    signCountL.font = LabelFont(20);
    [_backIV addSubview:signCountL];
    
    [signCountL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_backIV.mas_bottom).offset(-GENERAL_SIZE(20));
        make.left.equalTo(_backIV).offset(GENERAL_SIZE(35));
    }];
    
    _signCount = [[UILabel alloc]init];
    _signCount.textColor = RGBCOLOR(249, 255, 0);
    _signCount.font = LabelFont(18);
    [_backIV addSubview:_signCount];
    
    [_signCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(signCountL.mas_top).offset(-GENERAL_SIZE(15));
        make.centerX.equalTo(signCountL);
    }];
    
    UILabel *coinCountL = [[UILabel alloc]init];
    coinCountL.text = @"欧拉币值";
    coinCountL.textColor = [UIColor whiteColor];
    coinCountL.font = LabelFont(20);
    [_backIV addSubview:coinCountL];
    
    [coinCountL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_backIV.mas_bottom).offset(-GENERAL_SIZE(20));
        make.right.equalTo(_backIV.mas_right).offset(-GENERAL_SIZE(35));
    }];
    
    _coinCount = [[UILabel alloc]init];
    _coinCount.textColor = RGBCOLOR(249, 255, 0);;
    _coinCount.font = LabelFont(18);
    [_backIV addSubview:_coinCount];
    
    [_coinCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(coinCountL.mas_top).offset(-GENERAL_SIZE(15));
        make.centerX.equalTo(coinCountL);
    }];
    
    UIImageView *bottomIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_signIn_bottom"]];
    [self addSubview:bottomIV];
    
    [bottomIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_backIV.mas_bottom);
    }];
    
    UILabel *tipL = [[UILabel alloc] init];
    tipL.text = @"快分享给小伙伴吧";
    tipL.textColor = RGBCOLOR(81, 83, 93);
    tipL.font = LabelFont(20);
    [bottomIV addSubview:tipL];
    
    [tipL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bottomIV);
        make.top.equalTo(bottomIV).offset(GENERAL_SIZE(24));
    }];
    
    UIView *diveder1 = [[UIView alloc]init];
    diveder1.backgroundColor = RGBCOLOR(235, 235, 235);
    [bottomIV addSubview:diveder1];
    
    [diveder1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tipL);
        make.left.equalTo(bottomIV).offset(GENERAL_SIZE(30));
        make.right.equalTo(tipL.mas_left).offset(-GENERAL_SIZE(15));
        make.height.equalTo(@1);
    }];
    
    UIView *diveder2 = [[UIView alloc]init];
    diveder2.backgroundColor = RGBCOLOR(235, 235, 235);
    [bottomIV addSubview:diveder2];
    
    [diveder2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tipL);
        make.left.equalTo(tipL.mas_right).offset(GENERAL_SIZE(15));
        make.right.equalTo(bottomIV.mas_right).offset(-GENERAL_SIZE(30));
         make.height.equalTo(@1);
    }];
    
    UIButton *qqIV = [UIButton buttonWithType:UIButtonTypeCustom];
    [qqIV setImage:[UIImage imageNamed:@"ic_qq"] forState:UIControlStateNormal];
    qqIV.tag = 1003;
    [qqIV addTarget:self action:@selector(didClickShareButton:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:qqIV];
    
    [qqIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bottomIV);
    }];
    
    UILabel *qqL = [[UILabel alloc]init];
    qqL.text = @"QQ好友";
    qqL.font = LabelFont(16);
    qqL.textColor = RGBCOLOR(81, 83, 93);
    [self addSubview:qqL];
    
    [qqL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qqIV.mas_bottom).offset(GENERAL_SIZE(10));
        make.centerX.equalTo(qqIV);
    }];
    
    UIButton *wechatIV = [UIButton buttonWithType:UIButtonTypeCustom];
    wechatIV.tag = 1001;
    [wechatIV addTarget:self action:@selector(didClickShareButton:) forControlEvents:UIControlEventTouchDown];
    [wechatIV setImage:[UIImage imageNamed:@"ic_wechat"] forState:UIControlStateNormal];
    [self addSubview:wechatIV];
    
    [wechatIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomIV).offset(GENERAL_SIZE(32));
        make.centerY.equalTo(bottomIV);
    }];
    
    UILabel *wechatL = [[UILabel alloc]init];
    wechatL.text = @"微信";
    wechatL.font = LabelFont(16);
    wechatL.textColor = RGBCOLOR(81, 83, 93);
    [self addSubview:wechatL];
    
    [wechatL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wechatIV.mas_bottom).offset(GENERAL_SIZE(10));
        make.centerX.equalTo(wechatIV);
    }];
    
    UIButton *timelineIV = [UIButton buttonWithType:UIButtonTypeCustom];
    [timelineIV setImage:[UIImage imageNamed:@"ic_timeline"] forState:UIControlStateNormal];
    timelineIV.tag = 1002;
    [timelineIV addTarget:self action:@selector(didClickShareButton:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:timelineIV];
    
    [timelineIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wechatIV.mas_right).offset(GENERAL_SIZE(32));
        make.centerY.equalTo(bottomIV);
    }];
    
    UILabel *timelineL = [[UILabel alloc]init];
    timelineL.text = @"朋友圈";
    timelineL.font = LabelFont(16);
    timelineL.textColor = RGBCOLOR(81, 83, 93);
    [self addSubview:timelineL];
    
    [timelineL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timelineIV.mas_bottom).offset(GENERAL_SIZE(10));
        make.centerX.equalTo(timelineIV);
    }];
    
    UIButton *sinaIV = [UIButton buttonWithType:UIButtonTypeCustom];
    [sinaIV setImage:[UIImage imageNamed:@"ic_sina"] forState:UIControlStateNormal];
    sinaIV.tag = 1005;
    [sinaIV addTarget:self action:@selector(didClickShareButton:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:sinaIV];
    
    [sinaIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomIV.mas_right).offset(-GENERAL_SIZE(32));
        make.centerY.equalTo(bottomIV);
    }];
    
    UILabel *sinaL = [[UILabel alloc]init];
    sinaL.text = @"微博";
    sinaL.font = LabelFont(16);
    sinaL.textColor = RGBCOLOR(81, 83, 93);
    [self addSubview:sinaL];
    
    [sinaL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sinaIV.mas_bottom).offset(GENERAL_SIZE(10));
        make.centerX.equalTo(sinaIV);
    }];
    
    UIButton *qzoneIV = [UIButton buttonWithType:UIButtonTypeCustom];
    [qzoneIV setImage:[UIImage imageNamed:@"ic_qzone"] forState:UIControlStateNormal];
    qzoneIV.tag = 1004;
    [qzoneIV addTarget:self action:@selector(didClickShareButton:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:qzoneIV];
    
    [qzoneIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(sinaIV.mas_left).offset(-GENERAL_SIZE(32));
        make.centerY.equalTo(bottomIV);
    }];

    UILabel *qzoneL = [[UILabel alloc]init];
    qzoneL.text = @"QQ空间";
    qzoneL.font = LabelFont(16);
    qzoneL.textColor = RGBCOLOR(81, 83, 93);
    [self addSubview:qzoneL];
    
    [qzoneL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qzoneIV.mas_bottom).offset(GENERAL_SIZE(10));
        make.centerX.equalTo(qzoneIV);
    }];

}

-(void)setupViewWithDay:(NSString*)signDay Coin:(NSString*)coin{
    NSMutableAttributedString *signStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@天",signDay]];
    [signStr addAttribute:NSFontAttributeName value:LabelFont(24) range:NSMakeRange(0, signDay.length)];
    _signCount.attributedText = signStr;
    NSMutableAttributedString *coinStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@欧",coin]];
    [coinStr addAttribute:NSFontAttributeName value:LabelFont(24) range:NSMakeRange(0, coin.length)];
    _coinCount.attributedText = coinStr;
}


#pragma mark - Button Method
- (void)setCancelButtonBlock:(PopoverViewButtonBlock)block
{
    if (nil == _cancelButton)
    {
        
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelButton.frame = CGRectMake(0, 0, 30, 30);
        [self.cancelButton setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(buttonWasPressed:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.cancelButton];
        
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backIV).offset(GENERAL_SIZE(20));
            make.top.equalTo(_backIV).offset(GENERAL_SIZE(20));
        }];
        
    }
    
    objc_setAssociatedObject(self.cancelButton, kZSYPopoverListButtonClickForCancel, [block copy], OBJC_ASSOCIATION_RETAIN);
}

#pragma mark - Animated Mthod
- (void)animatedIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)animatedOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - show or hide self
- (void)show
{
    
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self];
    
    self.center = CGPointMake(keywindow.bounds.size.width/2.0f,
                              keywindow.bounds.size.height/2.0f);
    [self animatedIn];
}

- (void)dismiss
{
    [self animatedOut];
}

#pragma mark - UIButton Clicke Method
- (void)buttonWasPressed:(id)sender
{
    PopoverViewButtonBlock __block block;
    
    block = objc_getAssociatedObject(sender, kZSYPopoverListButtonClickForCancel);
    if (block)
    {
        block();
    }
    [self animatedOut];
}

- (void)touchForDismissSelf:(id)sender
{
    [self animatedOut];
}

-(void)didClickShareButton:(UIButton*)btn{
    [self animatedOut];
    if (_delegate) {
        [_delegate didClickOnImageIndex:btn.tag];
    }
}
@end
