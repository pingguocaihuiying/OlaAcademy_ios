//
//  TeacherInfoViewController.m
//  mxedu
//
//  Created by 田晓鹏 on 15/11/29.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import "TeacherInfoViewController.h"

#import "SysCommon.h"

@interface TeacherInfoViewController ()<UITextViewDelegate>

@end

@implementation TeacherInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _teacherInfo.name;
    
    [self setupBackButton];
    
    UITextView *textView= [[UITextView alloc]initWithFrame:self.view.bounds];
    textView.delegate = self;
    textView.text = [NSString stringWithFormat:@"        %@",_teacherInfo.profile];
    textView.textColor = RGBCOLOR(136, 136, 136);
    textView.font = [UIFont systemFontOfSize:15.0];
    [self.view addSubview:textView];
    
}

- (void)setupBackButton
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"ic_back_white"] forState:UIControlStateNormal];
    [backBtn sizeToFit];
    [backBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

-(void)backButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return NO;
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
