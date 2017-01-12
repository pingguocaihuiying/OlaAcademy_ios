//
//  RegisterViewController.m
//
//  Created by 田晓鹏 on 14-6-20.
//  Copyright (c) 2015年. All rights reserved.
//

#import "RegisterViewController.h"
#import "NSString+ContentCheck.h"
#import "UserManager.h"
#import "SysCommon.h"
#import "UserProcotolViewController.h"
#import "UserPrivacyViewController.h"
#import "MainViewController.h"

#import "Masonry.h"
#import "AuthManager.h"

@interface RegisterViewController ()<UIAlertViewDelegate>

@end

@implementation RegisterViewController{
    UILabel *tipLabel;
    UILabel *tipLabel2;
    UITextField *phoneTextField;
    UITextField *codeTextField;
    UITextField *passTextField;
    UIButton *codeBtn;
    UIButton *passBtn;
    UILabel *protocolLabel;
    
    BOOL passHidden;
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
    [self setupBackButton];
    
    tipLabel = [[UILabel alloc]init];
    tipLabel.text = @"您的电话号码是什么？";
    [tipLabel sizeToFit];
    tipLabel.font = [UIFont systemFontOfSize:20.0];
    tipLabel.textColor = RGBCOLOR(128, 128, 128);
    [self.view addSubview:tipLabel];
    
    tipLabel2 = [[UILabel alloc]init];
    tipLabel2.text = @"不用担心，我们不会公开您的号码";
    [tipLabel2 sizeToFit];
    tipLabel2.font = [UIFont systemFontOfSize:16.0];
    tipLabel2.textColor = RGBCOLOR(128, 128, 128);
    [self.view addSubview:tipLabel2];
    
    phoneTextField = [[UITextField alloc]init];
    phoneTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    phoneTextField.placeholder = @"请输入您的手机号";
    phoneTextField.returnKeyType = UIReturnKeyDone;
    phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:phoneTextField];
    
    codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [codeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,  0 , 0, 0)];
    codeBtn.layer.cornerRadius = 5;
    codeBtn.layer.masksToBounds = YES;
    codeBtn.backgroundColor= RGBCOLOR(84, 170, 238);
    codeBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [codeBtn setTitle:@"验证" forState:UIControlStateNormal];
    [codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [codeBtn addTarget:self action:@selector(verify:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:codeBtn];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(35);
        make.left.equalTo(self.view.mas_left).offset(10);
    }];
    
    [tipLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLabel.mas_bottom).offset(15);
        make.left.equalTo(self.view.mas_left).offset(10);
    }];
    
    [phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLabel2.mas_bottom).offset(50);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(codeBtn.mas_left).offset(-10);
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
    passHidden = YES;
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
    
    phoneTextField.delegate=self;
    codeTextField.delegate=self;
    passTextField.delegate=self;
    
    
    protocolLabel = [[UILabel alloc]init];
    protocolLabel.numberOfLines = 0;
    [protocolLabel sizeToFit];
    protocolLabel.font = [UIFont systemFontOfSize:14.0];
    protocolLabel.textColor = RGBCOLOR(3, 3, 3);
    [self.view addSubview:protocolLabel];
    
    [protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line3.mas_bottom).offset(20);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
    }];
    
    protocolLabel.text = @"请验证完成后点击『提交』完成注册。";
    
//    UIButton *protocolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [protocolBtn addTarget:self action:@selector(browseProcotol) forControlEvents:UIControlEventTouchDown];
//    [self.view addSubview:protocolBtn];
//    
//    [protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(line3.mas_bottom).offset(15);
//        make.left.equalTo(self.view.mas_left).offset(120);
//        make.width.equalTo(@70);
//        make.height.equalTo(@25);
//    }];
//    
//    UIButton *privacyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [privacyBtn addTarget:self action:@selector(browsePrivacy) forControlEvents:UIControlEventTouchDown];
//    [self.view addSubview:privacyBtn];
//    
//    [privacyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(line3.mas_bottom).offset(15);
//        make.left.equalTo(self.view.mas_left).offset(200);
//        make.width.equalTo(@70);
//        make.height.equalTo(@25);
//    }];
    
//    NSString *protocol = @"注册意味着您同意服务条款与隐私政策，请验证完成后点击『提交』完成注册。";
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]
//                                      initWithString:protocol];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:5];//调整行间距
//    
//    [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [protocol length])];
//    [str addAttribute:NSForegroundColorAttributeName value:COMMONBLUECOLOR range:NSMakeRange(8,4)];
//    [str addAttribute:NSForegroundColorAttributeName value:COMMONBLUECOLOR range:NSMakeRange(13,4)];
//    protocolLabel.attributedText = str;
    
    
    UIButton *regBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [regBtn setBackgroundImage:[UIImage imageNamed:@"bg_btn"] forState:UIControlStateNormal];
    [regBtn sizeToFit];
    [regBtn setTitle:@"提交" forState:UIControlStateNormal];
    regBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [regBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [regBtn addTarget:self action:@selector(regist) forControlEvents:UIControlEventTouchDown];
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
    
    
    [self setUpForDismissKeyboard];

}

- (void)setupBackButton
{
    self.title = @"注册";
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


#pragma methods

//查看协议
-(void)browseProcotol
{
    UserProcotolViewController *procotolVC = [[UserProcotolViewController alloc]init];
    [self.navigationController pushViewController:procotolVC animated:YES];
}

-(void)browsePrivacy
{
    UserPrivacyViewController *privacyVC = [[UserPrivacyViewController alloc]init];
    [self.navigationController pushViewController:privacyVC animated:YES];
}

//显示密码
-(void)showPass
{
    if (passHidden) {
        passTextField.secureTextEntry = NO;
        passHidden = NO;
    }else{
        passTextField.secureTextEntry = YES;
        passHidden = YES;
    }
   
}

int ns=0;

//获取验证码
- (void)verify:(UIButton*)btn {
    if(!phoneTextField.text.isValidChineseCellphoneNumberWithoutPrefix){
        UIAlertView * aView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aView show];
        return;
    }
    //倒计时
    [btn setTitle:@"60秒" forState:UIControlStateNormal];
    ns = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdown:) userInfo:nil repeats:YES];
    //网络获取
    UserManager *um = [[UserManager alloc]init];
    [um fetchValidateCodeWithMobile:phoneTextField.text Success:^{

    } Failure:^(NSError *error) {
        
    }];
    
}
// 注册方法
- (void)regist {
    
    if (passTextField.text.length < 6) {
        UIAlertView * aView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"为了您的账户安全，请输入6位到16位密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aView show];
        return;
    }
    if(codeTextField.text.length==0){
        UIAlertView * aView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aView show];
        return;
    }
    UserManager *userManger = [[UserManager alloc]init];
    [userManger registerUserWithMobile:phoneTextField.text
                          IdentityCode:codeTextField.text
                                   Pwd:passTextField.text
                                Status:@"1"
                               Success:^{
                                   // 保存用户名密码
                                   NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                                   NSDictionary *loginInfo = [NSDictionary dictionaryWithObjectsAndKeys:phoneTextField.text,@"mobile",passTextField.text,@"password", nil];
                                   [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:loginInfo]
                                                forKey:@"LoginInfo"];
                                   [self login];
                                   
                               } Failure:^(NSError *error) {
                                   
                               }];

}

//登陆方法
- (void)login {
    AuthManager *authManger = [[AuthManager alloc]init];
    [authManger authWithMobile:phoneTextField.text password:passTextField.text success:^{
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"NEEDREFRESH" object:nil];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        
    } failure:^(NSError *error) {
        NSLog(@"login error");
    }];
}

//倒计时
-(void)countdown:(NSTimer  *)t
{
    
    if (ns<=59) {
        codeBtn.backgroundColor=[UIColor grayColor];
        codeBtn.userInteractionEnabled=NO;
        
        ns++;
        int n=60-ns;
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
        ns = 0;
    }
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

#pragma UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [timer invalidate];
}

@end
