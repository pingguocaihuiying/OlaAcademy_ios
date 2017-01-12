//
//  IAPVIPController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/6/21.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "IAPVIPController.h"

#import "SysCommon.h"
#import "Masonry.h"
#import "SVProgressHUD.h"
#import "AuthManager.h"
#import "PayManager.h"
#import "VIPView.h"
#import "LoginViewController.h"

@interface IAPVIPController ()

@end

@implementation IAPVIPController{
    UIScrollView *_scrollView;
    UIButton *_payButton;
    
    UIImageView *monthImageView;
    UIImageView *yearImageView;
    
    NSString *productID; //IAP对应的产品ID
    
    UIButton *obtainVIP;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupBackButton];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
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
    
    productID = @"olaxueyuan1001"; //月度会员
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
    
    UIView *lineView8 = [[UIView alloc]initWithFrame:CGRectMake(0, 122, SCREEN_WIDTH, 10)];
    lineView8.backgroundColor = RGBCOLOR(236, 236, 236);
    [chooseVipView addSubview:lineView8];
    
    UILabel *typeLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 132, SCREEN_WIDTH, 40)];
    typeLabel2.text = @"会员特权";
    typeLabel2.font = LabelFont(32);
    [chooseVipView addSubview:typeLabel2];
    
    UIView *lineView5 = [[UIView alloc]initWithFrame:CGRectMake(0, 182, SCREEN_WIDTH, 1)];
    lineView5.backgroundColor = RGBCOLOR(236, 236, 236);
    [chooseVipView addSubview:lineView5];
    
    VIPView *vipView = [[VIPView alloc]initWithFrame:CGRectMake(0, 187, SCREEN_WIDTH, 120)];
    [_scrollView addSubview:vipView];
    
    _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_payButton setBackgroundImage:[UIImage imageNamed:@"ic_btn_background"] forState:UIControlStateNormal];
    [_payButton setTitle:@"开通会员" forState:UIControlStateNormal];
    _payButton.titleLabel.textColor = [UIColor whiteColor];
    [_payButton addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchDown];
    [_payButton sizeToFit];
    [_scrollView addSubview:_payButton];
    
    [_payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(vipView.mas_bottom).offset(15);
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
    productID = @"olaxueyuan1001"; //月度会员
}
-(void)chooseYearVIP{
    [monthImageView setImage:[UIImage imageNamed:@"ic_unchosen"]];
    [yearImageView setImage:[UIImage imageNamed:@"ic_chosen"]];
    productID = @"olaxueyuan1002"; //半年会员
}

-(void)pay{
    AuthManager *am = [AuthManager sharedInstance];
    if (!am.isAuthenticated) {
        LoginViewController* loginViewCon = [[LoginViewController alloc] init];
        UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:loginViewCon];
        [self.navigationController presentViewController:rootNav animated:YES completion:nil];
        return;
    }
    // 检测是否允许内购
    if([SKPaymentQueue canMakePayments]){
        [self requestProductData:productID];
    }else{
        NSLog(@"不允许程序内付费");
    }
}

//请求商品
- (void)requestProductData:(NSString *)type{
    
    [SVProgressHUD showWithStatus:@"正在请求商品信息" maskType:SVProgressHUDMaskTypeGradient];
    
    NSArray *product = [[NSArray alloc] initWithObjects:type, nil];
    
    NSSet *nsset = [NSSet setWithArray:product];
    
    // 请求动作
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    [request start];
}

//收到产品返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    NSArray *product = response.products;
    if([product count] == 0){
        return;
    }
    
    SKProduct *p = nil;
    
    // 所有的商品, 遍历找到商品
    for (SKProduct *pro in product) {
        if([pro.productIdentifier isEqualToString:productID]) {
            p = pro;
        }
    }
    
    SKPayment * payment = [SKPayment paymentWithProduct:p];
    
    [SVProgressHUD showWithStatus:@"正在发送购买请求" maskType:SVProgressHUDMaskTypeGradient];
    
    // 为支付队列增加一个观察者
    [[SKPaymentQueue defaultQueue]addTransactionObserver:self];
    // 增加了一个观察者到付款队列中
    [[SKPaymentQueue defaultQueue]addPayment:payment];
}

//购买请求
- (void)requestDidFinish:(SKRequest *)request {
    [SVProgressHUD dismiss];
}
//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
}

//监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction {
    
    for(SKPaymentTransaction *tran in transaction){
        
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
                
                [SVProgressHUD showSuccessWithStatus:@"交易完成"];
                [self completeTransaction:tran];
                
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"商品添加进列表");
                
                [SVProgressHUD showWithStatus:@"正在请求付费信息" maskType:SVProgressHUDMaskTypeGradient];
                
                break;
            case SKPaymentTransactionStateRestored:
                
                [SVProgressHUD showErrorWithStatus:@"已经购买过商品"];
                
                break;
            case SKPaymentTransactionStateFailed:
                
                [SVProgressHUD showErrorWithStatus:@"交易失败, 请重试"];
                
                break;
            default:
                
                [SVProgressHUD dismiss];
                break;
        }
    }
}

//交易结束
- (void)completeTransaction:(SKPaymentTransaction *)transaction{
    
    [SVProgressHUD dismiss];
    
    AuthManager *am = [AuthManager sharedInstance];
    PayManager *pm = [[PayManager alloc]init];
    
    NSString * productIdentifier = [[NSString alloc] initWithData:transaction.transactionReceipt encoding:NSUTF8StringEncoding];
    NSString *receipt = [[productIdentifier dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
    
    if ([productIdentifier length] > 0) {
        // 向自己的服务器验证购买凭证
        [pm updateVIPByIAPWithUserId:am.userInfo.userId Receipt:receipt ProductId:productID Success:^(CommonResult *result) {
            if (result.code==10000) {
                if (_callbackBlock) {
                    _callbackBlock();
                }
            }
        } Failure:^(NSError *error) {
            
        }];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)dealloc{
    // 移除监听
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
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