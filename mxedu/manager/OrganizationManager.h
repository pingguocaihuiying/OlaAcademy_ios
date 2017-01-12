//
//  OrganizationManager.h
//  mxedu
//
//  Created by 田晓鹏 on 15/10/20.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OrganizationResult.h"
#import "CommonResult.h"
#import "TeacherResult.h"
#import "CheckInResult.h"
#import "CheckInListResult.h"

@interface OrganizationManager : NSObject

/**
 * 获取机构列表
 */
-(void)fetchOrganizationListWithUserId:(NSString*)userId
                               Success:(void(^)(OrganizationResult *result))success
                               Failure:(void(^)(NSError* error))failure;

/**
 * 更新机构关注数量
 */
-(void)updateAttendCountWithOrgId:(NSString*)orgId
                          Success:(void(^)(CommonResult *result))success
                          Failure:(void(^)(NSError* error))failure;

/**
 * 更新机构报名数量
 */
-(void)updateCheckInCountWithOrgId:(NSString*)orgId
                              Type:(NSString*)type
                           Success:(void(^)(CommonResult *result))success
                           Failure:(void(^)(NSError* error))failure;

/**
 * 获取机构教师列表
 */
-(void)fetchUserListWithOrgId:(NSString*)orgId
                      Success:(void(^)(TeacherResult *result))success
                      Failure:(void(^)(NSError* error))failure;

/**
 * 向机构报名
 */
-(void)checkInWithOrgId:(NSString*)orgId
             CheckinTime:(NSString*)checkinTime
               UserPhone:(NSString*)userPhone
               UserLocal:(NSString*)userLocal
                    Type:(NSString*)type
                 Success:(void(^)(CommonResult *result))success
                 Failure:(void(^)(NSError* error))failure;

/**
 * 取消报名
 */
-(void)removeCheckInfo:(NSString*)checkId
               Success:(void(^)(CommonResult *result))success
               Failure:(void(^)(NSError* error))failure;

/**
 * 根据手机号获取报名列表
 */
-(void)fetchListByUserPhone:(NSString*)userPhone
                    Success:(void(^)(CheckInListResult *result))success
                    Failure:(void(^)(NSError* error))failure;

/**
 * 根据手机号获取报名信息
 */
-(void)fetchInfoByUserPhone:(NSString*)userPhone
                      OrgId:(NSString*)orgId
                    Success:(void(^)(CheckInResult *result))success
                    Failure:(void(^)(NSError* error))failure;

@end
