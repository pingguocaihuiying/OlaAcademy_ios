//
//  MaterialManager.m
//  mxedu
//
//  Created by 田晓鹏 on 16/10/29.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "MaterialManager.h"

#import "SysCommon.h"

@implementation MaterialManager

/**
 *  资料列表
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchMaterialListWithMaterialId:(NSString*)materialId
                              PageSize:(NSString*)pageSize
                                  Type:(NSString*)type
                               Success:(void(^)(MaterialListResult *result))success
                               Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.materialListResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    // 采用post方式，get方式可能产生中文乱码
    [om postObject:nil path:@"/ola/material/getMaterialList" parameters:@{
                                                                    @"materialId": materialId,
                                                                    @"pageSize": pageSize,
                                                                    @"type": type
                                                                      }
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[MaterialListResult class]]) {
                   MaterialListResult *result = mappingResult.firstObject;
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

/**
 *  更新浏览量
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)updateBrowseCountWithID:(NSString*)materialId
                       Success:(void(^)(CommonResult *result))success
                       Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.commonResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    // 采用post方式，get方式可能产生中文乱码
    [om postObject:nil path:@"/ola/material/updateBrowseCount" parameters:@{
                                                                    @"materialId": materialId
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
