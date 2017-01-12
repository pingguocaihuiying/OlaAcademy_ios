//
//  SDMediaPlayerVC.m
//  NTreat
//
//  Created by 周冉 on 16/5/3.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "SDMediaPlayerVC.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

#import "SysCommon.h"
#import "SDHeader.h"
#import "SDTool.h"
#import "ALAlertView.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "RNEncryptor.h"
#import "UIImageView+WebCache.h"
#import "UIView+Frame.h"
#import "UIImage+expand.h"

#import "AuthManager.h"

#define kVidoeTitle                  @"vedioTitle"
#define kVidoeUrl                    @"vedioURL"
#define kVidoeId                     @"vedioId"

#define TopReturnBtnViewWidth       50
#define TopReturnBtnViewHeight      44

#define kListButtonWidth            40
#define kPlaybtnWidth               50
#define kPlaybtnHeight              50
#define kCutFramebtnWidth           40
#define kCutFramebtnHeight          40
#define kCurrentTimeWidth           60
#define kCurrentTimeHeight          20
#define kRemainingTimeWidth         63
#define kRemainingTimeHeight        20
#define kSliderHeight               2

#define kFastforwordWidth           26
#define kFastforwordHeight          13

#define kBrightnessViewWidth        125
#define kBrightnessViewHeight       125
#define kBrightnessProgressWidth    80
#define kBrightnessProgressHeight   2

#define kProgressTimeViewWidth      200
#define kProgressTimeViewHeight     60
#define kVedioPlayMaxSecends            300                  //. 没有登录视频最多可以播放长度



#define kHSpace                     3
#define kHMargin                    3

#define kVolumeStep                 0.02f               // 音量 +/-
#define kBrightnessStep             0.02f               // 亮度 +/-
#define kMovieProgressStep          5.0f                // 快进/快退 +/-

#define kAnimationTime              0.3


typedef NS_ENUM(NSInteger, GestureType){
    GestureTypeOfNone = 0,
    GestureTypeOfVolume,
    GestureTypeOfBrightness,
    GestureTypeOfProgress,
};

enum{
    kNetStatusAlertTag = 1,
    kLogStatusAlertTag
};

@interface SDMediaPlayerVC ()<UIAlertViewDelegate,VideoTerminalListSubViewDelegat>
@property (nonatomic,copy) NSString *movieTitle;                    //. 视频标题
@property (nonatomic,copy) NSString *videoId;                       //. 视频id
@property (nonatomic,strong) NSURL *movieURL;                       //. 当前视频URL
@property (nonatomic,copy) NSString *coverImageURL;                 //. 缩略图地址

@property (nonatomic,strong) AVPlayer *player;                       //. avplayer

@property (nonatomic,assign) CGFloat movieLength;                           //. 视频总长度
@property (nonatomic,assign) NSInteger currentPlayingItemIndex;             //. 当前播放的item 索引

@property (nonatomic,strong) UIImageView *coverImageView;           //. 缩略图
@property (nonatomic,strong) MBProgressHUD *progressHUD;             //. 加载
@property (nonatomic,strong) SUIButton *returnBtn;                    //. 返回按钮
@property (nonatomic,strong) UILabel *titleLable;                    //. 视频标题

@property (nonatomic,strong) SUIButton *playBtn;                      //. 播放/暂停
@property (nonatomic,strong) SUIButton *backwardBtn;                  //. 上一部按钮
@property (nonatomic,strong) SUIButton *forwardBtn;                   //. 下一部按钮
@property (nonatomic,strong) SUIButton *fastBackwardBtn;              //. 快退
@property (nonatomic,strong) SUIButton *fastForeardBtn;               //. 快进
@property (nonatomic,strong) UILabel *currentLable;                  //. 当前播放进度
@property (nonatomic,strong) UILabel *remainingTimeLable;            //. 剩余视频总长度
@property (nonatomic,strong) UISlider *movieSlider;                  //. 播放进度条
@property (nonatomic,strong) UIProgressView *movieProgress;          //. 缓冲进度条
@property (nonatomic,strong) ALAlertView *alertView;                 //. 当前alert

@property (nonatomic,strong) UIImageView *brightnessView;            //. 屏幕亮度
@property (nonatomic,strong) UIProgressView *brightnessProgress;     //. 屏幕亮度进度条

@property (nonatomic,weak) id timeObserver;                          //. item Observer
@property (nonatomic,assign) GestureType gestureType;                //. 手势类型
@property (nonatomic,assign) CGPoint originalLocation;               //. 手势初始点
@property (nonatomic,assign) BOOL isFirstOpenPlayer;                 //. 第一次打开需要读取历史观看进度
@property (nonatomic,assign) BOOL isHide;                            //. 是否隐藏
@property (nonatomic,assign) BOOL isPlaying;                         //. 是否在播放
@property (nonatomic,assign) BOOL isReadyToPlay;                     //. 是否将要播放
@property (nonatomic,assign) BOOL isClickToPause;                    //. 是否是手动暂停的
@property (nonatomic,assign) BOOL allow3GPlay;                       //. 是否允许3g播放
@property (nonatomic,assign) CGFloat systemBrightness;               //. 系统屏幕亮度

@property (nonatomic,assign) BOOL alertIsShown;                     //. 网络alert 提示是否显示了
@property (nonatomic,assign) BOOL alertCheckIsShown;                //. 只能播放三分钟alert 提示是否显示了

//@property (nonatomic,strong) NetWorkCreatVedioPlayRecord *netWorkCreatVedioPlayRecord;
//@property (nonatomic,strong) NetWorkGetVedioPlayRecord *netWorkGetVedioPlayRecord;
@property (nonatomic,assign) BOOL canGoOnPlay;                      //. 视频播放完后能不能继续播放
@property (nonatomic,assign) BOOL hasRegisterStatus;                //. 是否加过status kvo
@property (nonatomic,assign) BOOL hasRegisterRange;                 //. 是否加过缓冲kvo
@property (nonatomic,assign) BOOL hasRegisterValue;                 //. 是否加过slider value kvo

@property (nonatomic,assign) BOOL isFromBackGround;                 //. 是否是从后台进入的
@property (nonatomic,copy) NSString *stringNetStatus;               //. 当前网络状态

@property(nonatomic,assign)BOOL isFirstIn;
@end
static   SDMediaPlayerVC * sharedMyMediaPlayer = nil;

@implementation SDMediaPlayerVC
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    if(_hasRegisterValue)
    {
        [_movieSlider removeObserver:self forKeyPath:@"value"];
    }
    
    if(_timeObserver && _player)
    {
        [_player removeTimeObserver:_timeObserver];
        _timeObserver = nil;
    }
    
    if(_mode == MyMediaPlayerModeNetwork)
    {
        if(_hasRegisterRange && _player.currentItem)
        {
            [_player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        }
        if(_player.currentItem && _hasRegisterStatus)
        {
            [_player.currentItem removeObserver:self forKeyPath:@"status"];
            _hasRegisterStatus = NO;
        }
    }
    else
    {
        if(_player.currentItem && _hasRegisterStatus)
        {
            [_player.currentItem removeObserver:self forKeyPath:@"status"];
            _hasRegisterStatus = NO;
        }
    }
    if(_player)
    {
        [_player replaceCurrentItemWithPlayerItem:nil];
        _player = nil;
    }
    if(_playerLayer)
    {
        [_playerLayer removeFromSuperlayer];
        _playerLayer = nil;
    }
    
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (BOOL)isRotateEnable{
    if(_alertCheckIsShown || _alertIsShown)
        return NO;
    else
        return YES;
}

-(void)adjustVideoWithOrientation:(UIDeviceOrientation)orientation {
    
    if(_alertCheckIsShown || _alertIsShown) return;
    
    NSInteger spaceXStart=  10;
    
    __block CGFloat spaceXEnd = 0;
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    switch (orientation) {
        case UIDeviceOrientationUnknown:
        {
        }
            break;
        case UIDeviceOrientationPortrait:
        {
            
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
            
            self.bottomView.frame = CGRectMake(0,kVedioHeight -kBottomViewHeight_V, SCREEN_WIDTH, kBottomViewHeight_V);
            self.playerLayer.frame =CGRectMake(0, 0, SCREEN_WIDTH,kVedioHeight);
            
            
            _coverImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH,kVedioHeight);
            _coverImageView.center = CGPointMake(SCREEN_WIDTH/2.0, kVedioHeight/2.0);
            
            [UIView animateWithDuration:kAnimationTime animations:^{
                self.view.transform = CGAffineTransformMakeRotation(0);
                self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH,kVedioHeight);
                _returnBtn.frame = CGRectMake(0, 0, TopReturnBtnViewWidth, TopReturnBtnViewHeight);
                
                spaceXEnd =SCREEN_WIDTH - kHMargin;
                self.topView.frame = CGRectMake(0, 0,SCREEN_WIDTH,TopViewHeight);
                _titleLable.frame = CGRectMake(TopReturnBtnViewWidth, 0, _topView.frame.size.width - TopReturnBtnViewWidth - kHMargin, TopViewHeight);
                _titleLable.center = _topView.center;
                self.topView.alpha = 1;
                
            }];
            
            _playBtn.frame = CGRectMake(spaceXStart, (_bottomView.frame.size.height - kPlaybtnHeight)/2.0, kPlaybtnWidth, kPlaybtnHeight);
            spaceXStart += kPlaybtnWidth + kHSpace;
            
            [_playBtn setImage:_isPlaying?[UIImage imageNamed:@"Video_pause_nor.png"]:[UIImage imageNamed:@"Video_play_nor.png"] forState:UIControlStateNormal];
            
            _currentLable.frame = CGRectMake(spaceXStart, (_bottomView.frame.size.height - kCurrentTimeHeight)/2.0, kCurrentTimeWidth, kCurrentTimeHeight);
            spaceXStart += kCurrentTimeWidth + kHSpace;
            
            _cutFullModeBtn.frame = CGRectMake(spaceXEnd - kCutFramebtnWidth, (_bottomView.frame.size.height - kCutFramebtnHeight)/2.0, kCutFramebtnWidth, kCutFramebtnHeight);
            spaceXEnd -= (kCutFramebtnWidth + kHSpace);
            
            [_cutFullModeBtn setImage:_isFullScreen?[UIImage imageNamed:@"Video_full_no.png"]:[UIImage imageNamed:@"Video_full_yes.png"] forState:UIControlStateNormal];
            
            _remainingTimeLable.frame = CGRectMake(spaceXEnd - kRemainingTimeWidth, (_bottomView.frame.size.height - kRemainingTimeHeight)/2.0, kRemainingTimeWidth, kRemainingTimeHeight);
            spaceXEnd -= (kRemainingTimeWidth + kHSpace);
            
            _movieProgress.frame = CGRectMake(spaceXStart, (_bottomView.frame.size.height - kSliderHeight)/2.0, spaceXEnd - spaceXStart, kSliderHeight);
            _movieSlider.frame = _movieProgress.bounds;
            
            _brightnessView.frame = CGRectMake((self.view.bounds.size.width-kBrightnessViewWidth)/2.0, (self.view.bounds.size.height-kBrightnessViewHeight)/2.0, kBrightnessViewWidth, kBrightnessViewHeight);
            _brightnessProgress.frame =  CGRectMake((_brightnessView.frame.size.width - kBrightnessProgressWidth)/2.0, _brightnessView.frame.size.height - kBrightnessProgressHeight - 20, kBrightnessProgressWidth, kBrightnessProgressHeight);
            
            _tableListButton.hidden = YES;//当不是全屏时候list按钮该按钮为隐藏

            _tableListButton.frame = CGRectMake(SCREEN_WIDTH-kListButtonWidth-10, 0, TopReturnBtnViewWidth, TopViewHeight);

            _playerTablListView.view.hidden = YES;

            _listType = NO;
        }
            break;
        case UIDeviceOrientationPortraitUpsideDown:
        {
            
        }
            break;
        case UIDeviceOrientationLandscapeLeft:
        {
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            
            [UIView animateWithDuration:kAnimationTime animations:^{
                self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
                self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT);
                self.playerLayer.frame = CGRectMake(0, 0, SCREEN_HEIGHT,SCREEN_WIDTH);
                
                self.bottomView.frame = CGRectMake(0, SCREEN_WIDTH-kBottomViewHeight_H, SCREEN_HEIGHT, kBottomViewHeight_H);
                self.topView.frame = CGRectMake(0, 0,SCREEN_HEIGHT, TopViewHeight);
                
                _returnBtn.frame = CGRectMake(0, 0, TopReturnBtnViewWidth, TopReturnBtnViewHeight);
                _titleLable.frame = CGRectMake(TopReturnBtnViewWidth, 0, _topView.frame.size.width - TopReturnBtnViewWidth - kHMargin, TopViewHeight);
                _titleLable.center = _topView.center;
                
                spaceXEnd =SCREEN_HEIGHT - kHMargin;
                
                _coverImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                _coverImageView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
                
                self.topView.alpha = 1;
                
                [self performSelector:@selector(hidenControlBar) withObject:nil afterDelay:10];
            }];
            
            _playBtn.frame = CGRectMake(spaceXStart, (_bottomView.frame.size.height - kPlaybtnHeight)/2.0, kPlaybtnWidth, kPlaybtnHeight);
            spaceXStart += kPlaybtnWidth + kHSpace;
            
            [_playBtn setImage:_isPlaying?[UIImage imageNamed:@"Video_pause_nor.png"]:[UIImage imageNamed:@"Video_play_nor.png"] forState:UIControlStateNormal];
            
            _currentLable.frame = CGRectMake(spaceXStart, (_bottomView.frame.size.height - kCurrentTimeHeight)/2.0, kCurrentTimeWidth, kCurrentTimeHeight);
            spaceXStart += kCurrentTimeWidth + kHSpace;
            
            _cutFullModeBtn.frame = CGRectMake(spaceXEnd - kCutFramebtnWidth, (_bottomView.frame.size.height - kCutFramebtnHeight)/2.0, kCutFramebtnWidth, kCutFramebtnHeight);
            spaceXEnd -= (kCutFramebtnWidth + kHSpace);
            
            [_cutFullModeBtn setImage:_isFullScreen?[UIImage imageNamed:@"Video_full_no.png"]:[UIImage imageNamed:@"Video_full_yes.png"] forState:UIControlStateNormal];
            
            _remainingTimeLable.frame = CGRectMake(spaceXEnd - kRemainingTimeWidth, (_bottomView.frame.size.height - kRemainingTimeHeight)/2.0, kRemainingTimeWidth, kRemainingTimeHeight);
            spaceXEnd -= (kRemainingTimeWidth + kHSpace);
            
            _movieProgress.frame = CGRectMake(spaceXStart, (_bottomView.frame.size.height - kSliderHeight)/2.0, spaceXEnd - spaceXStart, kSliderHeight);
            _movieSlider.frame = _movieProgress.bounds;
            
            _brightnessView.frame = CGRectMake((self.view.bounds.size.width-kBrightnessViewWidth)/2.0, (self.view.bounds.size.height-kBrightnessViewHeight)/2.0, kBrightnessViewWidth, kBrightnessViewHeight);
            _brightnessProgress.frame =  CGRectMake((_brightnessView.frame.size.width - kBrightnessProgressWidth)/2.0, _brightnessView.frame.size.height - kBrightnessProgressHeight - 20, kBrightnessProgressWidth, kBrightnessProgressHeight);
            if([self.dataArray count] == 0)
            {
                _tableListButton.hidden = YES;
            }
            else
            {
                _tableListButton.hidden = self.mode == MyMediaPlayerModeLocal ? YES:NO;
            }
            _tableListButton.frame = CGRectMake(self.view.bounds.size.width-kListButtonWidth-10, 0, TopReturnBtnViewWidth, TopViewHeight);
            _playerTablListView.view.frame = CGRectMake(self.view.bounds.size.width-kVedioPalyListViewWidth, CGRectGetMaxY(_topView.frame), kVedioPalyListViewWidth, kVedioPalyListViewHeight);
            

            
        }
            break;
        case UIDeviceOrientationLandscapeRight:
        {
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            
            [UIView animateWithDuration:kAnimationTime animations:^{
                self.view.transform = CGAffineTransformMakeRotation(-M_PI_2);
                self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT);
                
                self.playerLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT);
                
                self.bottomView.frame = CGRectMake(0,SCREEN_WIDTH-kBottomViewHeight_H, SCREEN_HEIGHT, kBottomViewHeight_H);
                
                self.topView.frame = CGRectMake(0, 0,SCREEN_HEIGHT,TopViewHeight);
                
                _returnBtn.frame = CGRectMake(0, 0, TopReturnBtnViewWidth, TopReturnBtnViewHeight);
                _titleLable.frame = CGRectMake(TopReturnBtnViewWidth, 0, _topView.frame.size.width - TopReturnBtnViewWidth - kHMargin, TopViewHeight);
                _titleLable.center = _topView.center;
                
                spaceXEnd = SCREEN_HEIGHT - kHMargin;
                
                [self coverImageView].frame = CGRectMake(0, 0, SCREEN_HEIGHT,SCREEN_WIDTH);
                [self coverImageView].center = CGPointMake(SCREEN_HEIGHT/2.0, SCREEN_WIDTH/2.0);
                
                self.topView.alpha = 1;
                self.topView.frame = CGRectMake(0,0, SCREEN_HEIGHT, kBottomViewHeight_H);
                
                [self performSelector:@selector(hidenControlBar) withObject:nil afterDelay:10];
            }];
            
            _playBtn.frame = CGRectMake(spaceXStart, (_bottomView.frame.size.height - kPlaybtnHeight)/2.0, kPlaybtnWidth, kPlaybtnHeight);
            spaceXStart += kPlaybtnWidth + kHSpace;
            
            [_playBtn setImage:_isPlaying?[UIImage imageNamed:@"Video_pause_nor.png"]:[UIImage imageNamed:@"Video_play_nor.png"] forState:UIControlStateNormal];
            
            _currentLable.frame = CGRectMake(spaceXStart, (_bottomView.frame.size.height - kCurrentTimeHeight)/2.0, kCurrentTimeWidth, kCurrentTimeHeight);
            spaceXStart += kCurrentTimeWidth + kHSpace;
            
            _cutFullModeBtn.frame = CGRectMake(spaceXEnd - kCutFramebtnWidth, (_bottomView.frame.size.height - kCutFramebtnHeight)/2.0, kCutFramebtnWidth, kCutFramebtnHeight);
            spaceXEnd -= (kCutFramebtnWidth + kHSpace);
            
            [_cutFullModeBtn setImage:_isFullScreen?[UIImage imageNamed:@"Video_full_no.png"]:[UIImage imageNamed:@"Video_full_yes.png"] forState:UIControlStateNormal];
            
            _remainingTimeLable.frame = CGRectMake(spaceXEnd - kRemainingTimeWidth, (_bottomView.frame.size.height - kRemainingTimeHeight)/2.0, kRemainingTimeWidth, kRemainingTimeHeight);
            spaceXEnd -= (kRemainingTimeWidth + kHSpace);
            
            _movieProgress.frame = CGRectMake(spaceXStart, (_bottomView.frame.size.height - kSliderHeight)/2.0, spaceXEnd - spaceXStart, kSliderHeight);
            _movieSlider.frame = _movieProgress.bounds;
            
            _brightnessView.frame = CGRectMake((self.view.bounds.size.width-kBrightnessViewWidth)/2.0, (self.view.bounds.size.height-kBrightnessViewHeight)/2.0, kBrightnessViewWidth, kBrightnessViewHeight);
            _brightnessProgress.frame =  CGRectMake((_brightnessView.frame.size.width - kBrightnessProgressWidth)/2.0, _brightnessView.frame.size.height - kBrightnessProgressHeight - 20, kBrightnessProgressWidth, kBrightnessProgressHeight);
            if([self.dataArray count] == 0)
            {
                _tableListButton.hidden = YES;
            }
            else
            {
                _tableListButton.hidden = self.mode == MyMediaPlayerModeLocal ? YES:NO;
            }
            _tableListButton.frame = CGRectMake(self.view.bounds.size.width-kListButtonWidth-10, 0, TopReturnBtnViewWidth, TopViewHeight);
            _playerTablListView.view.frame = CGRectMake(self.view.bounds.size.width-kVedioPalyListViewWidth, CGRectGetMaxY(_topView.frame), kVedioPalyListViewWidth, kVedioPalyListViewHeight);

            
        }
            break;
        case UIDeviceOrientationFaceUp:
        {}
            break;
        case UIDeviceOrientationFaceDown:
        {}
            break;
        default:
            break;
    }
}

+ (SDMediaPlayerVC *) sharedMyMediaPlayer{
    @synchronized(self){
        if (sharedMyMediaPlayer == nil) {
            sharedMyMediaPlayer = [[self alloc] init];
        }
    }
    return  sharedMyMediaPlayer;
}

#pragma mark - init
- (id)initNetworkMyMediaPlayerWithURL:(NSURL *)url coverImageURL:(NSString *)coverImageURL movieTitle:(NSString *)movieTitle videoId:(NSString *)videoId
{
    self = [super init];
    if (self) {
        _isFirstOpenPlayer = YES;
        _movieURL = url;
        _coverImageURL = coverImageURL;
        _videoId = videoId;
        _isHide = NO;
        _canGoOnPlay = YES;
        _movieTitle = movieTitle;
        _mode = MyMediaPlayerModeNetwork;
    }
    return self;
}

- (id)initLocalMyMediaPlayerWithURL:(NSURL *)url coverImageURL:(NSString *)coverImageURL movieTitle:(NSString *)movieTitle videoId:(NSString *)videoId
{
    self = [super init];
    if (self) {
        _isFirstOpenPlayer = YES;
        _movieURL = url;
        _isFirstIn = YES;
        _coverImageURL = coverImageURL;
        _videoId = videoId;
        _isHide = NO;
        _canGoOnPlay = YES;
        _movieTitle = movieTitle;
        _mode = MyMediaPlayerModeLocal;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _systemBrightness = [UIScreen mainScreen].brightness;
    
    self.view.backgroundColor = [UIColor blackColor];
    
    if(CGRectEqualToRect(_nomalFrame, CGRectZero))
    {
        return;
    }
    
    // 网络环境变化通知
    if(_mode == MyMediaPlayerModeNetwork)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:)
                                                     name:kReachabilityChangedNotification object:nil];
    }
    
    [self createAvPlayer];
    
    [self creatCoverImageView];
    
    [self creatHudView];
    
    [self createTopView];
    
    [self createBottomView];
    
    [self createBrightnessView];
    
    [self createAvPlayerTableList];
    [self.view bringSubviewToFront:_coverImageView];
    [self.view bringSubviewToFront:_topView];
    [self.view bringSubviewToFront:_bottomView];
    [self.view bringSubviewToFront:_playerTablListView.view];
    
    [self performSelector:@selector(hidenControlBar) withObject:nil afterDelay:10];
    
    [self cutFullModeView];
    
    //监控 app 活动状态，打电话/锁屏 时暂停播放
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    // 监听视频播放结束
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [UIScreen mainScreen].brightness = _systemBrightness;
}

- (BOOL)prefersStatusBarHidden
{
    return _isFullScreen;
}
#pragma  mark 全屏播放视频
-(void)createAvPlayerTableList
{
    _playerTablListView = [[ChapterViewViewController alloc]init];
    _playerTablListView.delegat = self;
    _playerTablListView.dataArray = self.dataArray;
    _playerTablListView.fullScrenType = self.fullScrenType;
    _playerTablListView.view.frame = CGRectMake(self.view.width, TopViewHeight, kVedioPalyListViewWidth, kVedioPalyListViewHeight);
    _playerTablListView.view.hidden = YES;
    [self.view addSubview:_playerTablListView.view];
    [self addChildViewController:_playerTablListView];
    
}
#pragma mark - 布局
- (void)createAvPlayer
{

    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    // 网络
    if(_mode == MyMediaPlayerModeNetwork)
    {
        
        
        AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:_movieURL];
        
        if(_player == nil)
        {
            _player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
        }
        if(_playerLayer == nil)
        {
            _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
            self.playerLayer.anchorPoint =CGPointZero;

            _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        }
        if([_playerLayer superlayer] == nil)
        {
            [self.view.layer addSublayer:_playerLayer];
        }
        
        // 监听视频缓冲状态
        if(!_hasRegisterRange)
        {
            [_player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
            _hasRegisterRange = YES;
        }
    }
    // 本地
    else if(_mode == MyMediaPlayerModeLocal)
    {
        AVURLAsset *urlAsset = [[AVURLAsset alloc] initWithURL:_movieURL options:nil];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:urlAsset];
        
        
        if(_player == nil)
        {
            _player = [AVPlayer playerWithPlayerItem:playerItem];
            
        }
        if(_playerLayer == nil)
        {
            _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
            _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        }
        
        if([_playerLayer superlayer] == nil)
        {
            [self.view.layer addSublayer:_playerLayer];
        }
    }
    
    // 监听视频加载状态
    if(_hasRegisterStatus == NO)
    {
        [_player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        _hasRegisterStatus = YES;
    }
}

// 缩略图
- (void)creatCoverImageView
{
    if (_coverImageView == nil)
    {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
        _coverImageView.backgroundColor = [UIColor clearColor];
        [_coverImageView sd_setImageWithURL:[NSURL URLWithString:_coverImageURL]];
    }
    
    if(_coverImageView.superview == nil)
    {
        [self.view addSubview:_coverImageView];
    }
}

// hud
- (void)creatHudView
{
    if(_mode == MyMediaPlayerModeNetwork)
    {
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        _progressHUD.color = [UIColor lightGrayColor];
        [self.view addSubview:_progressHUD];
        [_progressHUD show:YES];
    }
}

// topview
- (void)createTopView
{
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, TopViewHeight)];
    _topView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _returnBtn = [SUIButton buttonWithType:UIButtonTypeSystem];
    [_returnBtn setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    _returnBtn.tintColor = [UIColor whiteColor];
    [_returnBtn addTarget:self action:@selector(popReturnView) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_returnBtn];
    
    _titleLable = [[UILabel alloc] initWithFrame:_topView.bounds];
    _titleLable.center = _topView.center;
    _titleLable.backgroundColor = [UIColor clearColor];
    _titleLable.text = _movieTitle;
    _titleLable.textColor = [UIColor whiteColor];
    _titleLable.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:_titleLable];
   //添加视频列表按钮
    _tableListButton = [SUIButton buttonWithType:UIButtonTypeSystem];
    if([self.dataArray count] == 0)
    {
        _tableListButton.hidden = YES;
    }
    else
    {
    _tableListButton.hidden = self.mode == MyMediaPlayerModeLocal ? YES:NO;
    }
    [_tableListButton setTitle:@"列表" forState:UIControlStateNormal];
    [_tableListButton addTarget:self action:@selector(TableListButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_tableListButton];

    [self.view addSubview:_topView];
    
    _topView.alpha = 1;//_isFullScreen==NO?1:0;
}

// 底部视频控制器
- (void)createBottomView
{
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.4f];
    // 播放/暂停按钮
    _playBtn = [SUIButton buttonWithType:UIButtonTypeCustom];
    [_playBtn setImage:_isPlaying?[UIImage imageNamed:@"Video_pause_nor.png"]:[UIImage imageNamed:@"Video_play_nor.png"] forState:UIControlStateNormal];
    _playBtn.enabled = NO;
    [_playBtn addTarget:self action:@selector(pauseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_playBtn];
    
    // 快退按钮
    _fastBackwardBtn = [SUIButton buttonWithType:UIButtonTypeCustom];
    _fastBackwardBtn.enabled = NO;
    [_fastBackwardBtn setImage:[UIImage imageNamed:@"Video_fast_backward_nor.png"] forState:UIControlStateNormal];
    [_fastBackwardBtn setImage:[UIImage imageNamed:@"Video_fast_backward_nor.png"] forState:UIControlStateHighlighted];
    [_fastBackwardBtn addTarget:self action:@selector(fastAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_fastBackwardBtn];
    
    // 快进按钮
    _fastForeardBtn = [SUIButton buttonWithType:UIButtonTypeCustom];
    _fastForeardBtn.enabled = NO;
    [_fastForeardBtn setImage:[UIImage imageNamed:@"Video_fast_forward_nor.png"] forState:UIControlStateNormal];
    [_fastForeardBtn setImage:[UIImage imageNamed:@"Video_fast_forward_nor.png"] forState:UIControlStateHighlighted];
    [_fastForeardBtn addTarget:self action:@selector(fastAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_fastForeardBtn];
    
    // 下一个视频按钮
    _forwardBtn = [SUIButton buttonWithType:UIButtonTypeCustom];
    _forwardBtn.enabled = NO;
    [_forwardBtn setImage:[UIImage imageNamed:@"Video_forward_disable.png"] forState:UIControlStateNormal];
    [_forwardBtn setImage:[UIImage imageNamed:@"Video_forward_disable.png"] forState:UIControlStateHighlighted
     ];
    [_bottomView addSubview:_forwardBtn];
    
    // 上一个视频按钮
    _backwardBtn = [SUIButton buttonWithType:UIButtonTypeCustom];
    _backwardBtn.enabled = NO;
    [_backwardBtn setImage:[UIImage imageNamed:@"Video_backward_disable.png"] forState:UIControlStateNormal];
    [_backwardBtn setImage:[UIImage imageNamed:@"Video_backward_disable.png"] forState:UIControlStateHighlighted];
    [_bottomView addSubview:_backwardBtn];
    
    if (_datasource != nil)
    {
        if ([_datasource isHaveNextMovie] == YES)
        {
            _forwardBtn.enabled = YES;
            [_forwardBtn setImage:[UIImage imageNamed:@"Video_forward_nor.png"] forState:UIControlStateNormal];
            [_forwardBtn setImage:[UIImage imageNamed:@"Video_forward_nor.png"] forState:UIControlStateHighlighted];
            
            [_forwardBtn addTarget:self action:@selector(forWordOrBackWardMovieAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        if ([_datasource isHavePreviousMovie] == YES)
        {
            _backwardBtn.enabled = YES;
            [_backwardBtn setImage:[UIImage imageNamed:@"Video_backward_nor.png"] forState:UIControlStateNormal];
            [_backwardBtn setImage:[UIImage imageNamed:@"Video_backward_nor.png"] forState:UIControlStateHighlighted];
            [_backwardBtn addTarget:self action:@selector(forWordOrBackWardMovieAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    // 当前播放进度
    _currentLable = [[UILabel alloc] init];
    _currentLable.font = [UIFont systemFontOfSize:13];
    _currentLable.textColor = [UIColor whiteColor];
    _currentLable.text = @"00:00";
    _currentLable.textAlignment = NSTextAlignmentCenter;
    [_bottomView addSubview:_currentLable];
    
    // 缓冲条
    _movieProgress = [[UIProgressView alloc] init];
    _movieProgress.trackTintColor = [UIColor colorWithRed:0.49f green:0.48f blue:0.49f alpha:1.00f];
    _movieProgress.progressTintColor = [UIColor whiteColor];
    [_bottomView addSubview:_movieProgress];
    
    // 播放进度条
    _movieSlider = [[UISlider alloc] init];
    _movieSlider.enabled = NO;
    [_movieSlider addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
    _hasRegisterValue = YES;
    
    if(_mode == MyMediaPlayerModeNetwork)
    {
        UIGraphicsBeginImageContextWithOptions((CGSize){ 1, 1 }, NO, 0.0f);
        UIImage *transparentImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [_movieSlider setMinimumTrackImage:transparentImage forState:UIControlStateNormal];
        [_movieSlider setMaximumTrackImage:transparentImage forState:UIControlStateNormal];
    }
    else
    {
        [_movieSlider setMinimumTrackTintColor:[UIColor whiteColor]];
        [_movieSlider setMaximumTrackTintColor:[UIColor colorWithRed:0.49f green:0.48f blue:0.49f alpha:1.00f]];
    }
    
    [_movieSlider setThumbImage:[UIImage imageNamed:@"Video_progressThumb.png"] forState:UIControlStateNormal];
    [_movieSlider addTarget:self action:@selector(scrubbingDidBegin) forControlEvents:UIControlEventTouchDown];
    [_movieSlider addTarget:self action:@selector(scrubbingDidChange) forControlEvents:UIControlEventValueChanged];
    [_movieSlider addTarget:self action:@selector(scrubbingDidEnd) forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchCancel)];
    [_movieProgress addSubview:_movieSlider];
    
    // 剩余总长度
    _remainingTimeLable = [[UILabel alloc] init];
    _remainingTimeLable.font = [UIFont systemFontOfSize:13];
    _remainingTimeLable.textColor = [UIColor whiteColor];
    _remainingTimeLable.text = @"00:00";
    _remainingTimeLable.textAlignment = NSTextAlignmentCenter;
    [_bottomView addSubview:_remainingTimeLable];
    [self.view addSubview:_bottomView];
    
    // 切换屏幕按钮
    _cutFullModeBtn =[[SUIButton alloc] init];
    [_cutFullModeBtn setImage:_isFullScreen?[UIImage imageNamed:@"Video_full_no.png"]:[UIImage imageNamed:@"Video_full_yes.png"] forState:UIControlStateNormal];
    _cutFullModeBtn.hidden = self.mode == MyMediaPlayerModeLocal ? YES:NO;
    [_cutFullModeBtn addTarget:self action:@selector(cutFullModeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_cutFullModeBtn];
}

// 屏幕亮度
- (void)createBrightnessView
{
    _brightnessView = [[UIImageView alloc] init];
    _brightnessView.image = [UIImage imageNamed:@"Video_brightness_bg.png"];
    _brightnessView.alpha = 0;
    [self.view addSubview:_brightnessView];
    
    _brightnessProgress = [[UIProgressView alloc] init];
    _brightnessProgress.trackImage = [UIImage imageNamed:@"Video_num_bg.png"];
    _brightnessProgress.progressImage = [UIImage imageNamed:@"Video_num_front.png"];
    _brightnessProgress.progress = [UIScreen mainScreen].brightness;
    [_brightnessView addSubview:_brightnessProgress];
}

// 切换屏幕尺寸
-(void)cutFullModeView
{
    self.view.frame = _isFullScreen?_cutFullModeFrame:_nomalFrame;
    self.view.layer.frame = _isFullScreen?_cutFullModeFrame:_nomalFrame;
    
    //    _topView.hidden = !_isFullScreen;
    _fastBackwardBtn.hidden = !_isFullScreen;
    _fastForeardBtn.hidden = !_isFullScreen;
    _forwardBtn.hidden = !_isFullScreen;
    _backwardBtn.hidden = !_isFullScreen;
    
    CGFloat spaceXStart = 0;
    CGFloat spaceXEnd = self.view.frame.size.width - kHMargin;
    
    _topView.frame = CGRectMake(0, 0, self.view.frame.size.width, TopViewHeight);
    _returnBtn.frame = CGRectMake(0, 0, TopReturnBtnViewWidth, TopReturnBtnViewHeight);
    _titleLable.frame = CGRectMake(TopReturnBtnViewWidth, 0, _topView.frame.size.width - TopReturnBtnViewWidth - kHMargin, TopViewHeight);
    _titleLable.center = _topView.center;
    
    if(_playerLayer)
        _playerLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    // 缩略图
    _coverImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _coverImageView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    
    _bottomView.frame = _isFullScreen?
    CGRectMake(spaceXStart, self.view.frame.size.height - kBottomViewHeight_H, self.view.frame.size.width, kBottomViewHeight_H):
    CGRectMake(spaceXStart, self.view.frame.size.height - kBottomViewHeight_V, self.view.frame.size.width, kBottomViewHeight_V);
    
    _playBtn.frame = CGRectMake(spaceXStart, (_bottomView.frame.size.height - kPlaybtnHeight)/2.0, kPlaybtnWidth, kPlaybtnHeight);
    spaceXStart += kPlaybtnWidth + kHSpace;
    
    [_playBtn setImage:_isPlaying?[UIImage imageNamed:@"Video_pause_nor.png"]:[UIImage imageNamed:@"Video_play_nor.png"] forState:UIControlStateNormal];
    
    _currentLable.frame = CGRectMake(spaceXStart, (_bottomView.frame.size.height - kCurrentTimeHeight)/2.0, kCurrentTimeWidth, kCurrentTimeHeight);
    spaceXStart += kCurrentTimeWidth + kHSpace;
    
    _cutFullModeBtn.frame = CGRectMake(spaceXEnd - kCutFramebtnWidth, (_bottomView.frame.size.height - kCutFramebtnHeight)/2.0, kCutFramebtnWidth, kCutFramebtnHeight);
    spaceXEnd -= (kCutFramebtnWidth + kHSpace);
    
    [_cutFullModeBtn setImage:_isFullScreen?[UIImage imageNamed:@"Video_full_no.png"]:[UIImage imageNamed:@"Video_full_yes.png"] forState:UIControlStateNormal];
    
    _remainingTimeLable.frame = CGRectMake(spaceXEnd - kRemainingTimeWidth, (_bottomView.frame.size.height - kRemainingTimeHeight)/2.0, kRemainingTimeWidth, kRemainingTimeHeight);
    spaceXEnd -= (kRemainingTimeWidth + kHSpace);
    
    _movieProgress.frame = CGRectMake(spaceXStart, (_bottomView.frame.size.height - kSliderHeight)/2.0, spaceXEnd - spaceXStart, kSliderHeight);
    _movieSlider.frame = _movieProgress.bounds;
    
    _brightnessView.frame = CGRectMake((self.view.bounds.size.width-kBrightnessViewWidth)/2.0, (self.view.bounds.size.height-kBrightnessViewHeight)/2.0, kBrightnessViewWidth, kBrightnessViewHeight);
    _brightnessProgress.frame =  CGRectMake((_brightnessView.frame.size.width - kBrightnessProgressWidth)/2.0, _brightnessView.frame.size.height - kBrightnessProgressHeight - 20, kBrightnessProgressWidth, kBrightnessProgressHeight);
}

#pragma mark - action
//显示列表按钮
-(void)TableListButtonClick
{
    _listType = !_listType;
    //当为也yes时候显示列表
    if(_listType)
    {
        _playerTablListView.view.hidden = NO;
    }
    else
    {
        _playerTablListView.view.hidden = YES;
    }
}

// 返回
-(void)popReturnView
{
    if(self.mode == MyMediaPlayerModeLocal)
    {
        if([self.delegate respondsToSelector:@selector(backClicked)])
        {
            [self.delegate backClicked];
        }
    }
    else
    {
    if(!_isFullScreen)
    {
        if([self.delegate respondsToSelector:@selector(backClicked)])
        {
            [self.delegate backClicked];
        }
    }
    else{
        if(self.mode == MyMediaPlayerModeLocal)
        {
            if([self.delegate respondsToSelector:@selector(backClicked)])
            {
                [self.delegate backClicked];
            }
        }
        else
        {
        [self cutFullModeBtnClick];
        }
    }

    }
}
-(void)showPlayerTableList
{
    _playerTablListView.view.hidden = NO;

    // 轻拍手势 隐藏/显示状态栏
    [UIView animateWithDuration:1 animations:^{
        if(_listType)
        {
            _playerTablListView.view.frame = CGRectMake(self.view.bounds.size.width-kVedioPalyListViewWidth, CGRectGetMaxY(_topView.frame), kVedioPalyListViewWidth, kVedioPalyListViewHeight);
        }else
        {
          _playerTablListView.view.frame = CGRectMake(self.view.bounds.size.width, CGRectGetMaxY(_topView.frame), kVedioPalyListViewWidth, kVedioPalyListViewHeight);
        }

    }];

}
// 切换横竖屏幕
-(void)cutFullModeBtnClick
{
  
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cutFullModeBtnClick" object:nil];

}


// 播放/暂停
- (void)pauseBtnClick
{
    if(_isFromBackGround == YES)
    {
        _isFromBackGround = NO;
    }
    
    if (_isPlaying == NO)
    {
        _isClickToPause = NO;
        
        // 即将播放
        _isReadyToPlay = YES;
        
        // 可以继续播放
        _canGoOnPlay = YES;
        
        // 条件满足 可以继续播放
        if([self netCanPlay] == YES)
        {
            // 播放
            [self play];
        }
    }
    else
    {
        _isClickToPause = YES;
        
        // 暂停
        [self pause];
    }
}

// 快退/快进
- (void)fastAction:(SUIButton *)btn
{
    if (btn == _fastBackwardBtn)
    {
        [self movieProgressAdd:-kMovieProgressStep];
    }
    else if (btn == _fastForeardBtn)
    {
        [self movieProgressAdd:kMovieProgressStep];
    }
}

// 快进/快退
- (void)movieProgressAdd:(CGFloat)step
{
    _movieSlider.value += (step/_movieLength);
    
    [self sliderScrollingEnded];
}

// 上一部/下一部
- (void)forWordOrBackWardMovieAction:(SUIButton *)btn
{
    _movieSlider.value = 0.f;
    
    if(_mode == MyMediaPlayerModeNetwork)
    {
        [_progressHUD show:YES];
    }
    
    _playBtn.enabled = NO;
    _fastBackwardBtn.enabled = NO;
    _fastForeardBtn.enabled = NO;
    _movieSlider.enabled = NO;
    
    if(_hasRegisterStatus)
    {
        [_player.currentItem removeObserver:self forKeyPath:@"status"];
        _hasRegisterStatus = NO;
    }
    if(_mode == MyMediaPlayerModeNetwork)
    {
        if(_hasRegisterRange)
        {
            [_player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
            _hasRegisterRange = NO;
        }
    }
    
    NSDictionary *dic = nil;
    if (btn == _backwardBtn && _datasource && [_datasource isHaveNextMovie])
    {
        dic = [_datasource nextMovieURLAndTitleToTheCurrentMovie];
    }
    else if(btn == _forwardBtn && _datasource && [_datasource isHavePreviousMovie])
    {
        dic = [_datasource previousMovieURLAndTitleToTheCurrentMovie];
    }
    
    _movieURL = (NSURL *)[dic objectForKey:kVidoeUrl];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:_movieURL];
    [_player replaceCurrentItemWithPlayerItem:playerItem];
    
    // 注册检测视频加载状态的通知
    if(_hasRegisterStatus == NO)
    {
        [_player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        _hasRegisterStatus = YES;
    }
    if(_mode == MyMediaPlayerModeNetwork)
    {
        if(!_hasRegisterRange)
        {
            [_player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
            _hasRegisterRange = YES;
        }
    }
    
    _movieTitle = [dic objectForKey:kVidoeTitle];
    _titleLable.text = _movieTitle;
    
    // 检测下一部电影的存在性
    if (_datasource && [_datasource isHaveNextMovie])
    {
        [_forwardBtn setImage:[UIImage imageNamed:@"Video_forward_nor.png"] forState:UIControlStateNormal];
        _forwardBtn.enabled = YES;
    }
    else
    {
        [_forwardBtn setImage:[UIImage imageNamed:@"Video_forward_disable.png"] forState:UIControlStateNormal];
        [_forwardBtn setImage:[UIImage imageNamed:@"Video_forward_disable.png"] forState:UIControlStateHighlighted];
        _forwardBtn.enabled = NO;
    }
    
    // 检测上一部电影的存在性
    if (_datasource && [_datasource isHavePreviousMovie])
    {
        [_backwardBtn setImage:[UIImage imageNamed:@"Video_backward_nor.png"] forState:UIControlStateNormal];
        _backwardBtn.enabled = YES;
    }
    else
    {
        [_backwardBtn setImage:[UIImage imageNamed:@"backward_disable.png"] forState:UIControlStateNormal];
        [_backwardBtn setImage:[UIImage imageNamed:@"backward_disable.png"] forState:UIControlStateHighlighted];
        _backwardBtn.enabled = NO;
    }
}

// 进入后台
- (void)didEnterBackground
{
    _isFromBackGround = NO;
}

// 进入前端
- (void)willEnterForeground
{
    _isFromBackGround = YES;
}

/// 程序活动的动作.
- (void)becomeActive
{
    if(_player.currentItem)
        _isReadyToPlay = YES;
    else
        _isReadyToPlay = NO;
    
    BOOL canPlay = NO;
    if(_mode == MyMediaPlayerModeLocal)
    {
        canPlay = YES;
    }
    
    NSString *netStatus = [SDTool getCurNetStatusForLog];
    if( _mode == MyMediaPlayerModeNetwork &&
       [netStatus isEqualToString:NSLocalizedString(@"NetStatusWifi", )] == YES)
    {
        canPlay = YES;
    }
    
    if(_isFromBackGround == YES)
    {
        canPlay = NO;
    }
    
    if(canPlay == YES)
    {
//        [self play];
    }
}

/// 程序不活动的动作.
- (void)resignActive
{
    // 记录播放记录
    if(_player.currentItem)
    {
        [self creatPlayRecord];
    }
    if (_isPlaying == YES)
    {
        [self pause];
    }
}

/// 声音改变.
- (void)volumeAdd:(CGFloat)step
{
    [MPMusicPlayerController applicationMusicPlayer].volume += step;;
}

/// 屏幕亮度改变.
- (void)brightnessAdd:(CGFloat)step
{
    [UIScreen mainScreen].brightness += step;
    _brightnessProgress.progress = [UIScreen mainScreen].brightness;
}

/// 按动播放进度条.
- (void)scrubbingDidBegin
{
    _gestureType = GestureTypeOfNone;
}

/// 滑动进度条.
- (void)scrubbingDidChange
{
    if(_movieSlider.enabled == NO)
    {
        return;
    }
    
    if([self checkLocalVedioNoLog:_movieSlider] == NO)
    {
        return;
    }
    
    _gestureType = GestureTypeOfProgress;
    
    if (_movieSlider.value == 0.000000)
    {
        __weak typeof(self) wself = self;
        [_player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
            __strong typeof(wself) sself = wself;
            [sself play];
        }];
    }
}

//／ 释放滑块.
- (void)scrubbingDidEnd
{
    if(_movieSlider.enabled
       == NO)
    {
        return;
    }
    
    if([self checkLocalVedioNoLog:_movieSlider] == NO)
    {
        return;
    }
    
    _gestureType = GestureTypeOfNone;
    
    [self sliderScrollingEnded];
}

// 拖动播放进度条
-(void)sliderScrollingEnded
{
    // 🈶三分钟播放提示
    if(_alertCheckIsShown == YES)
    {
        return;
    }
    
    if (_mode == MyMediaPlayerModeNetwork)
    {
        [_progressHUD show:YES];
    }
    
    __weak typeof(_progressHUD) progressHUD = _progressHUD;
    __weak typeof(_player) player = _player;
    typeof(_isPlaying) *isPlaying = &_isPlaying;
    
    double currentTime = floor(_movieLength *_movieSlider.value);
    
    // 转换成CMTime才能给player来控制播放进度
    CMTime dragedCMTime = CMTimeMake(currentTime, 1);
    if (_movieSlider.value == 0.000000)
    {
    }
    else
    {
    
    [_player seekToTime:dragedCMTime completionHandler:
     ^(BOOL finish){
         
         __strong typeof(progressHUD) progressHUD_ = progressHUD;
         __strong typeof(player) player_ = player;
         
         [progressHUD_ hide:YES];
         
         if (*isPlaying == YES){
             [player_ play];
         }
     }];
    }
}
#pragma mark
#pragma mark - touch event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _originalLocation = CGPointZero;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:self.view];
    CGFloat offset_x = currentLocation.x - _originalLocation.x;
    CGFloat offset_y = currentLocation.y - _originalLocation.y;
    
    if (CGPointEqualToPoint(_originalLocation,CGPointZero))
    {
        _originalLocation = currentLocation;
        return;
    }
    _originalLocation = currentLocation;
    
    if (_gestureType == GestureTypeOfNone)
    {
        // 横向 右侧 调整音量
        if ((currentLocation.x > self.view.frame.size.height * 0.8) &&
            (ABS(offset_x) <= ABS(offset_y)) &&
            _isFullScreen == YES)
        {
            _gestureType = GestureTypeOfVolume;
        }
        // 横向 左侧 调整音量
        else if ((currentLocation.x < self.view.frame.size.width * 0.2) &&
                 (ABS(offset_x) <= ABS(offset_y)) &&
                 _isFullScreen == YES)
        {
            _gestureType = GestureTypeOfBrightness;
        }
        else if ((ABS(offset_x) > ABS(offset_y)))
        {
            _gestureType = GestureTypeOfProgress;
        }
    }
    if ((_gestureType == GestureTypeOfProgress) && (ABS(offset_x) > ABS(offset_y)))
    {
        if(_movieSlider.enabled == NO)
        {
            return;
        }
        
        // 只能播放3分钟
        if([self checkLocalVedioNoLog:_movieSlider] == NO)
        {
            return;
        }
        
        if (offset_x > 0 && _alertCheckIsShown == NO)
        {
            // debugLog(@"横向向右");
            _movieSlider.value += 0.005;
        }
        else if(_alertCheckIsShown == NO)
        {
            // debugLog(@"横向向左");
            _movieSlider.value -= 0.005;
        }
    }
    else if ((_gestureType == GestureTypeOfVolume) &&
             (currentLocation.x > self.view.frame.size.width*0.8) &&
             (ABS(offset_x) <= ABS(offset_y)) &&
             _isFullScreen == YES)
    {
        if (offset_y > 0)
        {
            [self volumeAdd:-kVolumeStep];
        }
        else
        {
            [self volumeAdd:kVolumeStep];
        }
    }
    else if ((_gestureType == GestureTypeOfBrightness) &&
             (currentLocation.x < self.view.frame.size.width*0.2) &&
             (ABS(offset_x) <= ABS(offset_y)) &&
             _isFullScreen == YES)
    {
        if (offset_y > 0)
        {
            _brightnessView.alpha = 1;
            [self brightnessAdd:-kBrightnessStep];
        }
        else
        {
            _brightnessView.alpha = 1;
            [self brightnessAdd:kBrightnessStep];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    
    if (_gestureType == GestureTypeOfNone &&
        !CGRectContainsPoint(_bottomView.frame, point) &&
        !CGRectContainsPoint(_topView.frame, point))
    {
        // 轻拍手势 隐藏/显示状态栏
        [UIView animateWithDuration:0.1 animations:^{
            
            if (_isFullScreen == NO)
            {
                if (_isHide)
                {
                    _bottomView.alpha = 1;
                    _topView.alpha = 1;
                    _isHide = NO;
                    [self performSelector:@selector(hidenControlBar) withObject:nil afterDelay:10];
                }
                else
                {
                    _bottomView.alpha = 0;
                    _isHide = YES;
                }
            }
            else
            {
                if (_isHide)
                {
                    _bottomView.alpha = 1;
                    _topView.alpha = 1;
                    _isHide = NO;
                    [self performSelector:@selector(hidenControlBar) withObject:nil afterDelay:10];
                }
                else
                {
                    _bottomView.alpha = 0;
                    _topView.alpha = 0;
                    _isHide = YES;
                }
            }
        }];
    }
    else if (_gestureType == GestureTypeOfProgress)
    {
        _gestureType = GestureTypeOfNone;
        
        if(_movieSlider.enabled == NO)
        {
            return;
        }
        
        if([self checkLocalVedioNoLog:_movieSlider] == NO)
        {
            return;
        }
        
        [self sliderScrollingEnded];
    }
    else
    {
        _gestureType = GestureTypeOfNone;
        
        if (_brightnessView.alpha != 0)
        {
            [UIView animateWithDuration:0.3 animations:^{
                _brightnessView.alpha = 0;
            }];
        }
    }
}

- (void)hidenControlBar
{
    [UIView animateWithDuration:0.1 animations:^{
        if (_isHide == NO)
        {
            _bottomView.alpha = 0;
            _topView.alpha = 0;
            _isHide = YES;
        }
        _topView.alpha = 0;
    }];
}


#pragma mark - 辅助
// 只能播放3分钟
- (BOOL)checkLocalVedioNoLog:(UISlider *)slider
{
    AuthManager *am =[AuthManager sharedInstance];
    if(!am.isAuthenticated)
    {
        if(floor(_movieLength *slider.value) >= kVedioPlayMaxSecends && _alertCheckIsShown == NO)
        {
            ALAlertView *alertView = [[ALAlertView alloc] init];
            alertView.nAnimationType = ALTransitionStylePop;
            alertView.dRound = 10.0;
            alertView.showAnimate = NO;
            
            __weak typeof(self) wself = self;
            
            [alertView doYesNo:@"" body:@"您还没有登录,登录后继续观看" cancel:@"取消" ok:@"确定" yes:^(ALAlertView *alertView) {
                __strong typeof(wself) sself = wself;
                sself.alertCheckIsShown = NO;
                
                if([sself delegate] && [[sself delegate] respondsToSelector:@selector(movieQuickLogIn)])
                {
                    [[sself delegate] movieQuickLogIn];
                }
            } no:^(ALAlertView * alertView) {
                __strong typeof(wself) sself = wself;
                sself.alertCheckIsShown = NO;
            }];
            _alertCheckIsShown = YES;
            
            __weak typeof(self) sself = self;// 这里误差有2秒
            [_player seekToTime:CMTimeMake(kVedioPlayMaxSecends, 1) completionHandler:^(BOOL finished) {
                if(finished)
                {
                    __strong typeof(sself) sself_ = sself;
                    [sself_ pause];
                }
            }];
            
            return NO;
        }
    }
    
    return YES;
}

/*
 @property (nonatomic,assign) BOOL alertIsShown;                     //. 网络alert 提示是否显示了
 @property (nonatomic,assign) BOOL alertCheckIsShown;
 */

- (void)showNoNetAlert
{
    if(_datasource && [_datasource respondsToSelector:@selector(allowPlay)])
    {
        BOOL shouldShowAlert = [_datasource shouldShowAlert];
        if(!shouldShowAlert)
        {
            return;
        }
    }
    ALAlertView *alertView = [[ALAlertView alloc] init];
    alertView.nAnimationType = ALTransitionStylePop;
    alertView.dRound = 10.0;
    alertView.showAnimate = YES;
    alertView.bGrayBg = YES;
    _alertView = alertView;
    
    [alertView doAlert:@"" body:@"oops~,看起来您断网了" duration:0 done:^(ALAlertView *alertView) {
        
    }];
    
    if(_isFullScreen)
    {
        alertView.layer.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
        alertView.vAlert.center = alertView.center;
        
        alertView.layer.transform = CATransform3DMakeRotation(M_PI/2.0, 0, 0, 1);
        alertView.layer.position = CGPointMake(0.5*SCREEN_WIDTH, 0.5*SCREEN_HEIGHT);
    }
    
    _alertIsShown = YES;
    __weak typeof(self) wself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(wself) sself = wself;
        [alertView hideAlert];
        sself.alertIsShown = NO;
    });
}

- (void)showAllow3GPlayBackAlert
{
    if(_datasource && [_datasource respondsToSelector:@selector(allowPlay)])
    {
        BOOL shouldShowAlert = [_datasource shouldShowAlert];
        if(!shouldShowAlert)
        {
            return;
        }
    }
    ALAlertView *alertView = [[ALAlertView alloc] init];
    alertView.nAnimationType = ALTransitionStylePop;
    alertView.dRound = 10.0;
    alertView.showAnimate = YES;
    alertView.bGrayBg = YES;
    _alertView = alertView;
    
    [alertView doAlert:@"" body:@"您正在使用运营商网络" duration:0 done:^(ALAlertView *alertView) {
        
    }];
    
    if(_isFullScreen)
    {
        alertView.layer.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
        alertView.vAlert.center = alertView.center;
        
        alertView.layer.transform = CATransform3DMakeRotation(M_PI/2.0, 0, 0, 1);
        alertView.layer.position = CGPointMake(0.5*SCREEN_WIDTH, 0.5*SCREEN_HEIGHT);
    }
    
    _alertIsShown = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertView hideAlert];
        _alertIsShown = NO;
    });
}

- (void)showDoNotAllow3GPlayBackAlert
{
    if(_datasource && [_datasource respondsToSelector:@selector(allowPlay)])
    {
        BOOL shouldShowAlert = [_datasource shouldShowAlert];
        if(!shouldShowAlert)
        {
            return;
        }
    }
    ALAlertView *alertView = [[ALAlertView alloc] init];
    alertView.nAnimationType = ALTransitionStylePop;
    alertView.dRound = 10.0;
    alertView.showAnimate = NO;
    _alertView = alertView;
    
    __weak typeof(self) wself = self;
    [alertView doYesNo:@"" body:@"您正在使用运营商网络,继续观看可能产生超额流量费" cancel:@"取消" ok:@"继续播放" yes:^(ALAlertView *alertView) {
        
        __strong typeof(wself) sself = wself;
        
        // 设置允许过2G/3G/4G/断网 可继续播放
        _allow3GPlay = YES;
        sself.alertIsShown = NO;
        
        [sself play];
        
    } no:^(ALAlertView *alertView) {
        
        __strong typeof(wself) sself = wself;
        sself.alertIsShown = NO;
        
    }];
    
    if(_isFullScreen)
    {
        UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
        alertView.layer.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
        alertView.vAlert.center = alertView.center;
        if (deviceOrientation == UIDeviceOrientationLandscapeRight) {
            alertView.layer.transform = CATransform3DMakeRotation(-M_PI_2, 0, 0, 1);
        }else if(deviceOrientation == UIDeviceOrientationLandscapeLeft){
            alertView.layer.transform = CATransform3DMakeRotation(M_PI/2.0, 0, 0, 1);
        }
        alertView.layer.position = CGPointMake(0.5*SCREEN_WIDTH, 0.5*SCREEN_HEIGHT);
    }
    
    _alertIsShown = YES;
}

- (void)showConnectNetAlert
{
    if(_datasource && [_datasource respondsToSelector:@selector(allowPlay)])
    {
        BOOL shouldShowAlert = [_datasource shouldShowAlert];
        if(!shouldShowAlert)
        {
            return;
        }
    }
    ALAlertView *alertView = [[ALAlertView alloc] init];
    alertView.nAnimationType = ALTransitionStylePop;
    alertView.dRound = 10.0;
    alertView.showAnimate = YES;
    alertView.bGrayBg = YES;
    
    [alertView doAlert:@"" body:@"已连接到Wi-Fi" duration:0 done:^(ALAlertView *alertView) {
        
    }];
    
    if(_isFullScreen)
    {
        alertView.layer.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
        alertView.vAlert.center = alertView.center;
        
        alertView.layer.transform = CATransform3DMakeRotation(M_PI/2.0, 0, 0, 1);
        alertView.layer.position = CGPointMake(0.5*SCREEN_WIDTH, 0.5*SCREEN_HEIGHT);
    }
    
    _alertIsShown = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertView hideAlert];
        _alertIsShown = NO;
    });
}

// 能不能播放视频
- (BOOL)netCanPlay
{
    if(_mode == MyMediaPlayerModeLocal)
    {
        return YES;
    }
    // 检测网络环境 wifi下自动播放
    NSString *netStatus = [SDTool getCurNetStatusForLog];
    _stringNetStatus = netStatus;
    if( _mode == MyMediaPlayerModeNetwork &&
       [netStatus isEqualToString:NSLocalizedString(@"NetStatusWifi", )] == YES)
    {
        return YES;
    }
    // 断网播放
    else if( _mode == MyMediaPlayerModeNetwork &&
            !netStatus &&
            _alertIsShown == NO)
    {
        [self showNoNetAlert];
        return YES;
    }
    // 非wifi允许过3G
    else if( _mode == MyMediaPlayerModeNetwork &&
            netStatus &&
            [netStatus isEqualToString:NSLocalizedString(@"NetStatusWifi", )] == NO &&
            _allow3GPlay == YES &&
            _alertIsShown == NO)
    {
        [self showAllow3GPlayBackAlert];
        return YES;
    }
    // 非wifi未允许过3g
    else if(_mode == MyMediaPlayerModeNetwork &&
            netStatus &&
            [netStatus isEqualToString:NSLocalizedString(@"NetStatusWifi", )] == NO &&
            _allow3GPlay == NO &&
            (_isPlaying || _isReadyToPlay) &&
            _alertIsShown == NO)
    {
        [self stop];
        [self showDoNotAllow3GPlayBackAlert];
        return NO;
    }
    
    return NO;
}

// 是否在播放
- (BOOL)isPlaying
{
    return _isPlaying;
}

// 播放
- (void)play
{
    if([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive)
    {
        return;
    }
    if(_canGoOnPlay == NO)
    {
        return;
    }
    if( _isFromBackGround == YES)
    {
        return;
    }
    if(_isClickToPause)
    {
        return;
    }
    if([self checkLocalVedioNoLog:_movieSlider] == NO)
    {
        return;
    }
    if(_datasource && [_datasource respondsToSelector:@selector(allowPlay)])
    {
        BOOL allowPlay = [_datasource allowPlay];
        if(!allowPlay)
        {
            return;
        }
    }
    if(_alertCheckIsShown ||( _alertIsShown && _allow3GPlay == NO))
    {
        return;
    }
    if(_playerLayer == nil)
    {
        [self createAvPlayer];
        [self.view bringSubviewToFront:_coverImageView];
        [self.view bringSubviewToFront:_topView];
        [self.view bringSubviewToFront:_bottomView];
        [self cutFullModeView];
    }
    else
    {
        [self coverImageView].hidden = YES;
        
        _isReadyToPlay = NO;
        _isPlaying = YES;
        _isClickToPause = NO;
        [_player play];
        [_playBtn setImage:_isPlaying?[UIImage imageNamed:@"Video_pause_nor.png"]:[UIImage imageNamed:@"Video_play_nor.png"] forState:UIControlStateNormal];
    }
}

// 暂停
- (void)pause
{
    _isReadyToPlay = YES;
    _isPlaying = NO;
    
    if(_player){
        [_player pause];
    }
    [_playBtn setImage:[UIImage imageNamed:@"Video_play_nor.png"] forState:UIControlStateNormal];
}

// 停止
- (void)stop
{
    if(_player.currentItem)
    {
        [self cutImgage];
        [self creatPlayRecord];
    }
    
    _isReadyToPlay = YES;
    _isPlaying = NO;
    _isClickToPause = NO;
    [_playBtn setImage:[UIImage imageNamed:@"Video_play_nor.png"] forState:UIControlStateNormal];
    
    if(_timeObserver && _player)
    {
        [_player removeTimeObserver:_timeObserver];
        _timeObserver = nil;
    }
    
    if(_player.currentItem)
    {
        if(_hasRegisterRange)
        {
            [_player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
            _hasRegisterRange = NO;
        }
        if(_hasRegisterStatus)
        {
            [_player.currentItem removeObserver:self forKeyPath:@"status"];
            _hasRegisterStatus = NO;
        }
        [_player.currentItem.asset cancelLoading];
    }
    if(_player)
    {
        [_player cancelPendingPrerolls];
        [_player replaceCurrentItemWithPlayerItem:nil];
        _player = nil;
    }
    if(_playerLayer)
    {
        [_playerLayer removeFromSuperlayer];
        _playerLayer = nil;
    }
}

// 释放事件
- (void)popView
{
    //保存本次播放进度
    if(_mode == MyMediaPlayerModeNetwork)
    {
        if(_player.currentItem)
        {
            [self creatPlayRecord];
        }
    }
    else
    {
        // 本地
        [[DatabaseManager defaultDatabaseManager] addPlayRecordWithIdentifier:_videoId progress:_movieSlider.value];
    }
    
    _isPlaying = NO;
    if(_player)
    {
        [_player pause];
    }
    
    if(_hasRegisterValue)
    {
        [_movieSlider removeObserver:self forKeyPath:@"value"];
        _hasRegisterValue = NO;
    }
    
    if(_timeObserver && _player)
    {
        [_player removeTimeObserver:_timeObserver];
        _timeObserver = nil;
    }
    if(_mode == MyMediaPlayerModeNetwork)
    {
        if(_hasRegisterRange && _player.currentItem)
        {
            [_player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
            _hasRegisterRange = NO;
        }
        if(_hasRegisterStatus && _player.currentItem)
        {
            [_player.currentItem removeObserver:self forKeyPath:@"status"];
            _hasRegisterStatus = NO;
        }
    }
    else
    {
        if(_hasRegisterStatus && _player.currentItem)
        {
            [_player.currentItem removeObserver:self forKeyPath:@"status"];
            _hasRegisterStatus = NO;
        }
        if(_hasRegisterRange && _player.currentItem)
        {
            [_player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
            _hasRegisterRange = NO;
        }
    }
    if(_player)
    {
        [_player replaceCurrentItemWithPlayerItem:nil];
        _player = nil;
    }
    if(_playerLayer)
    {
        [_playerLayer removeFromSuperlayer];
        _playerLayer = nil;
    }
    UILabel *str ;
    [str addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [UIScreen mainScreen].brightness = _systemBrightness;
}

// kvo事件
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{

    if ([keyPath isEqualToString:@"status"])
    {
        self.clickType = YES;
        if( _mode == MyMediaPlayerModeNetwork)
        {
        [[NSNotificationCenter defaultCenter] postNotificationName:PlaybackIsPreparedToPlayDidChangeNotification object:self];
        }
        if([object isKindOfClass:[AVPlayerItem class]])
        {
            AVPlayerItem *playerItem = (AVPlayerItem*)object;
       
        if ([playerItem status] == AVPlayerStatusReadyToPlay)
    {

            // 视频加载完成,去掉等待
            [_progressHUD hide:YES];
        
            // 计算视频总长度
            _movieLength = (playerItem.asset.duration.value / playerItem.asset.duration.timescale);
            
            // 显示总长度
            [self reaminTime:_movieLength];
            
            // 监听播放状态
            [self monitoringPlayback:playerItem];
            
            // 播放
            _isReadyToPlay = YES;
            if([self netCanPlay] == YES)
            {
                // 获取上次播放进度,仅对本地有效
                if (_isFirstOpenPlayer == YES && _mode == MyMediaPlayerModeLocal)
                {
                    CGFloat progress = [[DatabaseManager defaultDatabaseManager] getProgressByIdentifier:_videoId];
                    _movieSlider.value = progress;
                    
                    CMTime dragedCMTime = CMTimeMake(floor(_movieLength *_movieSlider.value), 1);
                    
                    __weak typeof (self) sself = self;
                    [_player seekToTime:dragedCMTime completionHandler:
                     ^(BOOL finish){
                         __strong typeof(sself) self_ = sself;
                         self_.playBtn.enabled = YES;
                         self_.fastBackwardBtn.enabled = YES;
                         self_.fastForeardBtn.enabled = YES;
                         self_.movieSlider.enabled = YES;
                         
                         __strong typeof(sself) sself_ = sself;
                         [sself_ play];
                         
                     }];
                    
                    _isFirstOpenPlayer = NO;
                }
                else if(_mode == MyMediaPlayerModeNetwork)
                {
                    // 请求获取上次播放记录
                    [self requestPlayRecord];
                }
                
            }
        if(self.mode == MyMediaPlayerModeLocal)
        {
        NSError *error = nil;
        NSData * sdfssssd= [[NSFileManager defaultManager] contentsAtPath:[NSString stringWithFormat:@"%@%@",kDocPath,self.ECAPath]];

        
                    NSData *encryptedData = [RNEncryptor encryptData:sdfssssd
                                                        withSettings:kRNCryptorAES256Settings
                                                            password:@"PWD"
                                                               error:&error];
                    if([encryptedData writeToFile:[NSString stringWithFormat:@"%@%@",kDocPath,self.ECAPath] atomically:YES])
                    {
                        NSLog(@"1");
                    }
                    else
                    {
                        NSLog(@"2");
                        
                    }
        }
            //debugLog(@"AVPlayerStatusSuccess");
        }
        else if ([playerItem status] == AVPlayerStatusFailed)
        {
            [_alertView doAlert:@"" body:@"视频加载失败" duration:0 done:^(ALAlertView *alertView) {
                
            }];
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            
        
            [[self class] cancelPreviousPerformRequestsWithTarget:self];

//              [self popView];

        }
        else if ([playerItem status] == AVPlayerStatusUnknown)
        {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            
            
            [[self class] cancelPreviousPerformRequestsWithTarget:self];

        }
             }
    }
    if ([keyPath isEqualToString:@"loadedTimeRanges"])
    {
        if([object isKindOfClass:[AVPlayerItem class]])
        {
            [self.view.layer insertSublayer:self.playerLayer atIndex:0];
            [self.view bringSubviewToFront:_coverImageView];
            [self.view bringSubviewToFront:_topView];
            [self.view bringSubviewToFront:_bottomView];
            [self.view bringSubviewToFront:_playerTablListView.view];
            float bufferTime = [self availableDuration];
            //debugLog(@"缓冲进度%f",bufferTime);
            float durationTime = CMTimeGetSeconds([(AVPlayerItem*)object duration]);
            //debugLog(@"缓冲进度：%f , 百分比：%f",bufferTime,bufferTime/durationTime);
            
            [_movieProgress setProgress:bufferTime / durationTime animated:YES];
        }
   
    }
    else if ([keyPath isEqualToString:@"value"])
    {
        UISlider *slider = (UISlider *)object;
        
        // 看有没有登录/认证
        if(floor(_movieLength *slider.value) >= kVedioPlayMaxSecends)
        {
            [self checkLocalVedioNoLog:slider];
        }
    }
}

// 视频播放到结尾
- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    // 不能继续播放了
    _canGoOnPlay = NO;
    [_player seekToTime:kCMTimeZero];
    
    _isPlaying = NO;
    [_player pause];
    [_playBtn setImage:[UIImage imageNamed:@"Video_play_nor.png"] forState:UIControlStateNormal];
    
    // 都播放完了
    if (_delegate && [_delegate respondsToSelector:@selector(movieFinished:)])
    {
        [_delegate movieFinished:_movieSlider.value];
    }
    
    // 全屏收回
    if(_isFullScreen == YES)
    {
     
    if(self.mode == MyMediaPlayerModeNetwork)
    {
        [self cutFullModeBtnClick];
    }else
    {
        if (_delegate && [_delegate respondsToSelector:@selector(backClicked)])
        {
            [_delegate backClicked];
        }
    }
    
    }
}

// 监听播放的状态
- (void)monitoringPlayback:(AVPlayerItem *)playerItem
{
    __weak typeof(_player) player_ = _player;
    __weak typeof(_movieSlider) movieSlider_ = _movieSlider;
    __weak typeof(_currentLable) currentLable_ = _currentLable;
    __weak typeof(_remainingTimeLable) remainingTimeLable = _remainingTimeLable;
    
    typeof(_movieLength) *movieLength_ = &_movieLength;
    typeof(_gestureType) *gestureType_ = &_gestureType;
    
    // 第一个参数反应了检测的频率
    _timeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 30) queue:NULL usingBlock:^(CMTime time)
                     {
                         __strong typeof(player_) tplayer_ = player_;
                         __strong typeof(movieSlider_) tmovieProgressSlider_ = movieSlider_;
                         __strong typeof(currentLable_) tcurrentLable_ = currentLable_;
                         __strong typeof(remainingTimeLable) remainingTimeLable_ = remainingTimeLable;
                         
                         if ((*gestureType_) != GestureTypeOfProgress)
                         {
                             // 获取当前时间
                             CMTime currentTime = tplayer_.currentItem.currentTime;
                             double currentPlayTime = (double)currentTime.value / currentTime.timescale;
                             //
                             // 剩余时间
                             CGFloat remainingTime = (*movieLength_) - currentPlayTime;
                             
                             NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:currentPlayTime];
                             NSDate *remainDate = [NSDate dateWithTimeIntervalSince1970:remainingTime];
                             
                             NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                             [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
                             
                             [formatter setDateFormat:(currentPlayTime/3600>=1)? @"HH:mm:ss":@"mm:ss"];
                             NSString *currentTimeStr = [formatter stringFromDate:currentDate];
                             
                             [formatter setDateFormat:(remainingTime/3600>=1)? @"HH:mm:ss":@"mm:ss"];
                             NSString *remainingTimeStr = [NSString stringWithFormat:@"-%@",[formatter stringFromDate:remainDate]];
                             
                             // 进度条
                             tmovieProgressSlider_.value = currentPlayTime / (*movieLength_);
                             // 播放进度label
                             tcurrentLable_.text = currentTimeStr;
                             // 剩余时间label
                             remainingTimeLable_.text = remainingTimeStr;
                         }
                     }];
    
}

// 计算缓冲进度
- (float)availableDuration
{
    NSArray *loadedTimeRanges = [_player.currentItem loadedTimeRanges];
    
    if ([loadedTimeRanges count] > 0)
    {
        CMTimeRange timeRange = [[loadedTimeRanges objectAtIndex:0] CMTimeRangeValue];
        
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        
        return (startSeconds + durationSeconds);
    }
    else
    {
        return 0.0f;
    }
}

// 剩余时间
- (void)reaminTime:(CGFloat)duration
{
    NSDate *remainDate = [NSDate dateWithTimeIntervalSince1970:duration];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [formatter setDateFormat:(duration/3600>=1)? @"HH:mm:ss":@"mm:ss"];
    NSString *remainingTimeStr = [NSString stringWithFormat:@"-%@",[formatter stringFromDate:remainDate]];
    _remainingTimeLable.text = remainingTimeStr;
}

// 请求播放记录(从指定位置播放)
- (void)requestPlayRecord
{
    __weak typeof (self) sself = self;
    
    CMTime dragedCMTime = kCMTimeZero;
    
    if (_historyPlayTime) {
        dragedCMTime = CMTimeMake(floor([_historyPlayTime integerValue]), 1);
    }
    
    [_player seekToTime:dragedCMTime completionHandler:
     ^(BOOL finish){
         __strong typeof(sself) self_ = sself;
         self_.playBtn.enabled = YES;
         self_.fastBackwardBtn.enabled = YES;
         self_.fastForeardBtn.enabled = YES;
         self_.movieSlider.enabled = YES;
         
         [self.view.layer  addSublayer: self.playerLayer];
         
         [self.view bringSubviewToFront:_coverImageView];
         [self.view bringSubviewToFront:_topView];
         [self.view bringSubviewToFront:_bottomView];
         [self.view bringSubviewToFront:_playerTablListView.view];
         
         [self_ play];
         
     }];

}

// 记录播放记录
- (void)creatPlayRecord
{
//    if(_netWorkCreatVedioPlayRecord)
//    {
//        _netWorkCreatVedioPlayRecord = nil;
//    }
//
//    NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
//
//    NSString *customID = [AllinUserDefault  objectForKey:kLog_CustomerId];
//    
//    [dicParam setValue:customID forKey:@"customerId"];
//    [dicParam setValue:_videoId forKey:@"videoId"];
//    [dicParam setValue:[NSString stringWithFormat:@"%ld",(long)eAppSiteType] forKey:@"siteId"];
//    
//    // 获取当前时间
//    CMTime currentTime = _player.currentItem.currentTime;
//    double currentPlayTime = (double)currentTime.value / currentTime.timescale;
//    
//    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:currentPlayTime];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
//    [formatter setDateFormat:@"HH:mm:ss"];
//    NSString *currentTimeStr = [formatter stringFromDate:currentDate];
//    
//    [dicParam setValue:currentTimeStr forKey:@"playTime"];
//    
//    _netWorkCreatVedioPlayRecord = [[NetWorkCreatVedioPlayRecord alloc] init];
//    [_netWorkCreatVedioPlayRecord asyncCreatVedioPlayRecord:ALLIN_VedioCreatPlayRecord parame:dicParam type:post successBlock:^(id result) {
//        
//    } failedBlock:^(id error) {
//        
//    }];
}

// 截取某一帧图
- (void)cutImgage
{
    if(_player)
    {
        _coverImageView.image = [UIImage thumbnailImageForVideo:_movieURL atTime:_player.currentItem.currentTime.value/_player.currentItem.currentTime.timescale];
        _coverImageView.hidden = NO;
    }
}

// 切换视频
- (void)changeVedioByURL:(NSString *)urlString coverImageURL:(NSString *)coverImageURL vedioTitle:(NSString *)movieTitle videoId:(NSString *)videoId
{

    self.fastBackwardBtn.enabled = NO;
    self.fastForeardBtn.enabled = NO;
    self.movieSlider.enabled = NO;

    
    [[NSNotificationCenter defaultCenter] postNotificationName:PlaybackIsPreparedToPlayDidChangeNotification object:self];

    // 保存播放记录
    if(_player.currentItem)
    {
        [self creatPlayRecord];
    }
   
//    [_player removeItem:_player.currentItem];
    if(_isFromBackGround == YES)
    {
        _isFromBackGround = NO;
    }
    
    // 进度条
    _movieSlider.value = 0;
    // 播放进度label
    _currentLable.text = @"00:00";
    // 剩余时间label
    _remainingTimeLable.text = @"00:00";
    
//    BOOL isLocal = ([SDTool isLocalVideo:videoId]);
    BOOL isLocal  = NO;
    if(isLocal)
    {
        // 本地
        _mode = MyMediaPlayerModeLocal;
        urlString =[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        _movieURL = [NSURL fileURLWithPath:urlString isDirectory:NO];
        _movieTitle = movieTitle;
        _videoId = videoId;
        _coverImageURL = coverImageURL;
    }
    else
    {
        // 线上
        _mode = MyMediaPlayerModeNetwork;
        urlString =[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        _movieURL = [NSURL URLWithString:urlString];
        _movieTitle = movieTitle;
        _videoId = videoId;
        _coverImageURL = coverImageURL;
    }

    if(_playerLayer == nil)
    {
        [self createAvPlayer];
        [self.view bringSubviewToFront:_coverImageView];
        [self.view bringSubviewToFront:_topView];
        [self.view bringSubviewToFront:_bottomView];
        [self cutFullModeView];
    }
    else
    {
        if(isLocal)
        {
            // 本地
            [_titleLable setText:_movieTitle];
            _coverImageView.hidden = NO;
            [_coverImageView sd_setImageWithURL:[NSURL URLWithString:_coverImageURL]];
            
            if(_hasRegisterRange == YES)
            {
                [_player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
                _hasRegisterRange = NO;
            }
            if(_hasRegisterStatus)
            {
                [_player.currentItem removeObserver:self forKeyPath:@"status"];
                _hasRegisterStatus = NO;
            }
            AVURLAsset*  avasset = [AVURLAsset URLAssetWithURL:_movieURL options:nil];
            //avasset = [AVURLAsset URLAssetWithURL:url options:nil];
            AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:avasset];
            if(self.LoadType == NO){
                if(_player.currentItem){
                    
                    
                    
                    AVURLAsset*  avasset = [AVURLAsset URLAssetWithURL:_movieURL options:nil];

                    [_player replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithAsset:avasset]];
                    
                }else
                {
                    
                    
                    _player = [AVPlayer playerWithPlayerItem:playerItem];
                    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
                    
                }
            }
            else
            {
                
                _player = [AVPlayer playerWithPlayerItem:playerItem];
                self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
                _player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
                
                [self.view.layer insertSublayer: self.playerLayer atIndex:0];
                self.playerLayer.anchorPoint =CGPointZero;
                if(_isFullScreen)
                {
                    self.playerLayer.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
                }
                else
                {
                    self.playerLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 180*kScreenScaleHeight);
                }
                [_player play];
                
            }
        
            // 注册检测视频加载状态的通知
            [_player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
            _hasRegisterStatus = YES;
            [_player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
            _hasRegisterRange = YES;
        }
        else
        {
            [_titleLable setText:_movieTitle];

            [self popView];
         
            AVURLAsset*  avasset = [AVURLAsset URLAssetWithURL:_movieURL options:nil];
            //avasset = [AVURLAsset URLAssetWithURL:url options:nil];
            
            AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:avasset];
           
                    _player = [AVPlayer playerWithPlayerItem:playerItem];
                    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
                    _player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
                   
                    self.playerLayer.anchorPoint =CGPointZero;
                    if(_isFullScreen)
                    {
                    self.playerLayer.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
                    }
                    else
                    {
                    self.playerLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 180*kScreenScaleHeight);
                    }
        
            
                    [_player play];
                    
                    //      // 注册检测视频加载状态的通知
                    [_player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
                    _hasRegisterStatus = YES;
                    [_player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
                    _hasRegisterRange = YES;
    
                 [_movieSlider addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
                  _hasRegisterValue = YES;
        }
    }
}

#pragma mark
#pragma mark - alertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 登录
    if (alertView.tag == kLogStatusAlertTag)
    {
        if(buttonIndex != alertView.cancelButtonIndex)
        {
            if([self delegate] && [[self delegate] respondsToSelector:@selector(movieQuickLogIn)])
            {
                [[self delegate] movieQuickLogIn];
            }
        }
        _alertCheckIsShown = NO;
    }
}


// 网络状态发生变化
- (void)reachabilityChanged:(NSNotification *)note
{
    if(_mode == MyMediaPlayerModeLocal)
    {
        [self play];
        return;
    }
    
    Reachability *reachability = [note object];
    if(reachability.isReachableViaWiFi)
    {
        _stringNetStatus = NSLocalizedString(@"NetStatusWifi", );
        if(_mode == MyMediaPlayerModeNetwork &&
           _allow3GPlay == YES &&
           _alertIsShown == NO)
        {
            [self showConnectNetAlert];
        }
        [self play];
    }
    else if(reachability.isReachable == NO &&
            _mode == MyMediaPlayerModeNetwork &&
            _alertIsShown == NO)
    {
        _stringNetStatus = nil;
        [self showNoNetAlert];
    }
    // 非wifi允许过3G
    else if( _mode == MyMediaPlayerModeNetwork &&
            _allow3GPlay == YES &&
            _alertIsShown == NO)
    {
        _stringNetStatus = NSLocalizedString(@"NetStatus3G", );
        [self showAllow3GPlayBackAlert];
        [self play];
    }
    // 非wifi未允许过3g
    else if(_mode == MyMediaPlayerModeNetwork &&
            _allow3GPlay == NO &&
            _alertIsShown == NO)
    {
        _stringNetStatus = NSLocalizedString(@"NetStatus3G", );
        [self stop];
        [self showDoNotAllow3GPlayBackAlert];
    }
}
//点击(全屏时)播放器列表代理
-(void)didSelectRowAtIndexPathModal:(id)object indexPath:(NSIndexPath *)path;
{
  if([self.delegate respondsToSelector:@selector(didPlayeSelectRowAtIndexPathModal:viewController:indexPath:)])
       {
           [self.delegate didPlayeSelectRowAtIndexPathModal:object viewController:self indexPath:path];
           // 隐藏列表
           [self TableListButtonClick];
       }
}
@end
/*
 * DatabaseManager
 * 通过把播放过的影片的进度信息保存在plist 文件中，实现记住播放历史的功能
 * plist 文件采用队列形式，队列长度为50
 */

NSString *const MoviePlayerArchiveKey_identifier = @"identifier";
NSString *const MoviePlayerArchiveKey_date = @"date";
NSString *const MoviePlayerArchiveKey_progress = @"progress";

NSInteger const MoviePlayerArchiveKey_MaxCount = 50;

@implementation DatabaseManager

- (instancetype)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

+ (DatabaseManager *)defaultDatabaseManager{
    static DatabaseManager * manager = nil;
    if (manager == nil) {
        manager = [[DatabaseManager alloc]init];
    }
    return manager;
}

+ (NSString *)pathOfArchiveFile{
    NSString *plistFilePath = [kDocPath stringByAppendingPathComponent:@"playRecord.plist"];
    return plistFilePath;
}

- (void)addPlayRecordWithIdentifier:(NSString *)identifier progress:(CGFloat)progress{
    
    if(!identifier)
    {
        return;
    }
    
    NSMutableArray *recardList = [[NSMutableArray alloc]initWithContentsOfFile:[DatabaseManager pathOfArchiveFile]];
    if (!recardList) {
        recardList = [[NSMutableArray alloc]init];
    }
    if (recardList.count==MoviePlayerArchiveKey_MaxCount) {
        [recardList removeObjectAtIndex:0];
    }
    
    NSDictionary *dic = @{MoviePlayerArchiveKey_identifier:identifier,MoviePlayerArchiveKey_date:[NSDate date],MoviePlayerArchiveKey_progress:@(progress)};
    [recardList addObject:dic];
    [recardList writeToFile:[DatabaseManager pathOfArchiveFile] atomically:YES];
}

- (CGFloat)getProgressByIdentifier:(NSString *)identifier
{
    NSMutableArray *recardList = [[NSMutableArray alloc]initWithContentsOfFile:[DatabaseManager pathOfArchiveFile]];
    __block CGFloat progress = 0;
    [recardList enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dic = obj;
        
        id data = dic[MoviePlayerArchiveKey_identifier];
        if ([data isKindOfClass:[NSString class]] && [data isEqualToString:identifier])
        {
            progress = [dic[MoviePlayerArchiveKey_progress] floatValue];
            *stop = YES;
        }
        else if ([data isKindOfClass:[NSNumber class]] && [data integerValue] == [identifier integerValue])
        {
            progress = [dic[MoviePlayerArchiveKey_progress] floatValue];
            *stop = YES;
        }
    }];
    if (progress > 0.9 || progress < 0.05) {
        return 0;
    }
    return progress;
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
