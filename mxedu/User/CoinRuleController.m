//
//  CoinRuleController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/10/19.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "CoinRuleController.h"

#import "SysCommon.h"
#import "Masonry.h"

@interface CoinRuleController ()

@end

@implementation CoinRuleController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"欧拉币规则";
    self.view.backgroundColor = RGBCOLOR(247, 247, 247);
    
    UILabel *coinL = [[UILabel alloc] init];
    coinL.text = @"什么是欧拉币？";
    coinL.textColor = RGBCOLOR(51, 51, 51);
    coinL.font = LabelFont(32);
    [self.view addSubview:coinL];
    
    [coinL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(GENERAL_SIZE(40));
        make.left.equalTo(self.view).offset(GENERAL_SIZE(40));
    }];
    
    UILabel *coinText = [[UILabel alloc] init];
    coinText.text = @"欧拉币是欧拉学院用户在完成一些行为后获得的奖励币，用户可以用欧拉币解锁试题、下载资料、购买精品课程等。";
    coinText.numberOfLines = 0;
    coinText.textColor = RGBCOLOR(51, 51, 51);
    coinText.font = LabelFont(24);
    [self.view addSubview:coinText];
    
    [coinText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(coinL.mas_bottom).offset(GENERAL_SIZE(20));
        make.right.equalTo(self.view.mas_right).offset(-GENERAL_SIZE(40));
        make.left.equalTo(self.view).offset(GENERAL_SIZE(40));
    }];
    
    UILabel *taskL = [[UILabel alloc] init];
    taskL.text = @"完成新手任务";
    taskL.textColor = RGBCOLOR(51, 51, 51);
    taskL.font = LabelFont(32);
    [self.view addSubview:taskL];
    
    [taskL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(coinText.mas_bottom).offset(GENERAL_SIZE(40));
        make.left.equalTo(self.view).offset(GENERAL_SIZE(40));
    }];
    
    UILabel *taskText = [[UILabel alloc] init];
    taskText.text = @"针对刚注册欧拉学院的用户，完成一些新手任务可以获得积分，新手任务欧拉币每人只能获得一次：\n1、完善个人资料中的所有信息即可获得50欧拉币；\n2、首次在欧拉学院上购买会员即可获得100欧拉币；\n3、首次在欧拉学院上购买一门付费课程（价格不限）即可获得150欧拉币。";
    taskText.numberOfLines = 0;
    taskText.textColor = RGBCOLOR(51, 51, 51);
    taskText.font = LabelFont(24);
    [self.view addSubview:taskText];
    
    [taskText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(taskL.mas_bottom).offset(GENERAL_SIZE(20));
        make.right.equalTo(self.view.mas_right).offset(-GENERAL_SIZE(40));
        make.left.equalTo(self.view).offset(GENERAL_SIZE(40));
    }];
    
    UILabel *scoreL = [[UILabel alloc] init];
    scoreL.text = @"签到获得欧拉币";
    scoreL.textColor = RGBCOLOR(51, 51, 51);
    scoreL.font = LabelFont(32);
    [self.view addSubview:scoreL];
    
    [scoreL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(taskText.mas_bottom).offset(GENERAL_SIZE(40));
        make.left.equalTo(self.view).offset(GENERAL_SIZE(40));
    }];
    
    UILabel *scoreText = [[UILabel alloc] init];
    scoreText.text = @"每日签到均可获得欧拉币，每日分享也可获得欧拉币，具体规则如下：\n每日签到＝5欧拉币；\n每日分享＝2欧拉币，每天最多可获得10欧拉币。";
    scoreText.numberOfLines = 0;
    scoreText.textColor = RGBCOLOR(51, 51, 51);
    scoreText.font = LabelFont(24);
    [self.view addSubview:scoreText];
    
    [scoreText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scoreL.mas_bottom).offset(GENERAL_SIZE(20));
        make.right.equalTo(self.view.mas_right).offset(-GENERAL_SIZE(40));
        make.left.equalTo(self.view).offset(GENERAL_SIZE(40));
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
