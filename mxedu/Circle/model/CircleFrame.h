//
//  WKCellModel.h
//  WKDemo
//
//  Created by wangzhaohui-Mac on 14-8-5.
//  Copyright (c) 2014年 com.app. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class OlaCircle;

@interface CircleFrame : NSObject
/**头像frame*/
@property (nonatomic, assign) CGRect iconFrame;
/**昵称frame*/
@property (nonatomic, assign) CGRect nameFrame;
/**title的frame*/
@property (nonatomic, assign) CGRect titleFrame;
/**浏览按钮frame*/
@property (nonatomic, assign) CGRect visitFrame;
/**时间frame*/
@property (nonatomic, assign) CGRect timeFrame;
/**正文frame*/
@property (nonatomic, assign) CGRect textFrame;
/**图片frame*/
@property (nonatomic, assign) CGRect imageFrame;
/**点赞按钮frame*/
@property (nonatomic, assign) CGRect praiseFrame;
/**工具栏frame*/
@property (nonatomic, assign) CGRect toolFrame;

/**自定义cell的高度*/
@property (nonatomic,assign) CGFloat cellHeigth;

/**模型数据*/
@property (nonatomic,strong) OlaCircle *result;

@end
