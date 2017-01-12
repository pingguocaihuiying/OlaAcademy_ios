//
//  OlaCoinViewController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/10/17.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "OlaCoinViewController.h"

#import "SysCommon.h"
#import "Masonry.h"
#import "SignInPopoverView.h"
#import "ShareSheetView.h"
#import "SignInManager.h"
#import "AuthManager.h"

#import "CoinHistoryController.h"
#import "CoinRuleController.h"
#import "UserEditViewController.h"
#import "VIPSubController.h"
#import "CommodityViewController.h"

@interface OlaCoinViewController ()<SignInViewDelegate,ShareSheetDelegate>

@end

@implementation OlaCoinViewController{
    
    SignInStatus *coinStatus;
    
    UILabel *totalLabel;
    UILabel *todayLabel;
    
    UIButton *signBtn;
    UIButton *profileBtn;
    UIButton *vipBtn;
    UIButton *courseBtn;
    
    SignInPopoverView *signInView;
}

-(void)viewWillAppear:(BOOL)animated{
    [self fetchCoinStatus];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"欧拉币";
    self.view.backgroundColor = RGBCOLOR(238, 238, 238);
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, GENERAL_SIZE(238))];
    headView.backgroundColor = COMMONBLUECOLOR;
    [self.view addSubview:headView];
    
    totalLabel = [[UILabel alloc]init];
    totalLabel.text = @"欧拉币";
    totalLabel.textColor = [UIColor whiteColor];
    totalLabel.font = LabelFont(28);
    [headView addSubview:totalLabel];
    
    todayLabel = [[UILabel alloc]init];
    todayLabel.textColor = [UIColor whiteColor];
    todayLabel.font = LabelFont(28);
    [headView addSubview:todayLabel];
    
    [totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).offset(GENERAL_SIZE(30));
        make.centerY.equalTo(headView).offset(-GENERAL_SIZE(25));
    }];
    
    [todayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).offset(GENERAL_SIZE(30));
        make.centerY.equalTo(headView).offset(GENERAL_SIZE(25));
    }];
    
    UIView *ruleView =[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headView.frame), SCREEN_WIDTH, GENERAL_SIZE(104))];
    ruleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:ruleView];
    
    UIButton *detailL = [UIButton buttonWithType:UIButtonTypeCustom];
    [detailL setTitle:@"欧拉币明细" forState:UIControlStateNormal];
    detailL.titleLabel.font = LabelFont(28);
    [detailL setTitleColor:RGBCOLOR(102, 102, 102) forState:UIControlStateNormal];
    detailL.titleEdgeInsets = UIEdgeInsetsMake(0.0, 5.0, 0.0, -5.0);
    [detailL setImage:[UIImage imageNamed:@"ic_coin_history"] forState:UIControlStateNormal];
    [detailL addTarget:self action:@selector(showCoinHistoryView) forControlEvents:UIControlEventTouchDown];
    [ruleView addSubview:detailL];
    
    [detailL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ruleView);
        make.centerX.equalTo(ruleView).offset(-SCREEN_WIDTH/4);
    }];
    
    UIButton *ruleL =  [UIButton buttonWithType:UIButtonTypeCustom];
    [ruleL setTitle:@"欧拉币规则" forState:UIControlStateNormal];
    [ruleL setTitleColor:RGBCOLOR(102, 102, 102) forState:UIControlStateNormal];
    ruleL.titleLabel.font = LabelFont(28);
    [ruleL setImage:[UIImage imageNamed:@"ic_coin_rule"] forState:UIControlStateNormal];
    ruleL.titleEdgeInsets = UIEdgeInsetsMake(0.0, 5.0, 0.0, -5.0);
    [ruleL addTarget:self action:@selector(showCoinRuleView) forControlEvents:UIControlEventTouchDown];
    [ruleView addSubview:ruleL];
    
    [ruleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ruleView);
        make.centerX.equalTo(ruleView).offset(SCREEN_WIDTH/4);
    }];
    
    ///// 每日任务 //////
    UIView *signView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(ruleView.frame)+GENERAL_SIZE(20), SCREEN_WIDTH, GENERAL_SIZE(241))];
    signView.backgroundColor = [UIColor whiteColor];
    signView.userInteractionEnabled = YES;
    [self.view addSubview:signView];
    
    UIImageView *bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_half_circle"]];
    [signView addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(signView);
        make.centerX.equalTo(signView);
    }];
    
    UILabel *dailyL = [[UILabel alloc]init];
    dailyL.text = @"每日任务";
    dailyL.textColor = RGBCOLOR(51, 51, 51);
    dailyL.font = LabelFont(30);
    [bgView addSubview:dailyL];
    
    [dailyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.top.equalTo(bgView).offset(GENERAL_SIZE(20));
    }];
    
    ////// 签到 //////
    UILabel *signL = [[UILabel alloc]init];
    signL.text = @"今日签到";
    signL.font = LabelFont(30);
    signL.textColor = RGBCOLOR(102, 102, 102);
    [signView addSubview:signL];
    
    UILabel *signCoinL = [[UILabel alloc]init];
    signCoinL.text = @"奖励5欧拉币";
    signCoinL.font = LabelFont(24);
    signCoinL.textColor = RGBCOLOR(153, 153, 153);
    [signView addSubview:signCoinL];
    
    [signCoinL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(signView.mas_bottom).offset(-GENERAL_SIZE(30));
        make.left.equalTo(signView).offset(GENERAL_SIZE(45));
    }];
    
    [signL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(signCoinL.mas_top).offset(-GENERAL_SIZE(20));
        make.left.equalTo(signView).offset(GENERAL_SIZE(45));
    }];
    
    signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signBtn.layer.borderWidth = 1.0f;
    signBtn.layer.borderColor = [COMMONBLUECOLOR CGColor];
    signBtn.layer.cornerRadius = 5.0f;
    [signBtn setTitle:@"签到" forState:UIControlStateNormal];
    signBtn.titleLabel.font = LabelFont(26);
    [signBtn setTitleColor:COMMONBLUECOLOR forState:UIControlStateNormal];
    [signBtn addTarget:self action:@selector(showSignInView) forControlEvents:UIControlEventTouchDown];
    [signView addSubview:signBtn];
    
    [signBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(GENERAL_SIZE(160)));
        make.height.equalTo(@(GENERAL_SIZE(60)));
        make.right.equalTo(signView.mas_right).offset(-GENERAL_SIZE(30));
        make.bottom.equalTo(signView.mas_bottom).offset(-GENERAL_SIZE(40));
    }];
    
    ////// 分享 //////
    UIView *shareView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(signView.frame)+GENERAL_SIZE(2), SCREEN_WIDTH, GENERAL_SIZE(126))];
    shareView.backgroundColor = [UIColor whiteColor];
    shareView.userInteractionEnabled = YES;
    [self.view addSubview:shareView];
    
    UILabel *shareL = [[UILabel alloc]init];
    shareL.text = @"今日分享";
    shareL.font = LabelFont(30);
    shareL.textColor = RGBCOLOR(102, 102, 102);
    [shareView addSubview:shareL];
    
    UILabel *shareCoinL = [[UILabel alloc]init];
    shareCoinL.text = @"奖励5(最多10)欧拉币";
    shareCoinL.font = LabelFont(24);
    shareCoinL.textColor = RGBCOLOR(153, 153, 153);
    [shareView addSubview:shareCoinL];
    
    [shareL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shareView.mas_top).offset(GENERAL_SIZE(25));
        make.left.equalTo(shareView).offset(GENERAL_SIZE(45));
    }];
    
    [shareCoinL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(shareView.mas_bottom).offset(-GENERAL_SIZE(25));
        make.left.equalTo(shareView).offset(GENERAL_SIZE(45));
    }];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.layer.borderWidth = 1.0f;
    shareBtn.layer.borderColor = [COMMONBLUECOLOR CGColor];
    shareBtn.layer.cornerRadius = 5.0f;
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    shareBtn.titleLabel.font = LabelFont(26);
    [shareBtn setTitleColor:COMMONBLUECOLOR forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(showShareSheet) forControlEvents:UIControlEventTouchDown];
    [shareView addSubview:shareBtn];
    
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(GENERAL_SIZE(160)));
        make.height.equalTo(@(GENERAL_SIZE(60)));
        make.right.equalTo(shareView.mas_right).offset(-GENERAL_SIZE(30));
        make.centerY.equalTo(shareView);
    }];
    
    ////// 新手任务 ///////
    UIView *taskView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(shareView.frame)+GENERAL_SIZE(20), SCREEN_WIDTH, GENERAL_SIZE(405))];
    taskView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:taskView];
    
    UIImageView *bgView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_half_circle"]];
    [taskView addSubview:bgView2];
    
    [bgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(taskView);
        make.centerX.equalTo(taskView);
    }];
    
    UILabel *taskL = [[UILabel alloc]init];
    taskL.text = @"新手任务";
    taskL.textColor = RGBCOLOR(51, 51, 51);
    taskL.font = LabelFont(30);
    [bgView2 addSubview:taskL];
    
    [taskL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView2);
        make.top.equalTo(bgView2).offset(GENERAL_SIZE(20));
    }];
    
    
    ///// 购买会员 ///////
    UIImageView *vipIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_bg_task"]];
    vipIV.userInteractionEnabled = YES;
    [taskView addSubview:vipIV];
    
    [vipIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(taskView);
        make.height.equalTo(@(GENERAL_SIZE(255)));
        make.width.equalTo(@((SCREEN_WIDTH-GENERAL_SIZE(80))/3));
        make.bottom.equalTo(taskView.mas_bottom).offset(-GENERAL_SIZE(30));
    }];
    
    UILabel *vipLabel = [[UILabel alloc]init];
    vipLabel.text = @"首次购买会员";
    vipLabel.font = LabelFont(24);
    vipLabel.textColor = RGBCOLOR(102, 102, 102);
    [vipIV addSubview:vipLabel];
    
    [vipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(vipIV);
        make.top.equalTo(vipIV).offset(GENERAL_SIZE(40));
    }];
    
    vipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    vipBtn.layer.borderWidth = 1.0f;
    vipBtn.layer.borderColor = [COMMONBLUECOLOR CGColor];
    vipBtn.layer.cornerRadius = 2.0f;
    [vipBtn setTitle:@"去购买" forState:UIControlStateNormal];
    vipBtn.titleLabel.font = LabelFont(22);
    [vipBtn setTitleColor:COMMONBLUECOLOR forState:UIControlStateNormal];
    [vipBtn addTarget:self action:@selector(showVIPView) forControlEvents:UIControlEventTouchDown];
    [vipIV addSubview:vipBtn];
    
    [vipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(vipIV).offset(GENERAL_SIZE(30));
        make.right.equalTo(vipIV.mas_right).offset(-GENERAL_SIZE(30));
        make.bottom.equalTo(vipIV.mas_bottom).offset(-GENERAL_SIZE(30));
    }];
    
    UILabel *vipCoinL = [[UILabel alloc]init];
    vipCoinL.textColor = RGBCOLOR(153, 153, 153);
    vipCoinL.text = @"奖励100欧拉币";
    vipCoinL.font = LabelFont(24);
    [vipIV addSubview:vipCoinL];
    
    [vipCoinL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(vipIV);
        make.top.equalTo(vipBtn).offset(-GENERAL_SIZE(40));
    }];
    
    ///// 完善资料 ///////
    UIImageView *profileIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_bg_task"]];
    profileIV.userInteractionEnabled = YES;
    [taskView addSubview:profileIV];
    
    [profileIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(vipIV.mas_left).offset(-GENERAL_SIZE(20));
        make.height.equalTo(@(GENERAL_SIZE(255)));
        make.width.equalTo(@((SCREEN_WIDTH-GENERAL_SIZE(80))/3));
        make.bottom.equalTo(taskView.mas_bottom).offset(-GENERAL_SIZE(30));
    }];
    
    UILabel *profileLabel = [[UILabel alloc]init];
    profileLabel.text = @"完善个人资料";
    profileLabel.font = LabelFont(24);
    profileLabel.textColor = RGBCOLOR(102, 102, 102);
    [profileIV addSubview:profileLabel];
    
    [profileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(profileIV);
        make.top.equalTo(profileIV).offset(GENERAL_SIZE(40));
    }];
    
    profileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    profileBtn.layer.borderWidth = 1.0f;
    profileBtn.layer.borderColor = [COMMONBLUECOLOR CGColor];
    profileBtn.layer.cornerRadius = 2.0f;
    [profileBtn setTitle:@"去完善" forState:UIControlStateNormal];
    profileBtn.titleLabel.font = LabelFont(22);
    [profileBtn setTitleColor:COMMONBLUECOLOR forState:UIControlStateNormal];
    [profileBtn addTarget:self action:@selector(showProfileView) forControlEvents:UIControlEventTouchDown];
    [profileIV addSubview:profileBtn];
    
    [profileBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(profileIV).offset(GENERAL_SIZE(30));
        make.right.equalTo(profileIV.mas_right).offset(-GENERAL_SIZE(30));
        make.bottom.equalTo(profileIV.mas_bottom).offset(-GENERAL_SIZE(30));
    }];
    
    UILabel *profileCoinL = [[UILabel alloc]init];
    profileCoinL.textColor = RGBCOLOR(153, 153, 153);
    profileCoinL.text = @"奖励50欧拉币";
    profileCoinL.font = LabelFont(24);
    [profileIV addSubview:profileCoinL];
    
    [profileCoinL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(profileIV);
        make.top.equalTo(profileBtn).offset(-GENERAL_SIZE(40));
    }];
    
    ///// 购买课程 ///////
    UIImageView *courseIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_bg_task"]];
    courseIV.userInteractionEnabled = YES;
    [taskView addSubview:courseIV];
    
    [courseIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(vipIV.mas_right).offset(GENERAL_SIZE(20));
        make.height.equalTo(@(GENERAL_SIZE(255)));
        make.width.equalTo(@((SCREEN_WIDTH-GENERAL_SIZE(80))/3));
        make.bottom.equalTo(taskView.mas_bottom).offset(-GENERAL_SIZE(30));
    }];
    
    UILabel *courseLabel1 = [[UILabel alloc]init];
    courseLabel1.text = @"首次购买一门";
    courseLabel1.font = LabelFont(24);
    courseLabel1.textColor = RGBCOLOR(102, 102, 102);
    [courseIV addSubview:courseLabel1];
    
    [courseLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(courseIV);
        make.top.equalTo(courseIV).offset(GENERAL_SIZE(40));
    }];
    
    UILabel *courseLabel2 = [[UILabel alloc]init];
    courseLabel2.text = @"付费课程";
    courseLabel2.font = LabelFont(24);
    courseLabel2.textColor = RGBCOLOR(102, 102, 102);
    [courseIV addSubview:courseLabel2];
    
    [courseLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(courseIV);
        make.top.equalTo(courseLabel1.mas_bottom).offset(GENERAL_SIZE(10));
    }];
    
    courseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    courseBtn.layer.borderWidth = 1.0f;
    courseBtn.layer.borderColor = [COMMONBLUECOLOR CGColor];
    courseBtn.layer.cornerRadius = 2.0f;
    [courseBtn setTitle:@"去购买" forState:UIControlStateNormal];
    courseBtn.titleLabel.font = LabelFont(22);
    [courseBtn setTitleColor:COMMONBLUECOLOR forState:UIControlStateNormal];
    [courseBtn addTarget:self action:@selector(showCommodityView) forControlEvents:UIControlEventTouchDown];
    [courseIV addSubview:courseBtn];
    
    [courseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(courseIV).offset(GENERAL_SIZE(30));
        make.right.equalTo(courseIV.mas_right).offset(-GENERAL_SIZE(30));
        make.bottom.equalTo(courseIV.mas_bottom).offset(-GENERAL_SIZE(30));
    }];
    
    UILabel *courseCoinL = [[UILabel alloc]init];
    courseCoinL.textColor = RGBCOLOR(153, 153, 153);
    courseCoinL.text = @"奖励150欧拉币";
    courseCoinL.font = LabelFont(24);
    [courseIV addSubview:courseCoinL];
    
    [courseCoinL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(courseIV);
        make.top.equalTo(courseBtn).offset(-GENERAL_SIZE(40));
    }];

}

// 获取欧拉币领取状态状态
-(void)fetchCoinStatus{
    SignInManager *sm =[[SignInManager alloc]init];
    AuthManager *am = [AuthManager sharedInstance];
    if (am.isAuthenticated) {
        [sm fetchSignInStatusWithUserId:am.userInfo.userId Success:^(SignInStatusResult *result) {
            coinStatus = result.signInStatus;
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 欧拉币",coinStatus.coin]];
            [str addAttribute:NSFontAttributeName value:LabelFont(52) range:NSMakeRange(0,coinStatus.coin.length)];
            totalLabel.attributedText = str;
            todayLabel.text = [NSString stringWithFormat:@"今日获得%@欧拉币",coinStatus.todayCoin];
            if (coinStatus.status==1) {
                [signBtn setTitle:@"已领取" forState:UIControlStateNormal];
                [signBtn setEnabled:NO];
                signBtn.layer.borderColor = [RGBCOLOR(191, 191, 191) CGColor];
                [signBtn setTitleColor:RGBCOLOR(191, 191, 191) forState:UIControlStateNormal];
            }else{
                [signBtn setTitle:@"签到" forState:UIControlStateNormal];
                [signBtn setEnabled:YES];
                signBtn.layer.borderColor = [COMMONBLUECOLOR CGColor];
                [signBtn setTitleColor:COMMONBLUECOLOR forState:UIControlStateNormal];
            }
            
            if(coinStatus.profileTask == 1){
                [profileBtn setTitle:@"已领取" forState:UIControlStateNormal];
                profileBtn.layer.borderColor = [RGBCOLOR(191, 191, 191) CGColor];
                [profileBtn setTitleColor:RGBCOLOR(191, 191, 191) forState:UIControlStateNormal];
            }else{
                [profileBtn setTitle:@"去完善" forState:UIControlStateNormal];
                profileBtn.layer.borderColor = [COMMONBLUECOLOR CGColor];
                [profileBtn setTitleColor:COMMONBLUECOLOR forState:UIControlStateNormal];
            }
            
            if(coinStatus.vipTask == 1){
                [vipBtn setTitle:@"已领取" forState:UIControlStateNormal];
                vipBtn.layer.borderColor = [RGBCOLOR(191, 191, 191) CGColor];
                [vipBtn setTitleColor:RGBCOLOR(191, 191, 191) forState:UIControlStateNormal];
            }else{
                [vipBtn setTitle:@"去购买" forState:UIControlStateNormal];
                vipBtn.layer.borderColor = [COMMONBLUECOLOR CGColor];
                [vipBtn setTitleColor:COMMONBLUECOLOR forState:UIControlStateNormal];
            }
            
            if(coinStatus.courseTask == 1){
                [courseBtn setTitle:@"已领取" forState:UIControlStateNormal];
                courseBtn.layer.borderColor = [RGBCOLOR(191, 191, 191) CGColor];
                [courseBtn setTitleColor:RGBCOLOR(191, 191, 191) forState:UIControlStateNormal];
            }else{
                [courseBtn setTitle:@"去购买" forState:UIControlStateNormal];
                courseBtn.layer.borderColor = [COMMONBLUECOLOR CGColor];
                [courseBtn setTitleColor:COMMONBLUECOLOR forState:UIControlStateNormal];
            }
            
        } Failure:^(NSError *error) {
            
        }];
    }
}

//欧拉币明细
-(void)showCoinHistoryView{
    CoinHistoryController *historyVC = [[CoinHistoryController alloc]init];
    [self.navigationController pushViewController:historyVC animated:YES];
}

//欧拉币规则
-(void)showCoinRuleView{
    CoinRuleController *ruleVC = [[CoinRuleController alloc]init];
    [self.navigationController pushViewController:ruleVC animated:YES];
}

// 签到页面
-(void)showSignInView{
    signInView = [[SignInPopoverView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    signInView.delegate = self;
    [signInView setCancelButtonBlock:^{
        
    }];
    
    [signInView show];
    
    if (coinStatus.status==0) {
        [self signIn];
    }else{
        [signInView setupViewWithDay:coinStatus.signInDays Coin:coinStatus.coin];
    }
}

// 签到
-(void)signIn{
    AuthManager *am = [AuthManager sharedInstance];
    if (!am.isAuthenticated) {
        return;
    }
    SignInManager *sm = [[SignInManager alloc]init];
    [sm signInWithUserId:am.userInfo.userId success:^(CommonResult *result) {
        [signInView setupViewWithDay:coinStatus.signInDays Coin:[NSString stringWithFormat:@"%d",[coinStatus.coin intValue]+5]];
        [self fetchCoinStatus];
    } failure:^(NSError *error) {
        
    }];
}

// 个人信息
-(void)showProfileView{
    UserEditViewController *editVC = [[UserEditViewController alloc]init];
    [self.navigationController pushViewController:editVC animated:YES];
}

// vip购买
-(void)showVIPView{
    VIPSubController *vipVC = [[VIPSubController alloc]init];
    [self.navigationController pushViewController:vipVC animated:YES];
}

// 精品课购买
-(void)showCommodityView{
    CommodityViewController *commodityVC = [[CommodityViewController alloc]init];
    commodityVC.currentType = @"1";
    [self.navigationController pushViewController:commodityVC animated:YES];
}

-(void)obtainCoinbyShare{
    AuthManager *am = [AuthManager sharedInstance];
    if (!am.isAuthenticated) {
        return;
    }
    SignInManager *sm = [[SignInManager alloc]init];
    [sm shareWithUserId:am.userInfo.userId success:^(CommonResult *result) {
        [self fetchCoinStatus];
    } failure:^(NSError *error) {
        
    }];
}

- (void)showShareSheet{
    
    NSArray *shareButtonTitleArray = [[NSArray alloc] init];
    NSArray *shareButtonImageNameArray = [[NSArray alloc] init];
    
    shareButtonTitleArray = @[@"微信好友",@"微信朋友圈",@"新浪微博",@"QQ好友",@"QQ空间"];
    shareButtonImageNameArray = @[@"wechat",@"wetimeline",@"sina",@"qq",@"qzone"];
    
    ShareSheetView *lxActivity = [[ShareSheetView alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" ShareButtonTitles:shareButtonTitleArray withShareButtonImagesName:shareButtonImageNameArray];
    [lxActivity showInView:self.view];
}

#pragma SignInView  ShareSheetView   Delegate

- (void)didClickOnImageIndex:(NSInteger)imageIndex
{
    UIImage *image = [UIImage imageNamed:@"ic_logo"];
    NSString *content = @"我正在欧拉学院学习MBA课程，一起来吧！";
    NSString *url = [NSString stringWithFormat: @"http://app.olaxueyuan.com"];
    
    switch((int)imageIndex){
        case 1001: // SignInView
        case 0: //ShareSheetView
            [UMSocialData defaultData].extConfig.wechatSessionData.title = @"欧拉MBA";
            [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:content image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                }
            }];
            [self obtainCoinbyShare];
            break;
        case 1002:
        case 1:
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = content;
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:content image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                }
            }];
            [self obtainCoinbyShare];
            break;
        case 1003:
        case 2:
            [UMSocialData defaultData].extConfig.qqData.title = @"欧拉MBA";
            [UMSocialData defaultData].extConfig.qqData.url =url;
            [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:content image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                }
            }];
            [self obtainCoinbyShare];
            break;
        case 1004:
        case 3:
            // QQ空间分享只支持图文分享（图片文字缺一不可）
            [UMSocialData defaultData].extConfig.qzoneData.title = @"欧拉MBA";
            [UMSocialData defaultData].extConfig.qzoneData.url = url;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:content image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                }
            }];
            [self obtainCoinbyShare];
            break;
        case 1005:
        case 4:
            [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeWeb url:url];
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:content image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                }
            }];
            [self obtainCoinbyShare];
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
