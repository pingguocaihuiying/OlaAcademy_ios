//
//  QuestionViewController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/3/7.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "QuestionViewController.h"

#import "AuthManager.h"
#import "CourseManager.h"
#import "MessageManager.h"
#import "Course.h"
#import "QuestionWebController.h"
#import "BannerWebViewController.h"

#import "FilterView.h"
#import "MJRefresh.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MessageViewController.h"
#import "LoginViewController.h"

@interface QuestionViewController ()<FilterChooseDelegate>

@property (nonatomic) UIButton *titleBtn;
@property (nonatomic) UIImageView *messageBtn;

@property (nonatomic) NSArray *dataArray;
@property (nonatomic) UIImageView *headView;
@property (nonatomic) UILabel *secLabel;

@property (nonatomic) FilterView *filterView;// 遮罩筛选视图
@property (nonatomic) NSString *subjectId;//当前科目ID
@property (nonatomic) Course *currentCourse;

@end

@implementation QuestionViewController

@synthesize mainItemsAmt, subItemsAmt, groupCell;

#pragma mark - Class lifecycle

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [self fetchMessageCount]; //消息提醒
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavBar];
    [self setupRightButton];
    _subjectId = @"1";
    
    subItemsAmt = [[NSMutableDictionary alloc] initWithDictionary:nil];
    expandedIndexes = [[NSMutableDictionary alloc] init];
    
    _headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, GENERAL_SIZE(300))];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showWebView)];
    _headView.userInteractionEnabled = YES;
    [_headView addGestureRecognizer:tap];
    _headView.image = [UIImage imageNamed:@"ic_head_question"];
    [self.view addSubview:_headView];
    
    self.tableView.tableHeaderView = _headView;
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self setupData];
    }];
    
    [self setupData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupData) name:@"NEEDREFRESH" object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void)setupNavBar{
    _titleBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_titleBtn setFrame:CGRectMake(0, 0, 50, 20)];
    [_titleBtn setTitle:@"数学" forState:UIControlStateNormal];
    [_titleBtn setImage:[UIImage imageNamed:@"ic_pulldown"] forState:UIControlStateNormal];
    [_titleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
    [_titleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 30, 0, -30)];
    [_titleBtn addTarget:self action:@selector(showFilterView:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = _titleBtn;
}

-(void)setupRightButton{
    _messageBtn = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    _messageBtn.image = [UIImage imageNamed:@"icon_message"];
    _messageBtn.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showMessageView)];
    [_messageBtn addGestureRecognizer:singleTap];
    [_messageBtn sizeToFit];
    
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:_messageBtn];
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
}

-(void)setupData{
    NSString *userId = @"";
    AuthManager *am = [[AuthManager alloc]init];
    if (am.isAuthenticated) {
        userId = am.userInfo.userId;
    }
    CourseManager *cm = [[CourseManager alloc]init];
    [cm fetchCourseListWithID:_subjectId Type:@"1" UserId:userId Success:^(CourseListResult *result) {
        _currentCourse = result.course;
        if(_currentCourse.bannerPic){
            [_headView sd_setImageWithURL:[NSURL URLWithString: _currentCourse.bannerPic] placeholderImage:[UIImage imageNamed:@"ic_head_question"]];
        }
        _dataArray = result.course.subList;
        [self.tableView.header endRefreshing];
        [self.tableView reloadData];
    } Failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
    }];
}

-(void)fetchMessageCount{
    AuthManager *am = [[AuthManager alloc]init];
    if (am.isAuthenticated) {
        MessageManager *mm = [[MessageManager alloc]init];
        [mm fetchUnreadCountWithUserId:am.userInfo.userId Success:^(MessageUnreadResult *result) {
            if (result.code==10000&result.count>0) {
                _messageBtn.image = [UIImage imageNamed:@"icon_message_tip"];
            }else{
                _messageBtn.image = [UIImage imageNamed:@"icon_message"];
            }
        } Failure:^(NSError *error) {
            
        }];
    }
}

-(void)showWebView{
    if(_currentCourse){
        BannerWebViewController *webVC = [[BannerWebViewController alloc]init];
        webVC.url = _currentCourse.address;
        webVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

#pragma 下拉筛选

// 筛选视图
-(void)showFilterView:(UIButton*)btn{
    if(_filterView){
        _filterView.hidden = !_filterView.hidden;
        if (_filterView.hidden) {
            [_titleBtn setImage:[UIImage imageNamed:@"ic_pulldown"] forState:UIControlStateNormal];
        }else{
            [_titleBtn setImage:[UIImage imageNamed:@"ic_pullup"] forState:UIControlStateNormal];
        }
    }else{
        _filterView = [[FilterView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _filterView.delegate = self;
        [self.navigationController.view addSubview:_filterView]; //在nav上添加视图，避免随tableview滑动
        [_titleBtn setImage:[UIImage imageNamed:@"ic_pullup"] forState:UIControlStateNormal];
    }
}

// 筛选视图 delegate
-(void)didChooseSubject:(NSString*)subject Button: (UIButton *)button{
    _filterView.hidden = YES;
    
    [_titleBtn setTitle:subject forState:UIControlStateNormal];
    [_titleBtn setImage:[UIImage imageNamed:@"ic_pulldown"] forState:UIControlStateNormal];
    _subjectId = [NSString stringWithFormat:@"%ld",button.tag+1];
    [self setupData];
}

-(void)showMessageView{
    AuthManager *am = [[AuthManager alloc]init];
    if (!am.isAuthenticated) {
        [self showLoginView];
        return;
    }
    MessageViewController *messageVC = [[MessageViewController alloc]init];
    messageVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:messageVC animated:YES];
}

-(void)showLoginView{
    LoginViewController* loginViewCon = [[LoginViewController alloc] init];
    UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:loginViewCon];
    [self presentViewController:rootNav animated:YES completion:^{}
     ];
}

#pragma mark - TableView delegation

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *secView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, GENERAL_SIZE(60))];
    secView.backgroundColor = RGBCOLOR(240, 240, 240);
    _secLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-10, GENERAL_SIZE(60))];
    _secLabel.font = LabelFont(24);
    _secLabel.textColor = RGBCOLOR(144, 144, 144);
    if (_currentCourse) {
        _secLabel.text = _currentCourse.profile;
    }
    [secView addSubview:_secLabel];
    return secView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return GENERAL_SIZE(60);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell"];
    
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"SDGroupCell" owner:self options:nil];
        cell = groupCell;
        self.groupCell = nil;
    }
    
    [cell setParentTable: self];
    
    Course *course = [_dataArray objectAtIndex:indexPath.row];
    cell .itemText.text = course.name;
    [cell.progressView setProgress:[course.subNum floatValue]/[course.subAllNum floatValue] animated:YES];
    cell.progressL.text = [NSString stringWithFormat:@"%@/%@",course.subNum,course.subAllNum];
    cell.pointLabel.text = [NSString stringWithFormat:@"%ld个知识点",[course.subList count]];
    cell.course = course;
    
    NSNumber *amt = [NSNumber numberWithLong:[course.subList count]];
    [subItemsAmt setObject:amt forKey:indexPath];
    
    [cell setSubCellsAmt: [[subItemsAmt objectForKey:indexPath] intValue]];
    
    BOOL isExpanded = [[expandedIndexes objectForKey:indexPath] boolValue];
    cell.isExpanded = isExpanded;
    if(cell.isExpanded)
    {
        [cell rotateExpandBtnToExpanded];
    }
    else
    {
        [cell rotateExpandBtnToCollapsed];
    }
    
    [cell.subTable reloadData];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int amt = [[subItemsAmt objectForKey:indexPath] intValue];
    BOOL isExpanded = [[expandedIndexes objectForKey:indexPath] boolValue];
    if(isExpanded)
    {
        return [SDGroupCell getHeight] + [SDGroupCell getsubCellHeight]*amt + 1;
    }
    return [SDGroupCell getHeight];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //SDGroupCell *cell = (SDGroupCell *)[tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark - Nested Tables events

- (void) groupCell:(SDGroupCell *)cell didSelectSubCell:(SDGroupCell *)subCell withIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *groupCellIndexPath = [self.tableView indexPathForCell:cell];
    Course *course = [_dataArray objectAtIndex:groupCellIndexPath.row];
    if (course.subList) {
        Course *subCourse = [course.subList objectAtIndex:indexPath.row];
        QuestionWebController *questionVC = [[QuestionWebController alloc]init];
        questionVC.titleName = @"专项练习";
        questionVC.objectId = subCourse.courseId;
        questionVC.course = subCourse;
        questionVC.type = 1;
        questionVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:questionVC animated:YES];
    }
}

- (void) collapsableButtonTapped: (UIControl *) button withEvent: (UIEvent *) event
{
    UITableView *tableView = self.tableView;
    NSIndexPath * indexPath = [tableView indexPathForRowAtPoint: [[[event touchesForView: button] anyObject] locationInView: tableView]];
    if ( indexPath == nil )
        return;
    
    if ([[expandedIndexes objectForKey:indexPath] boolValue]) {
    }
    
    // reset cell expanded state in array
    BOOL isExpanded = ![[expandedIndexes objectForKey:indexPath] boolValue];
    NSNumber *expandedIndex = [NSNumber numberWithBool:isExpanded];
    [expandedIndexes setObject:expandedIndex forKey:indexPath];
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

@end
