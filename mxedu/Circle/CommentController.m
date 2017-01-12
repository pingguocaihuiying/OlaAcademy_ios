//
//  CommentController.m
//  NTreat
//
//  Created by 田晓鹏 on 16/2/23.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "CommentController.h"

#import "CircleFrame.h"
#import "CircleDetailView.h"
#import "CircleTableViewCell.h"
#import "CommentCell.h"
#import "SysCommon.h"
#import "CircleManager.h"
#import "OlaCircle.h"
#import "Comment.h"
#import "AuthManager.h"
#import "CommentManager.h"

#import "ShareSheetView.h"
#import "LoginViewController.h"
#import "User.h"
#import "UserEditViewController.h"

#import <Masonry.h>

#define COMMENT_INPUTVIEW_OFFSET_FOR_KEYBOARD 0

@interface CommentController ()<UMSocialUIDelegate,ShareSheetDelegate,UIAlertViewDelegate,CommentCellDelegate,CircleToolbarDelegate>

@property (nonatomic,strong)NSArray *datas;
@property (nonatomic,strong)NSString *toUserId; //被回复人id

@property (assign, nonatomic) int tapIndex;
@property (nonatomic) OlaCircle *channelPost;
@property (nonatomic,assign) NSIndexPath *indexPath;
@property (nonatomic) OlaCircle *sharedCircle;

@end

@implementation CommentController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"欧拉分享";
    [self setupBackButton];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = RGBCOLOR(224, 224, 224);
    
    [self setupInputView];
    
    [self loadCommentData];
    
    self.tapIndex = 0;
    
    // 监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAppear:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillDisappear:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)setupBackButton
{
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

- (void)viewWillAppear:(BOOL)animated
{
    [self setUpForDismissKeyboard];
    
}

- (void)setupInputView
{
    CommentManager *cm = [[CommentManager alloc]init];
    __weak CommentController* wself = self;
    _inputView.sendAction = ^{
        // 发表评论
        if (wself.toUserId==nil) {
            wself.toUserId = @"";
        }
        AuthManager *am = [[AuthManager alloc]init];
        if (!am.isAuthenticated) {
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"您尚未登录" delegate:wself cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        }
        if ([wself.inputView.text isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入评论内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        }
        OlaCircle *circle = wself.circleFrame.result;
        NSString *location = am.userInfo.local?am.userInfo.local:@"";
        [cm addPostReplyToUserId:wself.toUserId detail:wself.inputView.text postId:circle.circleId currentUserId:am.userInfo.userId type:@"2" location:location success:^(CommonResult *result) {
            wself.inputView.text = @"";
            [wself.inputView endEditing:YES];
            [wself loadCommentData];
            wself.toUserId=nil;
        } failure:^(NSError *error) {
            
        }];
    };
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillAppear:(NSNotification *)note
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    _containerViewBottomConstraint.constant = -[[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height - COMMENT_INPUTVIEW_OFFSET_FOR_KEYBOARD;
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}

- (void)keyboardWillDisappear:(NSNotification *)note
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    _containerViewBottomConstraint.constant = -COMMENT_INPUTVIEW_OFFSET_FOR_KEYBOARD;
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}


#pragma method

-(void)loadCommentData{
    CommentManager *cm = [[CommentManager alloc] init];
    [cm fetchCommentListWithPostId:_circleFrame.result.circleId Type:@"2" Success:^(CommentListResult *result) {
        _datas = result.commentArray;
        [self.tableView reloadData];
    } Failure:^(NSError *error) {
        
    }];
}

// 删除评论
-(void)removePostReply:(NSString*)commentId postId:(NSString*)postId{
    
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return self.datas.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CircleTableViewCell *detail = [CircleTableViewCell cellWithTableView:tableView];
        if (self.circleFrame) {
            detail.statusFrame = self.circleFrame;
        }
        detail.detailView.toolBar.delegate = self;
        return detail;
    }
    CommentCell *cell = [CommentCell cellWithTableView:tableView];
    cell.commentR = self.datas[indexPath.row];
    cell.cellDelegate = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.01;
    }else{
        return 35;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if(section==1){
        UIView *dividerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 2)];
        dividerView.backgroundColor = BACKGROUNDCOLOR;
        
        UIImageView *messageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 3, 20)];
        messageView.backgroundColor = [UIColor redColor];
        UILabel *myLabel = [[UILabel alloc] init];
        myLabel.frame = CGRectMake(15, 6, 100, 20);
        myLabel.font = [UIFont boldSystemFontOfSize:14];
        myLabel.text = @"全部评论";
        
        UIView *headerView = [[UIView alloc] init];
        headerView.backgroundColor = [UIColor whiteColor];
        [headerView addSubview:dividerView];
        [headerView addSubview:messageView];
        [headerView addSubview:myLabel];
        
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        return self.circleFrame.cellHeigth;
    }else{
        Comment *comment = self.datas[indexPath.row];
        
        CGFloat height = 0.0;
        CGFloat labelWidth = SCREEN_WIDTH-55;
        if (comment.content && ![comment.content isEqualToString:@""]) {
            NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:17.0]};
            CGRect rect = [comment.content boundingRectWithSize:CGSizeMake(labelWidth, MAXFLOAT)
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:attributes
                                                        context:nil];
            height+=rect.size.height;
        }
        return height+60;
    }
}

#pragma mark 删除操作
//要求委托方的编辑风格在表视图的一个特定的位置。
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;//默认没有编辑风格
    if (indexPath.section==1) {
        Comment *comment = self.datas[indexPath.row];
        AuthManager *am = [[AuthManager alloc]init];
        //        if ([comment.userId isEqualToString:am.accessToken.userId]||_statusFrame.result.isAllowed) {
        //            result = UITableViewCellEditingStyleDelete;//设置编辑风格为删除风格
        //        }
    }
    return result;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        //        if (editingStyle==UITableViewCellEditingStyleDelete) {
        //            Comment *comment =self.datas[indexPath.row];
        //            Channel *channelPost = self.statusFrame.result;
        //            [self.datas removeObject:comment];
        //            [self removePostReply:comment.data_id postId:channelPost.id];
        //            if (_successFunc) {
        //                _successFunc(channelPost,3);
        //            }
        //        }
        //使用下面的方法既可以局部刷新又有动画效果
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    AuthManager *am = [[AuthManager alloc]init];
    if (am.isAuthenticated && indexPath.section==1) {
         Comment *comment = self.datas[indexPath.row];
        if (![am.userInfo.userId isEqualToString:comment.userId]) {
            _inputView.textView.placeholder = [@"@" stringByAppendingString: comment.username];
            self.toUserId = comment.userId;
        }else{
            _inputView.textView.placeholder = @"";
            self.toUserId = @"";
        }
        [_inputView.textView becomeFirstResponder];
    }
}

// 隐藏软键盘
- (void)setUpForDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
}

#pragma method

/**
 *  点击头像 查看个人信息
 */
-(void)clickUserheadImage:(NSNotification *)notification{
    
    NSDictionary *dictionary = [notification userInfo];
    NSString *userId = [dictionary objectForKey:@"userID"];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSData* data = [defaults objectForKey:@"NTUserInfo"];
    //    User *userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    //    if ([userId isEqualToString:userInfo.userID]) {
    //        UserEditViewController *userEditVC = [[UserEditViewController alloc] init];
    //        userEditVC.hidesBottomBarWhenPushed=YES;
    //        [self.navigationController pushViewController:userEditVC animated:YES];
    //    }else{
    //        ChannelUserViewController *channelUsrVC = [[ChannelUserViewController alloc] init];
    //        channelUsrVC.userId=userId;
    //        channelUsrVC.hidesBottomBarWhenPushed = YES;
    //        [self.navigationController pushViewController:channelUsrVC animated:YES];
    //    }
}

/**
 *  删除帖子
 */
-(void)deleteChannelPost{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要删除该帖子？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 1;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        //        if (buttonIndex==1&&self.statusFrame) {
        //            Channel *chanelPost = self.statusFrame.result;
        //            ChannelManager *cm = [[ChannelManager alloc]init];
        //            [cm deletePostWithGid:chanelPost.id success:^{
        //                [self.navigationController popViewControllerAnimated:YES];
        //                if (_successFunc) {
        //                    _successFunc(chanelPost,1);
        //                }
        //            } failure:^(NSError *error) {
        //
        //            }];
        //        }
    }
}

#pragma Toolbar Delegate
// 点赞
-(void) didClickLove:(OlaCircle *)circle{
    CircleManager *cm = [[CircleManager alloc]init];
    [cm praiseCirclePostWithCircle:circle.circleId Success:^(CommonResult *result) {\
        OlaCircle *circle = _circleFrame.result;
        if (_successFunc) {
            _successFunc(circle,1);
        }
        [_tableView reloadData];
    } Failure:^(NSError *error) {
        
    }];
}
// 分享
-(void) didClickShare:(OlaCircle *)circle{
    _sharedCircle = circle;
    if (self.circleFrame) {
        NSArray *shareButtonTitleArray = [[NSArray alloc] init];
        NSArray *shareButtonImageNameArray = [[NSArray alloc] init];
        
        if (self.tapIndex == 0) {
            shareButtonTitleArray = @[@"微信好友",@"微信朋友圈",@"新浪微博",@"QQ好友",@"QQ空间"];
            shareButtonImageNameArray = @[@"wechat",@"wetimeline",@"sina",@"qq",@"qzone"];
        }
        ShareSheetView *lxActivity = [[ShareSheetView alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" ShareButtonTitles:shareButtonTitleArray withShareButtonImagesName:shareButtonImageNameArray];
        [lxActivity showInView:self.view];
    }
}

-(void) didClickComment:(OlaCircle *)circle{
    AuthManager *am = [[AuthManager alloc]init];
    if (!am.isAuthenticated) {
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"您尚未登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    [_inputView.textView becomeFirstResponder];
}

#pragma CommentCellDelegate
// 评论点赞
-(void)didPraiseAction:(CommentCell *)seletedCell{
    //    ChannelManager *cm = [[ChannelManager alloc]init];
    //    [cm praisePostReplyWithGid:seletedCell.commentR.data_id Success:^{
    //        Comment *comment = seletedCell.commentR;
    //        comment.isPraised =@"1";
    //        comment.like_count = [NSString stringWithFormat:@"%d",[seletedCell.commentR.like_count intValue]+1];
    //        [seletedCell setCommentR:comment];
    //    } Failure:^(NSError *error) {
    //
    //    }];
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

@end
