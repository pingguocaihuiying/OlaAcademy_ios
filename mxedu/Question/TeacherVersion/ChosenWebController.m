//
//  ChosenWebController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/10/9.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "ChosenWebController.h"

#import "SysCommon.h"
#import "Question.h"
#import "ExamManager.h"
#import "Masonry.h"
#import <WebViewJavascriptBridge.h>

#import "ChooseGroupController.h"

@interface ChosenWebController ()

@property (nonatomic) WebViewJavascriptBridge* bridge;
@property (nonatomic) UIWebView *webView;

@end

@implementation ChosenWebController{
    UIButton *deployBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"已选题目";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-UI_STATUS_BAR_HEIGHT-GENERAL_SIZE(122))];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.dataDetectorTypes = UIDataDetectorTypeNone;
    //隐藏滚动条
    for (UIView *_aView in [_webView subviews])
    {
        if ([_aView isKindOfClass:[UIScrollView class]])
        {
            [(UIScrollView *)_aView setShowsHorizontalScrollIndicator:NO];
        }
    }
    [self.view addSubview:_webView];
    
    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
    
    // js调用ios方法
    [_bridge registerHandler:@"mathObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *index = [data objectForKey:@"questionIndex"];
        [_questionArray removeObjectAtIndex:[index intValue]];
        [self setupQuestion];
        [deployBtn setTitle:[NSString stringWithFormat:@"去发布(%ld)",[_questionArray count]] forState:UIControlStateNormal];
    }];
    
    [self loadExamplePage:_webView];
    [self setupQuestion];
    [self setupButton];

}

-(void)setupButton{
    deployBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deployBtn.backgroundColor = COMMONBLUECOLOR;
    deployBtn.layer.masksToBounds = YES;
    deployBtn.layer.cornerRadius = GENERAL_SIZE(40);
    [deployBtn setTitle:[NSString stringWithFormat:@"去发布(%ld)",[_questionArray count]] forState:UIControlStateNormal];
    [deployBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deployBtn addTarget:self action:@selector(deploy) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:deployBtn];
    
    [deployBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-GENERAL_SIZE(70));
        make.height.equalTo(@(GENERAL_SIZE(80)));
        make.width.equalTo(@(GENERAL_SIZE(285)));
        make.bottom.equalTo(self.view).offset(-GENERAL_SIZE(20));
    }];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.layer.cornerRadius = GENERAL_SIZE(40);
    cancelBtn.layer.borderColor = [COMMONBLUECOLOR CGColor];
    cancelBtn.layer.borderWidth = 1.0f;
    [cancelBtn setTitle:@"取消发布" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:COMMONBLUECOLOR forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:cancelBtn];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(GENERAL_SIZE(70));
        make.width.equalTo(@(GENERAL_SIZE(285)));
        make.height.equalTo(@(GENERAL_SIZE(80)));
        make.bottom.equalTo(self.view).offset(-GENERAL_SIZE(20));
    }];
    
    UIView *divider = [[UIView alloc] init];
    divider.backgroundColor = RGBCOLOR(237, 237, 237);
    [self.view addSubview:divider];
    
    [divider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@(GENERAL_SIZE(2)));
        make.bottom.equalTo(deployBtn.mas_top).offset(-GENERAL_SIZE(20));
    }];
}

-(void)deploy{
    if ([_questionArray count]==0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请选择要发布的题目" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    ChooseGroupController *chooseGroup = [[ChooseGroupController alloc]init];
    NSString *subjectIds = @"";
    for (Question *question in _questionArray) {
        subjectIds = [[subjectIds stringByAppendingString:question.questionId] stringByAppendingString:@","];
    }
    chooseGroup.subjectIds = subjectIds;
    [self.navigationController pushViewController:chooseGroup animated:YES];
}

-(void)cancel{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)loadExamplePage:(UIWebView*)webView {
    
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"homework_chosen" ofType:@"html" inDirectory:@"MathJax/html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
}

-(void)setupQuestion{
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    [dataDic setObject:[NSString stringWithFormat:@"%ld",[_questionArray count]] forKey:@"count"];
    int index=0;
    for (Question *question in _questionArray){
        NSMutableDictionary *questionData = [NSMutableDictionary dictionaryWithCapacity:2];
        NSString *content = [question.question stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
        [content stringByReplacingOccurrencesOfString:@" " withString:@"&nbsp"];
        [questionData setObject:content forKey:@"title"];
        [dataDic setObject:questionData forKey:[NSString stringWithFormat:@"question%d",index]];
        index++;
    }
    [_bridge callHandler:@"javascriptHandler" data:dataDic responseCallback:^(id response) {
        NSLog(@"javascriptHandler responded: %@", response);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
