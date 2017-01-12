//
//  AttentionManager.m
//  关注（好友）
//
//  Created by 田晓鹏 on 16/9/22.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "AttentionManager.h"

#import "SysCommon.h"

@implementation AttentionManager

/*
 * 关注／取消关注
 * @param type 1 关注 2 取消
 */
-(void)attendOtherWithUserId:(NSString*)attendId
                  AttendedId:(NSString*)attednedId
                        Type:(NSString*)type
                     success:(void (^)(CommonResult *result))success
                     failure:(void (^)(NSError*))failure
{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.commonResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    // 采用post方式，get方式可能产生中文乱码
    [om postObject:nil path:@"/ola/attention/attendUser" parameters:@{
                                                                @"attendId":attendId,
                                                                @"attednedId": attednedId,
                                                                @"type": type
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
