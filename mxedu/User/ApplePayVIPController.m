//
//  ApplePayVIPController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/6/16.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "ApplePayVIPController.h"

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

@interface ApplePayVIPController ()

@end

@implementation ApplePayVIPController{
    UIScrollView *_scrollView;
    UIButton *_payButton;
    
    UIImageView *monthImageView;
    UIImageView *yearImageView;
    int vipType; //1 月 2 年
    
    UIButton *obtainVIP;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    int scrollViewHeight = SCREEN_HEIGHT-220;
    int scrollContentHeight = 487;
    if (iPhone6) {
        scrollContentHeight = 502;
    }
    if (iPhone6Plus) {
        scrollContentHeight = 517;
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
    [backBtn setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    [backBtn sizeToFit];
    [backBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

-(void)backButtonClicked{
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
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:@"月度黄金会员60元"];
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
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:@"半年黄金会员300元"];
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
    
    UIView *lineView8 = [[UIView alloc]initWithFrame:CGRectMake(0, 122, SCREEN_WIDTH, 10)];
    lineView8.backgroundColor = RGBCOLOR(236, 236, 236);
    [chooseVipView addSubview:lineView8];
    
    UILabel *typeLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 142, SCREEN_WIDTH, 40)];
    typeLabel2.text = @"会员特权";
    typeLabel2.font = LabelFont(32);
    [chooseVipView addSubview:typeLabel2];
    
    UIView *lineView5 = [[UIView alloc]initWithFrame:CGRectMake(0, 182, SCREEN_WIDTH, 1)];
    lineView5.backgroundColor = RGBCOLOR(236, 236, 236);
    [chooseVipView addSubview:lineView5];
    
    VIPView *vipView = [[VIPView alloc]initWithFrame:CGRectMake(0, 187, SCREEN_WIDTH, 120)];
    [_scrollView addSubview:vipView];
    
    
    UIView *lineView9 = [[UIView alloc]initWithFrame:CGRectMake(0, 307, SCREEN_WIDTH, 10)];
    lineView9.backgroundColor = RGBCOLOR(236, 236, 236);
    [_scrollView addSubview:lineView9];
    
    UILabel *typeLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 317, SCREEN_WIDTH, 40)];
    typeLabel3.text = @"VIP会员免费领取";
    typeLabel3.font = LabelFont(32);
    [_scrollView addSubview:typeLabel3];
    
    UIView *lineView10 = [[UIView alloc]initWithFrame:CGRectMake(0, 357, SCREEN_WIDTH, 1)];
    lineView10.backgroundColor = RGBCOLOR(236, 236, 236);
    [_scrollView addSubview:lineView10];
    
    UILabel *freeVIP = [[UILabel alloc]initWithFrame:CGRectMake(10, 358, 200, 40)];
    freeVIP.text = @"登录领取5天VIP";
    freeVIP.font = LabelFont(32);
    [_scrollView addSubview:freeVIP];
    
    obtainVIP = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [obtainVIP.layer setCornerRadius:5];
    [obtainVIP setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    obtainVIP.frame = CGRectMake(SCREEN_WIDTH-70, 372, 60, 20);
    [_scrollView addSubview:obtainVIP];
    [self updateVIPState];
    
    _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_payButton setBackgroundImage:[UIImage imageNamed:@"ic_btn_background"] forState:UIControlStateNormal];
    [_payButton setTitle:@"开通会员" forState:UIControlStateNormal];
    _payButton.titleLabel.textColor = [UIColor whiteColor];
    [_payButton addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchDown];
    [_payButton sizeToFit];
    [_scrollView addSubview:_payButton];
    
    [_payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(obtainVIP.mas_bottom).offset(15);
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

-(void)pay{
    if([PKPaymentAuthorizationViewController canMakePayments]) {
        
        // 是否支持Amex、MasterCard、Visa与银联四种卡
        NSArray *supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard,PKPaymentNetworkVisa,PKPaymentNetworkChinaUnionPay];
        if (![PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:supportedNetworks]) {
            [SVProgressHUD showInfoWithStatus:@"尚未绑定支付卡"];
            return;
        }
        
        // 创建支付请求PKPaymentRequest
        PKPaymentRequest *payRequest = [[PKPaymentRequest alloc]init];
        //价格
        NSString *item = @"月度会员";
        NSString *price = @"60";
        if(vipType==2){
            item = @"半年会员";
            price = @"300";
        }
        PKPaymentSummaryItem *subtotal = [PKPaymentSummaryItem summaryItemWithLabel:item amount:[NSDecimalNumber decimalNumberWithString:price]];
        // 付给谁
        PKPaymentSummaryItem *total = [PKPaymentSummaryItem summaryItemWithLabel:@"欧拉联考" amount:[NSDecimalNumber decimalNumberWithString:price]];
        payRequest.paymentSummaryItems = @[subtotal,total];
        //国家代码
        payRequest.countryCode = @"CN";
        // 货币代码(人民币的代码 CNY)
        payRequest.currencyCode = @"CNY";
        //申请merchantId   merchant.com.topshopcrm.payDemo
        payRequest.merchantIdentifier = @"merchant.com.michen.olaxueyuan";
        //用户进行银行卡绑定
        payRequest.supportedNetworks = supportedNetworks;
        // 设置支持的交易处理协议(3DS必须支持)
        payRequest.merchantCapabilities = PKMerchantCapability3DS | PKMerchantCapabilityEMV;
        //显示购物信息并回调
        PKPaymentAuthorizationViewController * vc = [[PKPaymentAuthorizationViewController alloc]initWithPaymentRequest:payRequest];
        vc.delegate = self;
        [self presentViewController:vc animated:YES completion:nil];
        
    } else {
        NSLog(@"This device cannot make payments");
    }
}

# pragma delegate 

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion
{
    NSLog(@"Payment was authorized: %@", payment);
    
    // do an async call to the server to complete the payment.
    // See PKPayment class reference for object parameters that can be passed
    BOOL asyncSuccessful = FALSE;
    
    // When the async call is done, send the callback.
    // Available cases are:
    //    PKPaymentAuthorizationStatusSuccess, // Merchant auth'd (or expects to auth) the transaction successfully.
    //    PKPaymentAuthorizationStatusFailure, // Merchant failed to auth the transaction.
    //
    //    PKPaymentAuthorizationStatusInvalidBillingPostalAddress,  // Merchant refuses service to this billing address.
    //    PKPaymentAuthorizationStatusInvalidShippingPostalAddress, // Merchant refuses service to this shipping address.
    //    PKPaymentAuthorizationStatusInvalidShippingContact        // Supplied contact information is insufficient.
    
    if(asyncSuccessful) {
        completion(PKPaymentAuthorizationStatusSuccess);
        
        // do something to let the user know the status
        
        NSLog(@"Payment was successful");
        
        //        [Crittercism endTransaction:@"checkout"];
        
    } else {
        completion(PKPaymentAuthorizationStatusFailure);
        
        // do something to let the user know the status
        
        NSLog(@"Payment was unsuccessful");
        
        //        [Crittercism failTransaction:@"checkout"];
    }
    
}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    NSLog(@"Finishing payment view controller");
    
    // hide the payment window
    [controller dismissViewControllerAnimated:TRUE completion:nil];
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

-(void)updateVIPState{
    AuthManager *am = [AuthManager sharedInstance];
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

@end
