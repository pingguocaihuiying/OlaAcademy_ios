//
//  CourSectionViewController.m
//  课程章节分类及视频 页面
//
//  Created by 田晓鹏 on 15/10/21.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import "CourSectionViewController.h"

#import "SysCommon.h"
#import "VIPSubController.h"
#import "AuthManager.h"
#import "CommodityManager.h"
#import "SDMediaPlayerVC.h"

#import "Masonry.h"
#import "CourSectionTableCell.h"
#import "LoginViewController.h"
#import "CourBuyViewController.h"
#import "CommodityPayVC.h"
#import "IAPVIPController.h"

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"
#import "Reachability.h"
#import "ShareSheetView.h"

#import "DownloadModal.h"
#import "DownloadManager.h"
#import "WatchRecordManager.h"

#import "PayManager.h"

#import "PDFView.h"
#import "CommodityView.h"
#import "HMSegmentedControl.h"
#import "SVProgressHUD.h"

@interface CourSectionViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,MFMailComposeViewControllerDelegate,PDFViewDelegate,MyMediaPlayerDelegate,MyMediaPlayerDataSource,ShareSheetDelegate,UMSocialUIDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) HMSegmentedControl *segmentedControl;
@property (nonatomic) UIView *operationView;
@property (nonatomic) CommodityView *detailView;
@property (nonatomic) PDFView *pdfView;

@property (nonatomic) ThirdPay *thirdPay; //iap支付 还是 支付宝 微信支付

@property (nonatomic) NSString *orderStatus; // 购买状态

@property (nonatomic) int currentIndex;
@property (nonatomic) CourseVideo *currentVideo;

@property(nonatomic ,strong) SDMediaPlayerVC *myMediaPlayer; //视频播放控件
@property(nonatomic ,strong) UIView *bgView;


@end

@implementation CourSectionViewController{
    
    UIView *titleView;
    
    UILabel *priceL;
    
    UIButton *forwardButton;
    UIButton *nextButton;
    UIButton *collectionButton;
    UIButton *downloadButton;
    UIButton *shareButton;
    
    BOOL vidioFinishLoad;
    
    /**
     *  数据源
     */
    NSMutableArray *dataArray;
    
    BOOL isCollected;
    
    NSInteger currentRow;
    
    NSIndexPath *lastIndexPath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 取消右滑关闭页面功能
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    dataArray = [NSMutableArray arrayWithCapacity:0];
    
    [self initView];
    
    [self setupData];
    [self fetchPayModuleStatus];
    
}

-(void)initView{
    titleView = [[UIView alloc]initWithFrame:CGRectMake(0, UI_STATUS_BAR_HEIGHT, SCREEN_WIDTH, UI_NAVIGATION_BAR_HEIGHT)];
    titleView.backgroundColor = RGBACOLOR(0, 0, 0, 0.6);
    [self.view addSubview:titleView];

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 50, UI_NAVIGATION_BAR_HEIGHT);
    [backBtn setImage:[UIImage imageNamed:@"ic_back_white"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchDown];
    [titleView addSubview:backBtn];
    
    [SVProgressHUD showWithStatus:@"加载中..."];
}

-(void)setupData{
    if (_type==1) {
        [self fetchSectionVideoWithVideoRefresh:YES];
    }else{
        [self fetchCommodityVideoListWithVideoRefresh:YES];
    }
    
}

// 后台控制是否显示支付相关功能
-(void)fetchPayModuleStatus{
    PayManager *pm = [[PayManager alloc]init];
    [pm fetchPayModuleStatusSuccess:^(ThirdPayResult *result) {
        _thirdPay = result.thirdPay;
    } Failure:^(NSError *error) {
        
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
    [SVProgressHUD dismiss];
}

#pragma mark 加载视频播放控件
-(void)setupPlayerViewWithProgress:(NSString*)playProgress
{
    if (_bgView == nil) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, kVedioHeight)];
        _bgView.backgroundColor = [UIColor blackColor];
    }
    if ([_bgView isDescendantOfView:self.view] == NO) {
        [self.view addSubview:_bgView];
    }
    
    if (_myMediaPlayer != nil) {
        _myMediaPlayer = nil;
    }
    
//    if(self.localOrOnLine)
//    {
//        NSString* filePath = [_localModal stringDownloadPath];
//        if ([filePath hasPrefix:@"/var"]) {
//            NSRange range = [filePath rangeOfString:kVedioListPath];
//            if (range.location != NSNotFound && range.length) {
//                NSString* subPathString = [filePath substringFromIndex:range.location];
//                filePath = [kDocPath stringByAppendingString:subPathString];
//            }
//        }
//        else
//        {
//            filePath = [kDocPath stringByAppendingString:filePath];
//        }
//        filePath =[filePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        
//        _myMediaPlayer = [[SDMediaPlayerVC alloc] initLocalMyMediaPlayerWithURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@",kDocPath,_localModal.henhaoPath]] coverImageURL:_localModal.stringShowImageURL movieTitle:_localModal.stringVideoName videoId:_localModal.stringSourseId];
//        _myMediaPlayer.ECAPath = _localModal.henhaoPath;
//    }
//    else
//    {
        // 网络视频
        _myMediaPlayer = [[SDMediaPlayerVC alloc] initNetworkMyMediaPlayerWithURL:[NSURL URLWithString:_currentVideo.address] coverImageURL:@"" movieTitle:_currentVideo.name videoId:_currentVideo.videoId];
//    }
    _myMediaPlayer.fullScrenType = 1;//用于视频播放器的列表
    _myMediaPlayer.dataArray = dataArray;
    _myMediaPlayer.nomalFrame = CGRectMake(0, 0, SCREEN_WIDTH, kVedioHeight);
    _myMediaPlayer.cutFullModeFrame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
    _myMediaPlayer.delegate = self;
    _myMediaPlayer.datasource = self;
    _myMediaPlayer.historyPlayTime = playProgress;
    if ([_myMediaPlayer.view isDescendantOfView:_bgView] == NO) {
        [_bgView addSubview:_myMediaPlayer.view];
    }
    
    vidioFinishLoad = NO;
    // 监听视频加载状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti:) name:PlaybackIsPreparedToPlayDidChangeNotification  object:nil];
    // 监听返回按钮
    [self addVideoCutObserver];
    
    [self setupSegment];
    [self setupTableView];
    [self setupDetailView];
    [self setupPDFView];
    
}

-(void)noti:(NSNotification *)noty
{
    // 视频加载成功后允许页面跳转
    if ([noty.name isEqualToString:PlaybackIsPreparedToPlayDidChangeNotification])
    {
        vidioFinishLoad = YES;
    }
}


- (void)addVideoCutObserver
{
    [[NSNotificationCenter defaultCenter] addObserverForName:@"cutFullModeBtnClick" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification) {
        
        [self.view bringSubviewToFront:_bgView];
        _myMediaPlayer.isFullScreen = ! _myMediaPlayer.isFullScreen;
        if (_myMediaPlayer.isFullScreen) {
            _bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            [_myMediaPlayer adjustVideoWithOrientation:UIDeviceOrientationLandscapeLeft];
        }
        else {
            _bgView.frame = CGRectMake(0, 20, SCREEN_WIDTH, kVedioHeight);
            [_myMediaPlayer adjustVideoWithOrientation:UIDeviceOrientationPortrait];
        }
    }];
}

-(void)setupSegment{
    _segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(_myMediaPlayer.nomalFrame)+UI_STATUS_BAR_HEIGHT, SCREEN_WIDTH-60, GENERAL_SIZE(80))];
    if (_type==1) {
        _segmentedControl.sectionTitles = @[@"目录",@"讲义"];
    }else if(_type==2){
        _segmentedControl.sectionTitles = @[@"目录",@"详情",@"讲义"];
    }
    
    _segmentedControl.selectedSegmentIndex = 0;
    
    _segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : RGBCOLOR(81, 84, 93), NSFontAttributeName : LabelFont(32)};
    _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : COMMONBLUECOLOR, NSFontAttributeName: LabelFont(32)};
    _segmentedControl.selectionIndicatorColor = COMMONBLUECOLOR;
    _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
    _segmentedControl.selectionIndicatorHeight = 2;
    _segmentedControl.selectionIndicatorBoxOpacity = 0;
    
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentedControl.backgroundColor = [UIColor whiteColor];
    _segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    [self.view addSubview:_segmentedControl];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = RGBCOLOR(238, 238, 238);
    [self.view addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_segmentedControl.mas_bottom);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@1);
    }];
    
    __weak CourSectionViewController *weakSelf =self;
    [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
        _currentIndex = (int)index;
        if (index==0) {
            weakSelf.pdfView.hidden = YES;
            weakSelf.detailView.hidden = YES;
        }else{
            if(_type==1){
                weakSelf.pdfView.hidden = NO;
                [weakSelf.pdfView loadPDF:weakSelf.currentVideo];
            }else{
                if (index==1) {
                    weakSelf.pdfView.hidden = YES;
                    weakSelf.detailView.hidden = NO;
                }else if(index==2){
                    weakSelf.pdfView.hidden = NO;
                    weakSelf.detailView.hidden = YES;
                    [weakSelf.pdfView loadPDF:weakSelf.currentVideo];
                }
            }
            
        }
    }];
    
}

-(void)setupTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_segmentedControl.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(_segmentedControl.frame)-43) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [self setupBottomView];
}

-(void)setupDetailView{
    _detailView = [[CommodityView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_segmentedControl.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(_segmentedControl.frame))];
    [_detailView setupWithModel:_commodity];
    _detailView.backgroundColor = [UIColor whiteColor];
    _detailView.hidden = YES;
    [self.view addSubview:_detailView];
}

-(void)setupPDFView{
    _pdfView = [[PDFView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_segmentedControl.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(_segmentedControl.frame))];
    _pdfView.backgroundColor = [UIColor whiteColor];
    _pdfView.hidden = YES;
    _pdfView.delegate = self;
    [self.view addSubview:_pdfView];
}

#pragma MyMediaPlayerDelegate 播放器代理

-(void)movieQuickLogIn
{
    OLA_LOGIN;
}

-(void)backClicked
{
    [self.navigationController popViewControllerAnimated:YES];
    if (_myMediaPlayer) {
        [_myMediaPlayer popView];
        [_myMediaPlayer.view removeFromSuperview];
    }
    // 记录观看进度
    if ([AuthManager sharedInstance].isAuthenticated) {
        //[self recordPlayProgress];
    }
}

//记录已观看进度
-(void)recordPlayProgressWithTime:(NSInteger)duration{
    NSString *userId = [AuthManager sharedInstance].userInfo.userId;
    WatchRecordManager *wm = [[WatchRecordManager alloc]init];
    [wm recordPlayProgressWithUserId:userId ObjectId:_objectId Type:[NSString stringWithFormat:@"%d",_type] CurrentIndex:[NSString stringWithFormat:@"%ld",currentRow] Duration:[NSString stringWithFormat:@"%ld",duration] Success:^(CommonResult *result) {
        
    } Failure:^(NSError *error) {
        
    }];
}


-(void)didPlayeSelectRowAtIndexPathModal:(id)object viewController:(SDMediaPlayerVC *)PlayerVC indexPath:(NSIndexPath *)path{
    [self switchCurrentVideo:path];
}

#pragma MyMediaPlayerDataSource (上一个 下一个 方法 还需完善)

- (NSDictionary*)previousMovieURLAndTitleToTheCurrentMovie
{
    return nil;
}

-(NSDictionary*)nextMovieURLAndTitleToTheCurrentMovie{
    return nil;
}

- (BOOL)isHaveNextMovie
{
    return NO;
}

- (BOOL)isHavePreviousMovie
{
    return NO;
}

- (BOOL)allowPlay{
    return YES;
}

// 显示提示框
- (BOOL)shouldShowAlert{
    return YES;
}


-(void)setupBottomView{
    forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [forwardButton setImage:[UIImage imageNamed:@"ic_forward"] forState:UIControlStateNormal];
//    [forwardButton sizeToFit];
    [forwardButton addTarget:self action:@selector(forwardPlayVideo) forControlEvents:UIControlEventTouchDown];
    
    nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setImage:[UIImage imageNamed:@"iconfont-qianjin"] forState:UIControlStateNormal];
//    [nextButton sizeToFit];
    [nextButton addTarget:self action:@selector(nextPlayVideo) forControlEvents:UIControlEventTouchDown];
    
    downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [downloadButton setImage:[UIImage imageNamed:@"ic_downloaded"] forState:UIControlStateNormal];
    [downloadButton sizeToFit];
    [downloadButton addTarget:self action:@selector(downloadVideo) forControlEvents:UIControlEventTouchDown];
    
    collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if(isCollected){
        [collectionButton setImage:[UIImage imageNamed:@"ic_collected"] forState:UIControlStateNormal];
    }else{
        [collectionButton setImage:[UIImage imageNamed:@"ic_collect"] forState:UIControlStateNormal];
    }
    [collectionButton sizeToFit];
    [collectionButton addTarget:self action:@selector(collectCourse) forControlEvents:UIControlEventTouchDown];
    
    shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
    [shareButton sizeToFit];
    [shareButton addTarget:self action:@selector(shareCourse) forControlEvents:UIControlEventTouchDown];
    
    UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyButton setBackgroundColor:RGBCOLOR(255, 108, 0)];
    [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyButton sizeToFit];
    [buyButton addTarget:self action:@selector(buyCourse) forControlEvents:UIControlEventTouchDown];
    
    _operationView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-43, SCREEN_WIDTH, 43)];
    _operationView.backgroundColor = RGBCOLOR(250, 250, 250);
    [self.view addSubview:_operationView];
    
    // 精品课程未购买则显示购买按钮
    if(_type==2&&[_orderStatus isEqualToString:@"0"]&&![_commodity.price isEqualToString:@"0"]){
        priceL = [[UILabel alloc]init];
        priceL.textColor = RGBCOLOR(255, 108, 0);
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@ 已有%@人购买",_commodity.price,_commodity.paynum]];
        [str addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(153, 153, 153) range:NSMakeRange(_commodity.price.length+2,str.length-_commodity.price.length-2)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(_commodity.price.length+2,str.length-_commodity.price.length-2)];
        priceL.attributedText = str;
        [_operationView addSubview: priceL];
        
        [_operationView addSubview:buyButton];
        
        [buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_operationView);
            make.bottom.equalTo(_operationView.mas_bottom);
            make.right.equalTo(_operationView.mas_right);
            make.width.equalTo(@(GENERAL_SIZE(240)));
        }];
        
        [priceL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_operationView);
            make.bottom.equalTo(_operationView.mas_bottom);
            make.left.equalTo(_operationView).offset(GENERAL_SIZE(20));
            make.right.equalTo(buyButton.mas_left);
        }];
    }else{
        [_operationView addSubview:forwardButton];
        [_operationView addSubview:nextButton];
        [_operationView addSubview:downloadButton];
        [_operationView addSubview:collectionButton];
        [_operationView addSubview:shareButton];
        
        [forwardButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_operationView.mas_left).offset(20);
            make.centerY.equalTo(_operationView);
            make.height.width.mas_equalTo(@30);
        }];
        [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_operationView);
            make.left.equalTo(forwardButton.mas_right).offset(10);
            make.height.width.mas_equalTo(@30);
        }];
        [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_operationView.mas_right).offset(-20);
            make.centerY.equalTo(_operationView);
        }];
        
        [downloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_operationView);
            make.right.equalTo(shareButton.mas_left).offset(-30);
        }];
        
        [collectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(downloadButton.mas_left).offset(-30);
            make.centerY.equalTo(_operationView);
        }];
    }
}

/**
 *  获取课程下的所有章节视频
 */
-(void)fetchSectionVideoWithVideoRefresh:(BOOL)refresh{
    AuthManager *am = [AuthManager sharedInstance];
    NSString *userId = @"";
    if (am.isAuthenticated) {
        userId = am.userInfo.userId;
    }
    CourseManager *cm = [[CourseManager alloc]init];
    [cm fetchSectionVideoWithID:_objectId UserId:userId Success:^(VideoBoxResult *result) {
        [dataArray removeAllObjects];
        [dataArray addObjectsFromArray: result.videoBox.videoList];
        if ([result.videoBox.isCollect intValue]==1) {
            isCollected = YES;
        }

        if ([dataArray count]>0) {
            titleView.hidden  = YES;
            currentRow = result.videoBox.playIndex?[result.videoBox.playIndex integerValue]:0;
            _currentVideo = dataArray[currentRow];
            _currentVideo.isChosen = 1;
            [dataArray replaceObjectAtIndex:currentRow withObject:_currentVideo]; //当前正在播放的视频
            if (refresh) {
                [self setupPlayerViewWithProgress:result.videoBox.playProgress];
            }
        }
        [SVProgressHUD dismiss];
        [_tableView reloadData];
    } Failure:^(NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"数据加载失败"];
    }];
}
// 成套视频
-(void)fetchCommodityVideoListWithVideoRefresh:(BOOL)refresh{
    NSString *userId = @"";
    AuthManager *am = [AuthManager sharedInstance];
    if (am.isAuthenticated) {
        userId = am.userInfo.userId;
    }
    CommodityManager *cm = [[CommodityManager alloc]init];
    [cm fetchCommodityVideoListWithGoodsId:_objectId UserId:userId Success:^(VideoListResult *result) {
        if (result.isCollect==1) {
            isCollected = YES;
        }
        [dataArray removeAllObjects];
        [dataArray addObjectsFromArray: result.videoList];
        if ([dataArray count]>0) {
            titleView.hidden  = YES;
            _orderStatus = result.orderStatus;
            currentRow = result.playIndex?[result.playIndex integerValue]:0;
            _currentVideo = dataArray[currentRow];
            _currentVideo.isChosen = 1;
            [dataArray replaceObjectAtIndex:currentRow withObject:_currentVideo]; //当前正在播放的视频
            [self setupPlayerViewWithProgress:result.playProgress];
        }
        [SVProgressHUD dismiss];
        [_tableView reloadData];
    } Failure:^(NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"数据加载失败"];
    }];
}

-(void)buyCourse{
    if (!vidioFinishLoad) { //视频未加载完成，不允许跳转
        return;
    }
    [_myMediaPlayer pause];
    CommodityPayVC *payVC = [[CommodityPayVC alloc]init];
    payVC.commodity = _commodity;
    [self.navigationController pushViewController:payVC animated:YES];
}
//切换上一个视频
-(void)forwardPlayVideo {
    NSLog(@"%s",__func__);
    //切换视频
//    [self switchCurrentVideo:lastIndexPath];
}
//切换下一个视频
-(void)nextPlayVideo {
    NSLog(@"%s",__func__);
    //切换视频
//    [self switchCurrentVideo:lastIndexPath];
}

-(void)collectCourse{
    AuthManager *am = [AuthManager sharedInstance];
    if (!am.isAuthenticated) {
        return;
    }
    if (_objectId) {
        CourseManager *cm = [[CourseManager alloc]init];
        int state = isCollected?0:1;
        [cm addVideoToCollectionWithUserId:am.userInfo.userId VideoId:_currentVideo.videoId CourseId: _objectId State:[NSString stringWithFormat:@"%d",state] Type:[NSString stringWithFormat:@"%d", _type] Success:^(CommonResult *result)  {
            if (isCollected) {
                isCollected = NO;
                [collectionButton setImage:[UIImage imageNamed:@"ic_collect"] forState:UIControlStateNormal];
            }else{
                isCollected = YES;
                [collectionButton setImage:[UIImage imageNamed:@"ic_collected"] forState:UIControlStateNormal];
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:@"NEEDREFRESH" object:nil];
            
        } Failure:^(NSError *error) {
            
        }];
    }
}

-(void)downloadVideo{
    AuthManager *am = [AuthManager sharedInstance];
    if (!am.isAuthenticated) {
        [self showLoginView];
        return;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger type = [defaults integerForKey:@"download_type"];
    if ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == NotReachable &&type==1){
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否设置允许使用移动数据下载？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        alertView.tag = 1001;
        [alertView show];
        return;
    }
    
    //正在下载视频
    NSMutableArray *LoadingArray = [[DownloadManager sharedDownloadManager]arrayDownLoadSessionModals];
    //本地视频
    NSMutableArray *LoactionArray = [[DownloadManager sharedDownloadManager]arrayDownLoadedSessionModals];
    for(DownloadModal *loadmodal in LoadingArray)
    {
        if([_currentVideo.videoId isEqualToString:loadmodal.stringSourseId])
        {
            [self loadPromptImage];//添加加入队列提示
            return;
        }
    }
    for(DownloadModal *loaction in LoactionArray)
    {
        if([_currentVideo.videoId isEqualToString: loaction.stringSourseId])
        {
            
            [self loadPromptImage];//添加加入队列提示框
            
            return;
        }
    }
    
    DownloadModal  *downloadModal = [[DownloadModal alloc]init];
    downloadModal.stringVideoName = _currentVideo.name;//标题的名字
    downloadModal.stringShowImageURL = _currentVideo.pic;//图片头像
    downloadModal.stringDownloadURL = _currentVideo.address;//下载地址
    downloadModal.stringCustomId = am.userInfo.userId;//账号id
    downloadModal.stringSourseId = _currentVideo.videoId;//视频id
    downloadModal.stringPlayTime = _currentVideo.timeSpan; //视频播放时长
    //downloadModal.stringVideoAuthor = _currentVideo.playCount;//观看次数
    [downloadModal setStringTotalSize: _currentVideo.content];//视频大小
    [[DownloadManager sharedDownloadManager]addDownloadTask: downloadModal];//添加下载队列
    [self loadPromptImage];//添加加入队列提示框
}

-(void)shareCourse{
    if (!vidioFinishLoad) { //视频未加载完成，不允许跳转
        return;
    }
    
    NSArray *shareButtonTitleArray = [[NSArray alloc] init];
    NSArray *shareButtonImageNameArray = [[NSArray alloc] init];
    
    shareButtonTitleArray = @[@"微信好友",@"微信朋友圈",@"新浪微博",@"QQ好友",@"QQ空间"];
    shareButtonImageNameArray = @[@"wechat",@"wetimeline",@"sina",@"qq",@"qzone"];
    
    ShareSheetView *lxActivity = [[ShareSheetView alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" ShareButtonTitles:shareButtonTitleArray withShareButtonImagesName:shareButtonImageNameArray];
    [lxActivity showInView:self.view];
}

//点击下载时弹出提示框
-(void)loadPromptImage
{
    UIAlertView *AlertView = [[UIAlertView alloc]initWithTitle:@"加入队列" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [AlertView show];
}

#pragma talbeview delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataArray count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CourSectionTableCell *cell = [[CourSectionTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sectionCell"];
    CourseVideo *videoInfo = [dataArray objectAtIndex:indexPath.row];
    [cell setCellWithModel:videoInfo];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    lastIndexPath = indexPath;
    [self switchCurrentVideo:indexPath];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return GENERAL_SIZE(100);
}

// 切换视频
-(void)switchCurrentVideo:(NSIndexPath *)indexPath{
    if (indexPath.row==currentRow) {
        return;
    }
    CourseVideo *videoInfo = [dataArray objectAtIndex:indexPath.row];
    if(videoInfo.isfree==1){
        if (!vidioFinishLoad) { //上一个视频加载中不允许切换
            return;
        }
        _currentVideo.isChosen = 0; //取消上一个的选中效果
        [dataArray replaceObjectAtIndex:currentRow withObject:_currentVideo];
        
        CourseVideo *videoInfo = [dataArray objectAtIndex:indexPath.row];
        currentRow = indexPath.row;
        _currentVideo = videoInfo;
        _currentVideo.isChosen = 1;
        [dataArray replaceObjectAtIndex:indexPath.row withObject:_currentVideo]; //当前正在播放的视频
        _myMediaPlayer.dataArray = dataArray;
        [_tableView reloadData];
        if (videoInfo.address) {
            [_myMediaPlayer changeVedioByURL:videoInfo.address coverImageURL:@"" vedioTitle:videoInfo.name videoId:videoInfo.videoId];
        }
    }else{
        AuthManager *am = [AuthManager sharedInstance];
        if(!am.isAuthenticated)
        {
            [self showLoginView];
            return;
        };
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"购买后即可拥有" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"去购买",nil];
        alert.tag = 1002;
        [alert show];
    }
}

#pragma alertview delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        if (alertView.tag == 1001) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:2 forKey:@"download_type"];
            [self downloadVideo];
        }else if (alertView.tag == 1002||alertView.tag == 1003) {
            if(alertView.tag == 1003||_type==1){
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                if ([_thirdPay.version isEqualToString:[infoDictionary objectForKey:@"CFBundleShortVersionString"]]&&[_thirdPay.thirdPay isEqualToString:@"0"]){
                    IAPVIPController *iapVC =[[IAPVIPController alloc]init];
                    iapVC.callbackBlock = ^{
                        [self fetchSectionVideoWithVideoRefresh:NO];
                    };
                    iapVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:iapVC animated:YES];
                }else{
                    VIPSubController *vipVC =[[VIPSubController alloc]init];
                    vipVC.callbackBlock = ^{
                        [self fetchSectionVideoWithVideoRefresh:NO];
                    };
                    vipVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vipVC animated:YES];
                }
            }else{
                CommodityPayVC *payVC = [[CommodityPayVC alloc]init];
                payVC.commodity = _commodity;
                [self.navigationController pushViewController:payVC animated:YES];
            }
        }
    }
}

-(void)showLoginView{
    [_myMediaPlayer pause];
    LoginViewController* loginViewCon = [[LoginViewController alloc] init];
    loginViewCon.successFunc = ^{
        if (_type==1) {
            [self fetchSectionVideoWithVideoRefresh:NO];
        }else{
            [self fetchCommodityVideoListWithVideoRefresh:NO];
        }
    };
    UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:loginViewCon];
    [self presentViewController:rootNav animated:YES completion:^{}
     ];
}

#pragma PDFView delegate
-(void)didClickSendMail:(CourseVideo *)video{
    [_myMediaPlayer pause];
    
    AuthManager *am = [AuthManager sharedInstance];
    if(!am.isAuthenticated)
    {
        [self showLoginView];
        return;
    }
    if([am.userInfo.vipTime isEqualToString:@"0"]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"仅限会员下载" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"去购买",nil];
        alert.tag = 1003;
        [alert show];
        return;
    }
    [self sendMailInApp:video];
}

#pragma  发送邮件 以及 代理
#pragma mark - 在应用内发送邮件
//激活邮件功能
- (void)sendMailInApp:(CourseVideo *)video
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (!mailClass) {
        //[self alertWithMessage:@"当前系统版本不支持应用内发送邮件功能，您可以使用mailto方法代替"];
        return;
    }
    if (![mailClass canSendMail]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请先在设置中配置您的邮箱，再进行分享。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        alert.tag = 1003;
        [alert show];
        return;
    }
    [self displayMailPicker:video];
}

//调出邮件发送窗口
- (void)displayMailPicker:(CourseVideo *)video
{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    mailPicker.mailComposeDelegate = self;
    
    [mailPicker setSubject: @"欧拉学院讲义"];
    //添加收件人
    //NSArray *toRecipients = [NSArray arrayWithObject: @"forevertxp@gmail.com"];
    //[mailPicker setToRecipients: toRecipients];
    
    //NSString *emailBody = @"<h6><hr id='ht'></h6><div><sup>欧拉学院</sup></div><div><sup>北京市海淀区清华科技园清华x-lab</sup></div><div><sup>我们的征途是星辰和大海！</sup></div>";
    //[mailPicker setMessageBody:emailBody isHTML:YES];
    
    //添加pdf附件
    NSString *fileName = [NSString stringWithFormat:@"%@.pdf",video.attachmentId];
    NSString* filepath = [[kDocPath stringByAppendingString:kPDFDataPath] stringByAppendingPathComponent:fileName];
    NSData *pdf = [NSData dataWithContentsOfFile:filepath];
    [mailPicker addAttachmentData:pdf mimeType:@"" fileName:video.name];

    [self presentViewController: mailPicker animated:YES completion:nil];
}

#pragma mark - 实现 MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    //关闭邮件发送窗口
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString *msg;
    switch (result) {
        case MFMailComposeResultCancelled:
            msg = @"发送已取消";
            break;
        case MFMailComposeResultSaved:
            msg = @"成功保存邮件";
            break;
        case MFMailComposeResultSent:
            msg = @"邮件已发送";
            break;
        case MFMailComposeResultFailed:
            msg = @"保存或者发送邮件失败";
            break;
    }
    [SVProgressHUD showInfoWithStatus:msg];
}

#pragma mark - LXActivityDelegate

- (void)didClickOnImageIndex:(NSInteger)imageIndex
{
    UIImage *image = [UIImage imageNamed:@"ic_logo"];
    NSString *content = _currentVideo.name;
    NSString *url = [NSString stringWithFormat: @"http://api.olaxueyuan.com/course.html?courseId=%@",_objectId];
    
    switch((int)imageIndex){
        case 0:
            [UMSocialData defaultData].extConfig.wechatSessionData.title = @"欧拉MBA";
            [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:content image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                }
            }];
            break;
        case 1:
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"欧拉MBA";
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:content image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                }
            }];
            break;
        case 2:
            [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeWeb url:url];
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:content image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                }
            }];
            break;
        case 3:
            [UMSocialData defaultData].extConfig.qqData.title = @"欧拉MBA";
            [UMSocialData defaultData].extConfig.qqData.url =url;
            [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:content image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                }
            }];
            break;
        case 4:
            // QQ空间分享只支持图文分享（图片文字缺一不可）
            [UMSocialData defaultData].extConfig.qzoneData.title = @"欧拉MBA";
            [UMSocialData defaultData].extConfig.qzoneData.url = url;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:content image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                }
            }];
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
