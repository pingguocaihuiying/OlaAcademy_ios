//
//  TeacherListController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/12/9.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "TeacherListController.h"

#import "SysCommon.h"
#import "MJRefresh.h"
#import "UserManager.h"
#import "TeacherTableCell.h"
#import "OtherUserController.h"

@interface TeacherListController ()<UITableViewDataSource,UITableViewDelegate,TeacherTableCellDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *dataArray;

@end

@implementation TeacherListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"师资";
    
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-UI_STATUS_BAR_HEIGHT)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self setupData];
    }];
    
    [self.tableView.header beginRefreshing];
}

-(void)setupData{
    UserManager *um = [[UserManager alloc]init];
    [um fetchTeacherListSuccess:^(GroupMemberResult *result)
     {
         if ([_dataArray count]>0) {
             [_dataArray removeAllObjects];
         }
         [_dataArray addObjectsFromArray: result.memberArray];
         [self.tableView reloadData];
         [self.tableView.header endRefreshing];
         
     } Failure:^(NSError *error) {
         [self.tableView.header endRefreshing];
     }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"teacherCell";
    TeacherTableCell *teacherCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (teacherCell == nil) {
        teacherCell = [[TeacherTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"teacherCell"];
    }
    User *user = [_dataArray objectAtIndex:indexPath.row];
    [teacherCell setupCellWithModel:user];
    teacherCell.delegate = self;
    teacherCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return teacherCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return GENERAL_SIZE(120);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    User *user = [_dataArray objectAtIndex:indexPath.row];
    OtherUserController *otherVC = [[OtherUserController alloc]init];
    otherVC.userInfo = user;
    //[self.navigationController pushViewController:otherVC animated:YES];
}

#pragma delegate
-(void)didClickInvite:(User *)user{
    if (_didChooseUser) {
        _didChooseUser(user);
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
