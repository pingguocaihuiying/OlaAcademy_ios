//
//  CommentAudioView.m
//  mxedu
//
//  Created by 田晓鹏 on 16/12/3.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "CommentAudioView.h"

#import <AVFoundation/AVFoundation.h>
#import "Masonry.h"
#import "SysCommon.h"
#import "mediaModel.h"
#import "LCAudioManager.h"
#import "LCAudioRecord.h"
#import "LCAudioPlay.h"


@implementation NSString (TimeString)

+(NSString*)timeStringForTimeInterval:(NSTimeInterval)timeInterval
{
    NSInteger ti = (NSInteger)timeInterval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    
    if (hours > 0)
    {
        return [NSString stringWithFormat:@"%02li:%02li:%02li", (long)hours, (long)minutes, (long)seconds];
    }
    else
    {
        return  [NSString stringWithFormat:@"%02li:%02li", (long)minutes, (long)seconds];
    }
}

@end

@interface CommentAudioView()<AVAudioPlayerDelegate>

@end

@implementation CommentAudioView
{
    //Recording
    AVAudioRecorder *_audioRecorder;
    NSString *_recordingFilePath;
    NSString *_fileName;
    CADisplayLink *meterUpdateDisplayLink;
    UILabel *recordingTime;
    UIImageView *recordBG;
    
    //Playing
    AVAudioPlayer *_audioPlayer;
    CADisplayLink *playProgressDisplayLink;
    
    UIButton *_recordButton;
    UIButton *_playButton;
    UIButton *_trashButton;
    UIBarButtonItem *_pauseButton;
    
    NSString *_oldSessionCategory;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupRecording];
        [self startUpdatingMeter];
    }
    return self;
}

-(void)setupRecording{
    //Unique recording URL 录音
    _fileName = [[NSProcessInfo processInfo] globallyUniqueString];
    
    {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.layer.cornerRadius = GENERAL_SIZE(20);
        _playButton.layer.masksToBounds = YES;
        _playButton.backgroundColor = RGBCOLOR(187,222,251);
        [_playButton setImage:[UIImage imageNamed:@"ic_broadcasting"] forState:UIControlStateNormal];
        [_playButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -GENERAL_SIZE(10), 0.0, 0.0)];
        [_playButton setTitleColor:RGBCOLOR(88, 147, 244) forState:UIControlStateNormal];
        _playButton.titleLabel.font = LabelFont(24);
        [_playButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_playButton];
        
        [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.centerX.equalTo(self).offset(-GENERAL_SIZE(70));
            make.width.equalTo(@(GENERAL_SIZE(130)));
            make.height.equalTo(@(GENERAL_SIZE(60)));
        }];
        
        _trashButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _trashButton.layer.borderWidth = 1.0f;
        _trashButton.layer.borderColor = [RGBCOLOR(217, 217, 217) CGColor];
        _trashButton.layer.cornerRadius = GENERAL_SIZE(30);
        _trashButton.layer.masksToBounds = YES;
        [_trashButton setTitle:@"重录" forState:UIControlStateNormal];
        [_trashButton setTitleColor:RGBCOLOR(83, 83,83) forState:UIControlStateNormal];
        _trashButton.titleLabel.font = LabelFont(24);
        [_trashButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_trashButton];
        
        [_trashButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.centerX.equalTo(self).offset(GENERAL_SIZE(70));
            make.width.equalTo(@(GENERAL_SIZE(130)));
            make.height.equalTo(@(GENERAL_SIZE(60)));
        }];
        
        _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordButton setImage:[UIImage imageNamed:@"ic_record_start"] forState:UIControlStateNormal];
        [_recordButton sizeToFit];
        [_recordButton addTarget:self action:@selector(recordingButtonAction:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_recordButton];
        
        [_recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        
        recordBG = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_recordingt_time"]];
        [self addSubview:recordBG];
        
        [recordBG mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_recordButton.mas_right).offset(-10);
            make.bottom.equalTo(_recordButton.mas_top).offset(GENERAL_SIZE(36));
        }];
        
        recordingTime = [[UILabel alloc]init];
        recordingTime.textColor = [UIColor whiteColor];
        recordingTime.textAlignment = NSTextAlignmentCenter;
        recordingTime.font = LabelFont(24);
        [recordBG addSubview:recordingTime];
        
        [recordingTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(recordBG);
            make.centerY.equalTo(recordBG).offset(-2);
        }];
        
        
        _playButton.hidden = YES;
        _trashButton.hidden = YES;
        recordBG.hidden = YES;
    }
    
}

-(void)startUpdatingMeter
{
    [meterUpdateDisplayLink invalidate];
    meterUpdateDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMeters)];
    [meterUpdateDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

-(void)stopUpdatingMeter
{
    [meterUpdateDisplayLink invalidate];
    meterUpdateDisplayLink = nil;
}


// 录音
- (void)recordingButtonAction:(UIButton *)item
{
    if ([LCAudioManager manager].isRecording == NO)
    {
        [_recordButton setImage:[UIImage imageNamed:@"ic_record_finish"] forState:UIControlStateNormal];
        
        //UI Update
        {
            _playButton.hidden = YES;
            _trashButton.hidden = YES;
            _recordButton.hidden = NO;
            recordBG.hidden = NO;
        }
        
        //开始录音
        [[LCAudioManager manager]startRecordingWithFileName:_fileName completion:^(NSError *error) {
            _audioRecorder = [LCAudioRecord sharedInstance].recorder;
            _audioRecorder.meteringEnabled = YES;
        }];
        
        if (_delegate) {
            [_delegate clearMediaData]; //清除图片及视频数据
        }
    }
    else
    {
        [_recordButton setImage:[UIImage imageNamed:@"ic_record_start"] forState:UIControlStateNormal];
        _recordButton.hidden = NO;
        
        //UI Update
        {
            _playButton.hidden = NO;
            _trashButton.hidden = NO;
            _recordButton.hidden = YES;
            recordBG.hidden = YES;
        }
        
        [[LCAudioManager manager]stopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
            _recordingFilePath = recordPath;
            [_playButton setTitle:recordingTime.text forState:UIControlStateNormal];
            // 用于上传服务器
            mediaModel *audioModel = [[mediaModel alloc] init];
            audioModel.type = @"2";
            audioModel.timeLong = recordingTime.text;
            audioModel.localpath = _recordingFilePath;
            audioModel.image = [UIImage imageNamed:@"ic_audio"];
            audioModel.isExit=NO;
            
            if (_delegate) {
                [_delegate updateDataSource:audioModel]; //返回音频数据
            }
        }];
    }
}

// 播放
- (void)playAction:(UIButton *)item
{
    if (![LCAudioManager manager].isPlaying) {
        
        [[LCAudioManager manager]playingWithRecordPath:_recordingFilePath completion:^(NSError *error) {
            _recordButton.enabled = YES;
            _trashButton.enabled = YES;
        }];
        _audioPlayer = [LCAudioPlay sharedInstance].player;
        //UI Update
        {
            _recordButton.enabled = NO;
            _trashButton.enabled = NO;
        }
        
        //Start regular update
        {
            [_playButton setTitle:[NSString timeStringForTimeInterval:(_audioPlayer.duration-_audioPlayer.currentTime)] forState:UIControlStateNormal];
            
            [playProgressDisplayLink invalidate];
            playProgressDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updatePlayProgress)];
            [playProgressDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        }
    }else{
        
        //UI Update
        {
            _recordButton.enabled = YES;
            _trashButton.enabled = YES;
        }
        
        {
            [playProgressDisplayLink invalidate];
            playProgressDisplayLink = nil;
        }
        [[LCAudioManager manager]stopPlaying];
        
        [_playButton setTitle:recordingTime.text forState:UIControlStateNormal];
    }
}

-(void)deleteAction
{
    if (_recordingFilePath) {
        [[NSFileManager defaultManager] removeItemAtPath:_recordingFilePath error:nil];
        _recordingFilePath = nil;
        
        _recordButton.hidden = NO;
        _playButton.hidden = YES;
        _trashButton.hidden = YES;
    }
}

#pragma mark - Update Meters

- (void)updateMeters
{
    if(_audioRecorder){
        [_audioRecorder updateMeters];
        
        if (_audioRecorder.isRecording)
        {
            recordingTime.text = [NSString timeStringForTimeInterval:_audioRecorder.currentTime];
        }
    }
}

#pragma mark - Update Play Progress

-(void)updatePlayProgress
{
    [_playButton setTitle:[NSString timeStringForTimeInterval:(_audioPlayer.duration-_audioPlayer.currentTime)] forState:UIControlStateNormal];
}


#pragma mark - AVAudioPlayerDelegate
/*
 Occurs when the audio player instance completes playback
 */
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
    [_playButton setTitle:recordingTime.text forState:UIControlStateNormal];
}


-(void)dealloc{
    [self stopUpdatingMeter];
}


@end
