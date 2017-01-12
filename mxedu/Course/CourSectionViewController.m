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
#import "PlayerManager.h"

#import "Masonry.h"
#import "CourSectionTableCell.h"
#import "LoginViewController.h"
#import "CourBuyViewController.h"
#import "CommodityPayVC.h"
#import "IAPVIPController.h"

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "Reachability.h"
#import "ShareSheetView.h"

#import "DownloadModal.h"
#import "DownloadManager.h"

#import "PayManager.h"

@interface CourSectionViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,ShareSheetDelegate,UMSocialUIDelegate>

@property (nonatomic) UIView *playView;

@property (nonatomic) int payStatus; //0 iap支付 1 支付宝 微信支付

@end

@implementation CourSectionViewController{
    
    UITableView *_tableView;
    
    UIButton *collectionButton;
    UIButton *downloadButton;
    UIButton *shareButton;
    
    UIView *playerView;
    UIView *operationView;
    
    /**
     *  数据源
     */
    NSMutableArray *dataArray;
    
    BOOL isCollected;
    
    CourseVideo *currentVideo;
    NSInteger currentRow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    dataArray = [NSMutableArray arrayWithCapacity:0];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SCREEN_WIDTH*9/16, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_WIDTH*9/16-43) style:UITableViewStylePlain];
    _tableView.backgroundColor = RGBCOLOR(240, 240, 240);
    _tableView.separatorStyle = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [self setupBottomView];
    
    [self setupData];
    [self fetchPayModuleStatus];
    
    [self.view bringSubviewToFront:_playView];
    
    //返回按钮监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti:) name:UCloudMoviePlayerClickBack object:nil];
    
}

-(void)setupData{
    if (_type==1) {
        [self fetchSectionVideo];
    }else{
        [self fetchCommodityVideoList];
        [self fetchCommodityStatus];
    }
    
}

// 后台控制是否显示支付相关功能
-(void)fetchPayModuleStatus{
    PayManager *pm = [[PayManager alloc]init];
    [pm fetchPayModuleStatusSuccess:^(StatusResult *result) {
        _payStatus = result.status;
    } Failure:^(NSError *error) {
        
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)setupPlayerView{
    _playView = [[UIView alloc]initWithFrame:CGRectMake(0, UI_STATUS_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_WIDTH*9.0/16.0)];
    [self.view addSubview:_playView];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    delegate.vc = self;
    
    [self playWithUrl:currentVideo.address];
    
    // 程序退到后台监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification object:nil];
}

-(void)playWithUrl:(NSString*)url{
    if (self.player) {
        [self.player.player.player pause];
        [self.player.player.player shutdown];
        self.player = nil;
    }
    self.player = [[PlayerManager alloc] init];
    self.player.view = _playView;
    self.player.viewContorller = self;
    
    [self.player setSupportAutomaticRotation:YES];
    [self.player setSupportAngleChange:YES];
    
    NSString *path = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.player buildPlayer:path];
}

- (void)noti:(NSNotification *)noti
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if ([noti.name isEqualToString:UCloudMoviePlayerClickBack])
    {
        /**
         *  一定要置空
         */
        self.player = nil;
        
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        delegate.vc = nil;
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)applicationWillResignActive{
    // 暂停
    [self.player.player.player pause];
}

/**
 *  以下方法必须实现
 */
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (self.player)
    {
        return self.player.supportInterOrtation;
    }
    else
    {
        /**
         *  这个在播放之外的程序支持的设备方向
         */
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.player rotateEnd];
    
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.player rotateBegain:toInterfaceOrientation];
}


-(void)setupBottomView{
    downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [downloadButton setImage:[UIImage imageNamed:@"ic_downloaded"] forState:UIControlStateNormal];
    [downloadButton sizeToFit];
    [downloadButton addTarget:self action:@selector(downloadVideo) forControlEvents:UIControlEventTouchDown];
    
    collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [collectionButton setImage:[UIImage imageNamed:@"ic_collect"] forState:UIControlStateNormal];
    [collectionButton sizeToFit];
    [collectionButton addTarget:self action:@selector(collectCourse) forControlEvents:UIControlEventTouchDown];
    
    shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
    [shareButton sizeToFit];
    [shareButton addTarget:self action:@selector(shareCourse) forControlEvents:UIControlEventTouchDown];
    
    UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyButton setBackgroundImage:[UIImage imageNamed:@"btn_buy"] forState:UIControlStateNormal];
    [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyButton sizeToFit];
    [buyButton addTarget:self action:@selector(buyCourse) forControlEvents:UIControlEventTouchDown];
    
    operationView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-43, SCREEN_WIDTH, 43)];
    operationView.backgroundColor = RGBCOLOR(250, 250, 250);
    [self.view addSubview:operationView];
    
    if (_type==1) {
        [operationView addSubview:downloadButton];
        [operationView addSubview:collectionButton];
        [operationView addSubview:shareButton];
        
        [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(operationView.mas_right).offset(-20);
            make.centerY.equalTo(operationView);
        }];
        
        [downloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(operationView);
            make.right.equalTo(shareButton.mas_left).offset(-20);
        }];
        
        [collectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(downloadButton.mas_left).offset(-20);
            make.centerY.equalTo(operationView);
        }];
    }else{
        [operationView addSubview:buyButton];
        operationView.hidden = YES;
        _tableView.frame = CGRectMake(0, SCREEN_WIDTH*9/16, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_WIDTH*9/16);
        
        [buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(operationView);
            make.right.equalTo(operationView.mas_right).offset(-10);
        }];
    }
}

-(void)fetchCommodityStatus{
    CommodityManager *cm = [[CommodityManager alloc]init];
    AuthManager *am = [[AuthManager alloc]init];
    if (am.isAuthenticated) {
        [cm fetchCommodityStautsWithGoodsId:_objectId UserId:am.userInfo.userId Success:^(StatusResult *result) {
            if (result.status==1||[_commodity.price isEqualToString:@"0"]) {
                operationView.hidden = YES;
                _tableView.frame = CGRectMake(0, SCREEN_WIDTH*9/16, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_WIDTH*9/16);
            }else{
                operationView.hidden = NO;
                _tableView.frame = CGRectMake(0, SCREEN_WIDTH*9/16, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_WIDTH*9/16-43);
            }
        } Failure:^(NSError *error) {
            
        }];
    }
}

/**
 *  获取课程下的所有章节视频
 */
-(void)fetchSectionVideo{
    AuthManager *am = [[AuthManager alloc]init];
    NSString *userId = @"";
    if (am.isAuthenticated) {
        userId = am.userInfo.userId;
    }
    CourseManager *cm = [[CourseManager alloc]init];
    [cm fetchSectionVideoWithID:_objectId UserId:userId Success:^(VideoBoxResult *result) {
        [dataArray removeAllObjects];
        [dataArray addObjectsFromArray: result.videoBox.videoList];
        if ([result.videoBox.isCollect intValue]==1) {
            [collectionButton setImage:[UIImage imageNamed:@"ic_collected"] forState:UIControlStateNormal];
            isCollected = YES;
        }

        if ([dataArray count]>0) {
            currentRow = 0;
            currentVideo = dataArray[0];
            currentVideo.isChosen = 1;
            [dataArray replaceObjectAtIndex:0 withObject:currentVideo]; //当前正在播放的视频
            [self setupPlayerView];
        }else{
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }
        [_tableView reloadData];
    } Failure:^(NSError *error) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }];
}
// 成套视频
-(void)fetchCommodityVideoList{
    NSString *userId = @"";
    AuthManager *am = [[AuthManager alloc]init];
    if (am.isAuthenticated) {
        userId = am.userInfo.userId;
    }
    CommodityManager *cm = [[CommodityManager alloc]init];
    [cm fetchCommodityVideoListWithGoodsId:_objectId UserId:userId Success:^(VideoListResult *result) {
        [dataArray removeAllObjects];
        [dataArray addObjectsFromArray: result.videoList];
        if ([dataArray count]>0) {
            currentRow = 0;
            currentVideo = dataArray[0];
            currentVideo.isChosen = 1;
            [dataArray replaceObjectAtIndex:0 withObject:currentVideo]; //当前正在播放的视频
            [self setupPlayerView];
        }else{
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }
        [_tableView reloadData];
    } Failure:^(NSError *error) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }];
}

-(void)buyCourse{
    if (!_player.isPrepared) { //视频未加载完成，不允许跳转
        return;
    }
    // 暂停
    [self.player.player.player pause];

    CourBuyViewController *buyVC = [[CourBuyViewController alloc]init];
    buyVC.commodity = _commodity;
    [self.navigationController pushViewController:buyVC animated:YES];
}

-(void)collectCourse{
    AuthManager *am = [[AuthManager alloc]init];
    if (!am.isAuthenticated) {
        return;
    }
    if (_objectId) {
        CourseManager *cm = [[CourseManager alloc]init];
        int type = isCollected?0:1;
        [cm addVideoToCollectionWithUserId:am.userInfo.userId VideoId:currentVideo.videoId CourseId: _objectId State:[NSString stringWithFormat:@"%d",type] Success:^(CommonResult *result)  {
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
    AuthManager *am = [[AuthManager alloc]init];
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
        if([currentVideo.videoId isEqualToString:loadmodal.stringSourseId])
        {
            [self loadPromptImage];//添加加入队列提示
            return;
        }
    }
    for(DownloadModal *loaction in LoactionArray)
    {
        if([currentVideo.videoId isEqualToString: loaction.stringSourseId])
        {
            
            [self loadPromptImage];//添加加入队列提示框
            
            return;
        }
    }
    
    DownloadModal  *downloadModal = [[DownloadModal alloc]init];
    downloadModal.stringVideoName = currentVideo.name;//标题的名字
    downloadModal.stringShowImageURL = currentVideo.pic;//图片头像
    downloadModal.stringDownloadURL = currentVideo.address;//下载地址
    downloadModal.stringCustomId = am.userInfo.userId;//账号id
    downloadModal.stringSourseId = currentVideo.videoId;//视频id
    downloadModal.stringPlayTime = currentVideo.timeSpan; //视频播放时长
    //downloadModal.stringVideoAuthor = currentVideo.playCount;//观看次数
    [downloadModal setStringTotalSize: currentVideo.content];//视频大小
    [[DownloadManager sharedDownloadManager]addDownloadTask: downloadModal];//添加下载队列
    [self loadPromptImage];//添加加入队列提示框
}

-(void)shareCourse{
    if (!_player.isPrepared) { //视频未加载完成，不允许跳转
        return;
    }
    // 暂停
    [self.player.player.player pause];
    
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
    if (indexPath.row==currentRow) {
        return;
    }
    CourseVideo *videoInfo = [dataArray objectAtIndex:indexPath.row];
    if(videoInfo.isfree==1){
        if (!_player.isPrepared) { //上一个视频加载中不允许切换
            return;
        }
        currentVideo.isChosen = 0; //取消上一个的选中效果
        [dataArray replaceObjectAtIndex:currentRow withObject:currentVideo];
        
        CourseVideo *videoInfo = [dataArray objectAtIndex:indexPath.row];
        currentRow = indexPath.row;
        currentVideo = videoInfo;
        currentVideo.isChosen = 1;
        [dataArray replaceObjectAtIndex:indexPath.row withObject:currentVideo]; //当前正在播放的视频
        [tableView reloadData];
        if (videoInfo.address) {
            [self playWithUrl:videoInfo.address];
        }
    }else{
        AuthManager *am =[[AuthManager alloc]init];
        if(!am.isAuthenticated)
        {
            [self showLoginView];
            return;
        };
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"友情提示" message:@"购买后即可拥有" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"去购买",nil];
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
        }else if (alertView.tag == 1002) {
            [self.player.player.player pause];
            if(_type==1){
                if (_payStatus==0) {
                    IAPVIPController *iapVC =[[IAPVIPController alloc]init];
                    iapVC.isSingleView = 1;
                    iapVC.callbackBlock = ^{
                        [self fetchSectionVideo];
                    };
                    iapVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:iapVC animated:YES];
                }else{
                    VIPSubController *vipVC =[[VIPSubController alloc]init];
                    vipVC.isSingleView = 1;
                    vipVC.callbackBlock = ^{
                        [self fetchSectionVideo];
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
    [self.player.player.player pause];
    LoginViewController* loginViewCon = [[LoginViewController alloc] init];
    loginViewCon.successFunc = ^{
        if (_type==1) {
            [self fetchSectionVideo];
        }else{
            [self fetchCommodityVideoList];
        }
    };
    UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:loginViewCon];
    [self presentViewController:rootNav animated:YES completion:^{}
     ];
}

#pragma mark - LXActivityDelegate

- (void)didClickOnImageIndex:(NSInteger *)imageIndex
{
    UIImage *image = [UIImage imageNamed:@"ic_logo"];
    NSString *content = currentVideo.name;
    NSString *url = [NSString stringWithFormat: @"http://api.olaxueyuan.com/course.html?courseId=%@",_objectId];
    
    switch((int)imageIndex){
        case 0:
            [UMSocialData defaultData].extConfig.wechatSessionData.title = @"欧拉联考";
            [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:content image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                }
            }];
            break;
        case 1:
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"欧拉联考";
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
            [UMSocialData defaultData].extConfig.qqData.title = @"欧拉联考";
            [UMSocialData defaultData].extConfig.qqData.url =url;
            [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:content image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                }
            }];
            break;
        case 4:
            // QQ空间分享只支持图文分享（图片文字缺一不可）
            [UMSocialData defaultData].extConfig.qzoneData.title = @"欧拉联考";
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
