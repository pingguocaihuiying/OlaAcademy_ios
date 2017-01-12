//
//  HomeManager.m
//  mxedu
//
//  Created by 田晓鹏 on 16/8/17.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "HomeManager.h"

#import "SysCommon.h"

@implementation HomeManager

/**
 *  首页数据
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchHomePageListWithUserId:(NSString*)userId
                           Success:(void(^)(HomeListResult *result))success
                        Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.homeListResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    // 采用post方式，get方式可能产生中文乱码
    [om postObject:nil path:@"/ola/home/getHomeList" parameters:@{@"userId":userId}
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[HomeListResult class]]) {
                   HomeListResult *result = mappingResult.firstObject;
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
