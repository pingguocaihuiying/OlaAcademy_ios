//
//  OrderSubController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/4/20.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "VIPSubController.h"

#import "SysCommon.h"
#import "Masonry.h"
#import "WXApiObject.h"
#import "WXApi.h"
#import "SVProgressHUD.h"
#import "AuthManager.h"
#import "PayManager.h"
#import "VIPView.h"
#import "LoginViewController.h"
#import <AlipaySDK/AlipaySDK.h>

@interface VIPSubController ()

@end

@implementation VIPSubController{
    UIScrollView *_scrollView;
    UIButton *_payButton;
    
    UIImageView *monthImageView;
    UIImageView *halfImageView;
    UIImageView *yearImageView;
    int vipType; //1 月 2 半年 4 年
    
    UIImageView *michenImageView;
    UIImageView *chenxingImageView;
    int type; //1支付宝 2 微信
    
    UIButton *obtainVIP;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"欧拉会员";
    self.view.backgroundColor = RGBCOLOR(236, 236, 236);;

    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    [self setupSubView];
    [self.view addSubview:_scrollView];
}

//支付成功后刷新
-(void)payRefresh{
    if (_callbackBlock) {
        _callbackBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *   会员
 */
- (void)setupSubView
{
    UIView *chooseVipView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 165)];
    chooseVipView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:chooseVipView];
    
    UIView *markV = [[UIView alloc]initWithFrame:CGRectMake(10, 12, 2, 16)];
    markV.backgroundColor = COMMONBLUECOLOR;
    [chooseVipView addSubview:markV];
    
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 0, SCREEN_WIDTH, 40)];
    typeLabel.text = @"会员套餐";
    typeLabel.font = LabelFont(34);
    [chooseVipView addSubview:typeLabel];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(10, 40, SCREEN_WIDTH-20, 1)];
    lineView2.backgroundColor = RGBCOLOR(236, 236, 236);
    [chooseVipView addSubview:lineView2];
    
    //////// 月会员 ////////////
    UIView *monthView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView2.frame), SCREEN_WIDTH, 40)];
    
    UILabel *wayLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 250, 40)];
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:@"月度黄金会员30元"];
    wayLabel1.textColor = RGBCOLOR(39, 42, 54);
    [str1 addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(245, 115, 0) range:NSMakeRange(6,2)];
    wayLabel1.attributedText = str1;
    wayLabel1.font = [UIFont systemFontOfSize:GENERAL_SIZE(32)];
    
    [monthView addSubview:wayLabel1];
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.textColor = RGBCOLOR(153, 153, 153);
    label1.font = LabelFont(28);
    label1.text = @"少喝一次咖啡而已";
    [monthView addSubview:label1];
    
    vipType = 1;
    monthImageView = [[UIImageView alloc]init];
    monthImageView.image = [UIImage imageNamed:@"icon_choice"];
    [monthView addSubview:monthImageView];
    
    monthView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap1 =[[UITapGestureRecognizer alloc]initWithTarget:self
                                                                         action:@selector(chooseMonthVIP)];
    [monthView addGestureRecognizer:tap1];
    [chooseVipView addSubview:monthView];
    
    [monthImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wayLabel1.mas_centerY).offset(0);
        make.right.equalTo(monthView.mas_right).offset(-20);
    }];
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wayLabel1.mas_centerY).offset(0);
        make.right.equalTo(monthImageView.mas_left).offset(-10);
    }];
    
    UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(monthView.frame), SCREEN_WIDTH-20, 1)];
    lineView3.backgroundColor = RGBCOLOR(236, 236, 236);
    [chooseVipView addSubview:lineView3];
    
    //////// 半年会员 ////////////
    UIView *halfView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView3.frame), SCREEN_WIDTH, 40)];
    
    UILabel *halfYL = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 250, 40)];
    NSMutableAttributedString *halfStr = [[NSMutableAttributedString alloc] initWithString:@"半年黄金会员158元"];
    halfYL.textColor = RGBCOLOR(39, 42, 54);
    [halfStr addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(245, 115, 0) range:NSMakeRange(6,3)];
    halfYL.attributedText = halfStr;
    halfYL.font = LabelFont(32);
    [halfView addSubview:halfYL];
    
    UILabel *worthL = [[UILabel alloc]initWithFrame:CGRectMake(GENERAL_SIZE(320), 10, 40, 20)];
    worthL.text = @"实惠";
    worthL.textColor = [UIColor redColor];
    worthL.textAlignment = NSTextAlignmentCenter;
    worthL.font = LabelFont(28);
    worthL.layer.borderColor = [UIColor redColor].CGColor;
    worthL.layer.borderWidth = 1.0;
    worthL.layer.cornerRadius = 5.0;
    [halfView addSubview:worthL];
    
    UILabel *halfTip = [[UILabel alloc]init];
    halfTip.textColor = RGBCOLOR(153, 153, 153);
    halfTip.font = LabelFont(28);
    halfTip.text = @"一次撸串儿钱";
    [halfView addSubview:halfTip];
    
    vipType = 1;
    halfImageView = [[UIImageView alloc]init];
    halfImageView.image = [UIImage imageNamed:@"icon_unchoice"];
    [halfView addSubview:halfImageView];
    
    halfView.userInteractionEnabled=YES;
    UITapGestureRecognizer *halfTap =[[UITapGestureRecognizer alloc]initWithTarget:self
                                                                            action:@selector(chooseHalfYearVIP)];
    [halfView addGestureRecognizer:halfTap];
    [chooseVipView addSubview:halfView];
    
    [halfImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(halfYL.mas_centerY).offset(0);
        make.right.equalTo(halfView.mas_right).offset(-20);
    }];
    
    [halfTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(halfYL.mas_centerY).offset(0);
        make.right.equalTo(monthImageView.mas_left).offset(-10);
    }];
    
    UIView *halfLineView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(halfView.frame), SCREEN_WIDTH-20, 1)];
    halfLineView.backgroundColor = RGBCOLOR(236, 236, 236);
    [chooseVipView addSubview:halfLineView];
    
    
    /////////// 年会员 /////////
    
    UIView *yearView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(halfLineView.frame), SCREEN_WIDTH, 40)];
    
    UILabel *wayLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, GENERAL_SIZE(300), 40)];
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:@"年度黄金会员298元"];
    wayLabel2.textColor = RGBCOLOR(39, 42, 54);
    [str2 addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(245, 115, 0) range:NSMakeRange(6,3)];
    wayLabel2.attributedText = str2;
    wayLabel2.font = LabelFont(32);
    [yearView addSubview:wayLabel2];
    
    
    UILabel *worthLabel = [[UILabel alloc]initWithFrame:CGRectMake(GENERAL_SIZE(320), 10, 40, 20)];
    worthLabel.text = @"超值";
    worthLabel.textColor = [UIColor redColor];
    worthLabel.textAlignment = NSTextAlignmentCenter;
    worthLabel.font = LabelFont(28);
    worthLabel.layer.borderColor = [UIColor redColor].CGColor;
    worthLabel.layer.borderWidth = 1.0;
    worthLabel.layer.cornerRadius = 5.0;
    [yearView addSubview:worthLabel];
    
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.textColor = RGBCOLOR(153, 153, 153);
    label2.font = LabelFont(28);
    label2.text = @"考试必欧拉";
    [yearView addSubview:label2];
    
    yearImageView = [[UIImageView alloc]init];
    yearImageView.image = [UIImage imageNamed:@"icon_unchoice"];
    [yearView addSubview:yearImageView];
    
    yearView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap2 =[[UITapGestureRecognizer alloc]initWithTarget:self
                                                                         action:@selector(chooseYearVIP)];
    [yearView addGestureRecognizer:tap2];
    [chooseVipView addSubview:yearView];
    
    
    [yearImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wayLabel2.mas_centerY).offset(0);
        make.right.equalTo(yearView.mas_right).offset(-20);
    }];
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wayLabel2.mas_centerY).offset(0);
        make.right.equalTo(yearImageView.mas_left).offset(-10);
    }];
    
    UIView *lineView4 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(yearView.frame), SCREEN_WIDTH, 10)];
    lineView4.backgroundColor = RGBCOLOR(236, 236, 236);
    [chooseVipView addSubview:lineView4];
    
    
    UIView *payView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView4.frame), SCREEN_WIDTH, 122)];
    payView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:payView];
    
    UIView *markV2 = [[UIView alloc]initWithFrame:CGRectMake(10, 12, 2, 16)];
    markV2.backgroundColor = COMMONBLUECOLOR;
    [payView addSubview:markV2];
    
    UILabel *payLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 0, SCREEN_WIDTH, 40)];
    payLabel.text = @"支付方式";
    payLabel.font = LabelFont(34);
    [payView addSubview:payLabel];
    
    UIView *lineView6 = [[UIView alloc]initWithFrame:CGRectMake(10, 40, SCREEN_WIDTH-20, 1)];
    lineView6.backgroundColor = RGBCOLOR(236, 236, 236);
    [payView addSubview:lineView6];
    
    UIView *aliView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView6.frame), SCREEN_WIDTH, 40)];
    
    UIImageView *discountView1 = [[UIImageView alloc]init];
    discountView1.image = [UIImage imageNamed:@"ic_alipay"];
    [discountView1 sizeToFit];
    [aliView addSubview:discountView1];
    
    UILabel *payLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 250, 40)];
    payLabel1.text = @"支付宝支付";
    payLabel1.textColor = RGBCOLOR(39, 42, 54);
    payLabel1.font = LabelFont(32);
    [aliView addSubview:payLabel1];
    
    type = 1;
    michenImageView = [[UIImageView alloc]init];
    michenImageView.image = [UIImage imageNamed:@"icon_choice"];
    [aliView addSubview:michenImageView];
    
    aliView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap3 =[[UITapGestureRecognizer alloc]initWithTarget:self
                                                                         action:@selector(chooseALiPay)];
    [aliView addGestureRecognizer:tap3];
    [payView addSubview:aliView];
    
    [michenImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(payLabel1.mas_centerY).offset(0);
        make.right.equalTo(aliView.mas_right).offset(-20);
    }];
    
    [discountView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(payLabel1.mas_centerY).offset(0);
        make.left.equalTo(aliView.mas_left).offset(12);
    }];
    
    UIView *lineView7 = [[UIView alloc]initWithFrame:CGRectMake(10, 81, SCREEN_WIDTH-20, 1)];
    lineView7.backgroundColor = RGBCOLOR(236, 236, 236);
    [payView addSubview:lineView7];
    
    UIView *wxView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView7.frame), SCREEN_WIDTH, 40)];
    
    UIImageView *discountView2 = [[UIImageView alloc]init];
    discountView2.image = [UIImage imageNamed:@"ic_wxpay"];
    [discountView2 sizeToFit];
    [wxView addSubview:discountView2];
    
    UILabel *payLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 250, 40)];
    payLabel2.text = @"微信支付";
    payLabel2.textColor = RGBCOLOR(39, 42, 54);
    payLabel2.font = LabelFont(32);
    [wxView addSubview:payLabel2];
    
    chenxingImageView = [[UIImageView alloc]init];
    chenxingImageView.image = [UIImage imageNamed:@"icon_unchoice"];
    [wxView addSubview:chenxingImageView];
    
    wxView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap4 =[[UITapGestureRecognizer alloc]initWithTarget:self
                                                                         action:@selector(chooseWXPay)];
    [wxView addGestureRecognizer:tap4];
    [payView addSubview:wxView];
    
    
    [chenxingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(payLabel2.mas_centerY).offset(0);
        make.right.equalTo(wxView.mas_right).offset(-20);
    }];
    
    [discountView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(payLabel2.mas_centerY).offset(0);
        make.left.equalTo(wxView.mas_left).offset(12);
    }];
    
    UIView *lineView8 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(payView.frame), SCREEN_WIDTH, 10)];
    lineView8.backgroundColor = RGBCOLOR(236, 236, 236);
    [chooseVipView addSubview:lineView8];
    
    UIView *vipLV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView8.frame), SCREEN_WIDTH, 40)];
    vipLV.backgroundColor = [UIColor whiteColor];
    
    UIView *markV3 = [[UIView alloc]initWithFrame:CGRectMake(10, 12, 2, 16)];
    markV3.backgroundColor = COMMONBLUECOLOR;
    [vipLV addSubview:markV3];
    UILabel *vipL = [[UILabel alloc]initWithFrame:CGRectMake(17, 0, 200, 40)];
    vipL.text = @"会员特权";
    vipL.font = LabelFont(34);
    [vipLV addSubview:vipL];
    
    [chooseVipView addSubview:vipLV];
    
    UIView *lineView5 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(vipLV.frame), SCREEN_WIDTH, 1)];
    lineView5.backgroundColor = [UIColor whiteColor];
    [chooseVipView addSubview:lineView5];
    
    UIView *lineViewx = [[UIView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 1)];
    lineViewx.backgroundColor = RGBCOLOR(236, 236, 236);
    [lineView5 addSubview:lineViewx];
    
    VIPView *vipView = [[VIPView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView5.frame), SCREEN_WIDTH, GENERAL_SIZE(220))];
    vipView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:vipView];
    
    _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_payButton setBackgroundColor:RGBCOLOR(224, 178, 112)];
    [_payButton setTitle:@"开通会员" forState:UIControlStateNormal];
    _payButton.titleLabel.textColor = [UIColor whiteColor];
    [_payButton addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchDown];
    _payButton.layer.masksToBounds = YES;
    _payButton.layer.cornerRadius = 5.0;
    [_scrollView addSubview:_payButton];
    
    [_payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        if(iPhone5){
            make.top.equalTo(vipView.mas_bottom).offset(15);
            make.height.equalTo(@35);
        }else{
            make.top.equalTo(vipView.mas_bottom).offset(GENERAL_SIZE(120));
            make.height.equalTo(@(GENERAL_SIZE(80)));
        }
        make.width.equalTo(@(SCREEN_WIDTH-40));
        make.centerX.equalTo(_scrollView.mas_centerX);
    }];
}

-(void)chooseMonthVIP{
    [monthImageView setImage:[UIImage imageNamed:@"icon_choice"]];
    [halfImageView setImage:[UIImage imageNamed:@"icon_unchoice"]];
    [yearImageView setImage:[UIImage imageNamed:@"icon_unchoice"]];
    vipType =1 ;
}
-(void)chooseHalfYearVIP{
    [monthImageView setImage:[UIImage imageNamed:@"icon_unchoice"]];
    [halfImageView setImage:[UIImage imageNamed:@"icon_choice"]];
    [yearImageView setImage:[UIImage imageNamed:@"icon_unchoice"]];
    vipType = 2;
}
-(void)chooseYearVIP{
    [monthImageView setImage:[UIImage imageNamed:@"icon_unchoice"]];
    [halfImageView setImage:[UIImage imageNamed:@"icon_unchoice"]];
    [yearImageView setImage:[UIImage imageNamed:@"icon_choice"]];
    vipType = 4;
}

-(void)chooseALiPay{
    [michenImageView setImage:[UIImage imageNamed:@"icon_choice"]];
    [chenxingImageView setImage:[UIImage imageNamed:@"icon_unchoice"]];
    type =1 ;
}
-(void)chooseWXPay{
    [michenImageView setImage:[UIImage imageNamed:@"icon_unchoice"]];
    [chenxingImageView setImage:[UIImage imageNamed:@"icon_choice"]];
    type = 2;
}

-(void)pay{
    if (type==1) {
        [self fetchAliPayInfo];
    }else if(type==2){
        [self fetchPayReqInfo];
    }
}

// 服务器获取支付宝支付信息
-(void)fetchAliPayInfo{
    AuthManager *am = [AuthManager sharedInstance];
    if (!am.isAuthenticated) {
        LoginViewController* loginViewCon = [[LoginViewController alloc] init];
        UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:loginViewCon];
        [self.navigationController presentViewController:rootNav animated:YES completion:nil];
        return;
    }
    PayManager *pm = [[PayManager alloc]init];
    [SVProgressHUD showWithStatus:@"请求中，请稍后..."];
    
    [pm fetchAliPayInfoWithUserId:am.userInfo.userId Type:[NSString stringWithFormat:@"%d",vipType] goodsId:@"" coin:@"0" Success:^(AliPayResult *result) {
        if (result.payInfo&&result.payInfo.orderInfo) {
            //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
            NSString *appScheme = @"mcalipay";
            [[AlipaySDK defaultService] payOrder:result.payInfo.orderInfo fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
            }];
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showInfoWithStatus:@"订单创建失败"];
        }

    } Failure:^(NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"订单创建失败"];
    }];
}

// 服务器获取微信支付信息
-(void)fetchPayReqInfo{
    AuthManager *am = [AuthManager sharedInstance];
    if (!am.isAuthenticated) {
        LoginViewController* loginViewCon = [[LoginViewController alloc] init];
        UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:loginViewCon];
        [self.navigationController presentViewController:rootNav animated:YES completion:nil];
        return;
    }
    PayManager *pm = [[PayManager alloc]init];
    [SVProgressHUD showWithStatus:@"请求中，请稍后..."];
    [pm fetchPayReqInfoWithUserId:am.userInfo.userId Type:[NSString stringWithFormat:@"%d",vipType] goodsId:@"" coin:@"0" Success:^(PayReqResult *result) {
        PayReq *payReq = result.payReq;
        if (payReq) {
            [WXApi sendReq:payReq];
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showInfoWithStatus:@"订单创建失败"];
        }
    } Failure:^(NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"订单创建失败"];
    }];
}

-(void)obtainVIP{
    if ([AuthManager sharedInstance].isAuthenticated) {
        return;
    }
    LoginViewController* loginViewCon = [[LoginViewController alloc] init];
    UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:loginViewCon];
    [self presentViewController:rootNav animated:YES completion:^{}
     ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
