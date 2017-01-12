//
//  PraiseMessageViewController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/12/19.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "PraiseMessageViewController.h"

#import "SysCommon.h"
#import "MJRefresh.h"
#import "CirclePraise.h"
#import "AuthManager.h"
#import "CircleManager.h"
#import "MessageCommonTableCell.h"
#import "CourSectionViewController.h"
#import "BannerWebViewController.h"
#import "CommodityViewController.h"
#import "CommentViewController.h"

@interface PraiseMessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *dataArray;

@end

@implementation PraiseMessageViewController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"赞过的人";
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-UI_STATUS_BAR_HEIGHT)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self setupData:@""];
    }];
    
    [self setupData:@""];
}

-(void)setupData:(NSString*)priaseId{
    AuthManager *am = [AuthManager sharedInstance];
    CircleManager *cm = [[CircleManager alloc]init];
    [cm fetchPraiseListWithUserId:am.userInfo.userId PraiseId:priaseId PageSize:@"20" Success:^(PraiseListResult *result) {
        if ([priaseId isEqualToString:@""]) {
            if ([result.praiseArray count]==20) {
                self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    CirclePraise *praise = [_dataArray lastObject];
                    if (praise) {
                        [self setupData:praise.praiseId];
                    }
                }];
            }
            [_dataArray removeAllObjects];
        }
        [_dataArray addObjectsFromArray:result.praiseArray];
        [_tableView reloadData];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    } Failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageCommonTableCell *cell = [[MessageCommonTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"messageTableCell"];
    CirclePraise *praise = [_dataArray objectAtIndex:indexPath.row];
    [cell setupCell:praise];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CirclePraise *praise = [_dataArray objectAtIndex:indexPath.row];
    CommentViewController *commentVC = [[CommentViewController alloc]init];
    commentVC.postId = praise.postId;
    [self.navigationController pushViewController:commentVC animated:YES];
    if([praise.isRead isEqualToString:@"0"]){
        praise.isRead = @"1";
        [_dataArray setObject:praise atIndexedSubscript:indexPath.row];
        [_tableView reloadData];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return GENERAL_SIZE(120);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


