//
//  HomeworkStatisticsController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/10/15.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "HomeworkStatisticsController.h"

#import "SysCommon.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import "HomeworkManager.h"
#import "UIColor+HexColor.h"
#import "WorkStatisticsTableCell.h"

@interface HomeworkStatisticsController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *dataArray;

@property (nonatomic) UILabel *correctLabel;
@property (nonatomic) UILabel *finishLabel;

@end

@implementation HomeworkStatisticsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"完成情况";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
    [self setupHeadView];
    
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self setupData:@"1"];
    }];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        int pageIndex = [_dataArray count]%20==0?(int)[_dataArray count]/20+1:(int)[_dataArray count]/20+2;
        [self setupData:[NSString stringWithFormat:@"%d",pageIndex]];
    }];
    
    [self.tableView.header beginRefreshing];
}

-(void)setupHeadView{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, GENERAL_SIZE(470))];
    // 渐变色 创建 CAGradientLayer 对象
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = headView.bounds;
    
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(id)[UIColor colorWhthHexString:@"#2196f3"].CGColor,
                             (id)[UIColor  colorWhthHexString:@"#4285f4"].CGColor];
    
    //  设置三种颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@(0.5f) ,@(1.0f)];
    
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    
    [headView.layer addSublayer:gradientLayer];
    
    UIView *correctV = [[UILabel alloc]init];
    correctV.backgroundColor = [UIColor whiteColor];
    correctV.layer.masksToBounds = YES;
    correctV.layer.cornerRadius = GENERAL_SIZE(150);
    [headView addSubview:correctV];
    
    [correctV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(GENERAL_SIZE(300)));
        make.height.equalTo(@(GENERAL_SIZE(300)));
        make.centerX.equalTo(headView);
        make.centerY.equalTo(headView).offset(-(GENERAL_SIZE(20)));
    }];
    
    _correctLabel = [[UILabel alloc]init];
    _correctLabel.textColor = COMMONBLUECOLOR;
    _correctLabel.font = LabelFont(108);
    [headView addSubview:_correctLabel];
    
    [_correctLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(correctV);
    }];
    
    UILabel *percentL = [[UILabel alloc]init];
    percentL.text = @"%";
    percentL.textColor = RGBCOLOR(164, 192, 250);
    percentL.font = LabelFont(24);
    [headView addSubview:percentL];
    
    [percentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_correctLabel.mas_bottom).offset(-GENERAL_SIZE(20));
        make.left.equalTo(_correctLabel.mas_right);
    }];
    
    UILabel *correctL = [[UILabel alloc]init];
    correctL.text = @"作业正确率";
    correctL.textColor = RGBCOLOR(164, 192, 250);
    correctL.font = LabelFont(24);
    [headView addSubview:correctL];
    
    [correctL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_correctLabel.mas_bottom);
        make.centerX.equalTo(correctV);
    }];
    
    _finishLabel = [[UILabel alloc]init];
    _finishLabel.textColor = [UIColor whiteColor];
    _finishLabel.font = LabelFont(28);
    [headView addSubview:_finishLabel];
    
    [_finishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(correctV);
        make.bottom.equalTo(headView.mas_bottom).offset(-GENERAL_SIZE(30));
    }];
    
    _tableView.tableHeaderView = headView;
}

-(void)setupData:(NSString*)pageIndex{
    HomeworkManager *hm = [[HomeworkManager alloc]init];
    [hm fetchHomeworkStatisticsWithHomeworkId:_homework.homeworkId GroupId:_homework.groupId PageIndex:pageIndex PageSize:@"20" Success:^(WorkStatisticsListResult *result) {
        if ([pageIndex isEqualToString:@"1"]) {
            _correctLabel.text = result.workStatistics.correctness;
            _finishLabel.text = [NSString stringWithFormat:@"%@完成，%@未完成",result.workStatistics.finishedCount,result.workStatistics.unfinishedCount];
            [_dataArray removeAllObjects];
        }
        [_dataArray addObjectsFromArray:result.workStatistics.statisticsList];
        [_tableView reloadData];
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
    } Failure:^(NSError *error) {
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return GENERAL_SIZE(80);
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, GENERAL_SIZE(80))];
    view.backgroundColor = [UIColor colorWhthHexString:@"#f8f8f8"];
    UILabel *finishL = [[UILabel alloc]initWithFrame:CGRectMake(GENERAL_SIZE(20), 0, 200, GENERAL_SIZE(80))];
    finishL.text = @"完成情况";
    finishL.font = LabelFont(34);
    finishL.textColor = RGBCOLOR(81, 83, 93);
    [view addSubview:finishL];
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"workCell";
    WorkStatisticsTableCell *groupCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (groupCell == nil) {
        groupCell = [[WorkStatisticsTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"workCell"];
    }
    StatisticsUser *user = [_dataArray objectAtIndex:indexPath.row];
    [groupCell setupCellWithModel:user];
    groupCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return groupCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return GENERAL_SIZE(140);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
