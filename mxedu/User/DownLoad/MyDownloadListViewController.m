//
//  MyDownloadListViewController.m
//  NTreat
//
//  Created by 周冉 on 16/4/14.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "MyDownloadListViewController.h"
#import "LoadVideoViewController.h"//正在下载视图
#import "UIView+Frame.h"
#import "Masonry.h"
@implementation MyDownloadListViewController{
    UIButton *editBtn;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的下载";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupBackButton];

    _downLoadingArray = [NSMutableArray arrayWithCapacity:2];
    [self LoadSwitchView];//加载选择视图控制器

}

- (void)setupBackButton
{
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"ic_back_white"] forState:UIControlStateNormal];
    [backBtn sizeToFit];
    [backBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setImage:[UIImage imageNamed:@"icon_delete"] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editDownload:) forControlEvents:UIControlEventTouchUpInside];
    [editBtn sizeToFit];
    
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    self.navigationItem.rightBarButtonItem = editItem;
}

-(void)backButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)LoadSwitchView
{
    LoadVideoViewController *loadView = [[LoadVideoViewController alloc]init];
    loadView.view.frame = CGRectMake(0, 0, SCREEN_WIDTH,  self.view.height-UI_TAB_BAR_HEIGHT);
    loadView.title = @"正在下载";
    loadView.eSDMyLocalVideoCellOver = eAllinMyLocalVideoCellDoing;
    UINavigationController *navL = [[UINavigationController alloc]initWithRootViewController:loadView];
    navL.navigationBarHidden  = YES;

    
    LoadVideoViewController *loctionView = [[LoadVideoViewController alloc]init];
    loctionView.view.frame = CGRectMake(0, 0, SCREEN_WIDTH,  self.view.height-UI_TAB_BAR_HEIGHT);
    loctionView.title = @"已下载";
    loctionView.selfVC = self;
    loctionView.eSDMyLocalVideoCellOver = eAllinMyLocalVideoCellOver;
    __weak LoadVideoViewController *weakView = loctionView;
    loctionView.addHeadView = ^{
        //解决播放本地视频后视图上移问题
        weakView.rootTable.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    };
    UINavigationController *navR = [[UINavigationController alloc]initWithRootViewController:loctionView];
    navR.navigationBarHidden  = YES;

    [self.VCArray addObject:navL];
    [self.VCArray addObject:navR];
    [self upLoadSwitchViewContent];
    
}
//选中或者滚动到当前的视图
-(void)searchInfoWithTag:(NSInteger)tag andMainString:(NSString *)str
{
    UINavigationController *selectVC = [self.VCArray  objectAtIndex: tag];
    DownLoadSubViews *subView = [[selectVC childViewControllers] objectAtIndex:0];
    subView.isEditing = YES;
    [subView edit:editBtn];
    [subView.rootTable reloadData];
 
}

-(void)editDownload:(UIButton *)sender
{
    UINavigationController *selectVC = [self.VCArray  objectAtIndex: self.seclect];
    DownLoadSubViews *subView = [[selectVC childViewControllers] objectAtIndex:0];
    [subView edit:sender];
}


@end
