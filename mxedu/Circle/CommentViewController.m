//
//  CommentViewController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/12/3.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "CommentViewController.h"

#import "SysCommon.h"
#import "CustomInputView.h"
#import "CommentAudioView.h"
#import "CommentMediaView.h"
#import "ShareSheetView.h"

#import "JRPlayerViewController.h"
#import "LoginViewController.h"

#import "mediaModel.h"
#import "PhotoManager.h"
#import "AuthManager.h"
#import "CommentManager.h"
#import "UploadManager.h"
#import "CircleManager.h"
#import "LCAudioManager.h"

#import "CircleFrame.h"
#import "Comment.h"
#import "CommentFrame.h"

#import "CircleTableViewCell.h"
#import "CommentCell.h"
#import "CommentAudioCell.h"

#import "Masonry.h"
#import "SVProgressHUD.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "OtherUserController.h"

#define COMMENT_INPUTVIEW_OFFSET_FOR_KEYBOARD 0

@interface CommentViewController ()<UITableViewDataSource,UITableViewDelegate,CommentAudioViewDelegate,CommentMediaViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UMSocialUIDelegate,ShareSheetDelegate,CommentCellDelegate,CustomProgressDelegate,CircleViewDelegate>

@property (nonatomic) CircleFrame* circleFrame;

@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSString *toUserId; //被回复人id

@property (nonatomic) UITableView *tableView;
@property (nonatomic) CustomInputView* inputView;

@property (nonatomic) CommentAudioView *audioView;
@property (nonatomic) CommentMediaView *mediaView;

@property (nonatomic) BOOL audioViewShow;
@property (nonatomic) BOOL mediaViewShow;

@property (nonatomic) OlaCircle *sharedCircle;

@property (nonatomic) NSString *currentUrl; //当前正在播放的音频

@property (nonatomic) NSMutableArray *mediaDataArray;//多媒体数组

@end

@implementation CommentViewController
{
    NSMutableArray *_photoNames;
    NSMutableArray *_dataSource;//储存图片model
    
    NSString *imgIDs;
    NSString *audioIDs;
    NSString *videoIDs;
    NSString *videoImgS;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    // 监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAppear:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillDisappear:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self setUpForDismissKeyboard];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-UI_STATUS_BAR_HEIGHT-50) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    _mediaDataArray= [NSMutableArray arrayWithCapacity:0];
    _dataSource = [NSMutableArray arrayWithCapacity:0];
    _photoNames = [NSMutableArray arrayWithCapacity:0];

    _audioView = [[CommentAudioView alloc]init];
    _audioView.backgroundColor = RGBCOLOR(253, 253, 253);
    _audioView.hidden = YES;
    _audioView.delegate = self;
    [self.view addSubview:_audioView];
    [_audioView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(@(GENERAL_SIZE(210)));
        make.width.equalTo(@(SCREEN_WIDTH));
    }];
    
    _mediaView = [[CommentMediaView alloc]init];
    _mediaView.backgroundColor = RGBCOLOR(253, 253, 253);
    _mediaView.hidden = YES;
    _mediaView.delegate = self;
    [self.view addSubview:_mediaView];
    
    [_mediaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(@(GENERAL_SIZE(210)));
        make.width.equalTo(@(SCREEN_WIDTH));
    }];
    
    [self loadCircleDetail];
}

- (void)setupInputView
{
    _inputView = [[CustomInputView alloc]init];
    [self.view addSubview:_inputView];
    [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    __weak CommentViewController* wself = self;
    _inputView.audioAction = ^{
        if([wself checkLoginState]){
            int height;
            if (wself.audioViewShow) {
                wself.audioViewShow = NO;
                wself.mediaViewShow = NO;
                wself.audioView.hidden = YES;
                wself.mediaView.hidden = YES;
                height = 0;
            }else{
                wself.audioViewShow = YES;
                wself.mediaViewShow = NO;
                height = GENERAL_SIZE(210);
                wself.audioView.hidden = NO;
                wself.mediaView.hidden = YES;
            }
            [wself.view endEditing:YES];
            [wself.inputView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(wself.view);
                make.right.equalTo(wself.view.mas_right);
                make.bottom.equalTo(wself.view).offset(-height);
            }];
        }else{
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:loginVC];
            [wself.navigationController presentViewController:rootNav animated:YES completion:^{
            }];
        }
    };
    
    _inputView.mediaAction = ^{
        if ([wself checkLoginState]) {
            int height;
            if (wself.mediaViewShow) {
                wself.mediaViewShow = NO;
                wself.audioViewShow = NO;
                wself.audioView.hidden = YES;
                wself.mediaView.hidden = YES;
                height = 0;
            }else{
                wself.mediaViewShow = YES;
                wself.audioViewShow = NO;
                height = GENERAL_SIZE(210);
                wself.audioView.hidden = YES;
                wself.mediaView.hidden = NO;
            }
            [wself.view endEditing:YES];
            [wself.inputView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(wself.view);
                make.right.equalTo(wself.view.mas_right);
                make.bottom.equalTo(wself.view).offset(-height);
            }];
        }else{
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:loginVC];
            [wself.navigationController presentViewController:rootNav animated:YES completion:^{
            }];
        }
    };
    
    _inputView.sendAction = ^{
        if([wself checkLoginState]){
            if(wself.inputView.text.length==0&&[wself.mediaDataArray count]==0){
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请输入评论内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }else{
                // 发表评论
                [wself saveComment];
            }
        }
        else{
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:loginVC];
            [wself.navigationController presentViewController:rootNav animated:YES completion:^{
            }];
        }
    };
}

-(BOOL)checkLoginState{
    return [AuthManager sharedInstance].isAuthenticated;
}

#pragma method

-(void)loadCircleDetail{
    CircleManager *cm = [[CircleManager alloc] init];
    NSString *userId = @"";
    AuthManager *am = [AuthManager sharedInstance];
    if (am.isAuthenticated) {
        userId = am.userInfo.userId;
    }
    [cm fetchCircleDetailWithId:_postId UserId: userId
                        Success:^(CircleDetailResult *result) {
        CircleFrame *frame = [[CircleFrame alloc]init];
        frame.result = result.circleDetail;
        self.circleFrame = frame;
        
        [self setupInputView];
        [self loadCommentData];
    } Failure:^(NSError *error) {
        
    }];
}

-(void)loadCommentData{
    CommentManager *cm = [[CommentManager alloc] init];
    [cm fetchCommentListWithPostId:_circleFrame.result.circleId Type:@"2" Success:^(CommentListResult *result) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
        for (Comment *comment in result.commentArray) {
            CommentFrame *m = [[CommentFrame alloc]init];
            if (comment.audioUrls) {
                comment.playstate = Stop;
                comment.urlString = [BASIC_Movie_URL stringByAppendingString:comment.audioUrls];
                comment.isReset = NO;
                comment.currentState = Stop;
            }
            m.comment = comment;
            [_dataArray addObject:m];
        }
        [self.tableView reloadData];
    } Failure:^(NSError *error) {
        
    }];
}

-(void)saveComment{
    
    _audioViewShow = NO;
    _mediaViewShow = NO;
    _audioView.hidden = YES;
    _mediaView.hidden = YES;
    [_inputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view);
    }];
    
    //首先是上传图片和视频以及音频
    imgIDs = @"";
    audioIDs =@"";
    videoIDs = @"";
    videoImgS = @"";
    
    //将多媒体分组
    if (_mediaDataArray.count>0) {
        UploadManager* um = [[UploadManager alloc]init];
        [um uploadCommentMdeiaDatas:_mediaDataArray angles:nil progress:^(NSInteger uploadedImageNum, NSInteger totalImageNum) {
            float progress = ((float)uploadedImageNum  + 0.5) / (float)totalImageNum;
            [SVProgressHUD showProgress:progress
                                 status:[NSString stringWithFormat:@"正在上传第%ld个附加文件，共%ld个。", (long)uploadedImageNum, (long)totalImageNum]];
        } success:^{
            imgIDs = [um.imageGids componentsJoinedByString:@","];
            audioIDs = [um.audioGids componentsJoinedByString:@","];
            videoIDs = [um.viedoGids componentsJoinedByString:@","];
            videoImgS = [um.movieImageS componentsJoinedByString:@","];
            
            [self putTogetherDataToSave];
            
        } failure:^(NSError *error) {
            [SVProgressHUD showInfoWithStatus:@"附件上传失败"];
        }];
        
    }else{
        //只有文字
        [self putTogetherDataToSave];
    }
    
}

-(void)putTogetherDataToSave{
    AuthManager *am = [AuthManager sharedInstance];
    CommentManager *cm = [[CommentManager alloc]init];
    NSString *location = am.userInfo.local?am.userInfo.local:@"";
    [SVProgressHUD showWithStatus:@"发布中..." maskType:SVProgressHUDMaskTypeNone];
    [cm addPostReplyToUserId:@"" detail:_inputView.text imageIds:imgIDs videoUrls:videoIDs videoImgs:videoImgS audioUrls:audioIDs postId:_postId currentUserId:am.userInfo.userId type:@"2" location:location success:^(CommonResult *result) {
        _inputView.text = @"";
        [SVProgressHUD dismiss];
        [self loadCommentData];
    } failure:^(NSError *error) {
        [SVProgressHUD showSuccessWithStatus:@"发布失败"];
    }];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillAppear:(NSNotification *)note
{
    _audioView.hidden = YES;
    _mediaView.hidden = YES;
    _audioViewShow = NO;
    _mediaViewShow = NO;
    [_inputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view).offset(-[[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height - COMMENT_INPUTVIEW_OFFSET_FOR_KEYBOARD);
    }];
}

- (void)keyboardWillDisappear:(NSNotification *)note
{
    [_inputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view).offset(-COMMENT_INPUTVIEW_OFFSET_FOR_KEYBOARD);
    }];
    
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

#pragma tableview delegate

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
        return self.dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CircleTableViewCell *detail = [CircleTableViewCell cellWithTableView:tableView];
        if (self.circleFrame) {
            detail.statusFrame = self.circleFrame;
        }
        detail.detailView.delegate = self;
        return detail;
    }
    CommentFrame *commentF = self.dataArray[indexPath.row];
    Comment * comment = commentF.comment;
    //音频
    if (comment.audioUrls&&![comment.audioUrls isEqualToString:@""]) {
        CommentAudioCell * cell = [tableView dequeueReusableCellWithIdentifier:@"audioCell"];
        if(cell == nil)
        {
            cell = [[CommentAudioCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"audioCell"];
            
        }
        cell.delegate = self;
        cell.cellDelegate = self;
        cell.sdModel = comment;
        return cell;
    }
    // 其他
    CommentCell *cell = [CommentCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setupCellWithFrame:commentF];
    cell.cellDelegate = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.01;
    }else{
        return GENERAL_SIZE(80);
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if(section==1){
        
        UILabel *myLabel = [[UILabel alloc] init];
        myLabel.frame = CGRectMake(GENERAL_SIZE(20), 0, 100, GENERAL_SIZE(80));
        myLabel.font = LabelFont(28);
        myLabel.textColor = RGBCOLOR(81, 81, 81);
        myLabel.text = @"全部评论";
        
        UIView *headerView = [[UIView alloc] init];
        headerView.backgroundColor = RGBCOLOR(235, 235, 235);
        [headerView addSubview:myLabel];
        
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        return self.circleFrame.cellHeigth;
    }
    CommentFrame *commentF = self.dataArray[indexPath.row];
    //音频
    if (commentF.comment.audioUrls&&![commentF.comment.audioUrls isEqualToString:@""]){
        CGFloat maxW = 0.0;
        
        NSString* contetxt = [commentF.comment.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
        contetxt = [contetxt stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        contetxt = [contetxt stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        //根据普通文本计算正文的范围
        maxW = SCREEN_WIDTH - 2*GENERAL_SIZE(30);
        NSMutableParagraphStyle *style =  [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 3.0f;
        NSDictionary *attributes = @{NSFontAttributeName: LabelFont(30),NSParagraphStyleAttributeName:style};
        CGRect rect = [contetxt boundingRectWithSize:CGSizeMake(maxW, MAXFLOAT)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:attributes
                                             context:nil];
        return (contetxt.length==0?0:rect.size.height) + GENERAL_SIZE(300);
    }else{
        return commentF.cellHeight;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AuthManager *am = [AuthManager sharedInstance];
    if (am.isAuthenticated && indexPath.section==1) {
        CommentFrame *frame = self.dataArray[indexPath.row];
        Comment *comment = frame.comment;
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

#pragma AudioView delegate
-(void)clearMediaData{
    if ([_mediaDataArray count]>0) {
        [_mediaDataArray removeAllObjects];
        [_mediaView refreshViewWithData:_mediaDataArray];
    }
}
-(void)updateDataSource:(mediaModel*)audioModel{
    [_mediaDataArray removeAllObjects];
    [_mediaDataArray addObject:audioModel];
}

#pragma MeidaView delegate 从手机选取照片或拍照

-(void)chooseImage:(NSInteger)type{
    
    [PhotoManager shareManager].delegate = self;
    [PhotoManager shareManager].type = type;
    [[PhotoManager shareManager] showPhotoView:^(NSArray *photoModels, PhotoManagerSourceType type) {
        if (type == PhotoManagerSourceTypeCancel || type == PhotoManagerSourceTypeOther) {
            return ;
        }
        
        if ([_mediaDataArray count]>0) {
            [_audioView deleteAction];
            [_mediaDataArray removeAllObjects];
        }
        
        if (photoModels.count > 0) {
            //存储图片和图片名字
            for (PhotoModel *photo in photoModels) {
                BOOL isAdd = YES;
                
                for (PhotoModel *p in self->_dataSource) {
                    if ([p isKindOfClass:[PhotoModel class]]) {
                        if ([p.photoName isEqualToString:photo.photoName]) {
                            isAdd = NO;
                            break;
                        }
                    }
                    
                }
                if (isAdd) {
                    [self->_dataSource addObject:photo];
                    mediaModel *imageModel = [[mediaModel alloc] init];
                    imageModel.type = @"1";
                    imageModel.image = [UIImage imageWithData:photo.thumbnailData];
                    imageModel.imgData = photo.thumbnailData;
                    imageModel.isExit=NO;
                    [_mediaDataArray addObject:imageModel];
                    
                }
                
                if (photo.photoName && ![photo.photoName isEqualToString:@""] && ![self->_photoNames containsObject:photo.photoName]) {
                    [self->_photoNames addObject:photo.photoName];
                }
            }
        }
        [_mediaView refreshViewWithData:_mediaDataArray];
        
    } withMaxSelect:3 withSelectedPhotoNames:_photoNames];
}
- (NSArray*)photoData
{
    NSMutableArray *photos = [NSMutableArray new];
    for (PhotoModel *model in _dataSource) {
        if ([model isKindOfClass:[PhotoModel class]]) {
            [photos addObject:model.photoData];
        }else{
            [photos addObject:model];
        }
    }
    return photos;
}


#pragma delegate 从手机选取视频及录像

-(void)chooseVideoFromDevice{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    [controller setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];// 设置类型
    NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
    if ([self canUserPickVideosFromPhotoLibrary]){
        [mediaTypes addObject:( NSString *)kUTTypeMovie];
    }
    
    [controller setMediaTypes:mediaTypes];
    [controller setDelegate:self];// 设置代理
    [self presentViewController:controller animated:YES completion:^{
        
    }];
}
-(void)shootVideoWithCamera{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    picker.delegate = self;
    picker.allowsEditing = YES;//设置可编辑
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.mediaTypes = @[(NSString*)kUTTypeMovie];
    picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}

#pragma UIImagePickerControllerDelegate

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString* type = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *image=nil;
    NSURL *movieUrl;
    //视频
    if ([type isEqualToString:(NSString*)kUTTypeMovie]) {
        movieUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        
        MPMoviePlayerController *player = [[MPMoviePlayerController alloc]initWithContentURL:movieUrl];
        player.shouldAutoplay = NO;//设置不默认播放，否则会开始播放视频
        image = [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        if ([_mediaDataArray count]>0) {
            [_mediaDataArray removeAllObjects];
            [_audioView deleteAction];
        }
        if (image) {
            mediaModel *audioModel = [[mediaModel alloc] init];
            audioModel.type = @"3";
            audioModel.timeLong = @"";
            audioModel.localpath = [NSString stringWithFormat:@"%@",movieUrl];
            audioModel.image = image;
            audioModel.isExit=NO;
            [_mediaDataArray addObject:audioModel];
            
            [_mediaView refreshViewWithData:_mediaDataArray];
        }
    }];
    
}

// 缩略图
-(UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    
    return thumbnailImage;
}

- (BOOL)canUserPickVideosFromPhotoLibrary{
    return [self cameraSupportsMedia:( NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
// 是否可以在相册中选择视频
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self cameraSupportsMedia:( NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
// 判断是否支持某种多媒体类型：拍照，视频
- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0){
        NSLog(@"Media type is empty.");
        return NO;
    }
    NSArray *availableMediaTypes =[UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL*stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
        
    }];
    return result;
}

#pragma CircleViewDelegate
// 点击头像
-(void)didClickUserAvatar:(User *)userInfo{
    OtherUserController * otherVC = [[OtherUserController alloc]init];
    otherVC.userInfo = userInfo;
    otherVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:otherVC animated:YES];
}

// 点赞
-(void) didClickLove:(OlaCircle *)circle{
    AuthManager * am = [AuthManager sharedInstance];
    NSString *userId = @"";
    if (am.isAuthenticated) {
        userId = am.userInfo.userId;
    }
    CircleManager *cm = [[CircleManager alloc]init];
    [cm praiseCirclePostWithCircle:circle.circleId UserId:userId Success:^(CommonResult *result) {
        OlaCircle *circle = _circleFrame.result;
        int praiseNumber;
        if([circle.isPraised isEqualToString:@"1"]){
            circle.isPraised = @"0";
            praiseNumber = [circle.praiseNumber intValue]-1;
        }else{
            circle.isPraised = @"1";
            praiseNumber = [circle.praiseNumber intValue]+1;
        }
        circle.praiseNumber = [NSString stringWithFormat:@"%d",praiseNumber];
        _circleFrame.result = circle;
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
        
        shareButtonTitleArray = @[@"微信好友",@"微信朋友圈",@"新浪微博",@"QQ好友",@"QQ空间"];
        shareButtonImageNameArray = @[@"wechat",@"wetimeline",@"sina",@"qq",@"qzone"];
        
        ShareSheetView *lxActivity = [[ShareSheetView alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" ShareButtonTitles:shareButtonTitleArray withShareButtonImagesName:shareButtonImageNameArray];
        [lxActivity showInView:self.view];
    }
}

-(void) didClickComment:(OlaCircle *)circle{
    AuthManager *am = [AuthManager sharedInstance];
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

}

-(void)showMediaContent:(Comment *)comment{
    if (comment.videoUrls&&![comment.videoUrls isEqualToString:@""]) {
        NSURL *url = [NSURL URLWithString:[BASIC_Movie_URL stringByAppendingString:comment.videoUrls]];
        JRPlayerViewController *playerVC = [[JRPlayerViewController alloc] initWithHTTPLiveStreamingMediaURL:url];
        playerVC.mediaTitle = @"名师讲解";
        [self presentViewController:playerVC animated:YES completion:nil];
    }
}

-(void)customProgressDidTapWithPlayState:(PlayState)state andWithUrl:(NSString *)urlString
{
    //如果两次点击url 不是同一个url
    if(![urlString isEqualToString:self.currentUrl])
    {
        if (self.currentUrl) {
            for (NSInteger i = 0; i < self.dataArray.count;i++) {
                
                CommentFrame * m = self.dataArray[i];
                Comment *comment = m.comment;
                
                if ([comment.urlString isEqualToString:self.currentUrl]) {
                    
                    //如何清空数据.. 通过获取数据源 修改数据源的数据 来清空timer..
                    comment.currentPalyTime = 0;
                    comment.isReset = YES;
                    comment.currentState = Stop;
                    
                    [self.tableView reloadData];
                    
                    if ([[LCAudioManager manager] isPlaying]) {
                        [[LCAudioManager manager] stopPlaying];
                    }
                    
                    break;
                    
                }
            }
        }
    }
    
    //记录上一次播放的状态..
    self.currentUrl = urlString;
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
