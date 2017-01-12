//
//  UserProcotolViewController.m
//  NTreat
//
//  Created by 田晓鹏 on 15-5-21.
//  Copyright (c) 2015年 田晓鹏. All rights reserved.
//

#import "UserProcotolViewController.h"
#import "SysCommon.h"

@interface UserProcotolViewController ()

@end

@implementation UserProcotolViewController

UIWebView *webView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"服务协议"];
    self.navigationController.navigationBar.translucent = NO;
    
    [self setupBackButton];

    webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    webView.scalesPageToFit =  YES;
    [self.view addSubview:webView];
    
    [self loadPDF];
}

- (void)setupBackButton
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    [backBtn sizeToFit];
    [backBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

-(void)backButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 加载pdf文件
- (void)loadPDF { NSString *path = [[NSBundle mainBundle] pathForResource:@"欧拉群服务协议.pdf" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    [webView loadData:data MIMEType:@"application/pdf" textEncodingName:@"GBK" baseURL:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
