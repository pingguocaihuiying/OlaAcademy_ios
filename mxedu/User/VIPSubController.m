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
    UIImageView *yearImageView;
    int vipType; //1 月 2 年
    
    UIImageView *michenImageView;
    UIImageView *chenxingImageView;
    int type; //1支付宝 2 微信
    
    UIButton *obtainVIP;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    int scrollViewHeight = SCREEN_HEIGHT-220;
    int scrollContentHeight = 610;
    if (iPhone6) {
        scrollContentHeight = 625;
    }
    if (iPhone6Plus) {
        scrollContentHeight = 640;
    }
    if(_isSingleView==1){
        [self setupBackButton];
        self.view.backgroundColor = [UIColor whiteColor];
        scrollViewHeight = SCREEN_HEIGHT;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payRefresh) name:@"ORDER_PAY_NOTIFICATION" object:nil];
    }
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, scrollViewHeight)];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, scrollContentHeight);
    [self setupSubView];
    [self.view addSubview:_scrollView];
}

- (void)setupBackButton
{
    self.title = @"欧拉会员";
    self.navigationController.navigationBarHidden = NO;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"ic_back_white"] forState:UIControlStateNormal];
    [backBtn sizeToFit];
    [backBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

-(void)backButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
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
    UIView *chooseVipView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 122)];
    chooseVipView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:chooseVipView];
    
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 40)];
    typeLabel.text = @"会员套餐";
    typeLabel.font = LabelFont(32);
    [chooseVipView addSubview:typeLabel];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 1)];
    lineView2.backgroundColor = RGBCOLOR(236, 236, 236);
    [chooseVipView addSubview:lineView2];
    
    UILabel *wayLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 41, 250, 40)];
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:@"月度黄金会员30元"];
    [str1 addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(245, 115, 0) range:NSMakeRange(6,2)];
    wayLabel1.attributedText = str1;
    wayLabel1.font = LabelFont(30);
    [chooseVipView addSubview:wayLabel1];
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.textColor = RGBCOLOR(153, 153, 153);
    label1.font = LabelFont(28);
    label1.text = @"少喝一次咖啡而已";
    [chooseVipView addSubview:label1];
    
    vipType = 1;
    monthImageView = [[UIImageView alloc]init];
    monthImageView.image = [UIImage imageNamed:@"ic_chosen"];
    [monthImageView sizeToFit];
    monthImageView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap1 =[[UITapGestureRecognizer alloc]initWithTarget:self
                                                                         action:@selector(chooseMonthVIP)];
    [monthImageView addGestureRecognizer:tap1];
    [chooseVipView addSubview:monthImageView];
    
    [monthImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wayLabel1.mas_centerY).offset(0);
        make.right.equalTo(chooseVipView.mas_right).offset(-20);
    }];
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wayLabel1.mas_centerY).offset(0);
        make.right.equalTo(monthImageView.mas_left).offset(-10);
    }];
    
    UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake(0, 81, SCREEN_WIDTH, 1)];
    lineView3.backgroundColor = RGBCOLOR(236, 236, 236);
    [chooseVipView addSubview:lineView3];
    
    UILabel *wayLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 82, GENERAL_SIZE(280), 40)];
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:@"半年黄金会员158元"];
    [str2 addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(245, 115, 0) range:NSMakeRange(6,3)];
    wayLabel2.attributedText = str2;
    wayLabel2.font = LabelFont(30);
    [chooseVipView addSubview:wayLabel2];
    
    
    UILabel *worthLabel = [[UILabel alloc]initWithFrame:CGRectMake(GENERAL_SIZE(300), 92, 40, 20)];
    worthLabel.text = @"超值";
    worthLabel.textColor = [UIColor redColor];
    worthLabel.textAlignment = NSTextAlignmentCenter;
    worthLabel.font = LabelFont(28);
    worthLabel.layer.borderColor = [UIColor redColor].CGColor;
    worthLabel.layer.borderWidth = 1.0;
    worthLabel.layer.cornerRadius = 5.0;
    [chooseVipView addSubview:worthLabel];
    
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.textColor = RGBCOLOR(153, 153, 153);
    label2.font = LabelFont(28);
    label2.text = @"一次撸串儿钱";
    [chooseVipView addSubview:label2];
    
    yearImageView = [[UIImageView alloc]init];
    yearImageView.image = [UIImage imageNamed:@"ic_unchosen"];
    [yearImageView sizeToFit];
    yearImageView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap2 =[[UITapGestureRecognizer alloc]initWithTarget:self
                                                                         action:@selector(chooseYearVIP)];
    [yearImageView addGestureRecognizer:tap2];
    [_scrollView addSubview:yearImageView];
    
    
    [yearImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wayLabel2.mas_centerY).offset(0);
        make.right.equalTo(chooseVipView.mas_right).offset(-20);
    }];
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wayLabel2.mas_centerY).offset(0);
        make.right.equalTo(yearImageView.mas_left).offset(-10);
    }];
    
    UIView *lineView4 = [[UIView alloc]initWithFrame:CGRectMake(0, 122, SCREEN_WIDTH, 10)];
    lineView4.backgroundColor = RGBCOLOR(236, 236, 236);
    [chooseVipView addSubview:lineView4];
    
    
    UIView *payView = [[UIView alloc]initWithFrame:CGRectMake(0, 130, SCREEN_WIDTH, 122)];
    payView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:payView];
    
    UILabel *payLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 40)];
    payLabel.text = @"支付方式";
    payLabel.font = LabelFont(32);
    [payView addSubview:payLabel];
    
    UIView *lineView6 = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 1)];
    lineView6.backgroundColor = RGBCOLOR(236, 236, 236);
    [payView addSubview:lineView6];
    
    UIImageView *discountView1 = [[UIImageView alloc]init];
    discountView1.image = [UIImage imageNamed:@"ic_alipay"];
    [discountView1 sizeToFit];
    [payView addSubview:discountView1];
    
    UILabel *payLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(40, 41, 250, 40)];
    payLabel1.text = @"支付宝支付";
    payLabel1.font = LabelFont(30);
    [payView addSubview:payLabel1];
    
    type = 1;
    michenImageView = [[UIImageView alloc]init];
    michenImageView.image = [UIImage imageNamed:@"ic_chosen"];
    [michenImageView sizeToFit];
    michenImageView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap3 =[[UITapGestureRecognizer alloc]initWithTarget:self
                                                                         action:@selector(chooseALiPay)];
    [michenImageView addGestureRecognizer:tap3];
    [payView addSubview:michenImageView];
    
    [michenImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(payLabel1.mas_centerY).offset(0);
        make.right.equalTo(payView.mas_right).offset(-20);
    }];
    
    [discountView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(payLabel1.mas_centerY).offset(0);
        make.left.equalTo(payView.mas_left).offset(12);
    }];
    
    UIView *lineView7 = [[UIView alloc]initWithFrame:CGRectMake(0, 81, SCREEN_WIDTH, 1)];
    lineView7.backgroundColor = RGBCOLOR(236, 236, 236);
    [payView addSubview:lineView7];
    
    UIImageView *discountView2 = [[UIImageView alloc]init];
    discountView2.image = [UIImage imageNamed:@"ic_wxpay"];
    [discountView2 sizeToFit];
    [payView addSubview:discountView2];
    
    UILabel *payLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(40, 82, 250, 40)];
    payLabel2.text = @"微信支付";
    payLabel2.font = LabelFont(30);
    [payView addSubview:payLabel2];
    
    chenxingImageView = [[UIImageView alloc]init];
    chenxingImageView.image = [UIImage imageNamed:@"ic_unchosen"];
    [chenxingImageView sizeToFit];
    chenxingImageView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap4 =[[UITapGestureRecognizer alloc]initWithTarget:self
                                                                         action:@selector(chooseWXPay)];
    [chenxingImageView addGestureRecognizer:tap4];
    [_scrollView addSubview:chenxingImageView];
    
    
    [chenxingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(payLabel2.mas_centerY).offset(0);
        make.right.equalTo(payView.mas_right).offset(-20);
    }];
    
    [discountView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(payLabel2.mas_centerY).offset(0);
        make.left.equalTo(payView.mas_left).offset(12);
    }];
    
    UIView *lineView8 = [[UIView alloc]initWithFrame:CGRectMake(0, 255, SCREEN_WIDTH, 10)];
    lineView8.backgroundColor = RGBCOLOR(236, 236, 236);
    [chooseVipView addSubview:lineView8];
    
    UILabel *typeLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 265, SCREEN_WIDTH, 40)];
    typeLabel2.text = @"会员特权";
    typeLabel2.font = LabelFont(32);
    [chooseVipView addSubview:typeLabel2];
    
    UIView *lineView5 = [[UIView alloc]initWithFrame:CGRectMake(0, 305, SCREEN_WIDTH, 1)];
    lineView5.backgroundColor = RGBCOLOR(236, 236, 236);
    [chooseVipView addSubview:lineView5];
    
    VIPView *vipView = [[VIPView alloc]initWithFrame:CGRectMake(0, 310, SCREEN_WIDTH, 120)];
    [_scrollView addSubview:vipView];
    
    
    if (_isSingleView==0) {
        UIView *lineView9 = [[UIView alloc]initWithFrame:CGRectMake(0, 430, SCREEN_WIDTH, 10)];
        lineView9.backgroundColor = RGBCOLOR(236, 236, 236);
        [_scrollView addSubview:lineView9];
        
        UILabel *typeLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 440, SCREEN_WIDTH, 40)];
        typeLabel3.text = @"VIP会员免费领取";
        typeLabel3.font = LabelFont(32);
        [_scrollView addSubview:typeLabel3];
        
        UIView *lineView10 = [[UIView alloc]initWithFrame:CGRectMake(0, 480, SCREEN_WIDTH, 1)];
        lineView10.backgroundColor = RGBCOLOR(236, 236, 236);
        [_scrollView addSubview:lineView10];
        
        UILabel *freeVIP = [[UILabel alloc]initWithFrame:CGRectMake(10, 481, 200, 40)];
        freeVIP.text = @"登录领取5天VIP";
        freeVIP.font = LabelFont(32);
        [_scrollView addSubview:freeVIP];
        
        obtainVIP = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        [obtainVIP.layer setCornerRadius:5];
        [obtainVIP setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        obtainVIP.frame = CGRectMake(SCREEN_WIDTH-70, 495, 60, 20);
        [_scrollView addSubview:obtainVIP];
        [self updateVIPState];
    }
    
    _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_payButton setBackgroundImage:[UIImage imageNamed:@"ic_btn_background"] forState:UIControlStateNormal];
    [_payButton setTitle:@"开通会员" forState:UIControlStateNormal];
    _payButton.titleLabel.textColor = [UIColor whiteColor];
    [_payButton addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchDown];
    [_payButton sizeToFit];
    [_scrollView addSubview:_payButton];
    
    [_payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        if (_isSingleView==0) {
            make.top.equalTo(obtainVIP.mas_bottom).offset(15);
        }else{
            make.top.equalTo(vipView.mas_bottom).offset(15);
        }
        if(iPhone5){
            make.height.equalTo(@35);
        }else{
            make.height.equalTo(@40);
        }
        make.width.equalTo(@(SCREEN_WIDTH-30));
        make.centerX.equalTo(_scrollView.mas_centerX);
    }];
}

-(void)chooseMonthVIP{
    [monthImageView setImage:[UIImage imageNamed:@"ic_chosen"]];
    [yearImageView setImage:[UIImage imageNamed:@"ic_unchosen"]];
    vipType =1 ;
}
-(void)chooseYearVIP{
    [monthImageView setImage:[UIImage imageNamed:@"ic_unchosen"]];
    [yearImageView setImage:[UIImage imageNamed:@"ic_chosen"]];
    vipType = 2;
}

-(void)chooseALiPay{
    [michenImageView setImage:[UIImage imageNamed:@"ic_chosen"]];
    [chenxingImageView setImage:[UIImage imageNamed:@"ic_unchosen"]];
    type =1 ;
}
-(void)chooseWXPay{
    [michenImageView setImage:[UIImage imageNamed:@"ic_unchosen"]];
    [chenxingImageView setImage:[UIImage imageNamed:@"ic_chosen"]];
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
    AuthManager *am = [[AuthManager alloc]init];
    if (!am.isAuthenticated) {
        LoginViewController* loginViewCon = [[LoginViewController alloc] init];
        UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:loginViewCon];
        [self.navigationController presentViewController:rootNav animated:YES completion:nil];
        return;
    }
    PayManager *pm = [[PayManager alloc]init];
    [SVProgressHUD showWithStatus:@"请求中，请稍后..."];
    
    [pm fetchAliPayInfoWithUserId:am.userInfo.userId Type:[NSString stringWithFormat:@"%d",vipType] goodsId:@"" Success:^(AliPayResult *result) {
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
    AuthManager *am = [[AuthManager alloc]init];
    if (!am.isAuthenticated) {
        LoginViewController* loginViewCon = [[LoginViewController alloc] init];
        UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:loginViewCon];
        [self.navigationController presentViewController:rootNav animated:YES completion:nil];
        return;
    }
    PayManager *pm = [[PayManager alloc]init];
    [SVProgressHUD showWithStatus:@"请求中，请稍后..."];
    [pm fetchPayReqInfoWithUserId:am.userInfo.userId Type:[NSString stringWithFormat:@"%d",vipType] goodsId:@"" Success:^(PayReqResult *result) {
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
    if ([[AuthManager alloc]init].isAuthenticated) {
        return;
    }
    LoginViewController* loginViewCon = [[LoginViewController alloc] init];
    UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:loginViewCon];
    [self presentViewController:rootNav animated:YES completion:^{}
     ];
}

-(void)updateVIPState{
    AuthManager *am = [[AuthManager alloc]init];
    if (am.isAuthenticated) {
        [obtainVIP setTitle:@"已领取" forState:UIControlStateNormal];
        obtainVIP.backgroundColor = RGBCOLOR(225, 225, 225);
    }else{
        [obtainVIP setTitle:@"领取" forState:UIControlStateNormal];
        obtainVIP.backgroundColor = COMMONBLUECOLOR;
        [obtainVIP addTarget:self action:@selector(obtainVIP) forControlEvents:UIControlEventTouchDown];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
