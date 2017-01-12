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
#import "HomeworkManager.h"
#import "AuthManager.h"
#import "LoginViewController.h"
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
#import "ShareSheetView.h"

#import "AnswerQuestionsCardController.h"

@interface QuestionWebController ()<UIAlertViewDelegate,ShareSheetDelegate>

@property (nonatomic) WebViewJavascriptBridge* bridge;
@property (nonatomic) UIWebView *webView;

@property (nonatomic) NSMutableArray *questionArray;
@property (nonatomic) int currentIndex; //当前第几道题
@property (nonatomic) NSMutableArray *correctnessArray;//答题结果


@end

@implementation QuestionWebController{
    UIView* titleView;
    
    UITextView *articleText;
    UIButton *preButton;
    UIButton *nextButton;
    UILabel *subjectNoLabel;
    UIButton *videoBtn;
    UILabel *timeL;
    
    NSTimer *timer;
    int timeCount;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLoad{
    
    self.title = _titleName;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavButton];
    
    timeCount = 0;
    
    //友盟统计
    if(_type==1){
        [MobClick event:@"enter_point_ios"];
    }else if(_type==2){
        [MobClick event:@"enter_exam_ios"];
    }else if(_type==3){
        [MobClick event:@"enter_homework_ios"];
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
            resultVC.callbackBlock = ^{
                if(_callbackBlock){
                    _callbackBlock(); //刷新首页答题情况
                }
            };
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
    [backBtn setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    [backBtn sizeToFit];
    [backBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    UIButton* subjectButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, GENERAL_SIZE(150), 40)];
    [subjectButton setImage:[UIImage imageNamed:@"icon_question_list"] forState:UIControlStateNormal];
    [subjectButton addTarget:self action:@selector(subjectButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [subjectButton setTitleColor:[UIColor colorWithRed:0.1 green:0.63 blue:0.96 alpha:0.93] forState:UIControlStateNormal];
    
    UIButton *timeBtn = [[UIButton alloc]initWithFrame:CGRectMake(GENERAL_SIZE(150), 0, GENERAL_SIZE(150), 40)];
    [timeBtn setImage:[UIImage imageNamed:@"icon_question_timer"] forState:UIControlStateNormal];
    [timeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    timeL = [[UILabel alloc]initWithFrame:CGRectMake(GENERAL_SIZE(150), 0, GENERAL_SIZE(150), 40)];
    timeL.backgroundColor = [UIColor clearColor];
    timeL.textAlignment = NSTextAlignmentCenter;
    timeL.textColor = COMMONBLUECOLOR;
    timeL.font = LabelFont(20);
    
    videoBtn = [[UIButton alloc]initWithFrame:CGRectMake(GENERAL_SIZE(300), 0, GENERAL_SIZE(150), 40)];
    [videoBtn setImage:[UIImage imageNamed:@"icon_question_video"] forState:UIControlStateNormal];
    [videoBtn addTarget:self action:@selector(videoButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    videoBtn.enabled = NO;
    
    titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, GENERAL_SIZE(450), 40)];
    [titleView addSubview:subjectButton];
    [titleView addSubview:timeBtn];
    [titleView addSubview:timeL];
    [titleView addSubview:videoBtn];
    
    self.navigationItem.titleView=titleView;
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"ic_share"] forState:UIControlStateNormal];
    [shareBtn sizeToFit];
    [shareBtn addTarget:self action:@selector(shareButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *shareButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItem = shareButtonItem;
    
}
//分享点击事件
-(void)shareButtonClicked {

}

-(void)backButtonClicked{
//    [self.navigationController popViewControllerAnimated:YES];
    
    AnswerQuestionsCardController *answerCardVC = [[AnswerQuestionsCardController alloc] init];
    
//    QuestionResultViewController *resultVC = [[QuestionResultViewController alloc]init];
//    answerCardVC.type = _type;
//    if (_type==1) {
//        answerCardVC.objectId = _objectId;
//        answerCardVC.url = _course.address;
//    }else{
//        answerCardVC.analysisCallback = ^{
//            _currentIndex = 0;
//            preButton.hidden = YES;
//            [nextButton setTitle:@"下一题" forState:UIControlStateNormal];
//            subjectNoLabel.text = [NSString stringWithFormat:@"%d/%ld",_currentIndex+1,[_questionArray count]];
//            _showAnswer = 1;
//            [self setupQuestion:_questionArray Index:_currentIndex];
//        };
//    }
//    answerCardVC.callbackBlock = ^{
//        if(_callbackBlock){
//            _callbackBlock(); //刷新首页答题情况
//        }
//    };
    answerCardVC.hidesBottomBarWhenPushed = YES;
    self.navigationController.navigationBarHidden = NO;
    answerCardVC.answersArray = _correctnessArray;
    [self.navigationController pushViewController:answerCardVC animated:YES];
    
//    answerCardVC.hidesBottomBarWhenPushed = YES;
//    self.navigationController.navigationBarHidden = NO;
//    
//    [self.navigationController pushViewController:answerCardVC animated:YES];
}

-(void)subjectButtonClicked{
    OLA_LOGIN;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"将此题加入到错题本中？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

-(void)videoButtonClicked{
    Question *question = _questionArray[_currentIndex];
    NSURL *url = [NSURL URLWithString:question.videourl];
    JRPlayerViewController *playerVC = [[JRPlayerViewController alloc] initWithHTTPLiveStreamingMediaURL:url];
    playerVC.mediaTitle = @"题目解析";
    [self presentViewController:playerVC animated:YES completion:nil];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        CourseManager *cm = [[CourseManager alloc]init];
        NSString *questionType = @"2";
        if (_type==1) {
            questionType = @"1";
        }
        Question *questioin = [_questionArray objectAtIndex:_currentIndex];
        [cm updateWrongSetWithUserId:[AuthManager sharedInstance].userInfo.userId SubjectId:questioin.questionId QuestionType: questionType Type:@"1" Success:^(CommonResult *result) {
            
        } Failure:^(NSError *error) {
            
        }];
    }
}

//计时器
-(void)countdown:(NSTimer*) t
{
    timeCount++;
    
    int h = timeCount/3600;
    int m = timeCount/60;
    int s = timeCount%60;
    if (h>0) {
        timeL.text = [NSString stringWithFormat:@"%02d:%02d:%02d",h,m,s];
    }else{
        timeL.text = [NSString stringWithFormat:@"%02d:%02d",m,s];
    }
}


-(void)fetchQuestionList{
    if (_type==1) {
        CourseManager *cm = [[CourseManager alloc]init];
        [cm fetchQuestionWithPointId:_objectId Success:^(QuestionListResult *result) {
            
            timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdown:) userInfo:nil repeats:YES];
            
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
    }else if(_type==2){
        ExamManager *em = [[ExamManager alloc]init];
        [em fetchQuestionWithExamId:_objectId Success:^(QuestionListResult *result) {
            
            timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdown:) userInfo:nil repeats:YES];
            
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
    }else if(_type==3){
        HomeworkManager *hm = [[HomeworkManager alloc]init];
        [hm fetchQuestionWithHomeworkId:_objectId Success:^(QuestionListResult *result) {
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
        videoBtn.enabled = YES;
        [videoBtn setImage:[UIImage imageNamed:@"icon_question_video"] forState:UIControlStateNormal];
    }else{
        videoBtn.enabled = NO;
        [videoBtn setImage:[UIImage imageNamed:@"icon_video_gray"] forState:UIControlStateNormal];
    }
    NSMutableDictionary *questionData = [NSMutableDictionary dictionaryWithCapacity:[question.optionList count]+1];
    NSString *content = [question.question stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    [content stringByReplacingOccurrencesOfString:@" " withString:@"&nbsp"];
    [questionData setObject:content forKey:@"title"];
    [questionData setObject:[self jsonStringFromArray :question.optionList] forKey:@"option"];
    int i = 0;
    NSString *rightanswer;
    NSString *currentChoice;
    for (QuestionOption *option in question.optionList) {
        i++;
        if (option.content&&![option.content isEqualToString:@""]) {
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

-(NSString*)jsonStringFromArray:(NSArray*)optionArray{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[optionArray count]];
    for (QuestionOption *option in optionArray) {
        if (option.content) {
            NSDictionary *contentDict = [NSDictionary dictionaryWithObjectsAndKeys:option.content,@"content", nil];
            [array addObject:contentDict];
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
