//
//  CircleViewController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/4/8.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "CircleViewController.h"

#import "SysCommon.h"
#import "MJRefresh.h"
#import "AuthManager.h"
#import "CircleManager.h"
#import "MessageManager.h"
#import "CircleListTableCell.h"
#import "DeployViewController.h"
#import "CommentViewController.h"
#import "MessageMainController.h"
#import "ShareSheetView.h"
#import "LoginViewController.h"
#import "OtherUserController.h"

#import "Masonry.h"

@interface CircleViewController ()<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate,ShareSheetDelegate,CircleListTableCellDelegate>

@property (nonatomic) UILabel *redL;

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *dataArray;

@property (nonatomic) OlaCircle *sharedCircle;

@property (nonatomic) MessageCount *messageCount;

@property (nonatomic,copy) NSString *pushTimer;

@end

@implementation CircleViewController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [self fetchMessageCount]; //消息提醒
    if(_isFromHomePage==1){
        [self setupBackButton];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"欧拉圈";
    [self setupRightButton];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-60)];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self setupData:@""];
    }];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        OlaCircle *cirlce = [_dataArray lastObject];
        if (cirlce) {
            [self setupData:cirlce.circleId];
        }
    }];
    
    [self setupDeployImage];
    
    [self setupData:@""];
}

- (void)setupBackButton
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    [backBtn sizeToFit];
    [backBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

-(void)backButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupRightButton{
    UIImageView *messageBtn = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    messageBtn.image = [UIImage imageNamed:@"icon_message"];
    messageBtn.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showMessageView)];
    [messageBtn addGestureRecognizer:singleTap];
    [messageBtn sizeToFit];
    
    _redL = [[UILabel alloc]init];
    _redL.layer.masksToBounds = YES;
    _redL.layer.cornerRadius = GENERAL_SIZE(10);
    _redL.backgroundColor = [UIColor redColor];
    _redL.font = LabelFont(14);
    _redL.textAlignment = NSTextAlignmentCenter;
    _redL.textColor = [UIColor whiteColor];
    _redL.hidden = YES;
    [messageBtn addSubview:_redL];
    
    [_redL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(messageBtn.mas_right).offset(GENERAL_SIZE(10));
        make.top.equalTo(messageBtn).offset(-GENERAL_SIZE(10));
        make.width.equalTo(@(GENERAL_SIZE(20)));
        make.height.equalTo(@(GENERAL_SIZE(20)));
    }];
    
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:messageBtn];
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
}

-(void)showMessageView{
    AuthManager *am = [AuthManager sharedInstance];
    if (!am.isAuthenticated) {
        [self showLoginView];
        return;
    }
    MessageMainController *messageVC = [[MessageMainController alloc]init];
    messageVC.messageCount = _messageCount;
    messageVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:messageVC animated:YES];
}

-(void)fetchMessageCount{
    AuthManager *am = [AuthManager sharedInstance];
    if (am.isAuthenticated) {
        MessageManager *mm = [[MessageManager alloc]init];
        [mm fetchUnreadCountWithUserId:am.userInfo.userId Success:^(MessageUnreadResult *result) {
            _messageCount = result.messageCount;
            int totalCount = _messageCount.systemCount+_messageCount.circleCount+_messageCount.praiseCount;
            if (result.code==10000&totalCount>0) {
                _redL.hidden = NO;
                _redL.text = [NSString stringWithFormat:@"%d",totalCount];
            }else{
                _redL.hidden = YES;
            }
        } Failure:^(NSError *error) {
            
        }];
    }
}

-(void)showLoginView{
    LoginViewController* loginViewCon = [[LoginViewController alloc] init];
    loginViewCon.successFunc = ^{
        [self setupData:@""];
    };
    UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:loginViewCon];
    [self presentViewController:rootNav animated:YES completion:^{}
     ];
}

//发帖按钮
-(void)setupDeployImage{
    
    int tabbarHeight = self.tabBarController.tabBar.frame.size.height;
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_deploy"]];
    UITapGestureRecognizer *recognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(handleTap:)];
    [imageView addGestureRecognizer:recognizer1];
    UIPanGestureRecognizer *recognizer2 = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(handlePan:)];
    [imageView addGestureRecognizer:recognizer2];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    __weak typeof(self)weekSelf = self;
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weekSelf)strongSelf = weekSelf;
        
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.bottom.equalTo(strongSelf.tableView.mas_bottom).offset(-(tabbarHeight+20));
    }];
    
}

/**
 *  处理点击手势
 *
 *  @param recognizer 手势识别器对象实例
 */
- (void)handleTap:(UIPanGestureRecognizer *)recognizer{
    AuthManager *am = [AuthManager sharedInstance];
    if (!am.isAuthenticated) {
        [self showLoginView];
        return;
    }
    DeployViewController *deployVC = [[DeployViewController alloc]init];
    deployVC.doneAction = ^{
        // 延迟一秒执行
        double delayInSeconds = 1.0;
        __block CircleViewController* bself = self;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [bself setupData:@""];
        });
        
    };
    deployVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:deployVC animated:YES];
}

/**
 *  处理拖动手势
 *
 *  @param recognizer 拖动手势识别器对象实例
 */
- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    //视图前置操作
    [recognizer.view.superview bringSubviewToFront:recognizer.view];
    
    CGPoint center = recognizer.view.center;
    CGFloat cornerRadius = recognizer.view.frame.size.width / 2;
    CGPoint translation = [recognizer translationInView:self.view];
    //NSLog(@"%@", NSStringFromCGPoint(translation));
    recognizer.view.center = CGPointMake(center.x + translation.x, center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        //计算速度向量的长度，当他小于200时，滑行会很短
        CGPoint velocity = [recognizer velocityInView:self.view];
        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
        CGFloat slideMult = magnitude / 200;
        //NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult); //e.g. 397.973175, slideMult: 1.989866
        
        //基于速度和速度因素计算一个终点
        float slideFactor = 0.1 * slideMult;
        CGPoint finalPoint = CGPointMake(center.x + (velocity.x * slideFactor),
                                         center.y + (velocity.y * slideFactor));
        //限制最小［cornerRadius］和最大边界值［self.view.bounds.size.width - cornerRadius］，以免拖动出屏幕界限
        finalPoint.x = MIN(MAX(finalPoint.x, cornerRadius),
                           self.view.bounds.size.width - cornerRadius);
        int height = 200;
        if (iPhone6) {
            height = 100;
        }else if(iPhone6Plus){
            height = 40;
        }
        finalPoint.y = MIN(MAX(finalPoint.y, cornerRadius),
                           self.view.bounds.size.height- height - cornerRadius);
        
        //使用 UIView 动画使 view 滑行到终点
        [UIView animateWithDuration:slideFactor*2
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             recognizer.view.center = finalPoint;
                         }
                         completion:nil];
    }
}

-(void)setupData:(NSString*)logId{
    NSString *userId = @"";
    AuthManager *am = [AuthManager sharedInstance];
    if (am.isAuthenticated) {
        userId = am.userInfo.userId;
    }
    CircleManager *cm = [[CircleManager alloc]init];
    [cm fetchVideoHistoryListWithVideoLogId:logId UserId:userId PageSize:@"20" Type:@"2" Success:^(VideoHistoryResult *result) {
        if ([logId isEqualToString:@""]) {
            [_dataArray removeAllObjects];
        }
        [_dataArray addObjectsFromArray:result.historyArray];
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [_tableView reloadData];
    } Failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"circleCell";
    CircleListTableCell *circleCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (circleCell == nil) {
        circleCell = [[CircleListTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"circleCell"];
    }
    circleCell.selectionStyle = UITableViewCellSelectionStyleNone;
    OlaCircle *circle = self.dataArray[indexPath.row];
    circleCell.delegate = self;
    [circleCell setupCellWithModel:circle];
    
    return circleCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OlaCircle *circle = self.dataArray[indexPath.row];
    CommentViewController *commentVC = [[CommentViewController alloc]init];
    commentVC.postId = circle.circleId;
    commentVC.successFunc = ^void(OlaCircle *circle,int type){
        if (type==1) {
            [self updatePraiseNumber:circle];
        }
    };
    commentVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:commentVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    OlaCircle *circle = self.dataArray[indexPath.row];
    NSString* contetxt = [circle.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //根据普通文本计算正文的范围
    NSMutableParagraphStyle *style =  [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 3.0f;
    NSDictionary *attributes = @{NSFontAttributeName: LabelFont(28),NSParagraphStyleAttributeName:style};
    CGRect rect = [contetxt boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-GENERAL_SIZE(40), MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attributes
                                         context:nil];
    if (circle.imageGids&&![circle.imageGids isEqualToString:@""]) {
        return rect.size.height+GENERAL_SIZE(580);
    }
    return rect.size.height+GENERAL_SIZE(250);
}

#pragma Delegate
// 点击头像
-(void)didClickUserAvatar:(User *)userInfo{
    OtherUserController * otherVC = [[OtherUserController alloc]init];
    otherVC.userInfo = userInfo;
    otherVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:otherVC animated:YES];
}

-(void)updatePraiseNumber:(OlaCircle*)circle{
    for (int i=0; i<[_dataArray count]; i++) {
        OlaCircle *oldCircle = [_dataArray objectAtIndex:i];
        if ([oldCircle.circleId isEqualToString:circle.circleId]) {
            circle.praiseNumber = [NSString stringWithFormat:@"%d", circle.praiseNumber.intValue+1];
            [_dataArray setObject:circle atIndexedSubscript:i];
            break;
        }
    }
    [_tableView reloadData];
}
// 分享
-(void) didClickShare:(OlaCircle *)circle{
    _sharedCircle = circle;
    NSArray *shareButtonTitleArray = [[NSArray alloc] init];
    NSArray *shareButtonImageNameArray = [[NSArray alloc] init];
    
    shareButtonTitleArray = @[@"微信好友",@"微信朋友圈",@"新浪微博",@"QQ好友",@"QQ空间"];
    shareButtonImageNameArray = @[@"wechat",@"wetimeline",@"sina",@"qq",@"qzone"];
    
    ShareSheetView *lxActivity = [[ShareSheetView alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" ShareButtonTitles:shareButtonTitleArray withShareButtonImagesName:shareButtonImageNameArray];
    [lxActivity showInView:self.view];
}

#pragma mark - LXActivityDelegate

- (void)didClickOnImageIndex:(NSInteger)imageIndex
{
    UIImage *image = [UIImage imageNamed:@"ic_logo"];
    NSString *content = _sharedCircle.content;
    NSString *url = [NSString stringWithFormat: @"%@/circlepost.html?circleId=%@",BASIC_URL,_sharedCircle.circleId];
    
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
