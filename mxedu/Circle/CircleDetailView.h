//
//  CircleDetailView.h
//  mxedu
//
//  Created by 田晓鹏 on 16/7/7.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OlaCircle.h"

@class CircleFrame;
@class User;

@protocol CircleViewDelegate <NSObject>

-(void)didClickUserAvatar:(User*)userInfo;

- (void)didClickLove:(OlaCircle*)circle;
- (void)didClickShare:(OlaCircle*)circle;
- (void)didClickComment:(OlaCircle*)circle;

@end

@interface CircleDetailView : UIView

/**头像*/
@property (nonatomic, weak) UIImageView *iconView;
/**昵称*/
@property (nonatomic, weak) UILabel *nameLabel;
/**标题*/
@property (nonatomic, weak) UILabel *titleLabel;
/**浏览*/
@property (nonatomic, weak) UILabel *visitLabel;
/**时间*/
@property (nonatomic, weak) UILabel *timeLabel;
/**正文*/
@property (nonatomic, weak) UILabel *textlabel;

/**图片集合*/
@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *imageArray;

@property (nonatomic,retain) NSString *circleType;

@property (nonatomic,retain) UIButton *praiseBtn;

@property (nonatomic,retain) UIView *toolBar;

/**frame模型*/
@property (nonatomic,strong) CircleFrame *statusFrame;

@property (nonatomic) id<CircleViewDelegate> delegate;

@end
