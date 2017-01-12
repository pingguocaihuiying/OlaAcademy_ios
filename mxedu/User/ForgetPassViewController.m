//
//  xiugaimimaViewController.m
//  Lvlicheng
//
//  Created by LZQ on 14-6-20.
//  Copyright (c) 2014年 lianyou. All rights reserved.
//

#import "ForgetPassViewController.h"
#import "UserManager.h"
#import "SysCommon.h"
#import <Masonry.h>
#import "NSString+ContentCheck.h"
@interface ForgetPassViewController ()

@end

@implementation ForgetPassViewController{
    UITextField *phoneTextField;
    UITextField *codeTextField;
    UITextField *passTextField;
    UIButton *codeBtn;
    UIButton *passBtn;
    
    NSTimer *timer;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"找回密码";
    [self setupBackButton];
    
    phoneTextField = [[UITextField alloc]init];
    phoneTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    phoneTextField.placeholder = @"请输入您的手机号";
    phoneTextField.returnKeyType = UIReturnKeyDone;
    phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:phoneTextField];
    
    [phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.isFromIndex) {
            make.top.equalTo(self.view.mas_top).with.offset(30);
        }else{
            make.top.equalTo(self.view.mas_top).with.offset(0);
        }
        
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        if (iPhone6Plus) {
            make.height.equalTo(@50);
        }else{
            make.height.equalTo(@38);
        }
    }];
    
    codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    codeBtn.layer.cornerRadius = 5;
    codeBtn.layer.masksToBounds = YES;
    codeBtn.backgroundColor= RGBCOLOR(84, 170, 238);
    codeBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [codeBtn setTitle:@"验证" forState:UIControlStateNormal];
    [codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [codeBtn addTarget:self action:@selector(verify:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:codeBtn];
    
    
    UIImageView *line1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_line"]];
    [self.view addSubview:line1];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneTextField.mas_bottom).offset(-5);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(codeBtn.mas_left).offset(-10);
    }];
    
    
    codeTextField = [[UITextField alloc]init];
    codeTextField.layer.cornerRadius = 8.0f;
    codeTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    codeTextField.placeholder = @"请输入验证码";
    codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    codeTextField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:codeTextField];
    
    [codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneTextField.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(codeBtn.mas_left).offset(-10);
        if (iPhone6Plus) {
            make.height.equalTo(@50);
        }else{
            make.height.equalTo(@38);
        }
    }];
    
    [codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(line1.mas_top).offset(0);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.equalTo(@25);
        make.width.equalTo(@50);
    }];
    
    UIImageView *line2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_line"]];
    [self.view addSubview:line2];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeTextField.mas_bottom).offset(-5);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(codeBtn.mas_left).offset(-10);
    }];
    
    passTextField = [[UITextField alloc]init];
    passTextField.layer.cornerRadius = 8.0f;
    passTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passTextField.placeholder = @"请输入密码";
    passTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passTextField.secureTextEntry = YES;
    passTextField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:passTextField];
    
    [passTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeTextField.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(codeBtn.mas_left).offset(-10);
        if (iPhone6Plus) {
            make.height.equalTo(@50);
        }else{
            make.height.equalTo(@38);
        }
    }];
    
    passBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [passBtn setImage:[UIImage imageNamed:@"ic_show_pass"] forState:UIControlStateNormal];
    [passBtn sizeToFit];
    [passBtn addTarget:self action:@selector(showPass) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:passBtn];
    
    [passBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line2.mas_bottom).with.offset(20);
        make.left.equalTo(passTextField.mas_right).offset(10);
    }];
    
    UIImageView *line3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_line"]];
    [self.view addSubview:line3];
    
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passTextField.mas_bottom).offset(-5);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(codeBtn.mas_left).offset(-10);
    }];
    
    UIButton *regBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [regBtn setBackgroundImage:[UIImage imageNamed:@"bg_btn"] forState:UIControlStateNormal];
    [regBtn sizeToFit];
    [regBtn setTitle:@"确认" forState:UIControlStateNormal];
    regBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [regBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [regBtn addTarget:self action:@selector(modifyPass) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:regBtn];
    [regBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.right.equalTo(self.view.mas_right).offset(-20);
    }];
    
    UIImageView *line4 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_line"]];
    [self.view addSubview:line4];
    
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(regBtn.mas_top).offset(-5);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
    }];

    
    
    phoneTextField.delegate = self;
    codeTextField.delegate = self;
    passTextField.delegate = self;
    phoneTextField.text = self.phoneNumber;
    
    [self setUpForDismissKeyboard];
    
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


int  flag=0;
//获取验证码方法
- (void)verify:(UIButton*)btn
{
    if(!phoneTextField.text.isValidChineseCellphoneNumberWithoutPrefix){
        UIAlertView * aView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aView show];
        return;
    }
    //倒计时
    flag = 0;
    [btn setTitle:@"60秒" forState:UIControlStateNormal];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(shijiantiaodong:) userInfo:nil repeats:YES];
    //网络获取
    UserManager *um = [[UserManager alloc]init];
    [um fetchValidateCodeWithMobile:phoneTextField.text Success:^{
        
    } Failure:^(NSError *error) {
        
    }];
}

//显示密码
-(void)showPass
{
    passTextField.secureTextEntry = NO;
}

//确认方法
-(void)modifyPass
{
    if ([phoneTextField.text isEqualToString:@""] || [codeTextField.text isEqualToString:@""]) {
        UIAlertView * aView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请输入手机号和验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aView show];
    }
    else if (passTextField.text.length < 6) {
        UIAlertView * aView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"为了您的账户安全，请输入6位到16位密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aView show];
        return;
    }
    else{
        UserManager *um = [[UserManager alloc]init];
        [um resetPassWithMobile:phoneTextField.text IdentityCode:codeTextField.text Pwd:passTextField.text Success:^{
            UIAlertView * aView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码重置成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [aView show];
        } Failure:^(NSError *error) {
            
        }];
    }
}
//倒计时方法
-(void)shijiantiaodong:(NSTimer  *)t
{
    
    if (flag<=59) {
        codeBtn.backgroundColor=[UIColor grayColor];
        codeBtn.userInteractionEnabled=NO;
        
        flag++;
        int n=60-flag;
        NSString *str=[NSString stringWithFormat:@"%i秒",n];
        [codeBtn setTitle:str forState:UIControlStateNormal];
    }
    else
    {
        codeBtn.backgroundColor= RGBCOLOR(84, 170, 238);
        codeBtn.userInteractionEnabled=YES;
        codeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        codeBtn.titleLabel.numberOfLines = 0;
        [codeBtn setTitle:@"验证" forState:UIControlStateNormal];
        [t invalidate];
        flag = 0;
    }
}

#pragma mark -- UITextFieldDelegate
//收键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

// 隐藏软键盘
- (void)setUpForDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
}

#pragma UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [timer invalidate];
}
@end
