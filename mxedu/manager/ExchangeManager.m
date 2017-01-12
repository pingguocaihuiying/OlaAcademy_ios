//
//  ExchangeManager.m
//  欧拉币兑换
//
//  Created by 田晓鹏 on 16/10/15.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "ExchangeManager.h"

#import "SysCommon.h"

@implementation ExchangeManager


/*
 * 欧拉币解锁题
 * @param type 1 课程 2 模考
 */
-(void)unlockSubjectWithUserId:(NSString*)userId
                      ObjectId:(NSString*)objectId
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
    [om postObject:nil path:@"/ola/exchange/unlockSubject" parameters:@{
                                                                      @"userId":userId,
                                                                      @"objectId": objectId,
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


/*
 * 欧拉币解锁资料
 */
-(void)unlockMaterialWithUserId:(NSString*)userId
                    MaterialId:(NSString*)objectId
                        success:(void (^)(CommonResult *result))success
                        failure:(void (^)(NSError*))failure
{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.commonResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    // 采用post方式，get方式可能产生中文乱码
    [om postObject:nil path:@"/ola/exchange/unlockMaterial" parameters:@{
                                                                    @"userId":userId,
                                                                    @"materialId": objectId
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
