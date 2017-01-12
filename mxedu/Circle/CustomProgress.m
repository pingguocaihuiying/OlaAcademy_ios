
//
//  CustomProgress.m
//  WisdomPioneer
//
//  Created by 主用户 on 16/4/11.
//  Copyright © 2016年 江萧. All rights reserved.
//

#import "CustomProgress.h"
#import "LCAudioManager.h"
#import "AFSoundPlayback.h"

#import "HSDownloadManager.h"



@interface CustomProgress()

@property (nonatomic,strong) NSTimer * timer;
//动画
@property (nonatomic, strong) UIImageView *messageVoiceStatusImageView;


@property (nonatomic,strong) UIActivityIndicatorView * indicatorview;


//记录当前正在播放的 和timer
@property (nonatomic,strong) NSMutableDictionary * cacheRecordDict;

@end

@implementation CustomProgress
@synthesize bgimg,leftimg,presentlab;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        bgimg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        bgimg.layer.borderColor = [UIColor clearColor].CGColor;
        bgimg.layer.borderWidth =  1;
        bgimg.layer.cornerRadius = self.frame.size.height/2;
        [bgimg.layer setMasksToBounds:YES];

        [self addSubview:bgimg];
        leftimg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, self.frame.size.height)];
        leftimg.layer.borderColor = [UIColor clearColor].CGColor;
        leftimg.layer.borderWidth =  1;
        leftimg.layer.cornerRadius = self.frame.size.height/2;
        [leftimg.layer setMasksToBounds:YES];
        [self addSubview:leftimg];
        
        presentlab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-15, self.frame.size.height)];
        presentlab.textAlignment = NSTextAlignmentRight;
        
        presentlab.textColor = [UIColor whiteColor];
        presentlab.font = [UIFont systemFontOfSize:15];
        [self addSubview:presentlab];

        //添加动画
        self.messageVoiceStatusImageView.frame = CGRectMake(10, GENERAL_SIZE(20), GENERAL_SIZE(40), GENERAL_SIZE(40));
        [self addSubview:self.messageVoiceStatusImageView];
        
        
        //添加转菊花
        self.indicatorview.frame = CGRectMake(self.frame.size.width - 25, GENERAL_SIZE(20), GENERAL_SIZE(40), GENERAL_SIZE(40));
        
        [self addSubview:self.indicatorview];
        
        self.indicatorview.hidden = YES;
        
        
        self.sdmodel.currentState = Stop;
        //给自己添加tap 事件
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beginOrStop)];
        
        [self addGestureRecognizer:tapGesture];
        
    }
    return self;
}



-(void)initRecordFrom
{
    //判定是否存在该文件。 并且要判定 文件大小是否相等..
    if ([HSDownloadManager isExistFile:self.sdmodel.urlString]) {
        
        //播放本地音频文件..
        NSString * localPath = [HSDownloadManager getLocalPathFromUrl:self.sdmodel.urlString];
        self.sdmodel.type = LOCAL;
        self.sdmodel.recordPath = localPath;
        CGFloat duration = [LCAudioManager durationWithAudio:[NSURL fileURLWithPath:localPath]];
        self.maxValue = duration;
        
    }
    else
    {
        
        self.sdmodel.type = NETWORK;
        
    }
    
    if (self.sdmodel.type == LOCAL) {
        self.sdmodel.fileState = Ready;
    }
    else{
        //如果正在是正在下载的状态 保持状态不变..
        if (self.sdmodel.fileState == Downloading) {
             self.sdmodel.fileState = Downloading;
        }
        else
        {
            self.sdmodel.fileState = NeedDown;
        }
    }
}


//开始或者暂停
-(void)beginOrStop
{
    

    
    if(self.sdmodel.currentState == Stop || self.sdmodel.currentState == Paused)
    {
        __weak typeof(self) wself = self;
        //判断播放的方式
        if (self.sdmodel.type == LOCAL) {
            //播放本地音频

            self.userInteractionEnabled = YES;
            //结束转菊花
            self.indicatorview.hidden = YES;
            //开始转菊花
            [self.indicatorview stopAnimating];
            
            //使用自定义timer 来计数..
        
            NSLog(@"%@",self.sdmodel.recordPath);
          
            
            if ([self.delegate respondsToSelector:@selector(customProgressDidTapWithPlayState:andWithUrl:)]) {
                [self.delegate customProgressDidTapWithPlayState:Playing andWithUrl:self.sdmodel.urlString];
            }
            
            [[LCAudioManager manager]playingWithRecordPath:self.sdmodel.recordPath atTime:self.sdmodel.currentPalyTime  completion:^(NSError *error) {
               
                if ([self.delegate respondsToSelector:@selector(customProgressDidTapWithPlayState:andWithUrl:)]) {
                    [self.delegate customProgressDidTapWithPlayState:Stop andWithUrl:self.sdmodel.urlString];
                }
                
                [wself stop];
            }];

            [self playing];
            
            
            //点击的时候要调用代理。更新状态

        }
        else
        {
            if (self.sdmodel.fileState == NeedDown) {

                wself.sdmodel.fileState = Downloading;
                
                self.indicatorview.hidden = NO;
                //开始转菊花
                [self.indicatorview startAnimating];
                
                self.userInteractionEnabled = NO;
                
                if ([self.delegate respondsToSelector:@selector(customProgressDidTapWithPlayState:andWithUrl:)]) {
                    [self.delegate customProgressDidTapWithPlayState:Playing andWithUrl:self.sdmodel.urlString];
                }
 
                //需要提示用户等待..
                [[HSDownloadManager sharedInstance]download:self.sdmodel.urlString progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
                 
                    //下载到本地..
                    
                    NSLog(@"download progress = %lf",progress);
                    
                } state:^(DownloadState state) {
                    
                    if (state == DownloadStateCompleted) {
                        
                        
                        wself.sdmodel.fileState = Ready;

                        NSString * recordPath = [HSDownloadManager getLocalPathFromUrl:wself.sdmodel.urlString];
                        //下载完成标志成本地
                        wself.sdmodel.type = LOCAL;
                        wself.sdmodel.recordPath =recordPath;
                        
                        CGFloat duration = [LCAudioManager durationWithAudio:[NSURL fileURLWithPath:recordPath]];
                        wself.maxValue = duration;

                        NSLog(@"%@",[NSThread currentThread]);
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [wself stop];
                            
                            self.userInteractionEnabled = YES;
                            //结束转菊花
                            self.indicatorview.hidden = YES;
                            //开始转菊花
                            [self.indicatorview stopAnimating];

                            
                            
                            //判断当前是否已经有在播放的音频，如果有，下载完成以后不播放
                            if (![LCAudioManager manager].isPlaying) {
                                if ([self.delegate respondsToSelector:@selector(customProgressDidTapWithPlayState:andWithUrl:)]) {
                                    [self.delegate customProgressDidTapWithPlayState:Playing andWithUrl:self.sdmodel.urlString];
                                }
                                
                                [wself playing];

                            }

                        });

                        if (![LCAudioManager manager].isPlaying) {
                            //如果完成下载 开始播放..
                            [[LCAudioManager manager]playingWithRecordPath:recordPath atTime:wself.sdmodel.currentPalyTime completion:^(NSError *error) {
                                
                                //播放完成执行的事件..
                                [wself stop];
                                
                                if ([self.delegate respondsToSelector:@selector(customProgressDidTapWithPlayState:andWithUrl:)]) {
                                    [self.delegate customProgressDidTapWithPlayState:Stop andWithUrl:self.sdmodel.urlString];
                                }

                            }];
                        }
  
                    }
                }];
            }
            else if(self.sdmodel.fileState == Downloading)
            {
                self.userInteractionEnabled = YES;

                wself.sdmodel.fileState = NeedDown;
                
                //暂停这个任务..
                [[HSDownloadManager sharedInstance]download:self.sdmodel.urlString progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
                    NSLog(@"download progress = %lf",progress);
                    
                } state:^(DownloadState state) {
                    
                    if (state == DownloadStateSuspended) {
                     
                    }
                }];
   
                return;
            }
            else{
                
                [self playing];
                NSString * recordPath = [HSDownloadManager getLocalPathFromUrl:self.sdmodel.urlString];
                [[LCAudioManager manager]playingWithRecordPath:recordPath completion:^(NSError *error) {
                    [wself stop];
                }];

            }

            
            //使用网络播放..
//            _playBlack = [[AFSoundPlayback alloc] initWithItem:self.sdmodel.soundItem];
//            [_playBlack play];
//
//         
//            [self.playBlack listenFeedbackUpdatesWithBlock:^(AFSoundItem *item) {
//                NSLog(@"Item duration: %ld - time elapsed: %ld", (long)item.duration, (long)item.timePlayed);
//                if (item.timePlayed > 0  && item.timePlayed <= 1) {
//                    self.messageVoiceStatusImageView.highlighted = YES;
//                    [self.messageVoiceStatusImageView startAnimating];
//                }
//               
//                self.maxValue = item.duration;
//                self.currentIndex = item.timePlayed;
//                [self setPresent: self.currentIndex];
//                
//            } andFinishedBlock:^{
//                
//                self.messageVoiceStatusImageView.highlighted = NO;
//                [self.messageVoiceStatusImageView stopAnimating];
//                self.currentState = Paused;
//                [self pause];
//            }];
        }
        
        if ([self.delegate respondsToSelector:@selector(customProgressDidTapWithPlayState:andWithUrl:)]) {
            [self.delegate customProgressDidTapWithPlayState:Playing andWithUrl:self.sdmodel.urlString];
        }
        
      
       
    }
    else{
        
        self.userInteractionEnabled = YES;
        
        //结束转菊花
        self.indicatorview.hidden = YES;
        //开始转菊花
        [self.indicatorview stopAnimating];
        
        if (self.sdmodel.type == LOCAL) {
            [[LCAudioManager manager] stopPlaying];
        }
        else{
            
        }

        self.messageVoiceStatusImageView.highlighted = NO;
        [self.messageVoiceStatusImageView stopAnimating];
        self.sdmodel.currentState = Paused;
        [self pause];
        
        //调用方法提示是 暂停状态..
        if ([self.delegate respondsToSelector:@selector(customProgressDidTapWithPlayState:andWithUrl:)]) {
            [self.delegate customProgressDidTapWithPlayState:Paused andWithUrl:self.sdmodel.urlString];
        }

        
    }
    
}

-(void)playing
{
    self.sdmodel.currentState = Playing;
    self.messageVoiceStatusImageView.highlighted = YES;
    self.messageVoiceStatusImageView.hidden = NO;
    [self.messageVoiceStatusImageView startAnimating];
    [self began];
}



//开始..
-(void)began
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(BeginCount) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}

//开始计时的函数
-(void)BeginCount
{
    self.sdmodel.currentPalyTime++;
    if (self.sdmodel.currentPalyTime<=self.maxValue) {
        [self setPresent:self.sdmodel.currentPalyTime];
    }
    else{
        self.sdmodel.currentPalyTime =0 ;
        [self setPresent:self.sdmodel.currentPalyTime];
        [self.timer invalidate];
        self.timer = nil;
        
    }
}

//暂停
-(void)pause
{
    [self.timer invalidate];
    self.timer = nil;
}

//停止
-(void)stop
{
    self.sdmodel.currentPalyTime = 0;
    [self setPresent:self.sdmodel.currentPalyTime];
    [self.timer invalidate];
    self.timer = nil;
    
    //
    
    //停止动画
    self.sdmodel.currentState = Stop;

    self.messageVoiceStatusImageView.highlighted = NO;
    [self.messageVoiceStatusImageView stopAnimating];
    
 

}


-(void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
}

-(void)setPresent:(CGFloat)present
{
    //赋值..
    presentlab.text = [self timeFormatted:self.maxValue-present];
    leftimg.frame = CGRectMake(0, 0, self.frame.size.width/self.maxValue*present, self.frame.size.height);
}

- (NSString *)timeFormatted:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

- (UIImageView *)messageVoiceStatusImageView {
    if (!_messageVoiceStatusImageView) {
        _messageVoiceStatusImageView = [[UIImageView alloc] init];
        _messageVoiceStatusImageView.image = [UIImage imageNamed:@"message_voice_receiver_normal"] ;
        UIImage *image1 = [UIImage imageNamed:@"message_voice_receiver_playing_1"];
        UIImage *image2 = [UIImage imageNamed:@"message_voice_receiver_playing_2"];
        UIImage *image3 = [UIImage imageNamed:@"message_voice_receiver_playing_3"];
        _messageVoiceStatusImageView.highlightedAnimationImages = @[image1,image2,image3];
        _messageVoiceStatusImageView.animationDuration = 1.5f;
        _messageVoiceStatusImageView.animationRepeatCount = NSUIntegerMax;
    }
    return _messageVoiceStatusImageView;
}

-(UIActivityIndicatorView *)indicatorview
{
    if (_indicatorview == nil) {
        
        _indicatorview = [[UIActivityIndicatorView alloc] init];
        _indicatorview.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        
    }
    return _indicatorview;
}


-(void)setSdmodel:(Comment *)sdmodel
{
    _sdmodel = sdmodel;
    
    //初始化参数..
    [self initRecordFrom];
    
    //如果设置了 播放时间为 0 清空计时..
    if (self.sdmodel.isReset) {
        
        [self stop];
        self.sdmodel.isReset = NO;
    }
    
    if (self.sdmodel.currentState == Playing) {
        self.messageVoiceStatusImageView.highlighted = YES;
        self.messageVoiceStatusImageView.hidden = NO;
        [self.messageVoiceStatusImageView startAnimating];
    }
    else
    {
        self.messageVoiceStatusImageView.highlighted = NO;
        [self.messageVoiceStatusImageView stopAnimating];
    }
    
    if (self.sdmodel.fileState == Downloading) {
        self.indicatorview.hidden = NO;
        [self.indicatorview startAnimating];
    }
    else{
        self.indicatorview.hidden = YES;
        [self.indicatorview stopAnimating];
    }
    
  
}

#pragma mark -- 保存字典..
-(NSMutableDictionary *)cacheRecordDict
{
    if (_cacheRecordDict == nil) {
        _cacheRecordDict = [NSMutableDictionary dictionary];
    }
    
    return _cacheRecordDict;
}

@end
