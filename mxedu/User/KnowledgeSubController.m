//
//  KnowledgeSubController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/4/10.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "KnowledgeSubController.h"

#import "SubjectTableCell.h"
#import "AuthManager.h"
#import "CourseManager.h"
#import "SysCommon.h"
#import "MistakeViewController.h"
#import "MJRefresh.h"

@interface KnowledgeSubController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *dataArray;

@end

@implementation KnowledgeSubController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"错题本";
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self setupData];
    }];
    
    [self setupData];
}

-(void)setupData{
    NSString *userId = @"";
    AuthManager *am = [AuthManager sharedInstance];
    if (am.isAuthenticated) {
        userId = am.userInfo.userId;
    }
    CourseManager *cm = [[CourseManager alloc]init];
    [cm fetchStatisticsListWithUserId:userId Type:@"1" Success:^(StatisticsListResult *result) {
        _dataArray = result.courseArray;
        [_tableView reloadData];
        [self.tableView.header endRefreshing];
    } Failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_dataArray count];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *secView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 35)];
    Course *course = [_dataArray objectAtIndex:section];
    label.text = course.name;
    [secView addSubview:label];
    return secView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    Course *course = [_dataArray objectAtIndex:section];
    return [course.subList count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifier = @"subjectCell";
    SubjectTableCell *cell = [[SubjectTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    Course *course = [_dataArray objectAtIndex:indexPath.section];
    Course *subCourse = [course.subList objectAtIndex:indexPath.row];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    [cell setCellWithModel:subCourse];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MistakeViewController *mistakeVC = [[MistakeViewController alloc]init];
    Course *course = [_dataArray objectAtIndex:indexPath.section];
    Course *subCourse = course.subList[indexPath.row];
    mistakeVC.objectId = subCourse.courseId;
    mistakeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mistakeVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
