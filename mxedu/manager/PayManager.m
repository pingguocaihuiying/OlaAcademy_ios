//
//  PayManager.m
//  NTreat
//
//  Created by 田晓鹏 on 16/4/15.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "PayManager.h"

#import "SysCommon.h"

@implementation PayManager

/**
 * 服务器控制是否显示支付相关功能
 */
-(void)fetchPayModuleStatusSuccess:(void(^)(StatusResult*))success
                           Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.statusResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    [om postObject:nil path:@"/ola/pay/showPayModule" parameters:nil
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[StatusResult class]]) {
                   StatusResult *result = mappingResult.firstObject;
                   if (success != nil) {
                       success(result);
                   }
               }
           } failure:^(RKObjectRequestOperation *operation, NSError *error) {
               if (failure != nil) {
                   failure(error);
               }
           }];
}


/**
 * 获取微信支付信息
 */
-(void)fetchPayReqInfoWithUserId:(NSString*)userId
                          Type:(NSString*)type
                       goodsId:(NSString*)goodsId
                        Success:(void(^)(PayReqResult*))success
                        Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.payReqResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    [om postObject:nil path:@"/ola/pay/getWXPayReq" parameters:@{ @"userId" : userId,
                                                                    @"type" : type,
                                                                    @"goodsId" : goodsId
                                                                    }
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[PayReqResult class]]) {
                   PayReqResult *result = mappingResult.firstObject;
                   if (success != nil) {
                       success(result);
                   }
               }
           } failure:^(RKObjectRequestOperation *operation, NSError *error) {
               if (failure != nil) {
                   failure(error);
               }
           }];
}

/**
 * 获取支付宝支付信息
 */
-(void)fetchAliPayInfoWithUserId:(NSString*)userId
                          Type:(NSString*)type
                       goodsId:(NSString*)goodsId
                       Success:(void(^)(AliPayResult*))success
                       Failure:(void(^)(NSError* error))failure{
    
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.aliPayResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    [om postObject:nil path:@"/ola/pay/getAliOrderInfo"parameters:@{   @"userId" : userId,
                                                                       @"type" : type,
                                                                       @"goodsId" : goodsId
                                                                       }
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[AliPayResult class]]) {
                   AliPayResult *result = mappingResult.firstObject;
                   if (success != nil) {
                       success(result);
                   }
               }
           } failure:^(RKObjectRequestOperation *operation, NSError *error) {
               if (failure != nil) {
                   failure(error);
               }
           }];
    
}

@end
