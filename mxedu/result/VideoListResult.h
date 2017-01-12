//
//  VideoListResult.h
//  mxedu
//
//  Created by 田晓鹏 on 15/11/21.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoListResult : NSObject

@property (nonatomic) int code;
@property (nonatomic) NSString *message;
@property (nonatomic) NSString *orderStatus; //是否购买
@property (nonatomic) int isCollect; //是否购买
@property (nonatomic) NSString *playIndex; //上次观看视频序号
@property (nonatomic) NSString *playProgress; //上次观看视频时间
@property (nonatomic) NSArray *videoList;

@end
