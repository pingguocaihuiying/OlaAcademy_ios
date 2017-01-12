//
//  GroupManager.m
//  mxedu
//
//  Created by 田晓鹏 on 16/8/29.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "GroupManager.h"

#import "SysCommon.h"

@implementation GroupManager

/**
 *  老师所创建的群列表
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchTeacherGroupListWithUserId:(NSString*)userId
                               Success:(void(^)(GroupListResult *result))success
                               Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.groupListResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    // 采用post方式，get方式可能产生中文乱码
    [om postObject:nil path:@"/ola/homework/getTeacherGroupList" parameters:@{@"userId": userId
                                                                        }
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[GroupListResult class]]) {
                   GroupListResult *result = mappingResult.firstObject;
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
 *  学生所加入的群列表
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchStudentGroupListWithUserId:(NSString*)userId
                                  Type:(NSString*)type
                               Success:(void(^)(GroupListResult *result))success
                               Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.groupListResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    // 采用post方式，get方式可能产生中文乱码
    [om postObject:nil path:@"/ola/homework/getUserGroupList"
                                                        parameters:@{@"userId": userId,
                                                                     @"type":type
                                                                    }
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[GroupListResult class]]) {
                   GroupListResult *result = mappingResult.firstObject;
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
 * 创建群
 */
-(void)createGroupWithUserId:(NSString*)userId
                        Name:(NSString*)name
                      Avatar:(NSString*)avatar
                     Profile:(NSString*)profile
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
    [om postObject:nil path:@"/ola/homework/createGroup" parameters:@{@"userId": userId,
                                                                    @"name": name,
                                                                    @"avatar": avatar,
                                                                    @"profile": profile,
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
 * 加入／退出群
 * @param type 1 加入 2 退出
 */
-(void)attendGroupWithUserId:(NSString*)userId
                     GroupId:(NSString*)groupId
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
    [om postObject:nil path:@"/ola/homework/attendGroup" parameters:@{@"userId": userId,
                                                                      @"groupId": groupId,
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
 * 群成员
 */
-(void)fetchGroupMemberWithGroupId:(NSString*)groupId
                         pageIndex:(NSString*)pageIndex
                          pageSize:(NSString*)pageSize
                           success:(void (^)(GroupMemberResult *result))success
                           failure:(void (^)(NSError*))failure
{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.memberListResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    // 采用post方式，get方式可能产生中文乱码
    [om postObject:nil path:@"/ola/homework/queryGroupMember" parameters:@{
                                                                    @"groupId": groupId,
                                                                    @"pageIndex": pageIndex,
                                                                    @"pageSize": pageSize
                                                                      }
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[GroupMemberResult class]]) {
                   GroupMemberResult *result = mappingResult.firstObject;
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
