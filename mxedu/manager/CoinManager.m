//
//  CoinManager.m
//  mxedu
//
//  Created by 田晓鹏 on 16/10/19.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "CoinManager.h"

#import "SysCommon.h"

@implementation CoinManager

/**
 *  欧拉币明细列表
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchCoinHistoryListWithUserId:(NSString*)userId
                              Success:(void(^)(CoinHistoryListResult *result))success
                              Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.coinHistoryListResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    // 采用post方式，get方式可能产生中文乱码
    [om postObject:nil path:@"/ola/coin/getHistoryList"
        parameters:@{
                     @"userId": userId,
                     }
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[CoinHistoryListResult class]]) {
                   CoinHistoryListResult *result = mappingResult.firstObject;
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
