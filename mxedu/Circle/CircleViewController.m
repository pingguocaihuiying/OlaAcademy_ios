//
//  CircleViewController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/4/8.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "CircleViewController.h"

#import "SysCommon.h"
#import "CircleTableViewCell.h"
#import "MJRefresh.h"
#import "AuthManager.h"
#import "CircleManager.h"
#import "CircleFrame.h"
#import "DeployViewController.h"
#import "CommentController.h"
#import "ShareSheetView.h"
#import "LoginViewController.h"

#import "PopViewController.h"
#import "PopContentTabeVIew.h"

@interface CircleViewController ()<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate,ShareSheetDelegate,CircleToolbarDelegate>

@property (nonatomic) UIButton *titleBtn;

@property (nonatomic) NSString *type;//当前筛选类型 1 学习记录 2帖子 空 其他
@property (nonatomic) PopViewController *popover;

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *dataArray;
@property (nonatomic) NSMutableArray *circleFrames;
@property (assign, nonatomic) int tapIndex;
@property (nonatomic) OlaCircle *sharedCircle;

@end

@implementation CircleViewController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavBar];
    [self setupRightButton];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-100)];
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
    
    _type = @"";
    [self setupData:@""];
    
    self.tapIndex = 0;
}

-(void)setupNavBar{
    _titleBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_titleBtn setFrame:CGRectMake(0, 0, 60, 20)];
    [_titleBtn setTitle:@"欧拉圈" forState:UIControlStateNormal];
    [_titleBtn setImage:[UIImage imageNamed:@"ic_pulldown"] forState:UIControlStateNormal];
    [_titleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
    [_titleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, -40)];
    [_titleBtn addTarget:self action:@selector(showFilterView:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = _titleBtn;
}

-(void)setupRightButton{
    UIImageView *slideBtn = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    slideBtn.image = [UIImage imageNamed:@"ic_add_circle"];
    slideBtn.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showDeployView)];
    [slideBtn addGestureRecognizer:singleTap];
    [slideBtn sizeToFit];
    
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:slideBtn];
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
}

-(void)showDeployView{
    AuthManager *am = [[AuthManager alloc]init];
    if (!am.isAuthenticated) {
        [self showLoginView];
        return;
    }
    DeployViewController *deployVC = [[DeployViewController alloc]init];
    deployVC.doneAction = ^{
        [self setupData:@""];
    };
    deployVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:deployVC animated:YES];
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

#pragma 下拉筛选

// 筛选视图
-(void)showFilterView:(UIButton*)btn{
    _modalDataArray = [NSMutableArray arrayWithCapacity:3];
    
    NSArray *titlesArr = @[@"全部",@"学习记录",@"欧拉分享"];
    for (NSString *titleStr in titlesArr) {
        NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:titleStr,@"titleName", nil];
        [_modalDataArray addObject:dataDic];
    }
    SAFE_ARC_RELEASE(popover); _popover=nil;
    
    //the controller we want to present as a popover
    PopContentTabeVIew *controller = [[PopContentTabeVIew alloc] initWithStyle:UITableViewStylePlain];
    controller.delegate = self;
    _popover = [[PopViewController alloc] initWithViewController:controller];
    _popover.tint = FPPopoverWhiteTint;
    _popover.keyboardHeight = 0;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        _popover.contentSize = CGSizeMake(300, 350);
    }
    else {
        _popover.contentSize = CGSizeMake(200, 230);
    }
    //no arrow
    _popover.arrowDirection = FPPopoverArrowDirectionAny;
    [_popover presentPopoverFromView:btn];

}

#pragma mark popView中taleCell的点击时间
-(void)selectedTableRow:(NSIndexPath *)path
{
    //NSString *navTitle = [[_modalDataArray objectAtIndex:path.row] objectForKey:@"titleName"];
    switch (path.row) {
        case 1:
            [_titleBtn setTitle:@"学习" forState:UIControlStateNormal];
            break;
        case 2:
            [_titleBtn setTitle:@"分享" forState:UIControlStateNormal];
            break;
            
        default:
            [_titleBtn setTitle:@"全部" forState:UIControlStateNormal];
            break;
    }
    
    _type = path.row == 0?@"":[NSString stringWithFormat:@"%ld", path.row];
    [self.tableView.header beginRefreshing];
    [_popover dismissPopoverAnimated:YES];
}

-(void)setupData:(NSString*)logId{
    CircleManager *cm = [[CircleManager alloc]init];
    [cm fetchVideoHistoryListWithVideoLogId:logId PageSize:@"20" Type:_type Success:^(VideoHistoryResult *result) {
        if ([logId isEqualToString:@""]) {
            [_dataArray removeAllObjects];
        }
        [_dataArray addObjectsFromArray:result.historyArray];
        self.circleFrames = [self circleFrameWithcircleModels:_dataArray];
        
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
    CircleTableViewCell *cell = [CircleTableViewCell cellWithTableView:tableView];
    CircleFrame *circleFrame = self.circleFrames[indexPath.row];
    cell.detailView.toolBar.delegate = self;
    cell.statusFrame = circleFrame;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CircleFrame *frame = self.circleFrames[indexPath.row];
    OlaCircle *circle = frame.result;
    if ([circle.type isEqualToString: @"1"]) {  //观看记录
        CourSectionViewController *sectionVC = [[CourSectionViewController alloc]init];
        sectionVC.objectId = circle.courseId;
        sectionVC.type = 1;
        sectionVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:sectionVC animated:YES];
    }else{ // 发帖
        CommentController *commentVC = [[CommentController alloc]init];
        commentVC.circleFrame = frame;
        commentVC.successFunc = ^void(OlaCircle *circle,int type){
            if (type==1) {
                [self updatePraiseNumber:circle];
            }
        };
        commentVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:commentVC animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CircleFrame *frame = self.circleFrames[indexPath.row];
    return frame.cellHeigth;
}
- (NSMutableArray *)circleFrameWithcircleModels:(NSArray *)modelArray
{
    NSMutableArray *frames = [NSMutableArray array];
    
    for (OlaCircle *result in modelArray) {
        CircleFrame *frame = [[CircleFrame alloc] init];
        //传递微博模型数据，计算所有子控件的frame
        frame.result = result;
        [frames addObject:frame];
    }
    return frames;
}

#pragma Toolbar Delegate
// 点赞
-(void) didClickLove:(OlaCircle *)circle{
    CircleManager *cm = [[CircleManager alloc]init];
    [cm praiseCirclePostWithCircle:circle.circleId Success:^(CommonResult *result) {
        [self updatePraiseNumber:circle];
    } Failure:^(NSError *error) {
        
    }];
}

-(void)updatePraiseNumber:(OlaCircle*)circle{
    for (int i=0; i<[_circleFrames count]; i++) {
        CircleFrame *frame = [_circleFrames objectAtIndex:i];
        OlaCircle *oldCircle = frame.result;
        if ([oldCircle.circleId isEqualToString:circle.circleId]) {
            circle.praiseNumber = [NSString stringWithFormat:@"%d", circle.praiseNumber.intValue+1];
            frame.result = circle;
            [_circleFrames setObject:frame atIndexedSubscript:i];
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
    
    if (self.tapIndex == 0) {
        shareButtonTitleArray = @[@"微信好友",@"微信朋友圈",@"新浪微博",@"QQ好友",@"QQ空间"];
        shareButtonImageNameArray = @[@"wechat",@"wetimeline",@"sina",@"qq",@"qzone"];
    }
    ShareSheetView *lxActivity = [[ShareSheetView alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" ShareButtonTitles:shareButtonTitleArray withShareButtonImagesName:shareButtonImageNameArray];
    [lxActivity showInView:self.view];
}

-(void) didClickComment:(OlaCircle *)circle{
    CommentController *commentVC = [[CommentController alloc]init];
    CircleFrame *frame = [[CircleFrame alloc] init];
    frame.result = circle;
    commentVC.circleFrame = frame;
    commentVC.successFunc = ^void(OlaCircle *circle,int type){
        if (type==1) {
            [self updatePraiseNumber:circle];
        }
    };
    commentVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:commentVC animated:YES];
}

#pragma mark - LXActivityDelegate

- (void)didClickOnImageIndex:(NSInteger *)imageIndex
{
    UIImage *image = [UIImage imageNamed:@"ic_logo"];
    NSString *content = _sharedCircle.content;
    NSString *url = [NSString stringWithFormat: @"%@/circlepost.html?circleId=%@",BASIC_URL,_sharedCircle.circleId];
    
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
