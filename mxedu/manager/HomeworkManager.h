//
//  HomeworkManager.h
//  mxedu
//
//  Created by 田晓鹏 on 16/8/3.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HomeworkListResult.h"
#import "QuestionListResult.h"
#import "CommonResult.h"
#import "WorkStatisticsListResult.h"

@interface HomeworkManager : NSObject

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
                          Failure:(void(^)(NSError* error))failure;

/**
 *  作业列表
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchHomeworkListWithHomeworkId:(NSString*)homeworkId
                              PageSize:(NSString*)pageSize
                                UserId:(NSString*)userId
Type:(NSString*)type
                               Success:(void(^)(HomeworkListResult *result))success
                               Failure:(void(^)(NSError* error))failure;

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
                                     Failure:(void(^)(NSError* error))failure;

/**
 *  获取作业对应的试题
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchQuestionWithHomeworkId:(NSString*)homeworkId
                           Success:(void(^)(QuestionListResult *result))success
                           Failure:(void(^)(NSError* error))failure;

@end
