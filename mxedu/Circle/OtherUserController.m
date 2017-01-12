//
//  OtherUserController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/9/20.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "OtherUserController.h"

#import "SysCommon.h"
#import "OtherHeadView.h"
#import "AuthManager.h"
#import "LoginViewController.h"
#import "AttentionManager.h"
#import "HMSegmentedControl.h"
#import "CircleManager.h"
#import "UserPostTableCell.h"
#import "MJRefresh.h"
#import "CommentViewController.h"

@interface OtherUserController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) UserPost *userPost;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *dataArray;
@property (nonatomic) OtherHeadView *headView;

@end

@implementation OtherUserController{
    HMSegmentedControl *segmentedControl;
    NSInteger currentIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人主页";
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-UI_STATUS_BAR_HEIGHT) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self fetchUserData];
    }];
    
    _headView = [[OtherHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, GENERAL_SIZE(370))];
     [_headView updateWithUser:_userInfo];
    _tableView.tableHeaderView = _headView;
    
    [_tableView.header beginRefreshing];
}

-(void)fetchUserData{
    CircleManager *cm = [[CircleManager alloc]init];
    [cm fetchUserPostListWithUserId:_userInfo.userId Success:^(UserPostResult *result) {
        _userPost = result.userPost;
        User *userInfo = [[User alloc]init];
        userInfo.userId = _userPost.userId;
        userInfo.name = _userPost.name;
        userInfo.avatar = _userPost.avator;
        userInfo.signature = _userPost.sign;
        [_headView updateWithUser:userInfo];
        
        _dataArray = result.userPost.deployList;
        [_tableView reloadData];
        [self.tableView.header endRefreshing];
    } Failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
    }];
}

-(void)attendUser:(NSString*)type{
    OLA_LOGIN;
    AttentionManager *atm = [[AttentionManager alloc]init];
    [atm attendOtherWithUserId:am.userInfo.userId AttendedId:_userInfo.userId Type:type success:^(CommonResult *result) {
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma tableview

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return GENERAL_SIZE(100);
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, GENERAL_SIZE(100))];
    view.backgroundColor = RGBCOLOR(235, 235, 235);
    
    if (!segmentedControl) {
        segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, GENERAL_SIZE(20), SCREEN_WIDTH, GENERAL_SIZE(78))];
        segmentedControl.sectionTitles = @[@"TA的提问",@"TA的回答"];
        segmentedControl.selectedSegmentIndex = 0;
        
        segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : RGBCOLOR(81, 84, 93), NSFontAttributeName : LabelFont(32)};
        segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : COMMONBLUECOLOR, NSFontAttributeName: LabelFont(32)};
        segmentedControl.selectionIndicatorColor = COMMONBLUECOLOR;
        segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        segmentedControl.selectionIndicatorHeight = 2;
        segmentedControl.selectionIndicatorBoxOpacity = 0;
        
        segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        segmentedControl.backgroundColor = [UIColor whiteColor];
        segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
        
        __weak OtherUserController* wself = self;
        [segmentedControl setIndexChangeBlock:^(NSInteger index) {
            currentIndex = index;
            if (index==0) {
                _dataArray = _userPost.deployList;
            }else{
                _dataArray = _userPost.replyList;
            }
            [wself.tableView reloadData];
        }];
    }
    [view addSubview:segmentedControl];
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserPostTableCell *cell = [[UserPostTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"userPostTableCell"];
    OlaCircle *circle = [_dataArray objectAtIndex:indexPath.row];
    [cell setupCell:circle Type:currentIndex];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OlaCircle *circle = [_dataArray objectAtIndex:indexPath.row];
    CommentViewController *commentVC = [[CommentViewController alloc]init];
    commentVC.postId = circle.circleId;
    [self.navigationController pushViewController:commentVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return GENERAL_SIZE(130);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
