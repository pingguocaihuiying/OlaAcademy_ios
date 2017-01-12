//
//  StuHomeworkController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/9/30.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "StuHomeworkController.h"

#import "SysCommon.h"
#import "HomeworkTableViewObject.h"

#import "HomeworkManager.h"
#import "AuthManager.h"
#import "MonthHomework.h"
#import "MJRefresh.h"

#import "GroupViewController.h"
#import "QuestionWebController.h"

@interface StuHomeworkController ()<MeetingTableViewDelegate>

@property (nonatomic) UIImageView *groupBtn;

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic) HomeworkTableViewObject *tableViewObject;
@property (nonatomic) NSString *userId;

@end

@implementation StuHomeworkController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的作业";
    [self setupBackButton];
    
    AuthManager *am = [AuthManager sharedInstance];
    if (am.isAuthenticated) {
        [self setupTableView];
        _userId = am.userInfo.userId;
        _dataSource = [[NSMutableArray alloc] init];
        [_tableView.header beginRefreshing];
    }
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

/**
 *  表格
 */
- (void)setupTableView
{
    _tableViewObject = [HomeworkTableViewObject new];
    _tableViewObject.delegate = self;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate = _tableViewObject;
    _tableView.dataSource = _tableViewObject;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self setupDataWithId:@""];
    }];
}

- (void)setupDataWithId:(NSString*)homeworkId
{
    HomeworkManager *hm = [[HomeworkManager alloc]init];
    [hm fetchHomeworkListWithHomeworkId:homeworkId PageSize:@"20" UserId:_userId Type:@"1" Success:^(HomeworkListResult *result) {
        
        if ([homeworkId isEqualToString:@""]) {
            if ([result.homeworkArray count]==20) {
                self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    Homework *homework = [_dataSource lastObject];
                    if (homework) {
                        [self setupDataWithId:homework.homeworkId];
                    }
                }];
            }
            [_dataSource removeAllObjects];
        }
        [_dataSource addObjectsFromArray:result.homeworkArray];
        _tableViewObject.dataSource = [self configDataWithArray:_dataSource];
        [_tableView reloadData];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    } Failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
}

/**
 *  整理数据
 *
 *  @param array
 *
 *  @return
 */
- (NSArray*)configDataWithArray:(NSArray*)array
{
    NSMutableArray *dataSource = [[NSMutableArray alloc] init];
    
    MonthHomework *monthModel = nil;
    
    for (Homework *item in array) {
        
        if (![item.month isEqualToString:monthModel.month]) {
            if (monthModel) {
                [dataSource addObject:monthModel];
            }
            
            monthModel = [[MonthHomework alloc] init];
            monthModel.homeworkArray = [[NSMutableArray alloc] init];
            monthModel.month = item.month;
        }
        
        if (item) {
            [monthModel.homeworkArray addObject:item];
        }
        
    }
    
    if (![dataSource containsObject:monthModel] && monthModel) {
        [dataSource addObject:monthModel];
    }
    
    return dataSource;
}

-(void)tableView:(UITableView *)tableView didSelectRowWithModel:(Homework *)model{
    QuestionWebController *questionVC = [[QuestionWebController alloc]init];
    questionVC.titleName = model.name;
    questionVC.objectId = model.homeworkId;
    questionVC.type = 3;
    questionVC.callbackBlock = ^{
        [self setupDataWithId:@""];
    };
    [self.navigationController pushViewController:questionVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
