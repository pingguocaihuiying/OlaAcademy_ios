//
//  CourseViewController.m
//  首页 课程页面（含推荐视频）
//
//  Created by 田晓鹏 on 15/10/19.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import "CourseViewController.h"

#import "SysCommon.h"
#import "CourseTableCell.h"
#import "XLCycleScrollView.h"
#import "TTTAttributedLabel.h"

#import "CourseManager.h"
#import "CourSectionViewController.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "PayManager.h"

#import "AuthManager.h"
#import "EnrollViewController.h"
#import "OrganizationViewController.h"
#import "CommodityViewController.h"
#import "BannerWebViewController.h"

#import "Masonry.h"

#import "CourseBarView.h"
#import "FilterView.h"


#define PUSH_TO_DOWNLOAD @"pushToMyDownload"

static const CGFloat kNavigtionHeight = 30.0;

@interface CourseViewController ()<UITableViewDataSource, UITableViewDelegate, XLCycleScrollViewDatasource, XLCycleScrollViewDelegate,CollectionCellDelegate,FilterChooseDelegate>

@property (nonatomic) UIButton *titleBtn;

@property (nonatomic) UITableView *courseTable;

@property (nonatomic) UIView *playView;

@property (nonatomic) BOOL barHidden;

@property (nonatomic) FilterView *filterView;// 遮罩筛选视图
@property (nonatomic) NSString *subjectId;//当前科目ID

@end

@implementation CourseViewController{
    
    /**
     *  轮播图
     */
    NSArray *_dataArray;
    
    /**
     *  轮播图
     */
    XLCycleScrollView *_bannerView;
    
    /**
     *  轮播图数据源
     */
    NSArray *_bannerArray;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _subjectId = @"1";
    
    _courseTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kNavigtionHeight) style:UITableViewStyleGrouped];
    _courseTable.separatorStyle = NO;
    _courseTable.dataSource = self;
    _courseTable.delegate = self;
    [self.view addSubview:_courseTable];
    
    self.courseTable.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self fetchCourseList];
    }];
    
    [self setupNavBar];
    
    [self fetchPayModuleStatus];
    
    [self fetchBannerList];
    [self fetchCourseList];
    
    //[self setupSlideMenu];
}

// 后台控制是否显示支付相关功能
-(void)fetchPayModuleStatus{
    PayManager *pm = [[PayManager alloc]init];
    [pm fetchPayModuleStatusSuccess:^(StatusResult *result) {
        [self setupHeadView:result.status];
    } Failure:^(NSError *error) {
        
    }];
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

-(void)setupHeadView:(int)status{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, GENERAL_SIZE(430))];
    [headView addSubview:[self bannerView]];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, GENERAL_SIZE(320), SCREEN_WIDTH, GENERAL_SIZE(10))];
    [headView addSubview:lineView1];
    
    CourseBarView *orgView = [[CourseBarView alloc]initWithFrame:CGRectMake(0, GENERAL_SIZE(330), SCREEN_WIDTH, GENERAL_SIZE(90))];
    [orgView setViewWithImage:@"ic_tutor" Title:@"名师辅导" Content:@"最优惠的线下辅导通道" ];
    orgView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToOrgView)];
    orgView.userInteractionEnabled = YES;
    [orgView addGestureRecognizer:tap1];
    [headView addSubview:orgView];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, GENERAL_SIZE(420), SCREEN_WIDTH, GENERAL_SIZE(10))];
    [headView addSubview:lineView2];
    
    if (status==1) {
        headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, GENERAL_SIZE(530));
        CourseBarView *courseView = [[CourseBarView alloc]initWithFrame:CGRectMake(0, GENERAL_SIZE(430), SCREEN_WIDTH, GENERAL_SIZE(90))];
        [courseView setViewWithImage:@"ic_course" Title:@"体系课程" Content:@"最权威的在线课程与匹配教材" ];
        courseView.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToComView)];
        courseView.userInteractionEnabled = YES;
        [courseView addGestureRecognizer:tap2];
        [headView addSubview:courseView];
        
        UIView *lineView5 = [[UIView alloc]initWithFrame:CGRectMake(0, GENERAL_SIZE(520), SCREEN_WIDTH, GENERAL_SIZE(10))];
        [headView addSubview:lineView5];
    }
    
    _courseTable.tableHeaderView = headView;
}

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
        _filterView = [[FilterView alloc]initWithFrame:self.view.bounds];
        _filterView.delegate = self;
        [self.view addSubview:_filterView];
        [_titleBtn setImage:[UIImage imageNamed:@"ic_pullup"] forState:UIControlStateNormal];
    }
}

// 筛选视图 delegate
-(void)didChooseSubject:(NSString*)subject Button: (UIButton *)button{
    _filterView.hidden = YES;
    [_titleBtn setTitle:subject forState:UIControlStateNormal];
    [_titleBtn setImage:[UIImage imageNamed:@"ic_pulldown"] forState:UIControlStateNormal];
    _subjectId = [NSString stringWithFormat:@"%ld",button.tag+1];
    [self fetchCourseList];
}

-(void)pushToOrgView{
    OrganizationViewController *orgVC = [[OrganizationViewController alloc]init];
    orgVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orgVC animated:YES];
}

-(void)pushToComView{
    CommodityViewController *commodityVC = [[CommodityViewController alloc]init];
    commodityVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:commodityVC animated:YES];
}

//侧拉按钮
-(void)setupSlideMenu{
    UIImageView *slideBtn = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    slideBtn.image = [UIImage imageNamed:@"ic_slide"];
    slideBtn.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openSlideMenu)];
    [slideBtn addGestureRecognizer:singleTap];
    [slideBtn sizeToFit];
    
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:slideBtn];
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
}

/**
 * 右侧按钮
 */
-(void)openSlideMenu{
    if(GetAppDelegate().slideViewController.isShowingMain){
        [GetAppDelegate().slideViewController showRighView];
    }else{
        [GetAppDelegate().slideViewController showMainView];
    }
}

-(void)fetchCourseList{
    NSString *userId = @"";
    AuthManager *am = [[AuthManager alloc]init];
    if (am.isAuthenticated) {
        userId = am.userInfo.userId;
    }
    CourseManager *cm = [[CourseManager alloc]init];
    [cm fetchCourseListWithID:_subjectId Type: @"2" UserId:userId Success:^(CourseListResult *result) {
        [self.courseTable.header endRefreshing];
        _dataArray = result.course.subList;
        [_courseTable reloadData];
    } Failure:^(NSError *error) {
        [self.courseTable.header endRefreshing];
    }];
}
/**
 *  轮播图数据源
 *
 */
-(void)fetchBannerList{
    CourseManager *cm = [[CourseManager alloc]init];
    [cm fetchBannerListSuccess:^(BannerListResult *result) {
        _bannerArray = result.bannerArray;
        [_bannerView reloadData];
    } Failure:^(NSError *error) {
    }];
}

/**
 *  轮播图
 *
 *  @return <#return value description#>
 */
- (XLCycleScrollView*)bannerView
{
    _bannerView = [[XLCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, GENERAL_SIZE(320))];
    _bannerView.delegate = self;
    _bannerView.datasource = self;
    _bannerView.tapEnabled = YES;
    [_bannerView reloadData];
    return _bannerView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"courseCell";
    CourseTableCell *courseCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (courseCell == nil) {
        courseCell = [[CourseTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"courseCell"];
    }
    Course *course = [_dataArray objectAtIndex:indexPath.row];
    [courseCell setCellWithModel:course];
    courseCell.delegate = self;
    courseCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return courseCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (iPhone6Plus) {
        return 180;
    }
    if (iPhone6) {
        return 170;
    }
    return 150;
}

#pragma mark - XLCycleScrollViewDelegate

- (NSInteger)numberOfPages
{
    return [_bannerArray count];
}

- (UIView *)pageAtIndex:(NSInteger)index
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, GENERAL_SIZE(320));
    
    Course *course = [_bannerArray objectAtIndex:index];
    [imageView sd_setImageWithURL:[NSURL URLWithString:course.address] placeholderImage:nil];
    
    UIImageView *shadowView = [[UIImageView alloc] init];
    shadowView.frame = CGRectMake(0, GENERAL_SIZE(240), SCREEN_WIDTH, GENERAL_SIZE(80));
    
    shadowView.image = [UIImage imageNamed:@""];
    shadowView.backgroundColor = [UIColor blackColor];
    shadowView.alpha = 0.2;
    [imageView addSubview:shadowView];
    
    TTTAttributedLabel *label = [TTTAttributedLabel new];
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 2;
    label.backgroundColor = [UIColor clearColor];
    label.lineSpacing = 5;
    label.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
    label.text = course.name;
    [imageView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shadowView.mas_left).offset(10);
        make.top.equalTo(shadowView.mas_top).offset(10);
        make.width.equalTo(@(SCREEN_WIDTH-20));
    }];
    
    return imageView;
}

-(void)didClickPage:(XLCycleScrollView *)csView atIndex:(NSInteger)index{
    Course *course = [_bannerArray objectAtIndex:index];
    if ([course.type isEqualToString:@"2"]) {
        CourSectionViewController *sectionVC = [[CourSectionViewController alloc]init];
        sectionVC.objectId = course.courseId;
        sectionVC.type = 1;
        sectionVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:sectionVC animated:YES];
    }else if ([course.type isEqualToString:@"3"]){
        BannerWebViewController *webVC = [[BannerWebViewController alloc]init];
        webVC.url = course.profile;
        webVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

#pragma mark - CollectionCellDelegate

-(void)collectionDidClick:(Course*)course{
    CourSectionViewController *sectionVC = [[CourSectionViewController alloc]init];
    sectionVC.objectId = course.courseId;
    sectionVC.type = 1;
    sectionVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sectionVC animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
