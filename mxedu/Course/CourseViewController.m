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
//#import "XLCycleScrollView.h"
#import "TTTAttributedLabel.h"

#import "CourseManager.h"
#import "CourSectionViewController.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"

#import "AuthManager.h"
#import "BannerWebViewController.h"
#import "CourseListController.h"

#import "Masonry.h"

#import "CourseBarView.h"
#import "HMSegmentedControl.h"


#define PUSH_TO_DOWNLOAD @"pushToMyDownload"

static const CGFloat kNavigtionHeight = 30.0;

@interface CourseViewController ()<UITableViewDataSource, UITableViewDelegate,CollectionCellDelegate,CourseTableDelegate>

@property (nonatomic) UITableView *courseTable;

@property (nonatomic) UIView *playView;

@property (nonatomic) BOOL barHidden;

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
//    XLCycleScrollView *_bannerView;
    
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
    
    self.navigationItem.title = @"课程库";
    _subjectId = @"1";
    
    [self setupSegment];
    
    _courseTable = [[UITableView alloc]initWithFrame:CGRectMake(0, GENERAL_SIZE(80), SCREEN_WIDTH, SCREEN_HEIGHT-kNavigtionHeight-GENERAL_SIZE(80)-UI_NAVIGATION_BAR_HEIGHT) style:UITableViewStyleGrouped];
    _courseTable.separatorStyle = NO;
    _courseTable.dataSource = self;
    _courseTable.delegate = self;
//    _courseTable.tableHeaderView = [self bannerView];
    [self.view addSubview:_courseTable];
    
    self.courseTable.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self fetchCourseList];
    }];
    
    
//    [self fetchBannerList];
    [self fetchCourseList];
    
    //[self setupSlideMenu];
}

-(void)setupSegment{
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-40, GENERAL_SIZE(80))];
    segmentedControl.sectionTitles = @[@"数学",@"英语", @"逻辑", @"写作", @"面试"];
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
        [self fetchCourseList];
    }];

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
    AuthManager *am = [AuthManager sharedInstance];
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
//-(void)fetchBannerList{
//    CourseManager *cm = [[CourseManager alloc]init];
//    [cm fetchBannerListSuccess:^(BannerListResult *result) {
////        _bannerArray = result.bannerArray;
//        [_bannerView reloadData];
//    } Failure:^(NSError *error) {
//    }];
//}

/**
 *  轮播图
 *
 *  @return <#return value description#>
 */
//- (XLCycleScrollView*)bannerView
//{
//    _bannerView = [[XLCycleScrollView alloc] init];//WithFrame:CGRectMake(0, 0, SCREEN_WIDTH, GENERAL_SIZE(300))];
//    _bannerView.delegate = self;
//    _bannerView.datasource = self;
//    _bannerView.tapEnabled = YES;
//    [_bannerView reloadData];
//    return _bannerView;
//}

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
    courseCell.tableCellDelegate = self;
    courseCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return courseCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return GENERAL_SIZE(395);
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return GENERAL_SIZE(20);
}
#pragma mark - XLCycleScrollViewDelegate

//- (NSInteger)numberOfPages
//{
//    return [_bannerArray count];
//}
//
//- (UIView *)pageAtIndex:(NSInteger)index
//{
//    UIImageView *imageView = [[UIImageView alloc] init];
//    imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, GENERAL_SIZE(300));
//    
//    Course *course = [_bannerArray objectAtIndex:index];
//    [imageView sd_setImageWithURL:[NSURL URLWithString:course.address] placeholderImage:nil];
//    
//    UIImageView *shadowView = [[UIImageView alloc] init];
//    shadowView.frame = CGRectMake(0, GENERAL_SIZE(220), SCREEN_WIDTH, GENERAL_SIZE(80));
//    
//    shadowView.image = [UIImage imageNamed:@""];
//    shadowView.backgroundColor = [UIColor blackColor];
//    shadowView.alpha = 0.2;
//    [imageView addSubview:shadowView];
//    
//    TTTAttributedLabel *label = [TTTAttributedLabel new];
//    label.textColor = [UIColor whiteColor];
//    label.numberOfLines = 2;
//    label.backgroundColor = [UIColor clearColor];
//    label.lineSpacing = 5;
//    label.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
//    label.text = course.name;
//    [imageView addSubview:label];
//    
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(shadowView.mas_left).offset(10);
//        make.top.equalTo(shadowView.mas_top).offset(10);
//        make.width.equalTo(@(SCREEN_WIDTH-20));
//    }];
//    
//    return imageView;
//}
//
//-(void)didClickPage:(XLCycleScrollView *)csView atIndex:(NSInteger)index{
//    Course *course = [_bannerArray objectAtIndex:index];
//    if ([course.type isEqualToString:@"2"]) {
//        CourSectionViewController *sectionVC = [[CourSectionViewController alloc]init];
//        sectionVC.objectId = course.courseId;
//        sectionVC.type = 1;
//        sectionVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:sectionVC animated:YES];
//    }else if ([course.type isEqualToString:@"3"]){
//        BannerWebViewController *webVC = [[BannerWebViewController alloc]init];
//        webVC.url = course.profile;
//        webVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:webVC animated:YES];
//    }
//}

#pragma mark - CourseTableDelegate

-(void)didClickMore:(Course *)course{
    CourseListController *listVC = [[CourseListController alloc]init];
    listVC.hidesBottomBarWhenPushed = YES;
    listVC.courseArray = course.subList;
    [self.navigationController pushViewController:listVC animated:YES];
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
