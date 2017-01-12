//
//  CircleDetailView.h
//  mxedu
//
//  Created by 田晓鹏 on 16/7/7.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OlaCircle.h"
#import "CircleToolbar.h"

@class CircleFrame;

@interface CircleDetailView : UIView

/**头像*/
@property (nonatomic, weak) UIImageView *iconView;
/**昵称*/
@property (nonatomic, weak) UILabel *nameLabel;
/**消息*/
@property (nonatomic, weak) UIButton *messageButton;
/**浏览*/
@property (nonatomic, weak) UIButton *visitButton;
/**时间*/
@property (nonatomic, weak) UILabel *timeLabel;
/**正文*/
@property (nonatomic, weak) UILabel *textlabel;

/**图片集合*/
@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *imageArray;

@property (nonatomic,retain) NSString *circleType;

@property (nonatomic,retain) CircleToolbar *toolBar;

/**frame模型*/
@property (nonatomic,strong) CircleFrame *statusFrame;

@end
