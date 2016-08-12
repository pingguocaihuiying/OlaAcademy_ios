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
#import "ExamManager.h"
#import "MessageManager.h"
#import "PayManager.h"
#import "Course.h"
#import "QuestionWebController.h"
#import "ExamTableCell.h"
#import "ChoiceTableCell.h"

#import "HomeworkView.h"
#import "ZSYPopoverListView.h"
#import "HMSegmentedControl.h"

#import "MJRefresh.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MessageViewController.h"
#import "LoginViewController.h"
#import "HomeworkViewController.h"
#import "IAPVIPController.h"
#import "VIPSubController.h"

@interface QuestionViewController ()<HomeworkViewDelegate,ZSYPopoverListDatasource, ZSYPopoverListDelegate,UIAlertViewDelegate>

@property (nonatomic) UIImageView *messageBtn;

@property (nonatomic) NSArray *dataArray; //考点数据
@property (nonatomic) NSArray *examArray; //模考或真题数据
@property (nonatomic) HomeworkView *homeworkView;
@property (nonatomic) ZSYPopoverListView *listView;
@property (nonatomic) UILabel *secLabel;

@property (nonatomic) NSArray *subjectArray;
@property (nonatomic) NSArray *choiceArray;
@property (nonatomic) NSInteger selectedIndex;

@property (nonatomic) NSString *subjectId;//当前科目ID
@property (nonatomic) Course *currentCourse;

@property (nonatomic) Homework *homework; //当前作业

@property (nonatomic) int payStatus; //0 iap支付 1 支付宝 微信支付

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
    
    [self fetchPayModuleStatus];
    
    self.navigationItem.title = @"考点";
    [self setupRightButton];
    [self setupHeadView];
    
    NSArray *mathArray = [NSArray arrayWithObjects:@"陈剑数学高分指南",@"数学预测八套卷",@"历年真题名家详解", nil];
    NSArray *engArray = [NSArray arrayWithObjects:@"阅读基本功之长难句",@"薛冰英语阅读理解",@"历年真题名家详解", nil];
    NSArray *logicArray = [NSArray arrayWithObjects:@"杨武金逻辑顿悟精炼",@"逻辑预测八套卷",@"历年真题名家详解", nil];
    NSArray *writeArray = [NSArray arrayWithObjects:@"陈君华写作高分指南",@"写作预测八套卷",@"历年真题名家详解", nil];
    _subjectArray = [NSArray arrayWithObjects:mathArray,engArray,logicArray,writeArray, nil];
    _choiceArray = mathArray;
    
    subItemsAmt = [[NSMutableDictionary alloc] initWithDictionary:nil];
    expandedIndexes = [[NSMutableDictionary alloc] init];
    
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

/**
 *  分类视图
 */
- (void)setupHeadView
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, GENERAL_SIZE(360))];
    
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, GENERAL_SIZE(80))];
    segmentedControl.sectionTitles = @[@"数学",@"英语", @"逻辑", @"写作"];
    segmentedControl.selectedSegmentIndex = 0;
    
    segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor lightGrayColor], NSFontAttributeName : LabelFont(32)};
    segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : COMMONBLUECOLOR, NSFontAttributeName: LabelFont(32)};
    segmentedControl.selectionIndicatorColor = COMMONBLUECOLOR;
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
    segmentedControl.selectionIndicatorHeight = 2;
    segmentedControl.selectionIndicatorBoxOpacity = 0;
    
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl.backgroundColor = [UIColor whiteColor];
    segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    [headView addSubview:segmentedControl];
    
    
    _homeworkView = [[HomeworkView alloc]initWithFrame:CGRectMake(0, GENERAL_SIZE(80), SCREEN_WIDTH, GENERAL_SIZE(280))];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showQuestionWebView)];
    _homeworkView.userInteractionEnabled = YES;
    _homeworkView.delegate = self;
    [_homeworkView addGestureRecognizer:tap];
    [headView addSubview:_homeworkView];
    
    self.tableView.tableHeaderView = headView;
    
    _subjectId = @"1";
    
    [segmentedControl setIndexChangeBlock:^(NSInteger index) {
        _subjectId = [NSString stringWithFormat:@"%d",(int)index+1];
        _choiceArray = [_subjectArray objectAtIndex:index];
        _secLabel.text = [_choiceArray objectAtIndex:self.selectedIndex];
        [self setupData];
    }];
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

// 后台控制是否显示支付相关功能
-(void)fetchPayModuleStatus{
    PayManager *pm = [[PayManager alloc]init];
    [pm fetchPayModuleStatusSuccess:^(StatusResult *result) {
        _payStatus = result.status;
    } Failure:^(NSError *error) {
        
    }];
}

-(void)setupData{
    
    NSString *userId = @"";
    AuthManager *am = [[AuthManager alloc]init];
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

-(void)showQuestionWebView{
    OLA_LOGIN;
    if (_homework) {
        QuestionWebController *questionVC = [[QuestionWebController alloc]init];
        questionVC.titleName = _homework.name;
        questionVC.objectId = _homework.homeworkId;
        questionVC.type = 3;
        questionVC.callbackBlock = ^{
            [self setupData];
        };
        questionVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:questionVC animated:YES];
    }
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
    //SDGroupCell *cell = (SDGroupCell *)[tableView cellForRowAtIndexPath:indexPath];
    if(self.selectedIndex!=0){
        Examination *examination = [_examArray objectAtIndex:indexPath.row];
        if([examination.isfree intValue]==1){
            QuestionWebController *questionVC = [[QuestionWebController alloc]init];
            if (self.selectedIndex==1) {
                questionVC.titleName = @"模拟考试";
            }else{
                questionVC.titleName = @"真题练习";
            }
            questionVC.objectId = examination.examId;
            questionVC.type = 2;
            if ([_subjectId isEqualToString:@"2"]) { //英语类
                questionVC.hasArticle = 1;
            }
            questionVC.callbackBlock = ^{
                [self setupData];
            };
            questionVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:questionVC animated:YES];
        }else{
            OLA_LOGIN;
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"友情提示" message:@"购买会员后即可拥有" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"去购买",nil];
            [alert show];
        }

    }
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
        questionVC.callbackBlock = ^{
            [self setupData];
        };
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

#pragma HomeworkViewDelegate
-(void)didClickBrowseMore{
    OLA_LOGIN;
    HomeworkViewController *homeworkV = [[HomeworkViewController alloc]init];
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

#pragma alertview delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        if (_payStatus==0) {
            IAPVIPController *iapVC =[[IAPVIPController alloc]init];
            iapVC.isSingleView = 1;
            iapVC.callbackBlock = ^{
                [self setupData];
            };
            iapVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:iapVC animated:YES];
        }else{
            VIPSubController *vipVC =[[VIPSubController alloc]init];
            vipVC.isSingleView = 1;
            vipVC.callbackBlock = ^{
                [self setupData];
            };
            vipVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vipVC animated:YES];
        }
        
    }
}

@end
