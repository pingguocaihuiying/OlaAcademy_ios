//
//  PlayerManager.m
//  UCloudMediaRecorderDemo
//
//  Created by yisanmao on 16/1/4.
//  Copyright © 2016年 zmw. All rights reserved.
//

#import "PlayerManager.h"
#import "UIWindow+YzdHUD.h"

#import "Masonry.h"

#define UISCREEN_WIDTH      MIN([UIApplication sharedApplication].keyWindow.bounds.size.width, [UIApplication sharedApplication].keyWindow.bounds.size.height)
#define UISCREEN_HEIGHT     MAX([UIApplication sharedApplication].keyWindow.bounds.size.width, [UIApplication sharedApplication].keyWindow.bounds.size.height)

#define UI_STATUS_BAR_HEIGHT 20

#define AlertViewSaveSucess 101
#define AlertViewPlayerError 102

@interface PlayerManager()<UCloudPlayerUIDelegate>
@property (strong, nonatomic) NSArray *contrants;
@end

@implementation PlayerManager
- (void)buildPlayer:(NSString *)path
{
    [self addNotification];
    
    NSURL *theMovieURL = [NSURL URLWithString:path];
    self.player = [[UCloudMediaPlayer alloc] init];
    [self.player setUrl:theMovieURL];
    
    __weak PlayerManager *weakSelf = self;
    [self.player showInview:self.view definition:^(NSInteger defaultNum, NSArray *data) {
        
        [weakSelf buildMediaControl:defaultNum data:data];
        [weakSelf configurePlayer];

    }];
}

- (void)dealloc
{
    [self removeNotification];
}

- (void)configurePlayer
{
    
    self.vc.view.autoresizingMask = UIViewAutoresizingNone;
    
//    [self.player.player.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
//    }];
//    [self.vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
//    }];

    NSMutableArray *cons = [NSMutableArray array];
    self.p = [NSMutableArray array];
    self.l = [NSMutableArray array];
    [self addConstraintForView:self.player.player.view inView:self.view constraint:cons p:self.p l:self.l];
    
    self.playerContraints = [NSArray arrayWithArray:cons];
    self.vcBottomConstraint = [self addConstraintForView:self.vc.view inView:self.view constraint:nil];
}

- (void)addConstraintForView:(UIView *)subView inView:(UIView *)view constraint:(NSMutableArray *)contraints p:(NSMutableArray *)p l:(NSMutableArray *)l
{
    //使用Auto Layout约束，禁止将Autoresizing Mask转换为约束
    [subView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSLayoutConstraint *contraint1 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    
    NSLayoutConstraint *contraint2 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    
    NSLayoutConstraint *contraint3 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
    NSLayoutConstraint *contraint4 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0];
    
    NSLayoutConstraint *contraint5 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0];
    NSLayoutConstraint *contraint6 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
    
    NSArray *array = [NSArray arrayWithObjects:contraint1, contraint2, contraint3, contraint4, contraint5, contraint6, nil];
    
    if (contraints)
    {
        [contraints addObjectsFromArray:array];
    }
    if (p)
    {
        [p addObjectsFromArray:@[contraint3, contraint4]];
    }
    if (l)
    {
        [l addObjectsFromArray:@[contraint5, contraint6]];
    }
    
    //把约束添加到父视图上
    [view addConstraints:array];
    
    self.contrants = @[contraint5,contraint6];
    [view removeConstraints:self.contrants];
    
    self.playerCenterXContraint = contraint2;
    self.playerHeightContraint = contraint4;
}

- (NSLayoutConstraint *)addConstraintForView:(UIView *)subView inView:(UIView *)view constraint:(NSMutableArray *)contraints
{
    //使用Auto Layout约束，禁止将Autoresizing Mask转换为约束
    [subView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSLayoutConstraint *contraint1 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    
    NSLayoutConstraint *contraint2 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
    
    NSLayoutConstraint *contraint3 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-0.0];
    //子view的右边缘离父view的右边缘40个像素
    NSLayoutConstraint *contraint4 = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1.0 constant:-0.0];
    //把约束添加到父视图上
    NSArray *array = [NSArray arrayWithObjects:contraint1, contraint2, contraint3, contraint4, nil];
    
    if (contraints)
    {
        [contraints addObjectsFromArray:array];
    }
    [view addConstraints:array];
    
    return contraint3;
}

// 调整画幅大小
- (void)reConfigurePlayer:(CGFloat)current
{
    float height = self.playerHeightContraint.constant;
    float centerX = self.playerCenterXContraint.constant;
    [self.view removeConstraints:@[self.playerCenterXContraint, self.playerHeightContraint]];
    
    self.vc.delegatePlayer = self.player.player;
    
    self.player.player.view.frame = self.vc.view.bounds;
    [self.view addSubview:self.player.player.view];
    
    
    NSMutableArray *cons = [NSMutableArray array];
    self.p = [NSMutableArray array];
    self.l = [NSMutableArray array];
    [self addConstraintForView:self.player.player.view inView:self.view constraint:cons p:self.p l:self.l];
    self.playerHeightContraint.constant = height;
    self.playerCenterXContraint.constant = centerX;
    self.playerContraints = [NSArray arrayWithArray:cons];
    
    self.isPrepared = NO;
    
    [self.view bringSubviewToFront:self.vc.view];
    [self.vc setRightPanelHidden:YES];

}

- (void)buildMediaControl:(NSInteger)defaultNum data:(NSArray *)data
{
    UCloudMediaViewController *vc = [[UCloudMediaViewController alloc] initWithNibName:@"UCloudMediaViewController" bundle:nil];
    self.vc = vc;
    self.vc.center = self.view.center;
    self.vc.defultQingXiDu = defaultNum;
    if (self.player.defaultDecodeMethod == DecodeMthodHard)
    {
        self.vc.defultJieMaQi = 0;
    }
    else if (self.player.defaultDecodeMethod == DecodeMthodSoft)
    {
        self.vc.defultJieMaQi = 1;
    }
    self.vc.urlType = self.player.urlType;
    
    self.vc.defultHuaFu = 2;
    self.player.player.scalingMode = MPMovieScalingModeAspectFit;
    
    self.vc.fileName = @"Test";
    self.vc.movieInfos = data;
    self.vc.view.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
    self.vc.delegateAction = self;
    self.vc.delegatePlayer = self.player.player;
    
    [self.view addSubview:self.vc.view];
}


#pragma mark - 屏幕旋转
- (void)awakeSupportInterOrtation:(UIViewController *)showVC completion:(void(^)(void))block
{
    UIViewController *vc = [[UIViewController alloc] init];
    void(^completion)() = ^() {
        [showVC dismissViewControllerAnimated:NO completion:nil];
        
        if (block)
        {
            block();
        }
    };
    
    // This check is needed if you need to support iOS version older than 7.0
    BOOL canUseTransitionCoordinator = [showVC respondsToSelector:@selector(transitionCoordinator)];
    BOOL animated = YES;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 8.0)
    {
        animated = NO;
    }
    else
    {
        animated = YES;
    }
    if (canUseTransitionCoordinator)
    {
        [showVC presentViewController:vc animated:animated completion:nil];
        [showVC.transitionCoordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            completion();
        }];
    }
    else
    {
        [showVC presentViewController:vc animated:NO completion:completion];
    }
}
//屏幕方向改变
-(void)deviceOrientationChanged:(UIInterfaceOrientation)interfaceOrientation
{
    [self.vc setRightPanelHidden:YES];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        self.view.transform = CGAffineTransformIdentity;
    }
    
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortrait:
        {
            [self turnToPortraint:^{
                
            }];
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:
        {
            [self turnToLeft:^{
                
            }];
        }
            break;
        case UIInterfaceOrientationLandscapeRight:
        {
            [self turnToRight:^{
                
            }];
        }
            break;
        default:
            break;
    }
    
    BOOL shouldChangeFrame = NO;
    if ((UIInterfaceOrientationIsLandscape(interfaceOrientation) && UIInterfaceOrientationIsPortrait(self.currentOrientation)) || (UIInterfaceOrientationIsPortrait(interfaceOrientation) && UIInterfaceOrientationIsLandscape(self.currentOrientation)))
    {
        shouldChangeFrame = YES;
    }
    
    //调整缓冲提示的位置
    if (shouldChangeFrame)
    {
        [self.vc.view.window changeFrame:interfaceOrientation];
    }
    
    //重绘画面
    [self.player refreshView];
}

- (void)rotateBegain:(UIInterfaceOrientation)noti
{
    [self deviceOrientationChanged:noti];
}

- (void)rotateEnd
{
    //重绘画面
    [self.player refreshView];
    [self.vc setRightPanelHidden:NO];
    
    [self.vc refreshProgressView];
}

-(void)turnToPortraint:(void(^)(void))block
{
    self.view.frame = CGRectMake(0, UI_STATUS_BAR_HEIGHT, UISCREEN_WIDTH, UISCREEN_WIDTH*9.0/16.0);
    
    [self.player refreshView];
    self.isFullscreen = NO;
    
    [self.vc hideMenu];
    if (block)
    {
        block();
    }
}

-(void)turnToLeft:(void(^)(void))block
{
    self.view.frame = CGRectMake(0, 0, UISCREEN_HEIGHT, UISCREEN_WIDTH);

    [self.player refreshView];
    self.isFullscreen = YES;
    if (block)
    {
        block();
    }
}

-(void)turnToRight:(void(^)(void))block
{
    self.view.frame = CGRectMake(0, 0, UISCREEN_HEIGHT, UISCREEN_WIDTH);
    
    [self.player refreshView];
    self.isFullscreen = YES;
    if (block)
    {
        block();
    }
}

#pragma mark - save pic
- (void)saveImageToPhotos:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    alert.tag = AlertViewSaveSucess;
    [alert show];
}
static bool showing = NO;
#pragma mark - loading view
- (void)showLoadingView
{
    if (!showing)
    {
        showing = YES;
        
        CGAffineTransform trans = self.view.transform;
        
        [self.vc.view.window showHUDWithText:@"加载中" Type:ShowLoading Enabled:NO transForm:trans];
    }
}

- (void)hideLoadingView
{
    showing = NO;
    CGAffineTransform trans = self.view.transform;
    [self.vc.view.window showHUDWithText:@"加载成功" Type:ShowPhotoYes Enabled:YES transForm:trans];
}

#pragma mark - notification
- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti:) name:UCloudPlaybackIsPreparedToPlayDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti:) name:UCloudPlayerLoadStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti:) name:UCloudMoviePlayerSeekCompleted object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti:) name:UCloudPlayerPlaybackStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti:) name:UCloudPlayerPlaybackDidFinishNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti:) name:UCloudMoviePlayerBufferingUpdate object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rotateEnd) name:UCloudViewControllerDidRotate object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rotateBegain:) name:UCloudViewControllerWillRotate object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti:) name:UCloudPlayerVideoChangeRotationNotification object:nil];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UCloudPlaybackIsPreparedToPlayDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UCloudPlayerLoadStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UCloudMoviePlayerSeekCompleted object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UCloudPlayerPlaybackStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UCloudPlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UCloudMoviePlayerBufferingUpdate object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UCloudViewControllerDidRotate object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UCloudViewControllerWillRotate object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UCloudPlayerVideoChangeRotationNotification object:nil];
}

- (void)noti:(NSNotification *)noti
{
    NSLog(@"%@", noti.name);
    if ([noti.name isEqualToString:UCloudPlaybackIsPreparedToPlayDidChangeNotification])
    {
        [self.vc refreshMediaControl];
        
        if (self.current != 0)
        {
            [self.player.player setCurrentPlaybackTime:self.current];
            self.current = 0;
        }
    }
    else if ([noti.name isEqualToString:UCloudPlayerLoadStateDidChangeNotification])
    {
        if ([self.player.player loadState] == MPMovieLoadStateStalled)
        {
            //网速不好，开始缓冲
            [self showLoadingView];
        }
        else if ([self.player.player loadState] == (MPMovieLoadStatePlayable|MPMovieLoadStatePlaythroughOK))
        {
            //缓冲完毕
            [self hideLoadingView];
        }
    }
    else if ([noti.name isEqualToString:UCloudMoviePlayerSeekCompleted])
    {
        
    }
    else if ([noti.name isEqualToString:UCloudPlayerPlaybackStateDidChangeNotification])
    {
        NSLog(@"backState:%ld", (long)[self.player.player playbackState]);
        if (!self.isPrepared)
        {
            self.isPrepared = YES;
            [self.player.player play];
            
            if (![self.player.player isPlaying])
            {
                [self.vc refreshCenterState];
            }
        }
    }
    else if ([noti.name isEqualToString:UCloudPlayerPlaybackDidFinishNotification])
    {
        MPMovieFinishReason reson = [[noti.userInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] integerValue];
        if (reson == MPMovieFinishReasonPlaybackEnded)
        {
            [self.vc stop];
        }
        else if (reson == MPMovieFinishReasonPlaybackError)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注意" message:@"视频播放错误" delegate:self cancelButtonTitle:@"知道了"   otherButtonTitles: nil, nil];
            alert.tag = AlertViewPlayerError;
            [alert show];
        }
    }
    else if ([noti.name isEqualToString:UCloudPlayerVideoChangeRotationNotification]&& self.supportAngleChange)
    {
    }
}


#pragma mark - mediaControl delegate
- (void)onClickMediaControl:(id)sender
{
    
}

- (void)onClickBack:(UIButton *)sender
{
    if (self.isFullscreen) {
        self.supportInterOrtation = UIInterfaceOrientationMaskPortrait;
        [self awakeSupportInterOrtation:self.viewContorller completion:^() {
            
            [self turnToPortraint:^{
                self.supportInterOrtation = UIInterfaceOrientationMaskAllButUpsideDown;
                [self.player.player play];
                
                //重绘画面
                [self.player refreshView];
            }];
            
        }];
    } else {
        [self.player.player.view removeFromSuperview];
        [self.vc.view removeFromSuperview];
        [self.player.player shutdown];
        self.player = nil;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:UCloudMoviePlayerClickBack object:self];
    }
}

- (void)onClickPlay:(id)sender
{
    [self.player.player play];
}

- (void)onClickPause:(id)sender
{
    [self.player.player pause];
}

- (void)durationSliderTouchBegan:(id)delta
{
    //        [self.player pause];
}

- (void)durationSliderTouchEnded:(id)delta
{
    CGFloat del = self.player.player.duration * [delta floatValue];
    del = self.player.player.currentPlaybackTime + del;
    [self.player.player setCurrentPlaybackTime:floor(del)];
    [self.player.player prepareToPlay];
}

- (void)durationSliderValueChanged:(id)delta
{
    
}

- (void)clickBright:(id)sender
{
    
}

- (void)clickVolume:(id)sender
{
    
}

- (void)clickShot:(id)sender
{
    self.current = [self.player.player currentPlaybackTime];
    UIImage *image = [self.player.player thumbnailImageAtCurrentTime];
    [self saveImageToPhotos:image];
}
/**
 * 解码方式
 */
- (void)selectedDecodeMthod:(DecodeMthod)decodeMthod
{
    self.current = [self.player.player currentPlaybackTime];
    [self.player selectDecodeMthod:decodeMthod];
    [self reConfigurePlayer:0];
    [self.player.player setCurrentPlaybackTime:self.current];
}
/**
 * 清晰度
 */
- (void)selectedDefinition:(Definition)definition
{
    self.current = [self.player.player currentPlaybackTime];
    [self.player selectDefinition:definition];
    [self reConfigurePlayer:0];
    [self.player.player setCurrentPlaybackTime:self.current];
}
/**
 * 画幅大小
 */
- (void)selectedScalingMode:(MPMovieScalingMode)scalingMode
{
    self.player.player.scalingMode = scalingMode;
    [self reConfigurePlayer:0];
}
/**
 * 全屏按钮
 */
- (void)clickFull:(UCoudWebBlock)block
{
    [self.player.player pause];
    
    if(!self.isFullscreen)
    {
        UIDeviceOrientation deviceOr = [UIDevice currentDevice].orientation;
        if (deviceOr == UIInterfaceOrientationLandscapeRight)
        {
            self.supportInterOrtation = UIInterfaceOrientationMaskLandscapeRight;
            [self awakeSupportInterOrtation:self.viewContorller completion:^() {
                
                [self turnToRight:^{
                    self.supportInterOrtation = UIInterfaceOrientationMaskAllButUpsideDown;
                    [self.player.player play];
                    self.currentOrientation = UIInterfaceOrientationLandscapeRight;
                    //重绘画面
                    [self.player refreshView];
                }];
            }];
        }
        else
        {
            self.supportInterOrtation = UIInterfaceOrientationMaskLandscapeLeft;
            [self awakeSupportInterOrtation:self.viewContorller completion:^() {
                
                [self turnToLeft:^{
                    self.supportInterOrtation = UIInterfaceOrientationMaskAllButUpsideDown;
                    [self.player.player play];
                    self.currentOrientation = UIInterfaceOrientationLandscapeLeft;
                    //重绘画面
                    [self.player refreshView];
                }];
            }];
        }
    }
    else
    {
        self.supportInterOrtation = UIInterfaceOrientationMaskPortrait;
        [self awakeSupportInterOrtation:self.viewContorller completion:^() {
            
            [self turnToPortraint:^{
                self.supportInterOrtation = UIInterfaceOrientationMaskAllButUpsideDown;
                [self.player.player play];
                
                //重绘画面
                [self.player refreshView];
            }];
            
        }];
    }
}

- (void)clickDanmu:(BOOL)show
{
    
}

- (void)selectedMenu:(NSInteger)menu choi:(NSInteger)choi
{
    NSLog(@"menu:%ld__choi:%ld", (long)menu, (long)choi);
}

- (BOOL)screenState
{
    return self.isFullscreen;
}

-(NSUInteger)supportInterOrtation
{
    if (self.supportAutomaticRotation)
    {
        return _supportInterOrtation;
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (void)setSupportAutomaticRotation:(BOOL)supportAutomaticRotation
{
    _supportAutomaticRotation = supportAutomaticRotation;
    if (_supportAutomaticRotation)
    {
        [self.vc setFullBtnState:NO];
    }
    else
    {
        [self.vc setFullBtnState:YES];
    }
}

@end
