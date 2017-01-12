//
//  LoginViewController.m
//  mxedu
//
//  Created by 田晓鹏 on 15/11/2.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import "LoginViewController.h"

#import "SysCommon.h"
#import "AuthManager.h"

#import "Masonry.h"

#import "MainViewController.h"
#import "RegisterViewController.h"
#import "ForgetPassViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>

@end

@implementation LoginViewController

UILabel *tipLabel;
UITextField *phoneTextField;
UITextField *passTextField;

-(void)viewWillAppear:(BOOL)animated{
    
    /***********************取数据*******************/
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSData* data = [defaults objectForKey:@"LoginInfo"];
    NSDictionary *loginInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    phoneTextField.text = [loginInfo objectForKey:@"mobile"];
    passTextField.text = [loginInfo objectForKey:@"password"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupBackButton];

    tipLabel = [[UILabel alloc]init];
    tipLabel.text = @"登录欧拉联考";
    [tipLabel sizeToFit];
    tipLabel.font = [UIFont systemFontOfSize:20.0];
    tipLabel.textColor = RGBCOLOR(128, 128, 128);
    [self.view addSubview:tipLabel];
    
    phoneTextField = [[UITextField alloc]init];
    phoneTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    phoneTextField.placeholder = @"请输入您的手机号";
    phoneTextField.returnKeyType = UIReturnKeyDone;
    phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:phoneTextField];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(35);
        make.left.equalTo(self.view.mas_left).offset(10);
    }];
    
    [phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLabel.mas_bottom).offset(50);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        if (iPhone6Plus) {
            make.height.equalTo(@50);
        }else{
            make.height.equalTo(@38);
        }
    }];
    
    UIImageView *line1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_line"]];
    [self.view addSubview:line1];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneTextField.mas_bottom).offset(-5);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
    }];
    
    passTextField = [[UITextField alloc]init];
    passTextField.layer.cornerRadius = 8.0f;
    passTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passTextField.placeholder = @"请输入您的密码";
    passTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passTextField.secureTextEntry = YES;
    passTextField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:passTextField];
    
    [passTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneTextField.mas_bottom).with.offset(20);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        if (iPhone6Plus) {
            make.height.equalTo(@50);
        }else{
            make.height.equalTo(@38);
        }
    }];
    
    UIImageView *line2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_line"]];
    [self.view addSubview:line2];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passTextField.mas_bottom).offset(-5);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
    }];
    
    phoneTextField.delegate=self;
    passTextField.delegate=self;
    
    UIButton *passBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [passBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    passBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [passBtn setTitleColor:COMMONBLUECOLOR forState:UIControlStateNormal];
    [passBtn addTarget:self action:@selector(findPassword) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:passBtn];
    [passBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.left.equalTo(self.view.mas_left).offset(20);
    }];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn sizeToFit];
    [loginBtn setImage:[UIImage imageNamed:@"btn_login_blue"] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.right.equalTo(self.view.mas_right).offset(-20);
    }];
    
    UIImageView *line3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_line"]];
    [self.view addSubview:line3];
    
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(loginBtn.mas_top).offset(-5);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
    }];


    
    [self setUpForDismissKeyboard];
}

- (void)setupBackButton
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"取消" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn sizeToFit];
    [backBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    UIButton *regBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [regBtn setTitle:@"注册" forState:UIControlStateNormal];
    [regBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [regBtn sizeToFit];
    [regBtn addTarget:self action:@selector(registClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *regButtonItem = [[UIBarButtonItem alloc] initWithCustomView:regBtn];
    self.navigationItem.rightBarButtonItem = regButtonItem;
}

-(void)backButtonClicked{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//用户注册
- (void)registClicked {
    RegisterViewController * regVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:regVC animated:YES];
}

//登陆方法
- (void)login {
    AuthManager *authManger = [[AuthManager alloc]init];
    [authManger authWithMobile:phoneTextField.text password:passTextField.text success:^{
        // 保存用户名密码
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *loginInfo = [NSDictionary dictionaryWithObjectsAndKeys:phoneTextField.text,@"mobile",passTextField.text,@"password", nil];
        [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:loginInfo]
                     forKey:@"LoginInfo"];
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        if (_successFunc) {
            _successFunc();
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"NEEDREFRESH" object:nil];
        
    } failure:^(NSError *error) {
        NSLog(@"login error");
    }];
}

//找回密码
- (void)findPassword {
    ForgetPassViewController * passVC = [[ForgetPassViewController alloc] init];
    passVC.phoneNumber = phoneTextField.text;
    passVC.isFromIndex = YES;
    [self.navigationController pushViewController:passVC animated:YES];
}


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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
