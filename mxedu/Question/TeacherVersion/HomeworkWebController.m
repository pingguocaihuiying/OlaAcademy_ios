//
//  HomeworkWebController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/9/29.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "HomeworkWebController.h"

#import "SysCommon.h"
#import "Question.h"
#import "ExamManager.h"
#import "Masonry.h"
#import <WebViewJavascriptBridge.h>
#import "ChosenWebController.h"

@interface HomeworkWebController ()

@property (nonatomic) WebViewJavascriptBridge* bridge;
@property (nonatomic) UIWebView *webView;

@property (nonatomic) NSMutableArray *questionArray;
@property (nonatomic) NSMutableArray *chosenArray;

@property (nonatomic) int isChooseAll;

@end

@implementation HomeworkWebController{
    UIButton *chooseBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"题目列表";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupRightButton];
    _chosenArray = [NSMutableArray arrayWithCapacity:0];
    
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
        NSString *optionIndex = [data objectForKey:@"optionIndex"];
        if ([optionIndex isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请选择题目" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alert show];
        }else{
            NSArray *indexItems = [optionIndex componentsSeparatedByString:@","];
            if ([_chosenArray count]>0) {
                [_chosenArray removeAllObjects];
            }
            for (NSString *index in indexItems) {
                if (![index isEqualToString:@""]) {
                    [_chosenArray addObject:[_questionArray objectAtIndex:[index integerValue]]];
                }
            }
            ChosenWebController *chosenWeb = [[ChosenWebController alloc]init];
            chosenWeb.questionArray = _chosenArray;
            [self.navigationController pushViewController:chosenWeb animated:YES];
        }
        
    }];
        
    [self fetchQuestionList];
}

- (void)setupRightButton{
    
    chooseBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    chooseBtn.frame=CGRectMake(0, 0, 50, 25);
    [chooseBtn setTitleColor:COMMONBLUECOLOR forState:UIControlStateNormal];
    [chooseBtn setTitle:@"全选" forState:UIControlStateNormal];
    
    [chooseBtn addTarget:self action:@selector(chooseAll) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightbtn=[[UIBarButtonItem alloc] initWithCustomView:chooseBtn];
    self.navigationItem.rightBarButtonItem = rightbtn;
}

-(void)chooseAll{
    if (_isChooseAll==0) {
        _isChooseAll = 1;
        [chooseBtn setTitle:@"不选" forState:UIControlStateNormal];
    }else{
        _isChooseAll = 0;
        [chooseBtn setTitle:@"全选" forState:UIControlStateNormal];
    }
    NSDictionary *data = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d",_isChooseAll] forKey:@"choose"];
    [_bridge callHandler:@"chooseAllHandler" data:data responseCallback:^(id response) {
    }];
}

-(void)fetchQuestionList{
    if (_type==1) {
        CourseManager *cm = [[CourseManager alloc]init];
        [cm fetchQuestionWithPointId:_objectId Success:^(QuestionListResult *result) {
            _questionArray = [NSMutableArray arrayWithArray:result.questionArray];
            if ([_questionArray count]>0) {
                [self setupNextButton];
                [self loadExamplePage:_webView];
                [self setupQuestion:_questionArray];
            }
        } Failure:^(NSError *error) {
            
        }];
    }else if(_type==2){
        ExamManager *em = [[ExamManager alloc]init];
        [em fetchQuestionWithExamId:_objectId Success:^(QuestionListResult *result) {
            _questionArray = [NSMutableArray arrayWithArray:result.questionArray];
            if ([_questionArray count]>0) {
                [self setupNextButton];
                [self loadExamplePage:_webView];
                [self setupQuestion:_questionArray];
            }
        } Failure:^(NSError *error) {
        }];
    }
}

-(void)setupNextButton{
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.backgroundColor = COMMONBLUECOLOR;
    nextBtn.layer.masksToBounds = YES;
    nextBtn.layer.cornerRadius = GENERAL_SIZE(40);
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(clickNext:) forControlEvents:UIControlEventTouchDown];
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

-(void)clickNext:(UIButton*)button{
    [_bridge callHandler:@"nextClickHandler" data:nil responseCallback:^(id response) {
    }];
}

- (void)loadExamplePage:(UIWebView*)webView {
    
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"homework" ofType:@"html" inDirectory:@"MathJax/html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
}

-(void)setupQuestion:(NSArray*)questionArray{
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    [dataDic setObject:[NSString stringWithFormat:@"%ld",[questionArray count]] forKey:@"count"];
    int index=0;
    for (Question *question in questionArray){
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
