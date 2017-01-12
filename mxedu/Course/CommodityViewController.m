//
//  CommodityViewController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/4/4.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "CommodityViewController.h"

#import "SysCommon.h"

#import "CommodityTableCell.h"
#import "CommodityManager.h"
#import "CourSectionViewController.h"
#import "CommodityFilterView.h"
#import "MJRefresh.h"

@interface CommodityViewController ()<UISearchBarDelegate, UITableViewDataSource,UITableViewDelegate,CommodityFilterChooseDelegate>

@property (nonatomic) UIButton *titleBtn;

@property (nonatomic) CommodityFilterView *filterView;// 遮罩筛选视图

@property (nonatomic) UITableView *tableView;

@end

@implementation CommodityViewController{
    /**
     *  数据源
     */
    NSArray *dataArray;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self setupNavBar];
    
    [self setupBackButton];
    if([_currentType isEqualToString: @"1"]){
        self.title = @"精品课程";
    }else{
        self.title = @"资料库";
    }
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-UI_NAVIGATION7_BAR_HEIGHT) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self fetchCommodityList];
    }];
    
    [self fetchCommodityList];
}

- (void)setupBackButton
{
    self.navigationController.navigationBarHidden = NO;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    [backBtn sizeToFit];
    [backBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}


-(void)setupNavBar{
    _titleBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _titleBtn.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    _titleBtn.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    _titleBtn.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    [_titleBtn setFrame:CGRectMake(0, 0, 80, 20)];
    [_titleBtn addTarget:self action:@selector(showFilterView:) forControlEvents:UIControlEventTouchUpInside];
    [_titleBtn setTitle:@"课程" forState:UIControlStateNormal];
    [_titleBtn setImage:[UIImage imageNamed:@"ic_pulldown"] forState:UIControlStateNormal];
    self.navigationItem.titleView = _titleBtn;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    [backBtn sizeToFit];
    [backBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backButtonItem;
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
        _filterView = [[CommodityFilterView alloc]initWithFrame:self.view.bounds];
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
    _currentType = [NSString stringWithFormat:@"%ld",button.tag+1];
    [self fetchCommodityList];
}

-(void)backButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)fetchCommodityList{
    CommodityManager *cm = [[CommodityManager alloc]init];
    [cm fetchCommodityListWithType:_currentType pageIndex:@"1" pageSize:@"20" Success:^(CommodityListRsult *result) {
        dataArray = result.commodityArray;
        [_tableView.header endRefreshing];
        [_tableView reloadData];
    } Failure:^(NSError *error) {
        [_tableView.header endRefreshing];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommodityTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[CommodityTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchResultCell"];
    }
    Commodity *commodity = [dataArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setupCellWithModel:commodity];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Commodity *commodity = [dataArray objectAtIndex:indexPath.row];
    if ([_currentType isEqualToString:@"1"]) {
        CourSectionViewController *sectionVC = [[CourSectionViewController alloc]init];
        sectionVC.objectId = commodity.comId;
        sectionVC.commodity = commodity;
        sectionVC.type = 2;
        [self.navigationController pushViewController:sectionVC animated:YES];
    }else{
        [self jumpToBuyWeb:commodity.url];
    }
}

-(void)jumpToBuyWeb:(NSString*)url{
    NSString* strIdentifier = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    BOOL isExsit = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]];
    if(isExsit) {
        NSLog(@"App %@ installed", strIdentifier);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strIdentifier]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
