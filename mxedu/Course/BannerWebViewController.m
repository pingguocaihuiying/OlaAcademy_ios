//
//  BannerWebViewController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/5/12.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "BannerWebViewController.h"

#import "SysCommon.h"

@interface BannerWebViewController ()

@end

@implementation BannerWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"欧拉精选";
    [self setupBackButton];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupWebView];
}

- (void)setupBackButton
{
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

- (void)setupWebView
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-UI_STATUS_BAR_HEIGHT)];
    [self.view addSubview:webView];
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
