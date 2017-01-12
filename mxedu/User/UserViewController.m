//
//  UserViewController.m
//  NTreat
//
//  Created by 田晓鹏 on 15-4-19.
//  Copyright (c) 2015年 田晓鹏. All rights reserved.
//

#import "UserViewController.h"
#import "SysCommon.h"
#import <RestKit.h>
#import <RETableViewManager.h>
#import "IndexViewController.h"
#import "AuthManager.h"
#import "UserManager.h"
#import "UserEditViewController.h"
#import "LoginViewController.h"
#import "SettingViewController.h"
#import "MainViewController.h"
#import "MyEnrollViewController.h"
#import "MyDownloadListViewController.h"

#import "KnowledgeSubController.h"
#import "CourseBuySubController.h"
#import "CollectionSubController.h"
#import "VIPSubController.h"
#import "IAPVIPController.h"

#import "CourseManager.h"
#import "PayManager.h"

#import "Masonry.h"
#import "UIColor+HexColor.h"
#import "HMSegmentedControl.h"

@interface UserViewController(){
    UITableView *_tableView;
    RETableViewManager* _manager;
    KnowledgeSubController *knowledgeVC;
    CollectionSubController *collectionVC;
    CourseBuySubController *courseVC;
    VIPSubController *vipVC;
    IAPVIPController *iapVipVC;
}

@end

static NSString* storeKeyUserInfo = @"NTUserInfo";

@implementation UserViewController{
    
    UIScrollView* _scrollView;
    
    NSArray* _viewPagerPageViews;
    
    NSInteger _currentPageIndex;

}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    if (_userView) {
        [_userView refreshUserInfo];
    }
    [vipVC updateVIPState];
}

-(void) viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"我";
    
    _userView = [[UserInfoView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, GENERAL_SIZE(240))];
    UITapGestureRecognizer *tabGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showUserView)];
    _userView.userInteractionEnabled = YES;
    [_userView addGestureRecognizer:tabGes];
    [_userView.collectButton addTarget:self action:@selector(showEnrollIn) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_userView];
    
    [self setupRightButton];
    
    [self setupSegmentedControl];
    
    [self fetchPayModuleStatus];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payRefresh) name:@"ORDER_PAY_NOTIFICATION" object:nil];
}

//支付成功后刷新
-(void)payRefresh{
    [_userView refreshUserInfo];
}

-(void)setupRightButton{
    UIImageView *slideBtn = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    slideBtn.image = [UIImage imageNamed:@"ic_setting"];
    slideBtn.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showSettingView)];
    [slideBtn addGestureRecognizer:singleTap];
    [slideBtn sizeToFit];
    
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:slideBtn];
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
    
    UIImageView *downlaodBtn = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    downlaodBtn.image = [UIImage imageNamed:@"icon_download"];
    downlaodBtn.userInteractionEnabled = YES;
    UITapGestureRecognizer *downloadTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showDownloadView)];
    [downlaodBtn addGestureRecognizer:downloadTap];
    [downlaodBtn sizeToFit];
    
    UIBarButtonItem *leftCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:downlaodBtn];
    self.navigationItem.leftBarButtonItem = leftCunstomButtonView;
}

// 后台控制是否显示支付相关功能
-(void)fetchPayModuleStatus{
    PayManager *pm = [[PayManager alloc]init];
    [pm fetchPayModuleStatusSuccess:^(StatusResult *result) {
        [self setupViewPager:result.status];
    } Failure:^(NSError *error) {
        
    }];
}

/**
 *  分类视图
 */
- (void)setupSegmentedControl
{
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, GENERAL_SIZE(240), SCREEN_WIDTH, GENERAL_SIZE(60))];
    segmentedControl.sectionTitles = @[@"知识型谱",@"课程收藏", @"VIP会员", @"购买课程"];
    segmentedControl.selectedSegmentIndex = 0;
    
    segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : LabelFont(28)};
    segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName: LabelFont(28)};
    segmentedControl.selectionIndicatorColor = [UIColor whiteColor];
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
    segmentedControl.selectionIndicatorHeight = 2;
    segmentedControl.selectionIndicatorBoxOpacity = 0;
    
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl.backgroundColor = RGBCOLOR(172, 202, 236);
    segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    [self.view addSubview:segmentedControl];
    
    _currentPageIndex = 0;
    
    [segmentedControl setIndexChangeBlock:^(NSInteger index) {
        [self switchToPageAt:index animated:YES];
    }];
}


- (void)setupViewPager:(int)payStatus
{
    _scrollView = [[UIScrollView alloc]init];
    [self.view addSubview:_scrollView];
    
    knowledgeVC = [[KnowledgeSubController alloc] init];
    [self addChildViewController:knowledgeVC];
    
    collectionVC = [[CollectionSubController alloc] init];
    [self addChildViewController:collectionVC];
    
    courseVC = [[CourseBuySubController alloc] init];
    [self addChildViewController:courseVC];
    
    if(payStatus==0){
        iapVipVC = [[IAPVIPController alloc] init];
        __weak UserViewController* wself = self;
        iapVipVC.callbackBlock = ^{
            [wself.userView refreshUserInfo];
        };
        [self addChildViewController:iapVipVC];
        _viewPagerPageViews = @[knowledgeVC.view,collectionVC.view,iapVipVC.view, courseVC.view];
    }else{
        vipVC = [[VIPSubController alloc] init];
        [self addChildViewController:vipVC];
        _viewPagerPageViews = @[knowledgeVC.view,collectionVC.view,vipVC.view, courseVC.view];
    }
    
    _scrollView.frame = CGRectMake(0, GENERAL_SIZE(300), SCREEN_WIDTH, SCREEN_HEIGHT-GENERAL_SIZE(300));
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * _viewPagerPageViews.count, SCREEN_HEIGHT);
    
    int i = 0;
    for (UIView* view in _viewPagerPageViews)
    {
        [_scrollView addSubview:view];
        view.frame = CGRectMake((CGFloat)i * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        i++;
    }
    _scrollView.scrollEnabled = NO;
}


- (void)switchToPageAt:(NSInteger)index animated:(BOOL)animated
{
    if (_currentPageIndex == index)
    {
        return;
    }
    if(index==1){
        [collectionVC refreshData];
    }
    if (index==3) {
        [courseVC refreshData];
    }
    
    _currentPageIndex = index;
    
    NSTimeInterval duration = animated ? 0.3 : 0.0;
    
    [UIView animateWithDuration:duration
                     animations:^{
                         
                         [_scrollView setContentOffset:CGPointMake((CGFloat)index * SCREEN_WIDTH, 0) animated:animated];
                     }];
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
    AuthManager *authManager = [[AuthManager alloc]init];
    if(authManager.isAuthenticated){
        [self.navigationController pushViewController:editViewCon animated:YES];
    }else {
        UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:loginViewCon];
        [self.navigationController presentViewController:rootNav animated:YES completion:nil];
    }
}

// 查看报名历史
-(void)showEnrollIn{
    AuthManager *am = [[AuthManager alloc]init];
    if (am.isAuthenticated) {
        MyEnrollViewController *myEnrollVC = [[MyEnrollViewController alloc]init];
        myEnrollVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myEnrollVC animated:YES];
    }
}

-(void)showSettingView{
    
    SettingViewController *settingVC = [[SettingViewController alloc]init];
    settingVC.logoutSuccess = ^{
        [_userView refreshUserInfo];
        [vipVC updateVIPState];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"NEEDREFRESH" object:nil];
    };
    settingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVC animated:YES];
}

-(void)showDownloadView{
    MyDownloadListViewController *downVC = [[MyDownloadListViewController alloc]init];
    downVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:downVC animated:YES];
}


@end
