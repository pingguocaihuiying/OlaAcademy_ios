//
//  MyEnrollViewController.m
//  mxedu
//
//  Created by 田晓鹏 on 15/11/29.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import "MyEnrollViewController.h"

#import "SysCommon.h"
#import "AuthManager.h"
#import "OrganizationManager.h"
#import "UiimageView+WebCache.h"

#import "CheckIn.h"
#import "EnrollDetailViewController.h"

@interface MyEnrollViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MyEnrollViewController{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的报名";
    [self setupBackButton];
    
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [self fetchCheckInfoList];
}

- (void)setupBackButton
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"ic_back_white"] forState:UIControlStateNormal];
    [backBtn sizeToFit];
    [backBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

-(void)backButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)fetchCheckInfoList{
    AuthManager *am = [[AuthManager alloc]init];
    if (am.isAuthenticated) {
        OrganizationManager *om = [[OrganizationManager alloc]init];
        [_dataArray removeAllObjects];
        [om fetchListByUserPhone:am.userInfo.phone Success:^(CheckInListResult *result) {
            [_dataArray addObjectsFromArray: result.checkInList];
            [_tableView reloadData];
        } Failure:^(NSError *error) {
            
        }];
    }
}

-(void)removeCheckInfo:(NSString*)checkId{
    AuthManager *am = [[AuthManager alloc]init];
    if (am.isAuthenticated) {
        OrganizationManager *om = [[OrganizationManager alloc]init];
        [om removeCheckInfo:checkId Success:^(CommonResult *result) {

        } Failure:^(NSError *error) {
            
        }];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"checkInfoCell";
    UITableViewCell *checkInfoCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (checkInfoCell == nil) {
        checkInfoCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"checkInfoCell"];
    }
    CheckIn *checkInfo = [_dataArray objectAtIndex:indexPath.row];
    
    [checkInfoCell.imageView sd_setImageWithURL:[NSURL URLWithString:checkInfo.orgPic] placeholderImage:nil];
    
    checkInfoCell.imageView.layer.cornerRadius = 5;
    checkInfoCell.imageView.layer.masksToBounds = YES;
    checkInfoCell.imageView.layer.borderWidth = 1;
    checkInfoCell.imageView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    CGSize itemSize = CGSizeMake(60, 60);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [checkInfoCell.imageView.image drawInRect:imageRect];
    checkInfoCell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    checkInfoCell.textLabel.text = checkInfo.orgName;
    checkInfoCell.detailTextLabel.text = checkInfo.checkinTime;
    checkInfoCell.detailTextLabel.textColor = RGBCOLOR(153, 153, 153);
    checkInfoCell.detailTextLabel.numberOfLines = 3;
    checkInfoCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    checkInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return checkInfoCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CheckIn *checkInfo = [_dataArray objectAtIndex:indexPath.row];
    EnrollDetailViewController *detailVC = [[EnrollDetailViewController alloc]init];
    detailVC.checkInfo = checkInfo;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CheckIn *checkInfo = [_dataArray objectAtIndex:indexPath.row];
        [self removeCheckInfo:checkInfo.checkId];
        [_dataArray removeObjectAtIndex:indexPath.row];
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
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
