//
//  PlayerManager.h
//  UCloudMediaRecorderDemo
//
//  Created by yisanmao on 16/1/4.
//  Copyright © 2016年 zmw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCloudMediaViewController.h"

@interface PlayerManager : NSObject
@property(strong, nonatomic) UCloudMediaPlayer *player;
@property(assign, nonatomic) UIInterfaceOrientationMask supportInterOrtation;

@property (strong, nonatomic) UCloudMediaViewController *vc;

@property (assign, nonatomic) BOOL isFullscreen;                             //是否横屏
@property (assign, nonatomic) UIInterfaceOrientation currentOrientation;     //当前屏幕方向

@property (assign, nonatomic) BOOL isPrepared;
@property (assign, nonatomic) CGFloat current;


@property (strong, nonatomic) UIView *view;
@property (strong, nonatomic) UIViewController *viewContorller;

//布局
@property (strong, nonatomic) NSMutableArray *p;
@property (strong, nonatomic) NSMutableArray *l;
@property (strong, nonatomic) NSLayoutConstraint *vcBottomConstraint;
@property (strong, nonatomic) NSLayoutConstraint *playerCenterXContraint;
@property (strong, nonatomic) NSLayoutConstraint *playerHeightContraint;
@property (strong, nonatomic) NSLayoutConstraint *danmuBottomContraint;
@property (strong, nonatomic) NSArray *playerContraints;

/**
 *  是否支持播放器自动旋转(改变设备物理方向，自动改变播放器画面)
 */
@property (assign, nonatomic) BOOL supportAutomaticRotation;
/**
 *  是否支持角度旋转协议(支持表示播放画面会随着推流端旋转而旋转)
 */
@property (assign, nonatomic) BOOL supportAngleChange;

- (void)buildPlayer:(NSString *)path;
- (void)rotateBegain:(UIInterfaceOrientation)noti;
- (void)rotateEnd;
- (void)awakeSupportInterOrtation:(UIViewController *)showVC completion:(void(^)(void))block;
@end
