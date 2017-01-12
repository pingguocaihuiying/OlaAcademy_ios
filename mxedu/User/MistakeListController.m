//
//  MistakeListController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/11/10.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "MistakeListController.h"

#import "SysCommon.h"
#import "MJRefresh.h"
#import "Masonry.h"

#import "AuthManager.h"
#import "LoginViewController.h"

#import "HMSegmentedControl.h"
#import "ZSYPopoverListView.h"

#import "MistakeTableCell.h"
#import "ChoiceTableCell.h"

#import "MistakeViewController.h"


@interface MistakeListController ()<UITableViewDelegate,UITableViewDataSource,ZSYPopoverListDatasource, ZSYPopoverListDelegate>

@property (nonatomic) ZSYPopoverListView *listView;

@property (nonatomic) NSArray *subjectArray;
@property (nonatomic) NSArray *choiceArray;
@property (nonatomic) NSInteger selectedIndex;

@property (nonatomic) UILabel *secLabel;

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *dataArray;

@property (nonatomic) NSString *subjectId;//当前科目ID

@end

@implementation MistakeListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"错题本";
    self.view.backgroundColor = [UIColor whiteColor];
    _subjectId = @"1";
    [self setupSegment];
    
    
    NSArray *mathArray = [NSArray arrayWithObjects:@"陈剑数学高分指南",@"数学预测八套卷",@"历年真题名家详解", nil];
    NSArray *engArray = [NSArray arrayWithObjects:@"阅读基本功之长难句",@"薛冰英语阅读理解",@"历年真题名家详解", nil];
    NSArray *logicArray = [NSArray arrayWithObjects:@"杨武金逻辑顿悟精炼",@"逻辑预测八套卷",@"历年真题名家详解", nil];
    NSArray *writeArray = [NSArray arrayWithObjects:@"陈君华写作高分指南",@"写作预测八套卷",@"历年真题名家详解", nil];
    _subjectArray = [NSArray arrayWithObjects:mathArray,engArray,logicArray,writeArray, nil];
    _choiceArray = mathArray;

    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, GENERAL_SIZE(80), SCREEN_WIDTH, SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-UI_STATUS_BAR_HEIGHT-GENERAL_SIZE(80))];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self setupData];
    }];
    
    [self.tableView.header beginRefreshing];
    
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
        _choiceArray = [_subjectArray objectAtIndex:index];
        _secLabel.text = [_choiceArray objectAtIndex:self.selectedIndex];
        [self setupData];
    }];
    
}

-(void)showChoiceView{
    _listView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _listView.datasource = self;
    _listView.delegate = self;
    [_listView setCancelButtonTitle:@"关闭" block:^{
    }];
    
    [_listView show];
}


-(void)setupData{
    AuthManager *am = [AuthManager sharedInstance];
    CourseManager *cm = [[CourseManager alloc]init];
    if (am.userInfo) {
        [cm fetchMistakeListWithUserId:am.userInfo.userId Type:[NSString stringWithFormat:@"%d",(int)_selectedIndex+1] SubjetcType:_subjectId Success:^(MistakeListResult *result) {
            _dataArray = result.mistakeArray;
            [_tableView reloadData];
            [self.tableView.header endRefreshing];
        } Failure:^(NSError *error) {
            [self.tableView.header endRefreshing];
        }];
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *secView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, GENERAL_SIZE(60))];
    secView.backgroundColor = RGBCOLOR(240, 240, 240);
    if (!_secLabel) {
        _secLabel = [[UILabel alloc]init];
        _secLabel.font = LabelFont(32);
        _secLabel.textColor = RGBCOLOR(81, 83, 93);
        _secLabel.text = [_choiceArray objectAtIndex:0];
    }
    UIImageView *pulldown = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_pulldown"]];
    
    secView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showChoiceView)];
    [secView addGestureRecognizer:tap];
    [secView addSubview:_secLabel];
    [secView addSubview:pulldown];
    
    [_secLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(secView).offset(-10);
        make.centerY.equalTo(secView);
    }];
    [pulldown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_secLabel);
        make.left.equalTo(_secLabel.mas_right).offset(5);
    }];
    return secView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return GENERAL_SIZE(80);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"mistakeCell";
    MistakeTableCell *mistakeCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (mistakeCell == nil) {
        mistakeCell = [[MistakeTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mistakeCell"];
    }
    Mistake *mistake = [_dataArray objectAtIndex:indexPath.row];
    [mistakeCell setupCellWithModel:mistake];
    mistakeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return mistakeCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return GENERAL_SIZE(150);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MistakeViewController *mistakeVC = [[MistakeViewController alloc]init];
    Mistake *mistake = [_dataArray objectAtIndex:indexPath.row];
    mistakeVC.objectId = mistake.mistakeId;
    mistakeVC.updateSuccess = ^void(){
        [self setupData];
    };
    if (_selectedIndex==0) {
        mistakeVC.type = @"1";
    }else{
        mistakeVC.type = @"2";
    }
    mistakeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mistakeVC animated:YES];
}


#pragma mark - 科目列表
- (NSInteger)popoverListView:(ZSYPopoverListView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_choiceArray count];
}

- (UITableViewCell *)popoverListView:(ZSYPopoverListView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    ChoiceTableCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identifier];
    if (nil == cell)
    {
        cell = [[ChoiceTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if ( self.selectedIndex==indexPath.row)
    {
        cell.choiceIV.image = [UIImage imageNamed:@"icon_mark"];
    }
    else
    {
        cell.choiceIV.image = [UIImage imageNamed:@""];
    }
    cell.nameL.text = [_choiceArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)popoverListView:(ZSYPopoverListView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)popoverListView:(ZSYPopoverListView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChoiceTableCell *cell = (ChoiceTableCell*)[tableView popoverCellForRowAtIndexPath:indexPath];
    cell.choiceIV.image = [UIImage imageNamed:@"icon_mark"];
    
    self.selectedIndex = indexPath.row;
    _secLabel.text = [_choiceArray objectAtIndex:indexPath.row];
    [self setupData];
    [_listView dismiss];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
