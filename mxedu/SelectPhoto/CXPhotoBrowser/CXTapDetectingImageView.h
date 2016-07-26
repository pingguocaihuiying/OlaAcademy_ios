//
//  CXTapDetectingImageView.h
//  CXPhotoBrowserDemo
//
//  Created by ChrisXu on 13/4/23.
//  Copyright (c) 2013年 QYER. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CXTapDetectingImageViewDelegate;

@interface CXTapDetectingImageView : UIImageView

@property (nonatomic, weak) id <CXTapDetectingImageViewDelegate> tapDelegate;
@property (nonatomic) BOOL isRemoteImage;
@property (nonatomic) BOOL isLoading;
- (void)handleSingleTap:(UITouch *)touch;
- (void)handleDoubleTap:(UITouch *)touch;
- (void)handleTripleTap:(UITouch *)touch;

@end

@protocol CXTapDetectingImageViewDelegate <NSObject>
@optional
- (void)imageView:(UIImageView *)imageView singleTapDetected:(UITouch *)touch;
- (void)imageView:(UIImageView *)imageView doubleTapDetected:(UITouch *)touch;
- (void)imageView:(UIImageView *)imageView tripleTapDetected:(UITouch *)touch;
@end