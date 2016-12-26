//
//  QuestionResultViewController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/3/15.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "QuestionResultViewController.h"

#import "AuthManager.h"
#import "SysCommon.h"
#import "Masonry.h"
#import "Correctness.h"
#import "CorrectTableCell.h"
#import "CourSectionTableCell.h"
#import "JRPlayerViewController.h"

@interface QuestionResultViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) UILabel *correctItem;
@property (nonatomic) UILabel *defectItem;

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *videoArray;

@end

@implementation QuestionResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"答题报告";

    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-UI_NAVIGATION7_BAR_HEIGHT-60) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [self setupHeadView];
    
    [self fetchSectionVideo];
    [self submitAnswerToServer];
}

-(void)setupHeadView{
    
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, GENERAL_SIZE(470))];
    bgImageView.backgroundColor = COMMONBLUECOLOR;
    
    UIImageView *tipView = [[UIImageView alloc]init];
    tipView.layer.cornerRadius = GENERAL_SIZE(150);
    tipView.layer.masksToBounds = YES;
    tipView.backgroundColor = [UIColor whiteColor];
    [bgImageView addSubview:tipView];
    
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgImageView.mas_top).offset(GENERAL_SIZE(60));
        make.centerX.equalTo(bgImageView);
        make.width.equalTo(@(GENERAL_SIZE(300)));
        make.height.equalTo(@(GENERAL_SIZE(300)));
    }];
    
    UILabel *correctLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    NSString *result = [NSString stringWithFormat:@"%d/%ld道",[self numberOfCorrect],[_answerArray count]];
    NSString *correct = [NSString stringWithFormat:@"%d",[self numberOfCorrect]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:result];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:40.0] range:NSMakeRange(0, [correct length])];
    [str addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(164, 192, 250) range:NSMakeRange([correct length], [result length]-[correct length])];
    [str addAttribute:NSForegroundColorAttributeName value:COMMONBLUECOLOR range:NSMakeRange(0,[correct length])];
    correctLabel.attributedText = str;
    correctLabel.textAlignment = NSTextAlignmentCenter;
    [bgImageView addSubview:correctLabel];
    
    [correctLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(tipView);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"您共答对";
    label.textColor = RGBCOLOR(164, 192, 250);
    label.font = LabelFont(24);
    [bgImageView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(tipView);
        make.bottom.equalTo(tipView.mas_bottom).offset(-GENERAL_SIZE(40));
    }];
    
    UIView *countView = [[UIView alloc] initWithFrame:CGRectMake(0, GENERAL_SIZE(310), SCREEN_WIDTH, GENERAL_SIZE(160))];
    [bgImageView addSubview:countView];
    
    _correctItem = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2.0, GENERAL_SIZE(160))];
    _correctItem.font = LabelFont(30);
    _correctItem.textAlignment = NSTextAlignmentCenter;
    _correctItem.textColor = [UIColor whiteColor];
    _correctItem.text = [NSString stringWithFormat:@"%d％ | 正确率", [self numberOfCorrect]*100/(int)[_answerArray count]];
    
    _defectItem = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/2.0), 0, SCREEN_WIDTH/2.0, GENERAL_SIZE(160))];
    NSString *defeatNum = @"60";
    if ([self numberOfCorrect]==0) {
        defeatNum = @"0%";
    }else if([self numberOfCorrect]==[_answerArray count]){
        defeatNum = @"100%";
    }else{
        int n = arc4random() % 35+60;
        defeatNum = [NSString stringWithFormat:@"%d％",n];
    }
    _defectItem.textAlignment = NSTextAlignmentCenter;
    _defectItem.font = LabelFont(30);
    _defectItem.textColor = [UIColor whiteColor];
    _defectItem.text = [NSString stringWithFormat:@"%@ | 打败考生",defeatNum];
    
    [countView addSubview:_correctItem];
    [countView addSubview:_defectItem];
    
    _tableView.tableHeaderView = bgImageView;
    _tableView.tableHeaderView.backgroundColor = COMMONBLUECOLOR;
    
    [self setupBottomView];
}

-(void)setupBottomView{
    
    UIButton *analysisButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [analysisButton setBackgroundImage:[UIImage imageNamed:@"btn_analysis"] forState:UIControlStateNormal];
    [analysisButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [analysisButton sizeToFit];
    
    if (_type==1) {
        [analysisButton setTitle:@"购买教材" forState:UIControlStateNormal];
        [analysisButton addTarget:self action:@selector(jumpToBuyWeb) forControlEvents:UIControlEventTouchDown];
    }else{
        [analysisButton setTitle:@"全部解析" forState:UIControlStateNormal];
        [analysisButton addTarget:self action:@selector(showAnalysis) forControlEvents:UIControlEventTouchDown];
    }
    
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [finishButton setBackgroundImage:[UIImage imageNamed:@"question_finish"] forState:UIControlStateNormal];
    [finishButton setTitle:@"答题完成" forState:UIControlStateNormal];
    [finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [finishButton sizeToFit];
    [finishButton addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchDown];
    
    UIView *operationView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-UI_NAVIGATION7_BAR_HEIGHT-60, SCREEN_WIDTH, 60)];
    operationView.backgroundColor = RGBCOLOR(250, 250, 250);
    [self.view addSubview:operationView];
    
    [operationView addSubview:analysisButton];
    [operationView addSubview:finishButton];
    
    [analysisButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(operationView);
        make.width.equalTo(@(SCREEN_WIDTH*24/75));
        make.left.equalTo(operationView.mas_left).offset(15);
    }];
    
    [finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(operationView);
        make.left.equalTo(analysisButton.mas_right).offset(15);
        make.right.equalTo(operationView.mas_right).offset(-15);
    }];
}

-(void)jumpToBuyWeb{
    if(_url){
        NSString* strIdentifier = [_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strIdentifier]];
    }
}

-(void)showAnalysis{
    if(_analysisCallback){
        _analysisCallback();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)finish{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// 已答数
-(int)numberOfFinished{
    int i=0;
    for (Correctness *correct in _answerArray) {
        if (![correct.isCorrect isEqualToString:@"2"]) {
            i++;
        }
    }
    return i;
}
// 正确数
-(int)numberOfCorrect{
    int i=0;
    for (Correctness *correct in _answerArray) {
        if ([correct.isCorrect isEqualToString:@"1"]) {
            i++;
        }
    }
    return i;
}


/**
 *  获取知识点对应的视频
 */
-(void)fetchSectionVideo{
    if (!_objectId) {
        return;
    }
    CourseManager *cm = [[CourseManager alloc]init];
    NSString *userId = @"";
    AuthManager *am = [AuthManager sharedInstance];
    if (am.isAuthenticated) {
        userId = am.userInfo.userId;
    }
    [cm fetchSectionVideoWithID:_objectId UserId: userId Success:^(VideoBoxResult *result) {
        _videoArray = result.videoBox.videoList;
        [_tableView reloadData];
    } Failure:^(NSError *error) {
        
    }];
}

// 提交答案
-(void)submitAnswerToServer{
    AuthManager *am = [AuthManager sharedInstance];
    if (am.isAuthenticated) {
        CourseManager *cm = [[CourseManager alloc]init];
        NSString *answerJson = [self jsonStringFromDictionary];
        [cm submitQuestionAnswerWithId:am.userInfo.userId answer:answerJson type:[NSString stringWithFormat:@"%d",_type] Success:^(CommonResult *result) {
            if(_callbackBlock){
                _callbackBlock();
            }
            
        } Failure:^(NSError *error) {
            
        }];
    }
}

-(NSString*)jsonStringFromDictionary{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[_answerArray count]];
    for (Correctness *correctness in _answerArray) {
        if (correctness.optId) {
            NSDictionary *answerDict = [NSDictionary dictionaryWithObjectsAndKeys:correctness.no,@"no",correctness.optId,@"optId",correctness.timeSpan,@"timeSpan", nil];
            [array addObject:answerDict];
        }
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString;
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
        jsonString=@"";
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

#pragma tablview delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else{
        return [_videoArray count];
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        CorrectTableCell *cell = [[CorrectTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"correctCell"];
        [cell setupCell:_answerArray];
        return cell;
    }else{
        CourSectionTableCell *cell = [[CourSectionTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"videoCell"];
        CourseVideo *videoInfo = [_videoArray objectAtIndex:indexPath.row];
        [cell setCellWithModel:videoInfo];
        return cell;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    if (section==0) {
        sectionView.backgroundColor = [UIColor whiteColor];
    }else{
        sectionView.backgroundColor = RGBCOLOR(248, 248, 248);
    }
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    [sectionView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 200, 40)];
    if (section==0) {
        imageView.image = [UIImage imageNamed:@"icon_choice"];
        label.text = @"选择题";
    }else{
        if ([_videoArray count]>0) {
            imageView.image = [UIImage imageNamed:@"icon_ques_video"];
            label.text = @"知识点课程";
        }
    }
    [sectionView addSubview:label];
    
    return sectionView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1) {
        CourseVideo *videoInfo = [_videoArray objectAtIndex:indexPath.row];
        NSURL *url = [NSURL URLWithString:videoInfo.address];
        JRPlayerViewController *playerVC = [[JRPlayerViewController alloc] initWithHTTPLiveStreamingMediaURL:url];
        playerVC.mediaTitle = @"题目解析";
        [self presentViewController:playerVC animated:YES completion:nil];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if([_videoArray count]==0&&section==1)
        return 0.01;
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        NSInteger rowCount = [_answerArray count]%5==0?[_answerArray count]/5:[_answerArray count]/5+1;
        return rowCount*(SCREEN_WIDTH/5-10);
    }else{
        return 45;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
