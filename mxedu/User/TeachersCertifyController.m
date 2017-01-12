//
//  TeachersCertifyController.m
//  mxedu
//
//  Created by zhufeng on 2017/1/11.
//  Copyright © 2017年 田晓鹏. All rights reserved.
//

#import "TeachersCertifyController.h"
#import "SysCommon.h"
#import "teacherCertifyCell.h"
#import "teacherCertifyModel.h"

@interface TeachersCertifyController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextViewDelegate> {
    UITableView *tCertifyTableView;
}

@property (nonatomic,strong) teacherCertifyModel *teacherModel;

@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,strong) NSArray *placeholderArray;
@property (nonatomic,strong) UILabel *placeHolder;
@property (nonatomic,strong) UIView *footerView;

@property (nonatomic,strong) UITextField *nameText;
@property (nonatomic,strong) UITextField *telText;
@property (nonatomic,strong) UITextField *emailText;
@property (nonatomic,strong) UITextField *courseText;
@property (nonatomic,strong) UITextView *descitionText;

@property (nonatomic, assign) CGFloat keyBoardHeight;

@end

@implementation TeachersCertifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBCOLOR(235, 235, 235);
    
    _titleArray = @[@"真实姓名",@"联系电话",@"联系邮箱",@"所授科目",@"其他信息"];
    _placeholderArray = @[@"请输入真实姓名",@"请输入联系电话",@"请输入联系邮箱",@"请输入所授课程"];
    
    //返回按钮
    [self setNavBar];
    [self setupListTableview];
    
    [self registerKeyBoardNotification];//键盘弹出的响应通知
}

-(void)setupListTableview {
    tCertifyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-GENERAL_SIZE(120))];
    tCertifyTableView.dataSource = self;
    tCertifyTableView.delegate = self;
    tCertifyTableView.backgroundColor = RGBCOLOR(235, 235, 235);
    tCertifyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tCertifyTableView];
    
    tCertifyTableView.tableFooterView = [self setupFooterEditInformation];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    
    teacherCertifyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[teacherCertifyCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.titleLabel.text = self.titleArray[indexPath.row];
    
    if (indexPath.row == 4) {
        cell.valueText.text = nil;
        cell.slideView.hidden = YES;
    } else {
        cell.valueText.placeholder = self.placeholderArray[indexPath.row];
        if (indexPath.row == 0) {
            self.nameText = cell.valueText;
        }
        if (indexPath.row == 1) {
            self.telText = cell.valueText;
        }
        if (indexPath.row == 2) {
            self.emailText = cell.valueText;
        }
        if (indexPath.row == 3) {
            self.courseText = cell.valueText;
        }
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
        return GENERAL_SIZE(88);
    }
    return GENERAL_SIZE(100);
}

-(UIView *)setupFooterEditInformation {
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_HEIGHT-GENERAL_SIZE(100)*self.titleArray.count-64))];
    self.footerView.backgroundColor = RGBCOLOR(235, 235, 235);
    
    UITextView *descritonTextView = [[UITextView alloc] initWithFrame:CGRectMake(GENERAL_SIZE(0), 0, SCREEN_WIDTH, GENERAL_SIZE(160))];
    //设置文字内边距
    descritonTextView.textContainerInset = UIEdgeInsetsMake(0, GENERAL_SIZE(18), 0, GENERAL_SIZE(18));
    descritonTextView.delegate = self;
    descritonTextView.font = LabelFont(34);
    descritonTextView.textColor = RGBCOLOR(191, 192, 194);
    descritonTextView.backgroundColor = [UIColor whiteColor];
    [self.footerView addSubview:descritonTextView];
    
    _placeHolder = [[UILabel alloc] initWithFrame:CGRectMake(GENERAL_SIZE(20), 0, SCREEN_WIDTH-GENERAL_SIZE(40), 30)];
    _placeHolder.textColor = RGBCOLOR(191, 192, 194);
    _placeHolder.font = LabelFont(34);
    _placeHolder.text = @"请输入自我简介...";
    [descritonTextView addSubview:_placeHolder];
    
    [self setupFooterViewSubViews];
    
    self.descitionText = descritonTextView;
    
    return self.footerView;
}
-(void)setupFooterViewSubViews {
    //说明文字
    CGFloat explainLabelH = GENERAL_SIZE(60);
    UILabel *explainLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.footerView.height-explainLabelH-GENERAL_SIZE(30), SCREEN_WIDTH, explainLabelH)];
    explainLabel.text = @"携手老师，推进互联网教学服务，共创未来!";
    explainLabel.textColor = RGBCOLOR(126, 127, 132);
    explainLabel.textAlignment = NSTextAlignmentCenter;
    [self.footerView addSubview:explainLabel];
    //欧拉学院
    UILabel *olaStudyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, explainLabel.y-GENERAL_SIZE(20)-GENERAL_SIZE(80), SCREEN_WIDTH, GENERAL_SIZE(80))];
    olaStudyLabel.text = @"欧拉学院";
    olaStudyLabel.font = LabelFont(38);
    olaStudyLabel.textColor = COMMONBLUECOLOR;
    olaStudyLabel.textAlignment = NSTextAlignmentCenter;
    [self.footerView addSubview:olaStudyLabel];
    //提交按钮
    UIButton *submmitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [submmitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submmitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submmitButton setBackgroundColor:COMMONBLUECOLOR];
    submmitButton.frame = CGRectMake(GENERAL_SIZE(60), olaStudyLabel.y-GENERAL_SIZE(20)-GENERAL_SIZE(80), SCREEN_WIDTH-GENERAL_SIZE(120), GENERAL_SIZE(80));
    submmitButton.layer.cornerRadius = GENERAL_SIZE(15);
    submmitButton.layer.masksToBounds = YES;
    [self.footerView addSubview:submmitButton];
    
    [submmitButton addTarget:self action:@selector(submmitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
}
//提交信息
-(void)submmitButtonClick {
    //把编辑的信息赋值给 Model
    [self setupModel];

}
-(void)setupModel {
    self.teacherModel.name = self.nameText.text;
    self.teacherModel.telNumber = self.telText.text;
    self.teacherModel.email = self.emailText.text;
    self.teacherModel.course = self.courseText.text;
    self.teacherModel.descritionString = self.descitionText.text;
}
-(teacherCertifyModel *)teacherModel {
    if (!_teacherModel) {
        _teacherModel = [[teacherCertifyModel alloc] init];
    }
    return _teacherModel;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect rect = [textView convertRect:textView.bounds toView:window];
    [self keyBoardWindowCGRect:rect];

}
#pragma mask ==== 键盘弹出的操作
- (void)registerKeyBoardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoardHide:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoardAction:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)handleKeyBoardHide:(NSNotification *)notification {
    CGRect rect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyBoardHeight = rect.size.height;
}

- (void)handleKeyBoardAction:(NSNotification *)notification {
}

//处理键盘
- (void)keyBoardWindowCGRect:(CGRect)rect {
    CGPoint offset = tCertifyTableView.contentOffset;
    offset.y += rect.origin.y + 130 - ([UIScreen mainScreen].bounds.size.height - self.keyBoardHeight - 40);;
    if (offset.y < 0) {
        offset.y = 0;
    }
    [UIView animateWithDuration:0.25 animations:^{
        tCertifyTableView.contentOffset = offset;
    }];
}
- (void)textViewDidChange:(UITextView *)textView
{
    if (!textView.text.length) {
        self.placeHolder.alpha = 1;
    } else {
        self.placeHolder.alpha = 0;
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [tCertifyTableView endEditing:YES]; //滑动屏幕收回键盘
    [tCertifyTableView resignFirstResponder];
    
}
-(void)setNavBar
{
    self.title = @"老师认证";
    self.navigationController.navigationBar.translucent = NO;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    [backBtn sizeToFit];
    [backBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}
-(void)backButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
