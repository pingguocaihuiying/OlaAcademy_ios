//
//  SignInManager.m
//  签到
//
//  Created by 田晓鹏 on 16/9/22.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "SignInManager.h"

#import "SysCommon.h"

@implementation SignInManager

/**
 *  获取签到状态
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchSignInStatusWithUserId:(NSString*)userId
                           Success:(void(^)(SignInStatusResult *result))success
                           Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.signInStatusResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    // 采用post方式，get方式可能产生中文乱码
    [om postObject:nil path:@"/ola/dailyact/getCheckinStatus"
        parameters:@{@"userId": userId
                     }
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[SignInStatusResult class]]) {
                   SignInStatusResult *result = mappingResult.firstObject;
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
 * 签到
 */
-(void)signInWithUserId:(NSString*)userId
                success:(void (^)(CommonResult *result))success
                failure:(void (^)(NSError*))failure
{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.commonResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    // 采用post方式，get方式可能产生中文乱码
    [om postObject:nil path:@"/ola/dailyact/checkin" parameters:@{@"userId": userId
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
 * 分享送欧拉币
 */
-(void)shareWithUserId:(NSString*)userId
                success:(void (^)(CommonResult *result))success
                failure:(void (^)(NSError*))failure
{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.commonResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    // 采用post方式，get方式可能产生中文乱码
    [om postObject:nil path:@"/ola/dailyact/dailyShare" parameters:@{@"userId": userId
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
