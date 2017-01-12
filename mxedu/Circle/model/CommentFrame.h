//
//  CommentFrame.h
//  mxedu
//
//  Created by 田晓鹏 on 16/11/29.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Comment;

@interface CommentFrame : NSObject

/**头像frame*/
@property (nonatomic, assign) CGRect iconFrame;
/**昵称frame*/
@property (nonatomic, assign) CGRect nameFrame;
/**视频frame*/
@property (nonatomic, assign) CGRect mediaFrame;
/**正文frame*/
@property (nonatomic, assign) CGRect textFrame;
/**图片frame*/
@property (nonatomic, assign) CGRect imageFrame;
/**点赞frame*/
@property (nonatomic, assign) CGRect praiseFrame;
/**时间frame*/
@property (nonatomic, assign) CGRect timeFrame;

/**自定义cell的高度*/
@property (nonatomic,assign) CGFloat cellHeight;

/**模型数据*/
@property (nonatomic,strong) Comment *comment;

@end
