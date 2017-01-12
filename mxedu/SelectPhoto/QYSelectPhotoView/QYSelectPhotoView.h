//
//  QYSelectPhotoView.h
//  Frank
//
//  Created by Frank on 15/5/20.
//  Copyright (c) 2015年 Frank. All rights reserved.
//

#import <UIKit/UIKit.h>

// add by 田晓鹏
@protocol QYSelectPhotoViewDelegate <NSObject>

-(void)didShowSelectPhoto;

@end

/**
 *  选择图片视图
 */
@interface QYSelectPhotoView : UIView

/**
 *  最大选择图片的张数
 */
@property (nonatomic, assign) NSUInteger maximumNumberOfImages;

/**
 *  最终选择的大图数组
 */
@property (nonatomic, strong) NSArray *photoData;

@property (nonatomic, strong) NSArray *smallphotoData;

@property (nonatomic, strong) NSArray *photoAngle;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, weak) UIViewController* delegate;

@property (nonatomic) BOOL isEnable;

@property (nonatomic) BOOL isHiddenAdd;//是否隐藏掉添加按钮

- (void)reloadData;

- (void)showSelectPhotoView;

@property (nonatomic) id<QYSelectPhotoViewDelegate> photoDelegate;

@end
