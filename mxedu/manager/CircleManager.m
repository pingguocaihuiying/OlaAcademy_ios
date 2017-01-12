//
//  CircleManager.m
//  mxedu
//
//  Created by 田晓鹏 on 16/7/5.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "CircleManager.h"

#import "SysCommon.h"
#import "DataMappingManager.h"

@implementation CircleManager

-(void)addOlaCircleWithUserId:(NSString*)userId
                       Title:(NSString*)title
                     content:(NSString*)content
                   imageGids:(NSString*)imageGids
                   assignUser:(NSString*)assignUser
                     isPublic:(NSString*)isPublic
                   Location:(NSString*)location
                        Type:(NSString*)type
                Success:(void(^)(CommonResult *result))success
                Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.commonResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    [om postObject:nil path:@"/ola/circle/addOlaCircle" parameters:@{@"userId" : userId,
                                                                     @"title" : title,
                                                                     @"content":content,
                                                                     @"isPublic":isPublic,
                                                                     @"assignUser":assignUser,
                                                                     @"imageGids":imageGids,
                                                                     @"location":location,
                                                                     @"type":type
                                                                      }
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[CommonResult class]]) {
                   CommonResult *result = mappingResult.firstObject;
                   if (result.code!=10000) {
                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:result.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                       [alert show];
                   }
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
 *  欧拉圈列表
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchVideoHistoryListWithVideoLogId:(NSString*)circleId
                                    UserId:(NSString*)userId
                                  PageSize:(NSString*)pageSize
                                      Type:(NSString*)type
                                   Success:(void(^)(VideoHistoryResult *result))success
                                   Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.historyListResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    // 采用post方式，get方式可能产生中文乱码
    [om postObject:nil path:@"/ola/circle/getCircleList" parameters:@{
                                                                @"userId": userId,
                                                                @"circleId": circleId,
                                                                @"pageSize": pageSize,
                                                                @"type": type
                                                                     }
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[VideoHistoryResult class]]) {
                   VideoHistoryResult *result = mappingResult.firstObject;
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
 *  个人主页
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchUserPostListWithUserId:(NSString*)userId
                           Success:(void(^)(UserPostResult *result))success
                           Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.userPostResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    // 采用post方式，get方式可能产生中文乱码
    [om postObject:nil path:@"/ola/circle/getUserPostList" parameters:@{@"userId": userId
                                                                      }
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[UserPostResult class]]) {
                   UserPostResult *result = mappingResult.firstObject;
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
 *  帖子详情
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchCircleDetailWithId:(NSString*)circleId
                        UserId:(NSString*)userId
                       Success:(void(^)(CircleDetailResult *result))success
                       Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.circleDetailResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    // 采用post方式，get方式可能产生中文乱码
    [om postObject:nil path:@"/ola/circle/queryCircleDetail" parameters:@{
                                                                    @"circleId": circleId,
                                                                    @"userId":   userId
                                                                         }
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[CircleDetailResult class]]) {
                   CircleDetailResult *result = mappingResult.firstObject;
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
 *  欧拉圈帖子点赞
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)praiseCirclePostWithCircle:(NSString*)circleId
                           UserId:(NSString*)userId
                          Success:(void(^)(CommonResult *result))success
                          Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.commonResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    // 采用post方式，get方式可能产生中文乱码
    [om postObject:nil path:@"/ola/circle/praiseCirclePost" parameters:
                                                     @{
                                                        @"circleId": circleId,
                                                        @"userId" : userId
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

/**
 *  点赞列表
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchPraiseListWithUserId:(NSString*)userId
                        PraiseId:(NSString*)praiseId
                        PageSize:(NSString*)pageSize
                         Success:(void(^)(PraiseListResult *result))success
                         Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.praiseListResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    // 采用post方式，get方式可能产生中文乱码
    [om postObject:nil path:@"/ola/circle/getPraiseList" parameters:@{@"userId": userId,
                                                                      @"praiseId": praiseId,
                                                                      @"pageSize": pageSize
                                                                        }
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[PraiseListResult class]]) {
                   PraiseListResult *result = mappingResult.firstObject;
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
