//
//  MaterailViewController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/10/29.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "MaterialViewController.h"


#import "SysCommon.h"
#import "MJRefresh.h"
#import "HMSegmentedControl.h"
#import "MaterialManager.h"
#import "MaterialTableCell.h"

#import "AuthManager.h"
#import "ExchangeManager.h"
#import "LoginViewController.h"
#import "MaterialBrowseController.h"
#import "CommodityViewController.h"
#import "OlaCoinViewController.h"

@interface MaterialViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *dataArray;

@property (nonatomic) NSString *type; // 数学 英语 逻辑 写作

@property (nonatomic) Material *material;

@end

@implementation MaterialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"资料库";
    self.view.backgroundColor = [UIColor whiteColor];
    _type = @"1";
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    
    [self setupRightButton];
    [self setupSegment];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, GENERAL_SIZE(80), SCREEN_WIDTH, SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-UI_STATUS_BAR_HEIGHT-GENERAL_SIZE(80))];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self setupDataWithMaterialId:@""];
    }];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        Material *material = [_dataArray lastObject];
        if (material) {
            [self setupDataWithMaterialId:material.materialId];
        }
    }];
    
    [self.tableView.header beginRefreshing];
}

-(void)setupRightButton{
    UIImageView *createBtn = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    createBtn.image = [UIImage imageNamed:@"icon_tao"];
    createBtn.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showCommodityView)];
    [createBtn addGestureRecognizer:singleTap];
    [createBtn sizeToFit];
    
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:createBtn];
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
}

-(void)showCommodityView{
    CommodityViewController *commodityVC = [[CommodityViewController alloc]init];
    commodityVC.currentType = @"2";
    commodityVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:commodityVC animated:YES];
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
        _type = [NSString stringWithFormat:@"%d",(int)index+1];
        [self setupDataWithMaterialId:@""];
    }];
    
}


-(void)setupDataWithMaterialId:(NSString*)materialId{
    MaterialManager *mm = [[MaterialManager alloc]init];
    [mm fetchMaterialListWithMaterialId:materialId PageSize:@"20" Type:_type Success:^(MaterialListResult *result) {
        if ([materialId isEqualToString:@""]) {
            [_dataArray removeAllObjects];
        }
        [_dataArray addObjectsFromArray:result.materialArray];
        [_tableView reloadData];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    } Failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MaterialTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MaterialTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchResultCell"];
    }
    Material *material = [_dataArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setupCellWithModel:material];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OLA_LOGIN;
    
    _material = [_dataArray objectAtIndex:indexPath.row];
    if([_material.status isEqualToString:@"1"]){
        MaterialBrowseController *browseVC = [[MaterialBrowseController alloc]init];
        browseVC.material = _material;
        [self.navigationController pushViewController:browseVC animated:YES];
    }else{
        if ([[AuthManager sharedInstance].userInfo.coin intValue]<[_material.price intValue]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的欧拉币不足" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"去赚取",nil];
            alert.tag = 1001;
            [alert show];

        }else{
            NSString *message = [NSString stringWithFormat:@"兑换该套资料将消耗您%@欧拉币",_material.price];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"兑换",nil];
            alert.tag = 1002;
            [alert show];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        if (alertView.tag == 1001) {
            OlaCoinViewController *coinVC = [[OlaCoinViewController alloc] init];
            [self.navigationController pushViewController:coinVC animated:YES];
        }else if(alertView.tag == 1002){
            [self exchangeWithOlaCoin];
        }
    }
}


// 欧拉币兑换题目
-(void)exchangeWithOlaCoin{
    ExchangeManager *em = [[ExchangeManager alloc]init];
    [em unlockMaterialWithUserId:[AuthManager sharedInstance].userInfo.userId MaterialId:_material.materialId success:^(CommonResult *result) {
        if (result.code==10000) {
            [self setupDataWithMaterialId:@""];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:result.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    } failure:^(NSError *error) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
