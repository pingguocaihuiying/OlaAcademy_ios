//
//  WatchRecordManager.h
//  mxedu
//
//  Created by 田晓鹏 on 17/1/13.
//  Copyright © 2017年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CommonResult.h"

@interface WatchRecordManager : NSObject

/**
 *  更新视频观看记录
 *
 *  @param type 1 course 2 goods
 *  @param currentIndex 课程或精品课中的第几个视频
 *  @param duration 时长 秒为单位
 */
-(void)recordPlayProgressWithUserId:(NSString*)userId
                           ObjectId:(NSString*)objectId
                               Type:(NSString*)type
                       CurrentIndex:(NSString*)currentIndex
                           Duration:(NSString*)duration
                            Success:(void(^)(CommonResult *result))success
                            Failure:(void(^)(NSError* error))failure;

@end
