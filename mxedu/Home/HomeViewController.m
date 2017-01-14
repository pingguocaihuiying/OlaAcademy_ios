//
//  HomeViewController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/8/15.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "HomeViewController.h"

#import "SysCommon.h"
#import "HomeHeadView.h"
#import "ConsultTableCell.h"
#import "HomeTableCell.h"
#import "StudyProgressCell.h"

#import "AuthManager.h"
#import "HomeManager.h"
#import "MJRefresh.h"
#import "UIColor+HexColor.h"

#import "LoginViewController.h"
#import "StuEnrollController.h"
#import "CircleViewController.h"
#import "CommodityViewController.h"
#import "BannerWebViewController.h"
#import "CommentViewController.h"
#import "DeployViewController.h"
#import "MaterialViewController.h"
#import "StuGroupListController.h"

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,CollectionCellDelegate,HomeHeadViewDelegate>

@property (nonatomic) HomeHeadView *headView;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) UILabel *nameL; //section
@property (nonatomic) NSArray *nameArray;
@property (nonatomic) NSArray *consultArray; //最新问答
@property (nonatomic) NSArray *courseArray; //课程库
@property (nonatomic) NSArray *comodityArray;//精品课程

@property (nonatomic, copy) NSString* avatar;

@end

@implementation HomeViewController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _nameArray = [NSArray arrayWithObjects:@"学习进度",@"最新问答",@"精品课程",@"课程库", nil];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.separatorStyle = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [self setupHeadView];
    [self setupData];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self setupData];
    }];
}

-(void)setupHeadView{
    
    _headView = [[HomeHeadView alloc]initWithFrame:CGRectMake(0, 0, GENERAL_SIZE(395), GENERAL_SIZE(470))];
    _headView.headViewDelegate = self;
    self.tableView.tableHeaderView = _headView;
}

-(void)setupData{
    NSString *userId = @"";
    AuthManager *am = [AuthManager sharedInstance];
    if (am.isAuthenticated) {
        userId = am.userInfo.userId;
    }
    self.avatar = am.userInfo.avatar;
    HomeManager *hm = [[HomeManager alloc]init];
    [hm fetchHomePageListWithUserId:userId Success:^(HomeListResult *result) {
        NSArray *bannerArray = result.homeData.bannerArray;
        [_headView setupView:bannerArray];
        _consultArray = result.homeData.consultArray;
        _comodityArray = result.homeData.comodityArray;
        _courseArray = result.homeData.courseArray;
        [_tableView reloadData];
        [self.tableView.header endRefreshing];
    } Failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
    }];
}

#pragma tablview

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==1) {
        return [_consultArray count];
    }
    return 1;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *secView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, GENERAL_SIZE(90))];
    
    UIView *dividerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, GENERAL_SIZE(20))];
    dividerView.backgroundColor = RGBCOLOR(235, 235, 235);
    [secView addSubview:dividerView];
    
    UIView *hLine = [[UIView alloc]initWithFrame:CGRectMake(10, GENERAL_SIZE(40), 2, GENERAL_SIZE(30))];
    hLine.backgroundColor = COMMONBLUECOLOR;
    [secView addSubview:hLine];
    
    _nameL = [[UILabel alloc] initWithFrame:CGRectMake(17, GENERAL_SIZE(40), 200, GENERAL_SIZE(30))];
    _nameL.font = [UIFont systemFontOfSize:GENERAL_SIZE(30)];
    _nameL.text = [_nameArray objectAtIndex:section];
    _nameL.textColor = [UIColor colorWhthHexString:@"#272b36"];
    _nameL.contentMode = UIViewContentModeTop;
    [secView addSubview:_nameL];
    
    UIButton *moreBtn = [[UIButton alloc]init];
    if (section == 0) {
        moreBtn.frame = CGRectMake(SCREEN_WIDTH-GENERAL_SIZE(100), GENERAL_SIZE(20), GENERAL_SIZE(120), GENERAL_SIZE(70));
        [moreBtn setImage:[UIImage imageNamed:@"ic_next"] forState:UIControlStateNormal];
    } else if (section == 1) {
        moreBtn.hidden = YES;
    } else {
        moreBtn.frame = CGRectMake(SCREEN_WIDTH-GENERAL_SIZE(120), GENERAL_SIZE(20), GENERAL_SIZE(120), GENERAL_SIZE(70));
        [moreBtn setTitle:@"显示全部" forState:UIControlStateNormal];
        [moreBtn setTitleColor:[UIColor colorWhthHexString:@"#a8aaad"] forState:UIControlStateNormal];
        moreBtn.titleLabel.font = LabelFont(20);
    }
    moreBtn.tag = section;
    [moreBtn addTarget:self action:@selector(showMore:) forControlEvents:UIControlEventTouchDown];
    [secView addSubview:moreBtn];

    return secView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return GENERAL_SIZE(90);
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        static NSString *cellIdentifier = @"zeroCell";
        StudyProgressCell *consultCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (consultCell == nil) {
            consultCell = [[StudyProgressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        [consultCell setAvatar:self.avatar];
        consultCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return consultCell;

    }else if (indexPath.section == 1) {
        static NSString *cellIdentifier = @"consultCell";
        ConsultTableCell *consultCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (consultCell == nil) {
            consultCell = [[ConsultTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"consultCell"];
        }
        Consult *consult = [_consultArray objectAtIndex:indexPath.row];
        [consultCell setupCellWithModel:consult AtRow:indexPath.row];
        consultCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return consultCell;
        
    } else {
        static NSString *cellIdentifier = @"homeCell";
        HomeTableCell *dataCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (dataCell == nil) {
            dataCell = [[HomeTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"homeCell"];
        }
        switch (indexPath.section) {
            case 2:
                [dataCell setCellWithData:_comodityArray];
                break;
            case 3:
                [dataCell setCellWithData:_courseArray];
                break;
                
            default:
                break;
        }
        dataCell.delegate = self;
        dataCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return dataCell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        Consult *consult = [_consultArray objectAtIndex:indexPath.row];
        CommentViewController *commentVC = [[CommentViewController alloc]init];
        commentVC.postId = consult.consultId;
        commentVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:commentVC animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        return GENERAL_SIZE(150);
    }
    return GENERAL_SIZE(295);
}

-(void) showMore:(UIButton*)btn{
    switch (btn.tag) {
        case 0:
            NSLog(@"====== 显示全部");
            break;
            
//        case 1:
//            [self pushToCircleView];
//            break;
            
        case 2:
            [self pushToComView:@"1"];
            break;
            
        case 3:
            self.navigationController.tabBarController.selectedIndex = 1;
            break;
            
        default:
            break;
    }
}

#pragma headview delegate
-(void)didClickBanner:(Banner *)banner{
    if (banner.type==1) {
        BannerWebViewController *webVC = [[BannerWebViewController alloc]init];
        webVC.url = banner.url;
        webVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];
    }else if (banner.type==2||banner.type==3){
        CourSectionViewController *sectionVC = [[CourSectionViewController alloc]init];
        sectionVC.objectId = banner.objectId;
        sectionVC.type = banner.type-1;
        if (banner.type==3) {
            sectionVC.commodity = banner.commodity;
        }
        sectionVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:sectionVC animated:YES];
    }else if(banner.type==4){
        StuEnrollController *enrollVC = [[StuEnrollController alloc]init];
        NSArray *indexArray = [banner.objectId componentsSeparatedByString:@","];
        if ([indexArray count]==2) {
            enrollVC.optionIndex = [indexArray[0] intValue];
            enrollVC.nameIndex = [indexArray[1] intValue];
        }
        enrollVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:enrollVC animated:YES];
    }
}

-(void)didClickConsultView{
    OLA_LOGIN;
    DeployViewController *deployVC = [[DeployViewController alloc]init];
    deployVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:deployVC animated:YES];
}
-(void)didClickTeacherView{
    OLA_LOGIN;
    [self pushToOrgView];
}
-(void)didClickMaterialView{
    [self pushToMaterialView];
}
-(void)didClickGroupView{
    OLA_LOGIN;
    StuGroupListController *groupVC = [[StuGroupListController alloc]init];
    groupVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:groupVC animated:YES];
}

#pragma  delegate
-(void)collectionDidClick:(NSObject *)data{
    CourSectionViewController *sectionVC = [[CourSectionViewController alloc]init];
    if([data isKindOfClass:[Commodity class]]){
        Commodity *commodity = (Commodity*)data;
        sectionVC.objectId = commodity.comId;
        sectionVC.commodity = commodity;
        sectionVC.type = 2;
    }else if([data isKindOfClass:[Course class]]){
        Course *course = (Course*)data;
        sectionVC.objectId = course.courseId;
        sectionVC.type = 1;
    }
    sectionVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sectionVC animated:YES];
}

-(void)pushToComView:(NSString*)type{
    CommodityViewController *commodityVC = [[CommodityViewController alloc]init];
    commodityVC.currentType = type; //1 课程 2 教材资料
    commodityVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:commodityVC animated:YES];
}

-(void)pushToMaterialView{
    MaterialViewController *materialVC = [[MaterialViewController alloc]init];
    materialVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:materialVC animated:YES];
}

-(void)pushToCircleView{
    CircleViewController *circleVC = [[CircleViewController alloc]init];
    circleVC.isFromHomePage = 1;
    circleVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:circleVC animated:YES];
}


-(void)pushToOrgView{
    StuEnrollController *orgnizationVC = [[StuEnrollController alloc]init];
    orgnizationVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orgnizationVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
