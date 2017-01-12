//
//  CoinHistoryController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/10/19.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "CoinHistoryController.h"

#import "SysCommon.h"
#import "CoinHistoryTableCell.h"

#import "MJRefresh.h"
#import "AuthManager.h"
#import "CoinManager.h"

@interface CoinHistoryController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *dataArray;

@end

@implementation CoinHistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"欧拉币明细";
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-UI_STATUS_BAR_HEIGHT) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = RGBCOLOR(235, 235, 235);
    [self.view addSubview:_tableView];
    
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self setupData];
    }];
    
    [_tableView.header beginRefreshing];
    
}

-(void)setupData{
    AuthManager *am = [[AuthManager alloc]init];
    if (!am.isAuthenticated) {
        return;
    }
    CoinManager *cm = [[CoinManager alloc]init];
    [cm fetchCoinHistoryListWithUserId:am.userInfo.userId Success:^(CoinHistoryListResult *result) {
        _dataArray = result.historyArray;
        [_tableView reloadData];
        [_tableView.header endRefreshing];
    } Failure:^(NSError *error) {
        [_tableView.header endRefreshing];
    }];
}

#pragma tableview

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"userCell";
    CoinHistoryTableCell *coinCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (coinCell == nil) {
        coinCell = [[CoinHistoryTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"userCell"];
    }
    CoinHistory *model = [_dataArray objectAtIndex:indexPath.row];
    [coinCell setupCellWithModel:model];
    coinCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return coinCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return GENERAL_SIZE(130);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
