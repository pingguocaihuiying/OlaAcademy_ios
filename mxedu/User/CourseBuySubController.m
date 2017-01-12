//
//  CourseBuySubController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/5/26.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "CourseBuySubController.h"

#import "CommodityManager.h"
#import "BuyTableCell.h"

#import "SysCommon.h"
#import "AuthManager.h"
#import "CourSectionViewController.h"
#import "Masonry.h"
#import "MJRefresh.h"

@interface CourseBuySubController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) UITableView *tableView;

@end

@implementation CourseBuySubController{
    
    NSArray *commodityArray;
    
    UIView *defaultView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-220) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self fetchCourseVideo];
    }];
    
    defaultView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-220)];
    defaultView.backgroundColor = [UIColor whiteColor];
    
    UILabel *tipLabel = [UILabel new];
    tipLabel.text = @"您的列表是空的";
    tipLabel.textColor = RGBCOLOR(125, 125, 125);
    [defaultView addSubview:tipLabel];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:[UIImage imageNamed:@"ic_add_course"] forState:UIControlStateNormal];
    [addButton sizeToFit];
    [addButton addTarget:self action:@selector(addCourse) forControlEvents:UIControlEventTouchDown];
    [defaultView addSubview:addButton];
    
    [self.view addSubview:defaultView];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(defaultView);
        if (iPhone6Plus) {
            make.top.equalTo(defaultView.mas_top).offset(50);
        }else if (iPhone6) {
            make.top.equalTo(defaultView.mas_top).offset(30);
        }else{
            make.top.equalTo(defaultView.mas_top).offset(20);
        }
    }];
    
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(defaultView);
    }];
    
    [self fetchCourseVideo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchCourseVideo) name:@"NEEDREFRESH" object:nil];
}

-(void)addCourse{
    self.navigationController.tabBarController.selectedIndex = 2;
}

-(void)refreshData{
    if ([commodityArray count]==0) {
        [self fetchCourseVideo];
    }
}

-(void)fetchCourseVideo{
    CommodityManager *cm = [[CommodityManager alloc]init];
    AuthManager *am = [[AuthManager alloc]init];
    if (am.isAuthenticated) {
        [cm fetchBuyCommodityListWithUserId:am.userInfo.userId Success:^(CommodityListRsult *result) {
            commodityArray = result.commodityArray;
            if ([commodityArray count]>0) {
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
        commodityArray = [[NSArray alloc]init];;
        [_tableView reloadData];
        defaultView.hidden = NO;
    }
}

#pragma tableview delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [commodityArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BuyTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[BuyTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"buyCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Commodity *commodity = [commodityArray objectAtIndex:indexPath.row];
    [cell setupCellWithModel:commodity];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Commodity *commodity = [commodityArray objectAtIndex:indexPath.row];
    CourSectionViewController *sectionVC = [[CourSectionViewController alloc]init];
    sectionVC.objectId = commodity.comId;
    sectionVC.type = 2;
    sectionVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sectionVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
