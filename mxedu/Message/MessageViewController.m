//
//  MessageViewController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/7/19.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "MessageViewController.h"

#import "SysCommon.h"
#import "MJRefresh.h"
#import "AuthManager.h"
#import "MessageManager.h"
#import "MessageTableCell.h"
#import "CourSectionViewController.h"
#import "BannerWebViewController.h"
#import "CommodityViewController.h"

@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *dataArray;

@end

@implementation MessageViewController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"系统消息";
    
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

-(void)setupData:(NSString*)messageId{
    AuthManager *am = [AuthManager sharedInstance];
    MessageManager *mm = [[MessageManager alloc]init];
    [mm fetchMessageListWithMessageId:messageId UserId:am.userInfo.userId PageSize:@"20" Success:^(MessageListResult *result) {
        if ([messageId isEqualToString:@""]) {
            if ([result.messageArray count]==20) {
                self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    Message *message = [_dataArray lastObject];
                    if (message) {
                        [self setupData:message.messageId];
                    }
                }];
            }
            [_dataArray removeAllObjects];
        }
        [_dataArray addObjectsFromArray:result.messageArray];
        [_tableView reloadData];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    } Failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
}

-(void)updateReadStatus:(NSString*)messageIds Index:(NSInteger)index{
    AuthManager *am = [AuthManager sharedInstance];
    MessageManager *mm = [[MessageManager alloc]init];
    [mm updateReadStatusWithUserId:am.userInfo.userId MessageIds:messageIds Success:^(CommonResult *result) {
        if (result.code==10000) {
            Message *message = [_dataArray objectAtIndex:index];
            message.status = @"1";
            [_dataArray setObject:message atIndexedSubscript:index];
            [_tableView reloadData];
        }
    } Failure:^(NSError *error) {
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageTableCell *cell = [[MessageTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"messageTableCell"];
    Message *message = [_dataArray objectAtIndex:indexPath.row];
    [cell setupCell:message];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Message *message = [_dataArray objectAtIndex:indexPath.row];
    if (![message.status isEqualToString:@"1"]) {
        [self updateReadStatus:message.messageId Index:indexPath.row];
    }
    if ([message.type isEqualToString:@"2"]) {
        CourSectionViewController *courseVC = [[CourSectionViewController alloc]init];
        courseVC.type=1;
        courseVC.objectId = message.otherId;
        [self.navigationController pushViewController:courseVC animated:YES];
    }else if ([message.type isEqualToString:@"3"]) {
        BannerWebViewController *bannerVC = [[BannerWebViewController alloc]init];
        bannerVC.url = message.url;
        [self.navigationController pushViewController:bannerVC animated:YES];
    }else if ([message.type isEqualToString:@"4"]) {
        CommodityViewController *commodityVC = [[CommodityViewController alloc]init];
        commodityVC.currentType = @"1";
        [self.navigationController pushViewController:commodityVC animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return GENERAL_SIZE(160);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
