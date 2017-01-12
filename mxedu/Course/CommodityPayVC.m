//
//  CommodityPayVC.m
//  mxedu
//
//  Created by 田晓鹏 on 16/4/4.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "CommodityPayVC.h"

#import "SysCommon.h"
#import "Masonry.h"
#import "WXApiObject.h"
#import "payRequsestHandler.h"
#import "WXApi.h"
#import "PayManager.h"
#import "AuthManager.h"

#import <AlipaySDK/AlipaySDK.h>
#import <SVProgressHUD.h>

@interface CommodityPayVC ()<UITextFieldDelegate>

@end

@implementation CommodityPayVC{
    
    UIImageView *_imageView;
    UIButton *_payButton;
    
    UITextField *phoneText;
    UILabel *dateLabel;
    UIImageView *michenImageView;
    UIImageView *chenxingImageView;
    
    int type; //1支付宝 2 微信
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"支付订单";
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = BACKGROUNDCOLOR;
    [self setupBackButton];
    [self setupSubView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payRefresh) name:@"ORDER_PAY_NOTIFICATION" object:nil];
}

- (void)setupBackButton
{
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
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[CourSectionViewController class]]) {
            [((CourSectionViewController*)controller) setupData];
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

- (void)setupSubView
{
    UIView *orderView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 150)];
    orderView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:orderView];
    
    UILabel *orderDetail = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 40)];
    orderDetail.text = @"订单详情";
    orderDetail.font = LabelFont(32);
    [orderView addSubview:orderDetail];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 1)];
    lineView1.backgroundColor = RGBCOLOR(236, 236, 236);
    [self.view addSubview:lineView1];
    
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 200, 30)];
    numberLabel.text = [NSString stringWithFormat:@"订单号：%d",(int)[[NSDate date] timeIntervalSince1970]];
    numberLabel.font = LabelFont(30);
    numberLabel.textColor = RGBCOLOR(143, 143, 143);
    [orderView addSubview:numberLabel];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 300, 30)];
    titleLabel.text = [NSString stringWithFormat:@"购买商品：%@",_commodity.name];
    titleLabel.font = LabelFont(30);
    titleLabel.textColor = RGBCOLOR(143, 143, 143);
    [orderView addSubview:titleLabel];
    
    UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 110, 200, 30)];
    moneyLabel.text = [NSString stringWithFormat:@"还需支付：¥%@",_commodity.price];
    moneyLabel.font = LabelFont(30);
    moneyLabel.textColor = RGBCOLOR(143, 143, 143);
    [orderView addSubview:moneyLabel];
    
    UIView *payView = [[UIView alloc]initWithFrame:CGRectMake(0, 170, SCREEN_WIDTH, 122)];
    payView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:payView];
    
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 40)];
    typeLabel.text = @"支付方式";
    typeLabel.font = LabelFont(32);
    [payView addSubview:typeLabel];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 1)];
    lineView2.backgroundColor = RGBCOLOR(236, 236, 236);
    [payView addSubview:lineView2];
    
    UILabel *wayLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(40, 41, 250, 40)];
    wayLabel1.text = @"支付宝支付";
    wayLabel1.font = LabelFont(30);
    [payView addSubview:wayLabel1];
    
    UIImageView *discountView1 = [[UIImageView alloc]init];
    discountView1.image = [UIImage imageNamed:@"ic_alipay"];
    [discountView1 sizeToFit];
    [payView addSubview:discountView1];
    
    type = 1;
    michenImageView = [[UIImageView alloc]init];
    michenImageView.image = [UIImage imageNamed:@"ic_chosen"];
    [michenImageView sizeToFit];
    michenImageView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap1 =[[UITapGestureRecognizer alloc]initWithTarget:self
                                                                         action:@selector(chooseALiPay)];
    [michenImageView addGestureRecognizer:tap1];
    [payView addSubview:michenImageView];
    
    [michenImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wayLabel1.mas_centerY).offset(0);
        make.right.equalTo(payView.mas_right).offset(-20);
    }];

    [discountView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wayLabel1.mas_centerY).offset(0);
        make.left.equalTo(payView.mas_left).offset(10);
    }];

    UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake(0, 81, SCREEN_WIDTH, 1)];
    lineView3.backgroundColor = RGBCOLOR(236, 236, 236);
    [payView addSubview:lineView3];
    
    UILabel *wayLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(40, 82, 250, 40)];
    wayLabel2.text = @"微信支付";
    wayLabel2.font = LabelFont(30);
    [payView addSubview:wayLabel2];
    
    UIImageView *discountView2 = [[UIImageView alloc]init];
    discountView2.image = [UIImage imageNamed:@"ic_wxpay"];
    [discountView2 sizeToFit];
    [payView addSubview:discountView2];
    
    chenxingImageView = [[UIImageView alloc]init];
    chenxingImageView.image = [UIImage imageNamed:@"ic_unchosen"];
    [chenxingImageView sizeToFit];
    chenxingImageView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap2 =[[UITapGestureRecognizer alloc]initWithTarget:self
                                                                         action:@selector(chooseWXPay)];
    [chenxingImageView addGestureRecognizer:tap2];
    [self.view addSubview:chenxingImageView];
    
    
    [chenxingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wayLabel2.mas_centerY).offset(0);
        make.right.equalTo(payView.mas_right).offset(-20);
    }];
    
    [discountView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wayLabel2.mas_centerY).offset(0);
        make.left.equalTo(payView.mas_left).offset(10);
    }];
    
    _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_payButton setBackgroundImage:[UIImage imageNamed:@"ic_btn_background"] forState:UIControlStateNormal];
    [_payButton setTitle:@"立即支付" forState:UIControlStateNormal];
    _payButton.titleLabel.textColor = [UIColor whiteColor];
    [_payButton addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchDown];
    [_payButton sizeToFit];
    [self.view addSubview:_payButton];
    
    [_payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(payView.mas_bottom).offset(60);
        make.centerX.equalTo(self.view.mas_centerX);
        if(iPhone5){
            make.height.equalTo(@35);
        }else{
            make.height.equalTo(@40);
        }
        make.width.equalTo(@(SCREEN_WIDTH-30));
    }];
    
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
        [SVProgressHUD showInfoWithStatus:@"您尚未登录"];
        return;
    }
    PayManager *pm = [[PayManager alloc]init];
    [SVProgressHUD showWithStatus:@"请求中，请稍后..."];
    [pm fetchAliPayInfoWithUserId:am.userInfo.userId Type:@"3" goodsId:_commodity.comId Success:^(AliPayResult *result) {
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
        [SVProgressHUD showInfoWithStatus:@"您尚未登录"];
        return;
    }
    PayManager *pm = [[PayManager alloc]init];
    [SVProgressHUD showWithStatus:@"请求中，请稍后..."];
    [pm fetchPayReqInfoWithUserId:am.userInfo.userId Type:@"3" goodsId:_commodity.comId Success:^(PayReqResult *result){
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

// 本地生成支付信息支付
-(void)payWithLocalPayReq{
    //创建支付签名对象
    payRequsestHandler *req = [[payRequsestHandler alloc] init];
    //初始化支付签名对象
    [req init:APP_ID mch_id:MCH_ID];
    //设置密钥
    [req setKey:PARTNER_ID];
    
    NSMutableDictionary *dict = [req sendPay_demo];
    
    if(dict != nil){
        NSMutableString *retcode = [dict objectForKey:@"retcode"];
        if (retcode.intValue == 0){
            NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
            
            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.openID              = [dict objectForKey:@"appid"];
            req.partnerId           = [dict objectForKey:@"partnerid"];
            req.prepayId            = [dict objectForKey:@"prepayid"];
            req.nonceStr            = [dict objectForKey:@"noncestr"];
            req.timeStamp           = stamp.intValue;
            req.package             = [dict objectForKey:@"package"];
            req.sign                = [dict objectForKey:@"sign"];
            [WXApi sendReq:req];
            //日志输出
            NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",req.openID,req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
        }else{
            //[self alert:@"提示信息" msg:[dict objectForKey:@"retmsg"]];
        }
    }else{
        //[self alert:@"提示信息" msg:@"服务器返回错误，未获取到json对象"];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
