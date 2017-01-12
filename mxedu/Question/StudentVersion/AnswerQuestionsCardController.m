//
//  AnswerQuestionsCardController.m
//  mxedu
//
//  Created by zhufeng on 2017/1/11.
//  Copyright © 2017年 田晓鹏. All rights reserved.
//

#import "AnswerQuestionsCardController.h"
#import "CorrectTableCell.h"
#import "SysCommon.h"
#import "Correctness.h"

@interface AnswerQuestionsCardController ()<UITableViewDataSource,UITableViewDelegate> {
    UITableView *listTableView;
}

@end

@implementation AnswerQuestionsCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self initNavBar];
    
    [self setupListTable];
}

-(void)setupListTable {
    listTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    listTableView.dataSource = self;
    listTableView.delegate = self;
    [self.view addSubview:listTableView];
}
// 已答数
-(int)numberOfFinished{
    int i=0;
    for (Correctness *correct in _answersArray) {
        if (![correct.isCorrect isEqualToString:@"2"]) {
            i++;
        }
    }
    return i;
}

// 正确数
-(int)numberOfCorrect{
    int i=0;
    for (Correctness *correct in _answersArray) {
        if ([correct.isCorrect isEqualToString:@"1"]) {
            i++;
        }
    }
    return i;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        CorrectTableCell *cell = [[CorrectTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"correctCell"];
        [cell setupCell:_answersArray];
        return cell;
    } else {
        CorrectTableCell *cell = [[CorrectTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"correctCell"];
        [cell setupCell:_answersArray];
        return cell;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, GENERAL_SIZE(60))];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(GENERAL_SIZE(20), 0, SCREEN_WIDTH-GENERAL_SIZE(40), GENERAL_SIZE(60))];
    [headerTitleView addSubview:label];
    if (section == 0) {
        label.text = @"选择题";
    } if (section == 1) {
        label.text = @"非选择题";
    }
    return headerTitleView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return GENERAL_SIZE(60);
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        NSInteger rowCount = [_answersArray count]%5==0?[_answersArray count]/5:[_answersArray count]/5+1;
        return rowCount*(SCREEN_WIDTH/5-10);
    }else{
        return 45;
    }
}
-(void)initNavBar {
    
    
    NSLog(@"======= %@",self.answersArray);
    
    
    self.title = @"答题卡";
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateNormal];
    [backBtn sizeToFit];
    [backBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

-(void)backButtonClicked {
    [self.navigationController popToRootViewControllerAnimated:YES];
}



@end
