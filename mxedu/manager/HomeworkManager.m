//
//  HomeworkManager.m
//  mxedu
//
//  Created by 田晓鹏 on 16/8/3.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "HomeworkManager.h"

#import "SysCommon.h"

@implementation HomeworkManager

/**
 *  发布作业
 *
 *  @param subjectIds 题目Id串 逗号分隔
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)deployHomeworkWithGroupIds:(NSString*)groupIds
                        GroupName:(NSString*)name
                       SubjectIds:(NSString*)subjectIds
                          Success:(void(^)(CommonResult *result))success
                          Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.commonResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    // 采用post方式，get方式可能产生中文乱码
    [om postObject:nil path:@"/ola/homework/deployHomework"
        parameters:@{@"groupIds": groupIds,
                     @"name": name,
                     @"subjectIds": subjectIds
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
 *  作业列表
 *
 *  @param type 1 学生 2 老师
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchHomeworkListWithHomeworkId:(NSString*)homeworkId
                              PageSize:(NSString*)pageSize
                                UserId:(NSString*)userId
                                  Type:(NSString*)type
                               Success:(void(^)(HomeworkListResult *result))success
                               Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.homeworkListResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    // 采用post方式，get方式可能产生中文乱码
    [om postObject:nil path:@"/ola/homework/getHomeworkList"
        parameters:@{@"homeworkId": homeworkId,
                     @"pageSize": pageSize,
                     @"userId": userId,
                     @"type": type
                     }
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[HomeworkListResult class]]) {
                   HomeworkListResult *result = mappingResult.firstObject;
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
 *  (老师版)学生作业完成情况
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchHomeworkStatisticsWithHomeworkId:(NSString*)homeworkId
                                     GroupId:(NSString*)groupId
                                   PageIndex:(NSString*)pageIndex
                                    PageSize:(NSString*)pageSize
                                     Success:(void(^)(WorkStatisticsListResult *result))success
                                     Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.workStatisticsListResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    // 采用post方式，get方式可能产生中文乱码
    [om postObject:nil path:@"/ola/homework/getHomeworkStatistics"
        parameters:@{@"homeworkId": homeworkId,
                     @"groupId": groupId,
                     @"pageIndex": pageIndex,
                     @"pageSize": pageSize
                     }
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[WorkStatisticsListResult class]]) {
                   WorkStatisticsListResult *result = mappingResult.firstObject;
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
 *  获取作业对应的试题
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchQuestionWithHomeworkId:(NSString*)homeworkId
                           Success:(void(^)(QuestionListResult *result))success
                           Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.questionListResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    // 采用post方式，get方式可能产生中文乱码
    [om postObject:nil path:@"/ola/homework/getSubjectList" parameters:@{ @"homeworkId" : homeworkId
                                                                     }
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[QuestionListResult class]]) {
                   QuestionListResult *result = mappingResult.firstObject;
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
