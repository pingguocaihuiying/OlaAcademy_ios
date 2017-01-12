//
//  CollectionSubController.m
//  mxedu
//
//  Created by 田晓鹏 on 15/11/3.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import "CollectionSubController.h"

#import "CourseManager.h"
#import "CourseTableViewCell.h"

#import "SysCommon.h"
#import "AuthManager.h"
#import "CourSectionViewController.h"
#import "Masonry.h"
#import "UserViewController.h"
#import "MJRefresh.h"

@interface CollectionSubController () <UISearchBarDelegate, UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) UITableView *tableView;

@end

@implementation CollectionSubController{

    NSArray *videoArray;
    
    UIView *defaultView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的收藏";
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self fetchCourseVideo];
    }];
    
    defaultView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT)];
    defaultView.backgroundColor = [UIColor whiteColor];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:[UIImage imageNamed:@"LoccalVideo_NoData"] forState:UIControlStateNormal];
    [addButton sizeToFit];
    [addButton addTarget:self action:@selector(addCourse) forControlEvents:UIControlEventTouchDown];
    [defaultView addSubview:addButton];
    
    [self.view addSubview:defaultView];
    
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(defaultView);
        make.centerY.equalTo(defaultView).offset(-32);
    }];
    
    [self fetchCourseVideo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchCourseVideo) name:@"NEEDREFRESH" object:nil];
}

-(void)addCourse{
    self.navigationController.tabBarController.selectedIndex = 2;
}

-(void)refreshData{
    if ([videoArray count]==0) {
        [self fetchCourseVideo];
    }
}

/**
 *  获取所有收藏的视频
 */
-(void)fetchCourseVideo{
    CourseManager *cm = [[CourseManager alloc]init];
    AuthManager *am = [AuthManager sharedInstance];
    if (am.isAuthenticated) {
        [cm fetchVideoListWithUserId:am.userInfo.userId Success:^(CollectionListResult *result) {
            videoArray = result.collectionArray;
            if ([videoArray count]>0) {
                defaultView.hidden = YES;
            }else{
                defaultView.hidden = NO;
            }
            [_tableView reloadData];
            [self.tableView.header endRefreshing];
        } Failure:^(NSError *error) {
            [self.tableView.header endRefreshing];
        }];
    }else{
        videoArray = [[NSArray alloc]init];;
        [_tableView reloadData];
        defaultView.hidden = NO;
    }
}

#pragma tableview delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [videoArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CourseTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[CourseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"collectionCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CollectionVideo *video = [videoArray objectAtIndex:indexPath.row];
    [cell setupCell:video];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     return GENERAL_SIZE(230);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CollectionVideo *video = [videoArray objectAtIndex:indexPath.row];
    CourSectionViewController *sectionVC = [[CourSectionViewController alloc]init];
    sectionVC.objectId = video.courseId;
    sectionVC.type = video.type?[video.type intValue]:1;
    sectionVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sectionVC animated:YES];
    
}

-(void)removeAllCollection{
    AuthManager *am = [AuthManager sharedInstance];
    if (am.isAuthenticated) {
        CourseManager *cm = [[CourseManager alloc]init];
        [cm removeCollectionWithUserId:am.userInfo.userId Success:^(CommonResult *result) {
            videoArray = [[NSArray alloc]init];
            [_tableView reloadData];
            defaultView.hidden = NO;
        } Failure:^(NSError *error) {
            
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
