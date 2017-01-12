//
//  QuestionWebController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/3/7.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "QuestionWebController.h"

#import "CourseManager.h"
#import "ExamManager.h"
#import "Question.h"
#import "QuestionOption.h"
#import "SysCommon.h"
#import "Masonry.h"
#import "SysCommon.h"
#import "CourseManager.h"
#import "Question.h"
#import "QuestionOption.h"
#import "Correctness.h"
#import "JRPlayerViewController.h"
#import "QuestionResultViewController.h"
#import "MobClick.h"
#import <WebViewJavascriptBridge.h>

@interface QuestionWebController ()

@property (nonatomic) WebViewJavascriptBridge* bridge;
@property (nonatomic) UIWebView *webView;

@property (nonatomic) NSMutableArray *questionArray;
@property (nonatomic) int currentIndex; //当前第几道题
@property (nonatomic) NSMutableArray *correctnessArray;//答题结果


@end

@implementation QuestionWebController{
    UITextView *articleText;
    UIButton *preButton;
    UIButton *nextButton;
    UILabel *subjectNoLabel;
    UIButton *videoBtn;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLoad{
    
    self.title = _titleName;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavButton];
    
    //友盟统计
    if(_type==1){
        [MobClick event:@"enter_point"];
    }else if(_type==2){
        [MobClick event:@"enter_point"];
    }
    
    
    articleText = [[UITextView alloc]init];
    articleText.editable = NO;
    if (_hasArticle) {
        articleText.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/2-50);
    }else{
        articleText.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    }
    articleText.textColor = RGBCOLOR(51, 51, 51);
    [self.view addSubview:articleText];
    
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(articleText.frame), SCREEN_WIDTH, SCREEN_HEIGHT-120-CGRectGetMaxY(articleText.frame))];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.dataDetectorTypes = UIDataDetectorTypeNone;
    [self.view addSubview:_webView];
    
    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
    // js调用ios方法
    [_bridge registerHandler:@"mathObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *optionIndex = [data objectForKey:@"optionIndex"];
        [self chooseAnswer:optionIndex];
        
        if (_currentIndex<[_questionArray count]-1) {
            if (_currentIndex==[_questionArray count]-2) {
                [nextButton setTitle:@"提交" forState:UIControlStateNormal];
            }
            _currentIndex++;
            preButton.hidden = NO;
            subjectNoLabel.text = [NSString stringWithFormat:@"%d/%ld",_currentIndex+1,[_questionArray count]];
            [self setupQuestion:_questionArray Index:_currentIndex];
        }else{
            QuestionResultViewController *resultVC = [[QuestionResultViewController alloc]init];
            resultVC.type = _type;
            if (_type==1) {
                resultVC.objectId = _objectId;
                resultVC.url = _course.address;
            }else{
                resultVC.analysisCallback = ^{
                    _currentIndex = 0;
                    preButton.hidden = YES;
                    [nextButton setTitle:@"下一题" forState:UIControlStateNormal];
                    subjectNoLabel.text = [NSString stringWithFormat:@"%d/%ld",_currentIndex+1,[_questionArray count]];
                    _showAnswer = 1;
                    [self setupQuestion:_questionArray Index:_currentIndex];
                };
            }
            resultVC.answerArray = _correctnessArray;
            [self.navigationController pushViewController:resultVC animated:YES];
        }
        
    }];
    
    UIView *bottomLine = [[UIView alloc]init];
    bottomLine.backgroundColor = RGBCOLOR(240, 240, 240);
    [self.view addSubview:bottomLine];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).offset(-60);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@1);
    }];
    
    preButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [preButton setTitleColor:COMMONBLUECOLOR forState:UIControlStateNormal] ;
    [preButton addTarget:self action:@selector(clickPrevious:) forControlEvents:UIControlEventTouchDown];
    [preButton setTitle:@"上一题" forState:UIControlStateNormal];
    [self.view addSubview:preButton];
    
    subjectNoLabel = [[UILabel alloc]init];
    subjectNoLabel.textColor = RGBCOLOR(144, 144, 144);
    [self.view addSubview:subjectNoLabel];
    
    nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setTitle:@"下一题" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(clickNext:) forControlEvents:UIControlEventTouchDown];
    [nextButton setTitleColor:COMMONBLUECOLOR forState:UIControlStateNormal];
    [self.view addSubview:nextButton];
    
    [preButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.width.equalTo(@60);
        make.height.equalTo(@20);
    }];
    
    [subjectNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.centerX.equalTo(self.view);
    }];
    
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.width.equalTo(@60);
        make.height.equalTo(@20);
    }];
    
    
    _currentIndex = 0;
    preButton.hidden = YES;
    
    if (_objectId) {
        [self fetchQuestionList];
    }
}

- (void)setupNavButton
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"ic_back_white"] forState:UIControlStateNormal];
    [backBtn sizeToFit];
    [backBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    videoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [videoBtn setImage:[UIImage imageNamed:@"icon_video"] forState:UIControlStateNormal];
    [videoBtn sizeToFit];
    [videoBtn addTarget:self action:@selector(videoButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    videoBtn.hidden = YES;
    
    UIBarButtonItem *videoItem = [[UIBarButtonItem alloc] initWithCustomView:videoBtn];
    self.navigationItem.rightBarButtonItem = videoItem;
}

-(void)backButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)videoButtonClicked{
    Question *question = _questionArray[_currentIndex];
    NSURL *url = [NSURL URLWithString:question.videourl];
    JRPlayerViewController *playerVC = [[JRPlayerViewController alloc] initWithHTTPLiveStreamingMediaURL:url];
    playerVC.mediaTitle = @"题目解析";
    [self presentViewController:playerVC animated:YES completion:nil];
}

-(void)fetchQuestionList{
    if (_type==1) {
        CourseManager *cm = [[CourseManager alloc]init];
        [cm fetchQuestionWithPointId:_objectId Success:^(QuestionListResult *result) {
            _questionArray = [NSMutableArray arrayWithArray:result.questionArray];
            if ([_questionArray count]>0) {
                if([_questionArray count]==1){
                    [nextButton setTitle:@"提交" forState:UIControlStateNormal];
                }
                [self loadExamplePage:_webView];
                [self setupQuestion:_questionArray Index:_currentIndex];
                subjectNoLabel.text = [NSString stringWithFormat:@"%d/%ld",_currentIndex+1,[_questionArray count]];
                _correctnessArray = [NSMutableArray arrayWithCapacity:[_questionArray count]];
            }
        } Failure:^(NSError *error) {
            
        }];
    }else{
        ExamManager *em = [[ExamManager alloc]init];
        [em fetchQuestionWithExamId:_objectId Success:^(QuestionListResult *result) {
            _questionArray = [NSMutableArray arrayWithArray:result.questionArray];
            if ([_questionArray count]>0) {
                if([_questionArray count]==1){
                    [nextButton setTitle:@"提交" forState:UIControlStateNormal];
                }
                [self loadExamplePage:_webView];
                [self setupQuestion:_questionArray Index:_currentIndex];
                subjectNoLabel.text = [NSString stringWithFormat:@"%d/%ld",_currentIndex+1,[_questionArray count]];
                _correctnessArray = [NSMutableArray arrayWithCapacity:[_questionArray count]];
            }
        } Failure:^(NSError *error) {
        }];
    }
    
}

- (void)loadExamplePage:(UIWebView*)webView {
    
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"question" ofType:@"html" inDirectory:@"MathJax/html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
}

-(void)setupQuestion:(NSArray*)questionArray Index:(int)currentIndex{
    Question *question =[questionArray objectAtIndex:currentIndex];
    if (question.article&&![question.article isEqualToString:@""]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5;
        NSDictionary *attributes = @{
                                     NSFontAttributeName:LabelFont(28),
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        articleText.attributedText = [[NSAttributedString alloc] initWithString:question.article attributes:attributes];
    }
    if (question.videourl&&![question.videourl isEqualToString:@""]) {
        videoBtn.hidden = NO;
    }else{
        videoBtn.hidden = YES;
    }
    NSMutableDictionary *questionData = [NSMutableDictionary dictionaryWithCapacity:[question.optionList count]+1];
    NSString *content = [question.question stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    [content stringByReplacingOccurrencesOfString:@" " withString:@"&nbsp"];
    [questionData setObject:content forKey:@"title"];
    int i = 0;
    NSString *rightanswer;
    NSString *currentChoice;
    for (QuestionOption *option in question.optionList) {
        i++;
        if (option.content&&![option.content isEqualToString:@""]) {
            [questionData setObject:option.content forKey:[NSString stringWithFormat:@"option%d",i]];
            if([option.isanswer isEqualToString:@"1"]){
                rightanswer =[NSString stringWithFormat:@"%d",64+i];
            }
            if (option.isCurrentChosen==1) {
                currentChoice = [NSString stringWithFormat:@"%d", i-1];
            }
        }
    }
    [questionData setObject:rightanswer forKey:@"rightanswer"];
    [questionData setObject:[NSString stringWithFormat:@"%d",_type] forKey:@"type"];
    if (currentChoice) {
        [questionData setObject:currentChoice forKey:@"currentChoice"];
        if ([currentChoice intValue]+1==[rightanswer intValue]-64) {
            [questionData setObject:@"1" forKey:@"answerCorrect"];
        }else{
            [questionData setObject:@"0" forKey:@"answerCorrect"];
        }
    }
    [questionData setObject:[NSString stringWithFormat:@"%d",_showAnswer] forKey:@"showAnswer"];
    NSString *hint = question.hint?[question.hint stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"]:@"暂无解析";
    [hint stringByReplacingOccurrencesOfString:@" " withString:@"&nbsp"];
    [questionData setObject:hint forKey:@"hint"];
    [questionData setObject:question.pic?question.pic:@"" forKey:@"pic"];
    [questionData setObject:question.hintpic?question.hintpic:@"" forKey:@"hintpic"];
    [_bridge callHandler:@"javascriptHandler" data:questionData responseCallback:^(id response) {
        NSLog(@"javascriptHandler responded: %@", response);
    }];
}


-(void)clickPrevious:(UIButton*)button{
//    [_bridge callHandler:@"previousClickHandler" data:questionData responseCallback:^(id response) {
//    }];
    
    if (_currentIndex>0) {
        [nextButton setTitle:@"下一题" forState:UIControlStateNormal];
        _currentIndex--;
        if (_currentIndex==0) {
            preButton.hidden = YES;
        }
        subjectNoLabel.text = [NSString stringWithFormat:@"%d/%ld",_currentIndex+1,[_questionArray count]];
        [self setupQuestion:_questionArray Index:_currentIndex];
    }
}

-(void)clickNext:(UIButton*)button{
    [_bridge callHandler:@"nextClickHandler" data:nil responseCallback:^(id response) {
    }];
}

#pragma choose answer
-(void)chooseAnswer:(NSString *)optionIndex{
    Question *question =[_questionArray objectAtIndex:_currentIndex];
    Correctness *correct = [[Correctness alloc]init];
    correct.no = question.questionId;
    if (optionIndex) {
        QuestionOption *option = question.optionList[[optionIndex intValue]];
        option.isCurrentChosen = 1;
        [question.optionList replaceObjectAtIndex:[optionIndex intValue] withObject:option];
        [_questionArray replaceObjectAtIndex:_currentIndex withObject:question];
        correct.optId = option.optionId;
        correct.isCorrect = option.isanswer;
    }else{
        correct.isCorrect = @"2";
    }
    
    correct.timeSpan = @"10";
    _correctnessArray[_currentIndex] = correct;
}


@end