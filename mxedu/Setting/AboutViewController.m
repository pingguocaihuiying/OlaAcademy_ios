//
//  AboutViewController.m
//  NTreat
//
//  Created by 田晓鹏 on 15/6/4.
//  Copyright (c) 2015年 田晓鹏. All rights reserved.
//

#import "AboutViewController.h"
#import "SysCommon.h"
#import "Masonry.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupBackButton];
    [self setupView];
}

- (void)setupBackButton
{
    self.title = @"关于";
    self.navigationController.navigationBar.translucent = NO;
    
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

-(void)setupView{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_olaxueyuan"]];
    [imageView sizeToFit];
    [self.view addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(GENERAL_SIZE(100));
    }];
    
    UILabel *versionLabel = [UILabel new];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    versionLabel.text = [NSString stringWithFormat:@"Version %@",[infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    versionLabel.textColor = RGBCOLOR(153, 153, 153);
    versionLabel.font = LabelFont(32);
    [versionLabel sizeToFit];
    [self.view addSubview:versionLabel];
    
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-90);
    }];
    
    UILabel *rightsLabel = [UILabel new];
    rightsLabel.text = @"Copyright @ 2016 All right reserved";
    rightsLabel.textColor = RGBCOLOR(153, 153, 153);
    rightsLabel.font = LabelFont(32);
    [rightsLabel sizeToFit];
    [self.view addSubview:rightsLabel];
    
    [rightsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-60);
    }];
    
    UILabel *contactLabel = [UILabel new];
    contactLabel.text = @"service@olaxueyuan.com";
    contactLabel.textColor = RGBCOLOR(153, 153, 153);
    contactLabel.font = LabelFont(32);
    [contactLabel sizeToFit];
    [self.view addSubview:contactLabel];
    
    [contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
