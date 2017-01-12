//
//  UserViewController.m
//  NTreat
//
//  Created by 田晓鹏 on 15-4-19.
//  Copyright (c) 2015年 田晓鹏. All rights reserved.
//

#import "UserViewController.h"
#import "SysCommon.h"

#import "AuthManager.h"
#import "UserManager.h"
#import "UserEditViewController.h"
#import "LoginViewController.h"
#import "SettingViewController.h"
#import "MainViewController.h"
#import "MyEnrollViewController.h"
#import "MyDownloadListViewController.h"

#import "MistakeListController.h"
#import "CourseBuySubController.h"
#import "CollectionSubController.h"
#import "VIPSubController.h"
#import "IAPVIPController.h"
#import "OlaCoinViewController.h"

#import "UserTableCell.h"
#import "ModelConfig.h"

#import "CourseManager.h"
#import "PayManager.h"
#import "SignInManager.h"

#import "Masonry.h"
#import "UIColor+HexColor.h"

#import "TeachersCertifyController.h"

@interface UserViewController() <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *dataArray;
@property (nonatomic) ThirdPay *thirdPay; //用于判断使用第三方支付还是IAP

@end

static NSString* storeKeyUserInfo = @"NTUserInfo";

@implementation UserViewController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    if (_userView) {
        [_userView refreshUserInfo];
    }
    [self fetchSignInStatus];
}

-(void) viewDidLoad{
    [super viewDidLoad];
    
    _dataArray = [ModelConfig confgiModelDataWithCoin:@"" BuyCount:nil CollectCount:nil ShowSignIn:0];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = RGBCOLOR(235, 235, 235);
    [self.view addSubview:_tableView];
    
    _userView = [[UserInfoView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, GENERAL_SIZE(320))];
    UITapGestureRecognizer *tabGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showUserView)];
    _userView.userInteractionEnabled = YES;
    [_userView addGestureRecognizer:tabGes];
    [_userView.settingButton addTarget:self action:@selector(showSettingView) forControlEvents:UIControlEventTouchDown];
    _tableView.tableHeaderView = _userView;
    
    [self fetchPayModuleStatus];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payRefresh) name:@"ORDER_PAY_NOTIFICATION" object:nil];
}
//支付成功后刷新
-(void)payRefresh{
    [_userView refreshUserInfo];
}

// 后台控制是否显示支付相关功能
-(void)fetchPayModuleStatus{
    PayManager *pm = [[PayManager alloc]init];
    [pm fetchPayModuleStatusSuccess:^(ThirdPayResult *result) {
        _thirdPay = result.thirdPay;
    } Failure:^(NSError *error) {
        
    }];
}

// 获取签到状态
-(void)fetchSignInStatus{
    SignInManager *sm =[[SignInManager alloc]init];
    AuthManager *am = [AuthManager sharedInstance];
    if (am.isAuthenticated) {
        [sm fetchSignInStatusWithUserId:am.userInfo.userId Success:^(SignInStatusResult *result) {
            
            int showSignIn = result.signInStatus.status==1?0:1;
            _dataArray = [ModelConfig confgiModelDataWithCoin:am.userInfo.coin BuyCount:[NSString stringWithFormat:@"%d",result.signInStatus.coursBuyNum] CollectCount:[NSString stringWithFormat:@"%d",result.signInStatus.courseCollectNum] ShowSignIn:showSignIn];
            [_tableView reloadData];
        } Failure:^(NSError *error) {
            
        }];
    }
}

#pragma tableview

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"userCell";
    UserTableCell *userCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (userCell == nil) {
        userCell = [[UserTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"userCell"];
    }
    UserCellModel *model = [_dataArray objectAtIndex:indexPath.row];
    [userCell setupCellWithModel:model];
    userCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return userCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserCellModel *model = [_dataArray objectAtIndex:indexPath.row];
    if (model.isSection==1) {
        return GENERAL_SIZE(110);
    }else{
        return GENERAL_SIZE(90);
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
             MistakeListController *knowledgeVC = [[MistakeListController alloc] init];
            [self pushToViewController:knowledgeVC];
            break;
        }
        case 1:
        {
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            if (_thirdPay&&[_thirdPay.version isEqualToString:[infoDictionary objectForKey:@"CFBundleShortVersionString"]]&&[_thirdPay.thirdPay isEqualToString:@"0"]){
                IAPVIPController *iapVipVC = [[IAPVIPController alloc] init];
                __weak UserViewController* wself = self;
                iapVipVC.callbackBlock = ^{
                    [wself.userView refreshUserInfo];
                };
                [self pushToViewController:iapVipVC];
            }else{
                VIPSubController *vipVC = [[VIPSubController alloc] init];
                [self pushToViewController:vipVC];
            }
            break;
        }
        case 2:
        {
            OlaCoinViewController *coinVC = [[OlaCoinViewController alloc] init];
            [self pushToViewController:coinVC];
            break;
        }
        case 3:
        {
            CourseBuySubController *courseVC = [[CourseBuySubController alloc] init];
            [self pushToViewController:courseVC];
            break;
        }
        case 4:
        {
            CollectionSubController *collectionVC = [[CollectionSubController alloc] init];
            [self pushToViewController:collectionVC];;
            break;
        }
        case 5:
        {
            MyDownloadListViewController *downVC = [[MyDownloadListViewController alloc]init];
            [self pushToViewController:downVC];
            break;
        }
        case 6:
        {
            TeachersCertifyController *teacherVC = [[TeachersCertifyController alloc] init];
            
            [self pushToViewController:teacherVC];
            break;
        }
    }
}

#pragma method

-(void)pushToViewController:(UIViewController*)vc{
    OLA_LOGIN;
    self.navigationController.navigationBarHidden = NO;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)showUserView
{
    LoginViewController* loginViewCon = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
    loginViewCon.hidesBottomBarWhenPushed =YES;
    loginViewCon.successFunc = ^{
        //刷新userInfo
        [_userView refreshUserInfo];
    };
    
    UserEditViewController *editViewCon = [[UserEditViewController alloc]init];
    editViewCon.successFunc = ^{
        [_userView refreshUserInfo];
    };
    editViewCon.hidesBottomBarWhenPushed = YES;
    // 判断是否登录
    AuthManager *authManager = [AuthManager sharedInstance];
    if(authManager.isAuthenticated){
        self.navigationController.navigationBarHidden = NO;
        [self.navigationController pushViewController:editViewCon animated:YES];
    }else {
        UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:loginViewCon];
        [self.navigationController presentViewController:rootNav animated:YES completion:nil];
    }
}

-(void)showSettingView{
    
//    TeachersCertifyController *teacherVC = [[TeachersCertifyController alloc] init];
//    teacherVC.hidesBottomBarWhenPushed = YES;
//    self.navigationController.navigationBarHidden = NO;
//
//    [self.navigationController pushViewController:teacherVC animated:YES];
    
    SettingViewController *settingVC = [[SettingViewController alloc]init];
    settingVC.logoutSuccess = ^{
        [_userView refreshUserInfo];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"NEEDREFRESH" object:nil];
    };
    settingVC.hidesBottomBarWhenPushed = YES;
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:settingVC animated:YES];
}

@end
