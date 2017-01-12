//
//  ChenXingSubController.m
//  mxedu
//
//  Created by 田晓鹏 on 15/11/3.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import "ChenXingSubController.h"

#import "SysCommon.h"
#import "GUIPlayerView.h"
#import "CourseManager.h"
#import "Masonry.h"
#import "ChenxingPlanViewController.h"
#import "ChenxingQAViewController.h"

@interface ChenXingSubController () <GUIPlayerViewDelegate>

@property (strong, nonatomic) GUIPlayerView *playerView;

@property (strong, nonatomic) UIView *operationView;

@end

@implementation ChenXingSubController

@synthesize playerView;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo_small"]];

    CGFloat width = [UIScreen mainScreen].bounds.size.width-40;
    UIScrollView *starView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    starView.backgroundColor = [UIColor whiteColor];
    starView.contentSize = CGSizeMake(SCREEN_WIDTH, width * 9.0f / 16.0+100);
    
    playerView = [[GUIPlayerView alloc] initWithFrame:CGRectMake(20, 0, width, width * 9.0f / 16.0f)];
    [playerView setDelegate:self];
    
    [starView addSubview:playerView];
    
    _operationView = [[UIView alloc] initWithFrame:CGRectMake(0, width * 9.0f / 16.0f+10, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    UILabel *planLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-50, 20)];
    planLabel.textColor = RGBCOLOR(128, 128, 128);
    planLabel.text = @"晨星成长计划";
    [_operationView addSubview:planLabel];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToPlanDetail)];
    planLabel.userInteractionEnabled = YES;
    [planLabel addGestureRecognizer:tapGesture];
    
    UIButton *nextButon1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButon1 setImage:[UIImage imageNamed:@"ic_next"] forState:UIControlStateNormal];
    [nextButon1 sizeToFit];
    [_operationView addSubview:nextButon1];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 25, SCREEN_WIDTH, 1)];
    line1.backgroundColor =RGBCOLOR(236, 236, 236);
    [_operationView addSubview:line1];
    
    UILabel *starLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 33, SCREEN_WIDTH-50, 20)];
    starLabel.textColor = RGBCOLOR(128, 128, 128);
    starLabel.text = @"成长计划Q&A";
    [_operationView addSubview:starLabel];
    
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToQA)];
    starLabel.userInteractionEnabled = YES;
    [starLabel addGestureRecognizer:tapGesture2];
    
    UIButton *nextButon2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButon2 setImage:[UIImage imageNamed:@"ic_next"] forState:UIControlStateNormal];
    [nextButon2 sizeToFit];
    [_operationView addSubview:nextButon2];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 58, SCREEN_WIDTH, 1)];
    line2.backgroundColor =RGBCOLOR(236, 236, 236);
    [_operationView addSubview:line2];
    
    UIButton *applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [applyButton setImage:[UIImage imageNamed:@"ic_apply"] forState:UIControlStateNormal];
    [applyButton addTarget:self action:@selector(apply) forControlEvents:UIControlEventTouchDown];
    [applyButton sizeToFit];
    [_operationView addSubview:applyButton];
    
    [starView addSubview:_operationView];
    [self.view addSubview:starView];
    
    [nextButon1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(playerView.mas_bottom).offset(8);
    }];
    
    [nextButon2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(line1.mas_bottom).offset(5);
    }];
    
    [applyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(line2.mas_bottom).offset(5);
    }];

    // 网络视频
    NSURL *URL = [NSURL URLWithString:@"https://dn-orthopedia.qbox.me/genius_plan.mp4"];
    [playerView setVideoURL:URL];
    [playerView prepareAndPlayAutomatically:NO];

}

-(void)pushToPlanDetail
{
    ChenxingPlanViewController *planVC = [[ChenxingPlanViewController alloc]init];
    planVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:planVC animated:YES];
}

-(void)pushToQA
{
    ChenxingQAViewController *qaVC = [[ChenxingQAViewController alloc]init];
    qaVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:qaVC animated:YES];
}

-(void)apply{
    NSString* strIdentifier = @"http://www.chenxingplan.com/cxinfo/hzfreg.aspx?recommend=欧拉联考";
    strIdentifier = [strIdentifier stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    BOOL isExsit = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:strIdentifier]];
    if(isExsit) {
        NSLog(@"App %@ installed", strIdentifier);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strIdentifier]];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [playerView pause];
}

#pragma mark - GUI Player View Delegate Methods

- (void)playerWillEnterFullscreen {
    [[self navigationController] setNavigationBarHidden:YES];
    self.navigationController.tabBarController.tabBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    _operationView.hidden = YES;
    if (_screenChange) {
        _screenChange(YES);
    }
}

- (void)playerWillLeaveFullscreen {
    [[self navigationController] setNavigationBarHidden:NO];
    self.navigationController.tabBarController.tabBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    _operationView.hidden = NO;
    if (_screenChange) {
        _screenChange(NO);
    }
}

- (void)playerDidEndPlaying {
    //[playerView clean];
}

- (void)playerFailedToPlayToEnd {
    NSLog(@"Error: could not play video");
    [playerView clean];
}

-(void)dealloc{
    [playerView clean];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
