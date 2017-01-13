//
//  SDMediaPlayerVC.h
//  NTreat
//
//  Created by 周冉 on 16/5/3.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SUIButton.h"
#import <AVFoundation/AVFoundation.h>
#import "ChapterViewViewController.h"//视频全屏列表因为跟章节一样所以复用章节
static NSString * PlaybackIsPreparedToPlayDidChangeNotification = @"PlaybackIsPreparedToPlayDidChangeNotification";

@class SDMediaPlayerVC;
@protocol MyMediaPlayerDelegate <NSObject>

@optional
- (void)movieFinished:(CGFloat)progress;
- (void)movieBack;
- (void)movieQuickLogIn; //登录
- (void)backClicked;//返回按钮
- (void)showPalye;//失败后 显示play
- (void)recordPlayProgressWithTime:(NSInteger)duration;

// 全频播放时点击右侧列表切换的代理传递
-(void)didPlayeSelectRowAtIndexPathModal:(id)object viewController:(SDMediaPlayerVC *)PlayerVC indexPath:(NSIndexPath *)path;

@end

@protocol MyMediaPlayerDataSource <NSObject>

@optional
- (NSDictionary *)nextMovieURLAndTitleToTheCurrentMovie;
- (NSDictionary *)previousMovieURLAndTitleToTheCurrentMovie;
- (BOOL)isHaveNextMovie;
- (BOOL)isHavePreviousMovie;
- (BOOL)allowPlay;
- (BOOL)shouldShowAlert;
@end


@interface SDMediaPlayerVC : UIViewController

//视频类型的枚举  0表示网络  1本地
typedef enum {
    MyMediaPlayerModeNetwork = 0,
    MyMediaPlayerModeLocal
} MyMediaPlayerMode;

@property (nonatomic, weak) id<MyMediaPlayerDelegate> delegate;
@property (nonatomic, weak) id<MyMediaPlayerDataSource> datasource;
@property (nonatomic, assign) MyMediaPlayerMode mode;                    //. 视频模式
@property (nonatomic, assign) CGRect nomalFrame;                         //. 正常frame
@property (nonatomic, assign) CGRect cutFullModeFrame;                   //. 全屏幕尺寸
@property (nonatomic, assign) BOOL isFullScreen;                         //. 是否是全屏
@property (nonatomic, strong) SUIButton *cutFullModeBtn;                  //. 切换全屏模式
@property (nonatomic, assign) BOOL backPop;                              //. 返回是否退出

@property (nonatomic,strong)AVPlayerLayer *playerLayer;             //. avplayerLayer
@property (nonatomic,strong)UIView *bottomView;                     //. 底部视频控制器
@property (nonatomic,strong)UIView *topView;                        //. topview
@property (nonatomic, assign)BOOL LoadType;                          //加载失败或者成功
@property (nonatomic, strong)ChapterViewViewController *playerTablListView;   // //视频全屏列表
@property (nonatomic, strong)UIButton *tableListButton;           //全屏列表按钮
@property (nonatomic, assign)BOOL listType;                        //是否显示列表
@property (nonatomic, strong)NSMutableArray *dataArray;            //视频列表数组
@property(nonatomic ,assign)NSInteger fullScrenType;// 用于区分列表的类型
@property (nonatomic ,assign)BOOL clickType;//是否可以点击
@property (nonatomic ,copy)NSString *ECAPath;//加密文件路径

@property (nonatomic,copy) NSString *historyPlayTime; //上次播放时间位置


@property (nonatomic, assign, readonly) BOOL isRotateEnable; // 是否允许旋转

// 初始化网络视频
- (id)initNetworkMyMediaPlayerWithURL:(NSURL *)url coverImageURL:(NSString *)coverImageURL movieTitle:(NSString *)movieTitle videoId:(NSString *)videoId;

// 初始化本地视频
- (id)initLocalMyMediaPlayerWithURL:(NSURL *)url coverImageURL:(NSString *)coverImageURL movieTitle:(NSString *)movieTitle videoId:(NSString *)videoId;

// 在返回时释放
- (void)popView;

// 切换屏幕尺寸
- (void)cutFullModeView;

// 切换视频
- (void)changeVedioByURL:(NSString *)urlString coverImageURL:(NSString *)coverImageURL vedioTitle:(NSString *)movieTitle videoId:(NSString *)videoId;

// 暂停
- (void)pause;

// 播放
- (void)play;

// 是否在播放
- (BOOL)isPlaying;

+(SDMediaPlayerVC *) sharedMyMediaPlayer;

- (void)createBottomView;
- (void)createAvPlayer;
- (void)createTopView;
- (void)pauseBtnClick;

-(void)cutFullModeBtnClick;

-(void)adjustVideoWithOrientation:(UIDeviceOrientation)orientation ;
@end
//记住播放进度相关的数据库操作类
@interface DatabaseManager : NSObject
+ (id)defaultDatabaseManager;
- (void)addPlayRecordWithIdentifier:(NSString *)identifier progress:(CGFloat)progress;
- (CGFloat)getProgressByIdentifier:(NSString *)identifier;


@end
