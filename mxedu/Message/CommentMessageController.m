//
//  CommentMessageController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/12/14.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "CommentMessageController.h"

#import "SysCommon.h"
#import "MJRefresh.h"
#import "Comment.h"
#import "AuthManager.h"
#import "MessageManager.h"
#import "MessageCommonTableCell.h"
#import "CourSectionViewController.h"
#import "BannerWebViewController.h"
#import "CommodityViewController.h"
#import "CommentViewController.h"

@interface CommentMessageController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *dataArray;

@end

@implementation CommentMessageController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"评论消息";
    
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

-(void)setupData:(NSString*)commentId{
    AuthManager *am = [AuthManager sharedInstance];
    MessageManager *mm = [[MessageManager alloc]init];
    [mm fetchCommentMessageListWithCommentId:commentId UserId:am.userInfo.userId PageSize:@"20" Success:^(CommentListResult *result) {
        if ([commentId isEqualToString:@""]) {
            if ([result.commentArray count]==20) {
                self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    Comment *comment = [_dataArray lastObject];
                    if (comment) {
                        [self setupData:comment.data_id];
                    }
                }];
            }
            [_dataArray removeAllObjects];
        }
        [_dataArray addObjectsFromArray:result.commentArray];
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
            Comment *comment = [_dataArray objectAtIndex:index];
            [_dataArray setObject:comment atIndexedSubscript:index];
            [_tableView reloadData];
        }
    } Failure:^(NSError *error) {
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageCommonTableCell *cell = [[MessageCommonTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"messageTableCell"];
    Comment *comment = [_dataArray objectAtIndex:indexPath.row];
    [cell setupCell:comment];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Comment *comment = [_dataArray objectAtIndex:indexPath.row];
    CommentViewController *commentVC = [[CommentViewController alloc]init];
    commentVC.postId = comment.postId;
    [self.navigationController pushViewController:commentVC animated:YES];
    if([comment.isRead isEqualToString:@"0"]){
        comment.isRead = @"1";
        [_dataArray setObject:comment atIndexedSubscript:indexPath.row];
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

