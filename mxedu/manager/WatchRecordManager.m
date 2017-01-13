

//
//  WatchRecordManager.m
//  mxedu
//
//  Created by 田晓鹏 on 17/1/13.
//  Copyright © 2017年 田晓鹏. All rights reserved.
//

#import "WatchRecordManager.h"

#import "SysCommon.h"

@implementation WatchRecordManager

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
                       Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.commonResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    // 采用post方式，get方式可能产生中文乱码
    [om postObject:nil path:@"/ola/watchrecord/recordPlayProgress" parameters:@{
                                                                        @"userId": userId,
                                                                        @"objectId": objectId,
                                                                        @"type": type,
                                                                        @"currentIndex": currentIndex,
                                                                        @"duration": duration
                                                                            }
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[CommonResult class]]) {
                   CommonResult *result = mappingResult.firstObject;
                   if (success != nil) {
                       success(result);
                   }
               }
               
           }
           failure:^(RKObjectRequestOperation *operation, NSError *error) {
               if (failure != nil) {
                   failure(error);
               }
           }];
    
}

@end
