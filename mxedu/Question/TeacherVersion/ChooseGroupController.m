//
//  ChooseGroupController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/10/9.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "ChooseGroupController.h"

#import "SysCommon.h"
#import "UIColor+HexColor.h"
#import "Masonry.h"
#import "SVProgressHUD.h"
#import "ChooseGroupTableCell.h"

#import "GroupManager.h"
#import "AuthManager.h"
#import "HomeworkManager.h"

@interface ChooseGroupController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *dataArray;

@end

@implementation ChooseGroupController{
    
    UILabel *title; //title 的 placehoder
    UITextView *editTitle;
    
    UITapGestureRecognizer *wholeTap;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发布";
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(editTitle.frame), SCREEN_WIDTH, GENERAL_SIZE(90))];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UILabel *tip1 = [[UILabel alloc]initWithFrame:CGRectMake(GENERAL_SIZE(30), 0, 100, GENERAL_SIZE(90))];
    tip1.text = @"作业名称";
    tip1.font = LabelFont(28);
    tip1.textColor = [UIColor colorWhthHexString:@"#51545d"];
    [bgView addSubview:tip1];

    
    title = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 180, GENERAL_SIZE(60))];
    title.enabled = NO;
    title.text = @"请输入作业名称（2-15个字）";
    title.font =  LabelFont(24);
    title.textColor = [UIColor blackColor];
    
    editTitle = [UITextView new];
    editTitle.tag = 1001;
    editTitle.frame = CGRectMake(SCREEN_WIDTH-GENERAL_SIZE(360), GENERAL_SIZE(15), GENERAL_SIZE(360), GENERAL_SIZE(60));
    editTitle.font = LabelFont(28);
    editTitle.delegate = self;
    editTitle.showsVerticalScrollIndicator = false;
    [editTitle addSubview:title];
    [bgView addSubview:editTitle];
    
    UIView *divider = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView.frame), SCREEN_WIDTH, GENERAL_SIZE(90))];
    divider.backgroundColor = RGBCOLOR(235, 235, 235);
    [self.view addSubview:divider];
    
    UILabel *tip2 = [[UILabel alloc]initWithFrame:CGRectMake(GENERAL_SIZE(30), 0, 100, GENERAL_SIZE(90))];
    tip2.text = @"发布到";
    tip2.font = LabelFont(28);
    tip2.textColor = [UIColor colorWhthHexString:@"#51545d"];
    [divider addSubview:tip2];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(divider.frame), SCREEN_WIDTH, SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-UI_STATUS_BAR_HEIGHT-GENERAL_SIZE(300))];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = RGBCOLOR(235, 235, 235);
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [self setupData];
    
    wholeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
}

-(void)setupData{
    AuthManager *am = [AuthManager sharedInstance];
    GroupManager *gm = [[GroupManager alloc]init];
    if (am.userInfo) {
        [gm fetchTeacherGroupListWithUserId:am.userInfo.userId Success:^(GroupListResult *result) {
            _dataArray = [NSMutableArray arrayWithArray:result.groupArray];
            [_tableView reloadData];
            [self setupDeployButton];
        } Failure:^(NSError *error) {

        }];
    }
}

-(void)setupDeployButton{
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.backgroundColor = COMMONBLUECOLOR;
    nextBtn.layer.masksToBounds = YES;
    nextBtn.layer.cornerRadius = GENERAL_SIZE(40);
    [nextBtn setTitle:@"发布作业" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(deploy) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:nextBtn];
    
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(GENERAL_SIZE(75));
        make.right.equalTo(self.view.mas_right).offset(-GENERAL_SIZE(75));
        make.height.equalTo(@(GENERAL_SIZE(80)));
        make.bottom.equalTo(self.view).offset(-GENERAL_SIZE(20));
    }];
    
    UIView *divider = [[UIView alloc] init];
    divider.backgroundColor = RGBCOLOR(237, 237, 237);
    [self.view addSubview:divider];
    
    [divider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@(GENERAL_SIZE(2)));
        make.bottom.equalTo(nextBtn.mas_top).offset(-GENERAL_SIZE(20));
    }];
}

-(void)deploy{
    NSString *titleString = [editTitle.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (titleString.length<2||titleString.length>15) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"作业名称字数为2-15个字" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    NSString *groupIds = @"";
    for (Group *group in _dataArray) {
        if (group.isChosen == 1) {
            groupIds = [[groupIds stringByAppendingString:group.groupId]stringByAppendingString:@","];
        }
    }
    if([groupIds isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请选择要发布的群" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    [SVProgressHUD showWithStatus:@"发布中,请稍后..." maskType:SVProgressHUDMaskTypeNone];
    HomeworkManager *hm = [[HomeworkManager alloc]init];
    [hm deployHomeworkWithGroupIds:groupIds GroupName:titleString SubjectIds:_subjectIds Success:^(CommonResult *result) {
        [SVProgressHUD showInfoWithStatus:@"发布成功!"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"DEPLOY_HOMEWORK" object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } Failure:^(NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"发布失败!"];
    }];
}


#pragma UITextView

-(void)textViewDidBeginEditing:(UITextView *)textView{
    [self.view addGestureRecognizer:wholeTap];
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.tag==1001) {
        if ([textView.text length] == 0) {
            [title setHidden:NO];
        }else{
            [title setHidden:YES];
        }
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"groupCell";
    ChooseGroupTableCell *groupCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (groupCell == nil) {
        groupCell = [[ChooseGroupTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"groupCell"];
    }
    Group *group = [_dataArray objectAtIndex:indexPath.row];
    [groupCell setupCellWithModel:group];
    groupCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return groupCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return GENERAL_SIZE(90);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Group *group = [_dataArray objectAtIndex:indexPath.row];
    group.isChosen = group.isChosen==0?1:0;
    [_dataArray replaceObjectAtIndex:indexPath.row withObject:group];
    [tableView reloadData];
}

/**
 *  隐藏键盘
 */
-(void)dismissKeyboard {
    NSArray *subviews = [self.view subviews];
    for (id objInput in subviews) {
        if ([objInput isKindOfClass:[UITextField class]]) {
            UITextField *theTextField = objInput;
            if ([objInput isFirstResponder]) {
                [theTextField resignFirstResponder];
            }
        }
    }
    [self.view endEditing:YES];
    [self.view removeGestureRecognizer:wholeTap];
}

-(void)viewWillDisappear:(BOOL)animated{
    [SVProgressHUD dismiss];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
