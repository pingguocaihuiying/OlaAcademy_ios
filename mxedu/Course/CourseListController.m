//
//  CourseListController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/8/15.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "CourseListController.h"

#import "SysCommon.h"
#import "CourseListTableCell.h"

@interface CourseListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) UITableView *tableView;

@end

@implementation CourseListController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavBar];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.separatorStyle = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

-(void)setupNavBar{
    
    self.title = @"课程";
    
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_courseArray count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"courseTableCell";
    CourseListTableCell *courseCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (courseCell == nil) {
        courseCell = [[CourseListTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"courseTableCell"];
    }
    Course *course = [_courseArray objectAtIndex:indexPath.row];
    [courseCell setupCell:course];
    courseCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return courseCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return GENERAL_SIZE(230);
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return GENERAL_SIZE(16);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Course *course = [_courseArray objectAtIndex:indexPath.row];
    CourSectionViewController *sectionVC = [[CourSectionViewController alloc]init];
    sectionVC.objectId = course.courseId;
    sectionVC.type = 1;
    [self.navigationController pushViewController:sectionVC animated:YES];
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
