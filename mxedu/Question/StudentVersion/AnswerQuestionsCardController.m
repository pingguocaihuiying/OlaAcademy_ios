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
#import "QuestionResultViewController.h"

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
    listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-GENERAL_SIZE(150))];
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
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        CorrectTableCell *cell = [[CorrectTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"correctCell"];
        [cell setupCell:_answersArray];
        return cell;
    } else if (indexPath.section==1) {
        CorrectTableCell *cell = [[CorrectTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"correctCell"];
        [cell setupCell:_answersArray];
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"correctCell"];
        
        return cell;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, GENERAL_SIZE(60))];
    if (section == 2) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(GENERAL_SIZE(40), 0, SCREEN_WIDTH-GENERAL_SIZE(80), GENERAL_SIZE(60));
        [button setBackgroundImage:[UIImage imageNamed:@"btn_buy"] forState:UIControlStateNormal];
        UIImage *btnImage = button.currentBackgroundImage;
        //按钮的背景图片不要被拉伸
        btnImage = [btnImage stretchableImageWithLeftCapWidth:btnImage.size.width * 0.5 topCapHeight:btnImage.size.height * 0.5];
        [button setBackgroundImage:btnImage forState:UIControlStateNormal];
        [button setTitle:@"交卷并查看结果" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [headerTitleView addSubview:button];
        
        [button addTarget:self action:@selector(checkButtonClick) forControlEvents:UIControlEventTouchUpInside];

    } else {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(GENERAL_SIZE(20), 0, SCREEN_WIDTH-GENERAL_SIZE(40), GENERAL_SIZE(60))];
        [headerTitleView addSubview:label];
    
        if (section == 0) {
            label.text = @"选择题";
        } if (section == 1) {
            label.text = @"非选择题";
        }
    }
    
    return headerTitleView;
}
-(void)checkButtonClick {
    QuestionResultViewController *resultVC = [[QuestionResultViewController alloc]init];

    resultVC.answerArray = _answersArray;
    [self.navigationController pushViewController:resultVC animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return GENERAL_SIZE(60);
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==2) {
        return GENERAL_SIZE(100);
    }
        NSInteger rowCount = [_answersArray count]%5==0?[_answersArray count]/5:[_answersArray count]/5+1;
        return rowCount*(SCREEN_WIDTH/5-10);
//    }else{
//        return 45;
//    }
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
