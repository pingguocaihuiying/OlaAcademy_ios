//
//  SettingViewController.m
//  mxedu
//
//  Created by 田晓鹏 on 15/11/25.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import "SettingViewController.h"

#import <RETableViewManager.h>
#import "ShareSheetView.h"
#import "UMSocial.h"
#import "SysCommon.h"
#import "Masonry.h"

#import "AuthManager.h"
#import "ForgetPassViewController.h"
#import "AboutViewController.h"

#import <SDImageCache.h>

#define DOWNLOADT_TYPE @"download_type"

@interface SettingViewController ()<RETableViewManagerDelegate,ShareSheetDelegate,UMSocialUIDelegate,UIActionSheetDelegate>

@property (strong, readwrite, nonatomic) RETableViewManager *manager;
@property (assign, nonatomic) int tapIndex;

@end

@implementation SettingViewController

{
    UILabel *cacheSizeLabel;
    UILabel *downloadTypeLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackButton];
    self.view.backgroundColor = [UIColor whiteColor];

    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
    
    [self setupVersionSection];
    [self setupClearSection];
    [self setupDownloadSection];
    [self setupRecommendection];
    [self setupEvaluationSection];
    [self setupAboutSection];
    
    if ([[AuthManager alloc]init].isAuthenticated) {
        [self setupLogout];
    }
}

- (void)setupBackButton
{
    self.title = @"设置";
    self.navigationController.navigationBar.translucent = NO;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"ic_back_white"] forState:UIControlStateNormal];
    [backBtn sizeToFit];
    [backBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

-(void)backButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupVersionSection{
    UIView *dividerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 35)];
    label.textColor = RGBCOLOR(128, 128, 128);
    label.text = @"版本";
    dividerView.backgroundColor = RGBCOLOR(230, 230, 230);
    [dividerView addSubview:label];
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-150, 10, 135, 20)];
    versionLabel.textColor = RGBCOLOR(128, 128, 128);
    versionLabel.textAlignment=NSTextAlignmentRight;
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    versionLabel.text = [NSString stringWithFormat:@"V %@",[infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    [dividerView addSubview:versionLabel];
    
    RETableViewSection* section = [RETableViewSection sectionWithHeaderView:dividerView];
    
    RETableViewItem *titleAndImageItem = [RETableViewItem itemWithTitle:@"修改密码" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        ForgetPassViewController *passVC = [[ForgetPassViewController alloc]init];
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSData* data = [defaults objectForKey:@"LoginInfo"];
        NSDictionary *loginInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSString *mobile = [loginInfo objectForKey:@"mobile"];
        if (![mobile isEqualToString:@""]) {
            passVC.phoneNumber = mobile;
            passVC.isFromIndex = NO;
        }
        [self.navigationController pushViewController:passVC animated:YES];
    }];
    //titleAndImageItem.image = [UIImage imageNamed:@"ic_pass"];
    //titleAndImageItem.highlightedImage = [UIImage imageNamed:@"ic_pass"];
    [section addItem:titleAndImageItem];
    
    [self.manager addSection:section];
}

-(void)setupClearSection{
    UIView *dividerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 35)];
    label.textColor = RGBCOLOR(128, 128, 128);
    label.text = @"通用";
    dividerView.backgroundColor = RGBCOLOR(230, 230, 230);
    [dividerView addSubview:label];

    NSInteger cacheSize = [[SDImageCache sharedImageCache] getSize];
    NSString *cacheText = @"0.0";
    if(cacheSize >=1024&&cacheSize<1048576){
        cacheText = [NSString stringWithFormat:@"%ldKB",cacheSize/1024];
    }else if(cacheSize>=1048576){
        cacheText = [NSString stringWithFormat:@"%ldMB",cacheSize/1048576];
    }
    
    UIView *avatarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    UILabel *cacheLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 100, 30)];
    cacheLabel.textColor=[UIColor blackColor];
    cacheLabel.font=[UIFont systemFontOfSize:17];
    cacheSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-150, 10, 135, 20)];
    cacheSizeLabel.textColor=[UIColor grayColor];
    cacheSizeLabel.text = cacheText;
    cacheSizeLabel.font=[UIFont systemFontOfSize:15];
    cacheSizeLabel.textAlignment=NSTextAlignmentRight;
    cacheLabel.text = @"清除缓存";
    [avatarView addSubview:cacheLabel];
    [avatarView addSubview:cacheSizeLabel];
    avatarView.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearTmpPics)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [avatarView addGestureRecognizer:singleRecognizer];
    RETableViewSection* section = [RETableViewSection sectionWithHeaderView:dividerView footerView:avatarView];
    [_manager addSection:section];
    
}

-(void)setupDownloadSection{
    UIView *dividerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    dividerView.backgroundColor = RGBCOLOR(230, 230, 230);
    
    UIView *downloadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    UILabel *cacheLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 100, 30)];
    cacheLabel.textColor=[UIColor blackColor];
    cacheLabel.font=[UIFont systemFontOfSize:17];
    downloadTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-150, 10, 135, 20)];
    downloadTypeLabel.textColor=[UIColor grayColor];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger type = [defaults integerForKey:DOWNLOADT_TYPE];
    if (type==1) {
        downloadTypeLabel.text = @"仅WIFI";
    }else {
        downloadTypeLabel.text = @"移动数据和WIFI";
    }

    
    downloadTypeLabel.font=[UIFont systemFontOfSize:15];
    downloadTypeLabel.textAlignment=NSTextAlignmentRight;
    cacheLabel.text = @"下载类型";
    [downloadView addSubview:cacheLabel];
    [downloadView addSubview:downloadTypeLabel];
    downloadView.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOperatinView)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [downloadView addGestureRecognizer:singleRecognizer];
    RETableViewSection* section = [RETableViewSection sectionWithHeaderView:dividerView footerView:downloadView];
    [_manager addSection:section];
    
}

-(void)setupRecommendection{
    UIView *dividerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 35)];
    label.textColor = RGBCOLOR(128, 128, 128);
    label.text = @"更多";
    dividerView.backgroundColor = RGBCOLOR(230, 230, 230);
    [dividerView addSubview:label];
    RETableViewSection* section = [RETableViewSection sectionWithHeaderView:dividerView];
    
    RETableViewItem *titleAndImageItem = [RETableViewItem itemWithTitle:@"推荐给好友" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [self showShareSheet];
    }];
    //titleAndImageItem.image = [UIImage imageNamed:@"ic_recommend"];
    //titleAndImageItem.highlightedImage = [UIImage imageNamed:@"ic_recommend"];
    [section addItem:titleAndImageItem];
    
    [self.manager addSection:section];
}

-(void)setupEvaluationSection{
    RETableViewSection* section = [RETableViewSection sectionWithHeaderView:nil];
    
    RETableViewItem *titleAndImageItem = [RETableViewItem itemWithTitle:@"去评分" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        int appId = 1116458689;
        NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%d",appId];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }];
    //titleAndImageItem.image = [UIImage imageNamed:@"ic_evaluation"];
    //titleAndImageItem.highlightedImage = [UIImage imageNamed:@"ic_evaluation"];
    [section addItem:titleAndImageItem];
    
    [self.manager addSection:section];
}

-(void)setupAboutSection{
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:nil];
    
    RETableViewItem *titleAndImageItem = [RETableViewItem itemWithTitle:@"关于欧拉联考" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        AboutViewController *aboutVC = [[AboutViewController alloc]init];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }];
    //titleAndImageItem.image = [UIImage imageNamed:@"ic_introduction"];
    //titleAndImageItem.highlightedImage = [UIImage imageNamed:@"ic_introduction"];
    [section addItem:titleAndImageItem];
    
    [self.manager addSection:section];
}

-(void)setupLogout{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutBtn.frame =  CGRectMake(20, 60, SCREEN_WIDTH-40, 40);
    [logoutBtn setBackgroundImage:[UIImage imageNamed:@"btn_logout"] forState:UIControlStateNormal];
    [logoutBtn setTitle:@"退出登陆" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchDown];
    [footerView addSubview:logoutBtn];
    
    self.tableView.tableFooterView = footerView;
}

#pragma 设置下载类型

-(void)showOperatinView{
    NSString *item1 = @"仅WIFI";
    NSString *item2 = @"移动数据和WIFI";
    NSString *cancelTitle = @"取消";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:item1, item2, nil];
    
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    switch (buttonIndex) {
        case 0:
            downloadTypeLabel.text = @"仅WIFI";
            [defaults setInteger:1 forKey:DOWNLOADT_TYPE];
            break;
        case 1:
            downloadTypeLabel.text = @"移动数据和WIFI";
            [defaults setInteger:2 forKey:DOWNLOADT_TYPE];
            break;
            
        default:
            break;
    }
}

#pragma 清理缓存图片

- (void)clearTmpPics
{
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];//可有可无
    
    NSInteger cacheSize = [[SDImageCache sharedImageCache] getSize];
    cacheSizeLabel.text = [NSString stringWithFormat:@"%ld",cacheSize];
}


#pragma method
- (void)showShareSheet{
    
    NSArray *shareButtonTitleArray = [[NSArray alloc] init];
    NSArray *shareButtonImageNameArray = [[NSArray alloc] init];
    
    if (self.tapIndex == 0) {
        shareButtonTitleArray = @[@"微信好友",@"微信朋友圈",@"新浪微博",@"QQ好友",@"QQ空间"];
        shareButtonImageNameArray = @[@"wechat",@"wetimeline",@"sina",@"qq",@"qzone"];
    }
    ShareSheetView *lxActivity = [[ShareSheetView alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" ShareButtonTitles:shareButtonTitleArray withShareButtonImagesName:shareButtonImageNameArray];
    [lxActivity showInView:self.view];
}

-(void)logout{
    AuthManager *authManager = [[AuthManager alloc]init];
    [authManager logoutSuccess:^{
        if (_logoutSuccess) {
            _logoutSuccess();
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - LXActivityDelegate

- (void)didClickOnImageIndex:(NSInteger *)imageIndex
{
    UIImage *image = [UIImage imageNamed:@"ic_logo"];
    NSString *content = @"欧拉联考——中国最权威的管理类联考学习平台";
    NSString *url = [NSString stringWithFormat: @"http://app.olaxueyuan.com"];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
