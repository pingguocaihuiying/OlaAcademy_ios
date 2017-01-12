//
//  MainViewController.m
//  mxedu
//
//  Created by 田晓鹏 on 15/8/2.
//  Copyright (c) 2015年 田晓鹏. All rights reserved.
//

#import "MainViewController.h"

#import "SKSplashIcon.h"
#import "AuthManager.h"
#import "SysCommon.h"

#import "UITabBar+badge.h"

#import "TeaHomeworkController.h"
#import "QuestionViewController.h"
#import "HomeViewController.h"
#import "CourseViewController.h"
#import "CircleViewController.h"
#import "UserViewController.h"

@interface MainViewController ()

@property (strong, nonatomic) SKSplashView *splashView;

@property (strong, nonatomic) TeaHomeworkController *teachVC;
@property (strong, nonatomic) QuestionViewController *questionVC;
@property (strong, nonatomic) HomeViewController *homeVC;
@property (strong, nonatomic) CourseViewController *courseVC;
@property (strong, nonatomic) CircleViewController *circleVC;
@property (strong, nonatomic) UserViewController *userVC;

@property (strong, nonatomic) NSArray *teach_controllers;
@property (strong, nonatomic) NSArray *stu_controllers;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 启动动画
//    AuthManager *am = [AuthManager sharedInstance];
//    if (am.isAuthenticated) {
//        SKSplashIcon *swiftSplashIcon = [[SKSplashIcon alloc] initWithImage:[UIImage imageNamed:@"ic_logo_white"] animationType:SKIconAnimationTypeBounce];
//        _splashView = [[SKSplashView alloc] initWithSplashIcon:swiftSplashIcon backgroundColor:COMMONBLUECOLOR animationType:SKSplashAnimationTypeNone];
//        _splashView.delegate = self; //Optional -> if you want to receive updates on animation beginning/end
//        _splashView.animationDuration = 2; //Optional -> set animation duration. Default: 1s
//        [self.view addSubview:_splashView];
//        [_splashView startAnimation];
//    }
    
    _questionVC = [[QuestionViewController alloc]init];
    UINavigationController *questionNav = [[UINavigationController alloc]initWithRootViewController:_questionVC];
    questionNav.title = @"考点";
    questionNav.tabBarItem.image = [UIImage imageNamed:@"ic_point_normal"];
    questionNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"ic_point_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    _teachVC = [[TeaHomeworkController alloc]init];
    UINavigationController *teachNav = [[UINavigationController alloc]initWithRootViewController:_teachVC];
    teachNav.title = @"考点";
    teachNav.tabBarItem.image = [UIImage imageNamed:@"ic_point_normal"];
    teachNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"ic_point_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    _courseVC = [[CourseViewController alloc]init];
    UINavigationController *courseNav = [[UINavigationController alloc]initWithRootViewController:_courseVC];
    courseNav.title = @"课程";
    courseNav.tabBarItem.image = [UIImage imageNamed:@"ic_course_normal"];
    courseNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"ic_course_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    _homeVC = [[HomeViewController alloc]init];
    UINavigationController *homeNav = [[UINavigationController alloc]initWithRootViewController:_homeVC];
    homeNav.title = @"主页";
    homeNav.tabBarItem.image = [UIImage imageNamed:@"ic_home_normal"];
    homeNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"ic_home_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    _circleVC = [[CircleViewController alloc]init];
    UINavigationController *circleNav = [[UINavigationController alloc]initWithRootViewController:_circleVC];
    circleNav.title = @"欧拉圈";
    circleNav.tabBarItem.image = [UIImage imageNamed:@"ic_found_normal"];
    circleNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"ic_found_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    _userVC = [[UserViewController alloc]init];
    UINavigationController *userNav = [[UINavigationController alloc]initWithRootViewController:_userVC];
    userNav.title = @"我的";
    userNav.tabBarItem.image = [UIImage imageNamed:@"ic_user_normal"];
    userNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"ic_user_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    _stu_controllers = [NSArray arrayWithObjects:questionNav,courseNav,homeNav,circleNav,userNav,nil];
    _teach_controllers = [NSArray arrayWithObjects:teachNav,courseNav,homeNav,circleNav,userNav,nil];
    [self setupTabContent];
    self.selectedIndex = 2;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupTabContent) name:@"NEEDREFRESH" object:nil];
    
}

-(void)setupTabContent{
    AuthManager *am = [AuthManager sharedInstance];
    if (am.isAuthenticated&&[am.userInfo.isActive isEqualToString:@"2"]) {
        self.viewControllers = _teach_controllers;
    }else{
        self.viewControllers = _stu_controllers;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
