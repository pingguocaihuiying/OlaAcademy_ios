//
//  MessageManager.m
//  mxedu
//
//  Created by 田晓鹏 on 16/7/19.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "MessageManager.h"

#import "SysCommon.h"

@implementation MessageManager

/**
 *  获取未读消息数
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchUnreadCountWithUserId:(NSString*)userId
                          Success:(void(^)(MessageUnreadResult *result))success
                          Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.unreadMessageResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    // 采用post方式，get方式可能产生中文乱码
    [om postObject:nil path:@"/ola/message/getUnreadCount" parameters:@{
                                                                        @"userId": userId
                                                                        }
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[MessageUnreadResult class]]) {
                   MessageUnreadResult *result = mappingResult.firstObject;
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
 *  消息列表
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchMessageListWithMessageId:(NSString*)messageId
                              UserId:(NSString*)userId
                            PageSize:(NSString*)pageSize
                             Success:(void(^)(MessageListResult *result))success
                             Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.messageListResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    // 采用post方式，get方式可能产生中文乱码
    [om postObject:nil path:@"/ola/message/getMessageList" parameters:@{@"messageId": messageId,
                                                                        @"userId": userId,
                                                                        @"pageSize": pageSize
                                                                      }
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[MessageListResult class]]) {
                   MessageListResult *result = mappingResult.firstObject;
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
 *  更新消息为状态
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)updateReadStatusWithUserId:(NSString*)userId
                       MessageIds:(NSString*)messageIds
                          Success:(void(^)(CommonResult *result))success
                          Failure:(void(^)(NSError* error))failure{

    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.commonResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    // 采用post方式，get方式可能产生中文乱码
    [om postObject:nil path:@"/ola//message/addMessageRecord" parameters:@{
                                                                        @"userId": userId,
                                                                        @"messageIds": messageIds
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
