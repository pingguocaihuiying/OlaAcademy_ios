//
//  GroupManager.h
//  mxedu
//
//  Created by 田晓鹏 on 16/8/29.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GroupListResult.h"
#import "CommonResult.h"
#import "GroupMemberResult.h"

@interface GroupManager : NSObject

/**
 *  老师所创建的群列表
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchTeacherGroupListWithUserId:(NSString*)userId
                               Success:(void(^)(GroupListResult *result))success
                               Failure:(void(^)(NSError* error))failure;

/**
 *  学生所加入的群列表
 *
 *  @param type 1 数学 2 英语 3 逻辑 4 写作
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchStudentGroupListWithUserId:(NSString*)userId
                                  Type:(NSString*)type
                               Success:(void(^)(GroupListResult *result))success
                               Failure:(void(^)(NSError* error))failure;

/*
 * 创建群
 * type 1 数学 2 英语 3 逻辑 4 写作
 */
-(void)createGroupWithUserId:(NSString*)userId
                        Name:(NSString*)name
                      Avatar:(NSString*)avatar
                     Profile:(NSString*)profile
                        Type:(NSString*)type
                     success:(void (^)(CommonResult *result))success
                     failure:(void (^)(NSError*))failure;

/*
 * 加入／退出群
 * @param type 1 加入 2 退出
 */
-(void)attendGroupWithUserId:(NSString*)userId
                     GroupId:(NSString*)groupId
                        Type:(NSString*)type
                     success:(void (^)(CommonResult *result))success
                     failure:(void (^)(NSError*))failure;

/*
 * 群成员
 */
-(void)fetchGroupMemberWithGroupId:(NSString*)groupId
                         pageIndex:(NSString*)pageIndex
                          pageSize:(NSString*)pageSize
                           success:(void (^)(GroupMemberResult *result))success
                           failure:(void (^)(NSError*))failure;

@end
