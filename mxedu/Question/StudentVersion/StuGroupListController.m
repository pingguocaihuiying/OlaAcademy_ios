//
//  GroupViewController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/8/20.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "StuGroupListController.h"

#import "SysCommon.h"
#import "MJRefresh.h"
#import "StuGroupTableCell.h"

#import "GroupManager.h"
#import "AuthManager.h"
#import "LoginViewController.h"

#import "HMSegmentedControl.h"

#import "CreateGroupController.h"
#import "GroupMemberController.h"

@interface StuGroupListController ()<UITableViewDelegate,UITableViewDataSource,StuGroupCellDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *dataArray;

@property (nonatomic) NSString *subjectId;//当前科目ID

@end

@implementation StuGroupListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"群列表";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupBackButton];
    _subjectId = @"1";
    [self setupSegment];
    
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, GENERAL_SIZE(80), SCREEN_WIDTH, SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-GENERAL_SIZE(80))];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self setupData];
    }];
    
    [self.tableView.header beginRefreshing];
    
}

- (void)setupBackButton
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    [backBtn sizeToFit];
    [backBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

-(void)backButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupSegment{
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-40, GENERAL_SIZE(80))];
    segmentedControl.sectionTitles = @[@"数学",@"英语", @"逻辑", @"写作"];
    segmentedControl.selectedSegmentIndex = 0;
    
    segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : RGBCOLOR(81, 84, 93), NSFontAttributeName : LabelFont(32)};
    segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : COMMONBLUECOLOR, NSFontAttributeName: LabelFont(32)};
    segmentedControl.selectionIndicatorColor = COMMONBLUECOLOR;
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
    segmentedControl.selectionIndicatorHeight = 2;
    segmentedControl.selectionIndicatorBoxOpacity = 0;
    
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl.backgroundColor = [UIColor whiteColor];
    segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    [self.view addSubview:segmentedControl];
    
    [segmentedControl setIndexChangeBlock:^(NSInteger index) {
        _subjectId = [NSString stringWithFormat:@"%d",(int)index+1];
        [self setupData];
    }];
    
}

-(void)setupData{
    AuthManager *am = [AuthManager sharedInstance];
    GroupManager *gm = [[GroupManager alloc]init];
    if (am.userInfo) {
        [gm fetchStudentGroupListWithUserId:am.userInfo.userId Type:_subjectId Success:^(GroupListResult *result) {
            if ([_dataArray count]>0) {
                [_dataArray removeAllObjects];
            }
            [_dataArray addObjectsFromArray:result.groupArray];
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
    StuGroupTableCell *groupCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (groupCell == nil) {
        groupCell = [[StuGroupTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"groupCell"];
    }
    Group *group = [_dataArray objectAtIndex:indexPath.row];
    [groupCell setupCellWithModel:group RowIndex:indexPath.row];
    groupCell.delelgate = self;
    groupCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return groupCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return GENERAL_SIZE(190);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GroupMemberController *memberVC = [[GroupMemberController alloc]init];
    Group *group = [_dataArray objectAtIndex:indexPath.row];
    memberVC.groupId = group.groupId;
    [self.navigationController pushViewController:memberVC animated:YES];
}

#pragma delegate
-(void)clickAttendWithRowIndex:(NSInteger)rowIndex Type:(NSString*)type{
    OLA_LOGIN;
    Group *group = [_dataArray objectAtIndex:rowIndex];
    GroupManager *gm = [[GroupManager alloc]init];
    [gm attendGroupWithUserId:[AuthManager sharedInstance].userInfo.userId GroupId:group.groupId Type:type success:^(CommonResult *result) {
        if ([type isEqualToString:@"1"]) {
            group.isMember = @"1";
            group.number = [NSString stringWithFormat:@"%d", [group.number intValue]+1];
        }else{
            group.isMember = @"0";
            group.number = [NSString stringWithFormat:@"%d", [group.number intValue]-1];
        }
        [_dataArray replaceObjectAtIndex:rowIndex withObject:group];
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
