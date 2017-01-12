//
//  HomeworkChooseController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/9/30.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "HomeworkChooseController.h"

#import "AuthManager.h"
#import "CourseManager.h"
#import "ExamManager.h"
#import "PayManager.h"
#import "Course.h"
#import "QuestionWebController.h"
#import "HomeworkWebController.h"
#import "ExamTableCell.h"
#import "ChoiceTableCell.h"

#import "HomeworkView.h"
#import "ZSYPopoverListView.h"
#import "HMSegmentedControl.h"

#import "MJRefresh.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LoginViewController.h"
#import "StuHomeworkController.h"

@interface HomeworkChooseController ()<HomeworkViewDelegate,ZSYPopoverListDatasource, ZSYPopoverListDelegate>

@property (nonatomic) NSArray *dataArray; //考点数据
@property (nonatomic) NSArray *examArray; //模考或真题数据
@property (nonatomic) HomeworkView *homeworkView;
@property (nonatomic) ZSYPopoverListView *listView;
@property (nonatomic) UILabel *secLabel;

@property (nonatomic) NSArray *choiceArray;
@property (nonatomic) NSInteger selectedIndex;

@property (nonatomic) Course *currentCourse;

@property (nonatomic) Homework *homework; //当前作业

@end

@implementation HomeworkChooseController

@synthesize mainItemsAmt, subItemsAmt, groupCell;

#pragma mark - Class lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"作业发布";
    [self setupBackButton];
    
    NSArray *mathArray = [NSArray arrayWithObjects:@"陈剑数学高分指南",@"数学预测八套卷",@"历年真题名家详解", nil];
    NSArray *engArray = [NSArray arrayWithObjects:@"阅读基本功之长难句",@"薛冰英语阅读理解",@"历年真题名家详解", nil];
    NSArray *logicArray = [NSArray arrayWithObjects:@"杨武金逻辑顿悟精炼",@"逻辑预测八套卷",@"历年真题名家详解", nil];
    NSArray *writeArray = [NSArray arrayWithObjects:@"陈君华写作高分指南",@"写作预测八套卷",@"历年真题名家详解", nil];
    switch ([_subjectId intValue]) {
        case 1:
            _choiceArray = mathArray;
            break;
        case 2:
            _choiceArray = engArray;
            break;
        case 3:
            _choiceArray = logicArray;
            break;
        case 4:
            _choiceArray = writeArray;
            break;
    }
    
    subItemsAmt = [[NSMutableDictionary alloc] initWithDictionary:nil];
    expandedIndexes = [[NSMutableDictionary alloc] init];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self setupData];
    }];
    
    [self setupData];

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void)setupData{
    
    NSString *userId = @"";
    AuthManager *am = [AuthManager sharedInstance];
    if (am.isAuthenticated) {
        userId = am.userInfo.userId;
    }
    
    if (self.selectedIndex==0) {
        [self fetchCourseListWithUserId:userId];
    }else{
        [self fetchExamListWithUserId:userId];
    }
}

-(void)fetchCourseListWithUserId:(NSString*)userId{
    
    CourseManager *cm = [[CourseManager alloc]init];
    [cm fetchCourseListWithID:_subjectId Type:@"1" UserId:userId Success:^(CourseListResult *result) {
        _currentCourse = result.course;
        [_homeworkView setupViewWithModel:_currentCourse.homework];
        _homework = _currentCourse.homework;
        _dataArray = result.course.subList;
        [self.tableView.header endRefreshing];
        [self.tableView reloadData];
    } Failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
    }];
}

-(void)fetchExamListWithUserId:(NSString*)userId{
    ExamManager *em = [[ExamManager alloc]init];
    [em fetchExamListWithCourseID:_subjectId Type:[NSString stringWithFormat:@"%ld",self.selectedIndex] UserId:userId
                          Success:^(ExamListRsult *result) {
                              _examArray = result.examArray;
                              [self.tableView.header endRefreshing];
                              [self.tableView reloadData];
                          } Failure:^(NSError *error) {
                              [self.tableView.header endRefreshing];
                          }];
}

-(void)showLoginView{
    LoginViewController* loginViewCon = [[LoginViewController alloc] init];
    UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:loginViewCon];
    [self presentViewController:rootNav animated:YES completion:^{}
     ];
}

-(void)showChoiceView{
    _listView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _listView.datasource = self;
    _listView.delegate = self;
    [_listView setCancelButtonTitle:@"关闭" block:^{
    }];
    
    [_listView show];
}

#pragma mark - TableView delegation

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.selectedIndex==0) {
        return [_dataArray count];
    }else{
        return [_examArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedIndex==0) {
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
    }else{
        ExamTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExamCell"];
        if (cell == nil)
        {
            cell = [[ExamTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ExamCell"];
        }
        Examination *exam = [_examArray objectAtIndex:indexPath.row];
        [cell setCellWithModel:exam];
        return cell;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedIndex==0) {
        int amt = [[subItemsAmt objectForKey:indexPath] intValue];
        BOOL isExpanded = [[expandedIndexes objectForKey:indexPath] boolValue];
        if(isExpanded)
        {
            return [SDGroupCell getHeight] + [SDGroupCell getsubCellHeight]*amt + 1;
        }
        return [SDGroupCell getHeight];
    }else{
        return GENERAL_SIZE(150);
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.selectedIndex!=0){
        Examination *examination = [_examArray objectAtIndex:indexPath.row];
        [self chooseQuestionWithObjectId:examination.examId Type:2];
    }
}

#pragma mark - Nested Tables events

- (void) groupCell:(SDGroupCell *)cell didSelectSubCell:(SDGroupCell *)subCell withIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *groupCellIndexPath = [self.tableView indexPathForCell:cell];
    Course *course = [_dataArray objectAtIndex:groupCellIndexPath.row];
    if (course.subList) {
        Course *subCourse = [course.subList objectAtIndex:indexPath.row];
        [self chooseQuestionWithObjectId:subCourse.courseId Type:1];
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

// 勾选题目页面
-(void)chooseQuestionWithObjectId:(NSString*)objectId Type:(int)type{
    HomeworkWebController *homeworkWC = [[HomeworkWebController alloc]init];
    homeworkWC.type = type;
    homeworkWC.objectId = objectId;
    homeworkWC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:homeworkWC animated:YES];
}


#pragma HomeworkViewDelegate
-(void)didClickBrowseMore{
    OLA_LOGIN;
    StuHomeworkController *homeworkV = [[StuHomeworkController alloc]init];
    homeworkV.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:homeworkV animated:YES];
}

#pragma mark -
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

@end
