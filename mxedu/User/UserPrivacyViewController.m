//
//  UserPrivacyViewController.m
//  mxedu
//
//  Created by 田晓鹏 on 15/12/12.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import "UserPrivacyViewController.h"

@interface UserPrivacyViewController ()

@end

@implementation UserPrivacyViewController
{
    UIWebView *webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self setupBackButton];
    
    webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    
    [self loadPDF];

}

- (void)setupBackButton
{
    self.title = @"隐私政策";
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"ic_back_white"] forState:UIControlStateNormal];
    [backBtn sizeToFit];
    [backBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

-(void)backButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 加载pdf文件
- (void)loadPDF { NSString *path = [[NSBundle mainBundle] pathForResource:@"隐私政策.pdf" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    [webView loadData:data MIMEType:@"application/pdf" textEncodingName:@"GBK" baseURL:nil];
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
