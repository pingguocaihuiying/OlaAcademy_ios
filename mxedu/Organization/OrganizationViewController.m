//
//  OrganizationViewController.m
//  mxedu
//
//  Created by 田晓鹏 on 15/10/19.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import "OrganizationViewController.h"

#import "SysCommon.h"
#import "OrganizationTableCell.h"
#import "EnrollViewController.h"

#import "Organization.h"
#import "OrganizationManager.h"
#import "AuthManager.h"
#import "LoginViewController.h"

#import "MJRefresh.h"

static const CGFloat kNavigtionHeight = 64.0;

@interface OrganizationViewController ()<UITableViewDataSource,UITableViewDelegate,OrgizationCellDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *organizationArray;

@end

@implementation OrganizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"名师辅导";
    [self setupBackButton];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kNavigtionHeight) style:UITableViewStylePlain];
    _tableView.separatorStyle = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    UIImageView *headerIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, GENERAL_SIZE(300))];
    headerIV.image = [UIImage imageNamed:@"banner_goods"];
    self.tableView.tableHeaderView = headerIV;
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self setupData];
    }];
    
    _organizationArray = [NSMutableArray arrayWithCapacity:0];
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


-(void)setupData{
    NSString *userId = @"";
    AuthManager *am = [AuthManager sharedInstance];
    if (am.isAuthenticated) {
        userId = am.userInfo.userId;
    }
    OrganizationManager *om = [[OrganizationManager alloc]init];
    [om fetchOrganizationListWithUserId:userId
                                Success:^(OrganizationResult *result)
    {
        [self.tableView.header endRefreshing];
        [_organizationArray removeAllObjects];
        [_organizationArray addObjectsFromArray:result.orgList];;
        [_tableView reloadData];
    } Failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
    }];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_organizationArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrganizationTableCell *cell = [[OrganizationTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"organizationTableCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    Organization *org = [_organizationArray objectAtIndex:indexPath.row];
    [cell setCellWithModel:org Path:indexPath];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(iPhone6){
        return 160;
    }else if(iPhone6Plus){
        return 150;
    }
    return 155;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    EnrollViewController *enrollVC = [[EnrollViewController alloc]init];
//    enrollVC.org = [_organizationArray objectAtIndex:indexPath.row];
//    enrollVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:enrollVC animated:YES];
}


#pragma cell delegate

-(void)showLoginView{
    LoginViewController* loginViewCon = [[LoginViewController alloc] init];
    loginViewCon.successFunc = ^{
        [self setupData];
    };
    UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:loginViewCon];
    [self presentViewController:rootNav animated:YES completion:nil];
}

-(void)cell:(Organization *)org local:(NSIndexPath *)localPath didTapButton:(UIButton *)button{
    [_organizationArray replaceObjectAtIndex:localPath.row withObject:org];
    [_tableView reloadData];
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
