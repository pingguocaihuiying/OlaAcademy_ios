//
//  MessageMainController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/12/14.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "MessageMainController.h"

#import "SysCommon.h"
#import "MessageModel.h"
#import "MessageMainTableCell.h"
#import "CommentMessageController.h"
#import "PraiseMessageViewController.h"
#import "MessageViewController.h"

#import "AuthManager.h"
#import "MessageManager.h"

@interface MessageMainController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *dataArray;

@end

@implementation MessageMainController

-(void)viewWillAppear:(BOOL)animated{
    [self fetchMessageCount];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消息";
    [self setupData];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-UI_STATUS_BAR_HEIGHT) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

-(void)fetchMessageCount{
    AuthManager *am = [AuthManager sharedInstance];
    if (am.isAuthenticated) {
        MessageManager *mm = [[MessageManager alloc]init];
        [mm fetchUnreadCountWithUserId:am.userInfo.userId Success:^(MessageUnreadResult *result) {
            _messageCount = result.messageCount;
            [self setupData];
            [_tableView reloadData];
        } Failure:^(NSError *error) {
            
        }];
    }
}

-(void)setupData{
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    
    MessageModel *model1 = [[MessageModel alloc]init];
    model1.image = @"ic_circle_comment";
    model1.title = @"评论";
    model1.count = [NSString stringWithFormat:@"%d",_messageCount.circleCount];
    model1.detail = [NSString stringWithFormat:@"%d条待处理评论",_messageCount.circleCount];
    [_dataArray addObject:model1];
    
    MessageModel *model2 = [[MessageModel alloc]init];
    model2.image = @"ic_circle_praise";
    model2.title = @"赞";
    model2.count = [NSString stringWithFormat:@"%d",_messageCount.praiseCount];
    model2.detail = [NSString stringWithFormat:@"%d个点赞",_messageCount.praiseCount];
    [_dataArray addObject:model2];
    
    MessageModel *model3 = [[MessageModel alloc]init];
    model3.image = @"ic_circle_system";
    model3.title = @"系统消息";
    model3.count = [NSString stringWithFormat:@"%d",_messageCount.systemCount];
    model3.detail = [NSString stringWithFormat:@"%d条待阅读消息",_messageCount.systemCount];;
    [_dataArray addObject:model3];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"messageCell";
    MessageMainTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[MessageMainTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    MessageModel *model = [_dataArray objectAtIndex:indexPath.row];
    [cell setupCell:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            CommentMessageController *commentVC = [[CommentMessageController alloc]init];
            [self.navigationController pushViewController:commentVC animated:YES];
            break;
        }
        case 1:
        {
            PraiseMessageViewController *praiseVC = [[PraiseMessageViewController alloc]init];
            [self.navigationController pushViewController:praiseVC animated:YES];
            break;
        }
        case 2:
        {
            MessageViewController *systemVC = [[MessageViewController alloc]init];
            [self.navigationController pushViewController:systemVC animated:YES];
            break;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return GENERAL_SIZE(140);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
