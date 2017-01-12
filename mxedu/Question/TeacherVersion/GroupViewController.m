//
//  GroupViewController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/8/20.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "GroupViewController.h"

#import "SysCommon.h"
#import "MJRefresh.h"
#import "GroupTableCell.h"

#import "GroupManager.h"
#import "AuthManager.h"

#import "CreateGroupController.h"
#import "GroupMemberController.h"

@interface GroupViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *dataArray;

@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"群管理";
    [self setupRightButton];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self setupData];
    }];
    
    [self.tableView.header beginRefreshing];
    
}

-(void)setupRightButton{
    UIImageView *createBtn = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    createBtn.image = [UIImage imageNamed:@"ic_group"];
    createBtn.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showCreateView)];
    [createBtn addGestureRecognizer:singleTap];
    [createBtn sizeToFit];
    
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:createBtn];
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
}

-(void)showCreateView{
    CreateGroupController *createVC = [[CreateGroupController alloc]init];
    createVC.groupCreateBlock = ^{
        [self setupData];
    };
    [self.navigationController pushViewController:createVC animated:YES];
}

-(void)setupData{
    AuthManager *am = [AuthManager sharedInstance];
    GroupManager *gm = [[GroupManager alloc]init];
    if (am.userInfo) {
        [gm fetchTeacherGroupListWithUserId:am.userInfo.userId Success:^(GroupListResult *result) {
            _dataArray = result.groupArray;
            [_tableView reloadData];
            [self.tableView.header endRefreshing];
        } Failure:^(NSError *error) {
            [self.tableView.header endRefreshing];
        }];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"groupCell";
    GroupTableCell *groupCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (groupCell == nil) {
        groupCell = [[GroupTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"groupCell"];
    }
    Group *group = [_dataArray objectAtIndex:indexPath.row];
    [groupCell setupCellWithModel:group];
    groupCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return groupCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GroupMemberController *memberVC = [[GroupMemberController alloc]init];
    Group *group = [_dataArray objectAtIndex:indexPath.row];
    memberVC.groupId = group.groupId;
    [self.navigationController pushViewController:memberVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
