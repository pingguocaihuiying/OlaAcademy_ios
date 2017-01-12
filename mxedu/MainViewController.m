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

#import "QuestionViewController.h"
#import "ExamViewController.h"
#import "CourseViewController.h"
#import "CircleViewController.h"
#import "UserViewController.h"

@interface MainViewController ()

@property (strong, nonatomic) SKSplashView *splashView;

@property (strong, nonatomic) QuestionViewController *questionVC;
@property (strong, nonatomic) ExamViewController *examVC;
@property (strong, nonatomic) CourseViewController *courseVC;
@property (strong, nonatomic) CircleViewController *circleVC;
@property (strong, nonatomic) UserViewController *userVC;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 启动动画
//    AuthManager *am = [[AuthManager alloc]init];
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
    
    _examVC = [[ExamViewController alloc]init];
    UINavigationController *examNav = [[UINavigationController alloc]initWithRootViewController:_examVC];
    examNav.title = @"题库";
    examNav.tabBarItem.image = [UIImage imageNamed:@"ic_exam_normal"];
    examNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"ic_exam_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    _courseVC = [[CourseViewController alloc]init];
    UINavigationController *courseNav = [[UINavigationController alloc]initWithRootViewController:_courseVC];
    courseNav.title = @"课程";
    courseNav.tabBarItem.image = [UIImage imageNamed:@"ic_course_normal"];
    courseNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"ic_course_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
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
    
    NSArray *controllers = [NSArray arrayWithObjects:questionNav,examNav,courseNav,circleNav,userNav,nil];
    
    self.viewControllers = controllers;
    
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
