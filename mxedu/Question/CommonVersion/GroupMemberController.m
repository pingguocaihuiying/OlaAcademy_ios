//
//  GroupManagerController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/10/28.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "GroupMemberController.h"

#import "SysCommon.h"
#import "MJRefresh.h"
#import "GroupManager.h"
#import "MemberTableCell.h"
#import "OtherUserController.h"

@interface GroupMemberController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *dataArray;

@end

@implementation GroupMemberController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"群成员";
    
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-UI_STATUS_BAR_HEIGHT)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self setupData:@"1"];
    }];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        int pageSize = [_dataArray count]%20==0?(int)[_dataArray count]/20+1:(int)[_dataArray count]/20+2;
        [self setupData:[NSString stringWithFormat:@"%d",pageSize]];
    }];
    
    [self.tableView.header beginRefreshing];
}

-(void)setupData:(NSString*)pageIndex{
    GroupManager *gm = [[GroupManager alloc]init];
    [gm fetchGroupMemberWithGroupId:_groupId pageIndex:pageIndex pageSize:@"20" success:^(GroupMemberResult *result)
    {
        if ([result.memberArray count]==0) {
            [self.tableView.footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.footer endRefreshing];
        }
        if ([pageIndex isEqualToString:@"1"]) {
            [_dataArray removeAllObjects];
        }
        [_dataArray addObjectsFromArray: result.memberArray];
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"groupCell";
    MemberTableCell *groupCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (groupCell == nil) {
        groupCell = [[MemberTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"groupCell"];
    }
    User *user = [_dataArray objectAtIndex:indexPath.row];
    [groupCell setupCellWithModel:user];
    groupCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return groupCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return GENERAL_SIZE(200);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    User *user = [_dataArray objectAtIndex:indexPath.row];
    OtherUserController *otherVC = [[OtherUserController alloc]init];
    otherVC.userInfo = user;
    //[self.navigationController pushViewController:otherVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
