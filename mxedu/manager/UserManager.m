//
//  UserManager.m
//  NTreat
//
//  Created by 田晓鹏 on 15-5-20.
//  Copyright (c) 2015年 田晓鹏. All rights reserved.
//

#import "UserManager.h"
#import "DataMappingManager.h"
#import "SysCommon.h"
#import "CommonResult.h"
#import "UserInfoResult.h"

static NSString* storeKeyUserInfo = @"NTUserInfo";

@implementation UserManager

/**
 * 获取短信验证码
 */
-(void)fetchValidateCodeWithMobile:(NSString*)mobile
                           Success:(void(^)())success
                           Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.commonResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    [om postObject:nil path:@"/ola/user/getYzmByPhone" parameters:@{ @"mobile" : mobile
                                                                            }
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[CommonResult class]]){
                   CommonResult *result = mappingResult.firstObject;
                   if (result.code==10000) {
                       if (success != nil) {
                           success();
                       }
                   }else{
                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:result.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                       [alert show];
                   }
               }
           } failure:^(RKObjectRequestOperation *operation, NSError *error) {
               if (failure != nil) {
                   failure(error);
               }
           }];
}


-(void)registerUserWithMobile:(NSString*)mobile
                 IdentityCode:(NSString*)identityCode
                          Pwd:(NSString*)pwd
                       Status:(NSString*)status
                      Success:(void(^)())success
                      Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.commonResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    [om postObject:nil path:@"/ola/user/reg" parameters:@{ @"phone" : mobile,
                                                              @"code" : identityCode,
                                                              @"passwd" : pwd
                                                              }
                 success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                     if ([mappingResult.firstObject isKindOfClass:[CommonResult class]]){
                         CommonResult *result = mappingResult.firstObject;
                         if (result.code==10000) {
                             if (success != nil) {
                                 success();
                             }
                         }else{
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:result.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                             [alert show];
                         }
                     }
                 } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                     if (failure != nil) {
                         failure(error);
                     }
                 }];
}

/**
 * 找回并重置密码
 */
-(void)resetPassWithMobile:(NSString*)mobile
              IdentityCode:(NSString*)identityCode
                       Pwd:(NSString*)newPwd
                   Success:(void(^)())success
                   Failure:(void(^)(NSError* error))failure{
    
    DataMappingManager *dm = GetDataManager();
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.commonResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    [om postObject:nil path:@"/ola/user/modifypasswd" parameters:@{ @"phone" : mobile,
                                                             @"code" : identityCode,
                                                             @"passwd" : newPwd
                                                             }
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[CommonResult class]]){
                   CommonResult *result = mappingResult.firstObject;
                   if (result.code==10000) {
                       if (success != nil) {
                           success();
                       }
                   }else{
                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:result.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                       [alert show];
                   }
               }
           } failure:^(RKObjectRequestOperation *operation, NSError *error) {
               if (failure != nil) {
                   failure(error);
               }
           }];
}

/**
 * 修改密码
 */
-(void)modifyPasswordWithOldPwd:(NSString*)oldPwd
                         newPwd:(NSString*)newPwd
                        Success:(void(^)())success
                        Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.commonResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    [om postObject:nil path:@"/SDP/user/changePwd" parameters:@{@"oldPwd" : oldPwd,
                                                               @"newPwd" : newPwd
                                                             }
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[CommonResult class]]){
                   CommonResult *result = mappingResult.firstObject;
                   if (result.code==1) {
                       if (success != nil) {
                           success();
                       }
                   }else{
                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:result.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                       [alert show];
                   }
               }
           } failure:^(RKObjectRequestOperation *operation, NSError *error) {
               if (failure != nil) {
                   failure(error);
               }
           }];
}

/**
 * 修改用户资料
 */
-(void)updateUserWithUserId:(NSString*)userId
                       Name:(NSString*)name
                   RealName:(NSString*)realName
                        sex:(NSString*)sex
                      local:(NSString*)local
                   ExamType:(NSString*)examType
                   descript:(NSString*)descript
                     avatar:(NSString*)avatar
                    Success:(void(^)())success
                    Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.commonResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    [om postObject:nil path:@"/ola/user/updateInfo" parameters:@{@"id" : userId,
                                                                 @"name" : name,
                                                                 @"realName" : realName,
                                                                 @"avator" : avatar,
                                                                 @"local" : local,
                                                                 @"sex" : sex,
                                                                 @"examType" : examType,
                                                                 @"descript" : descript
                                                                 }
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[CommonResult class]]){
                   CommonResult *result = mappingResult.firstObject;
                   if (result.code==10000) {
                       if (success != nil) {
                           success();
                       }
                   }else{
                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:result.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                       [alert show];
                   }
               }
           } failure:^(RKObjectRequestOperation *operation, NSError *error) {
               if (failure != nil) {
                   failure(error);
               }
           }];
}



/**
 * 根据用户id 或姓名查询用户
 */
-(void)fetchUserWithUserId:(NSString*)userId
                      Success:(void(^)())success
                      Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.userInfoResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    [om postObject:nil path:@"/ola/user/queryUser" parameters:@{ @"id" : userId
                                                             }
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[UserInfoResult class]]){
                   UserInfoResult *result = mappingResult.firstObject;
                   if (result.code==10000) {
                       _userInfo = result.userInfo;
                       if (success != nil) {
                           success();
                       }
                   }else{
                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:result.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                       [alert show];
                   }
               }
           } failure:^(RKObjectRequestOperation *operation, NSError *error) {
               if (failure != nil) {
                   failure(error);
               }
           }];
}

/**
 * 老师列表
 */
-(void)fetchTeacherListSuccess:(void (^)(GroupMemberResult *result))success
                       Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.memberListResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    [om postObject:nil path:@"/ola/user/getTeacherList" parameters:nil
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[GroupMemberResult class]]){
                   GroupMemberResult *result = mappingResult.firstObject;
                   if (result.code==10000) {
                       if (success != nil) {
                           success(result);
                       }
                   }else{
                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:result.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                       [alert show];
                   }
               }
           } failure:^(RKObjectRequestOperation *operation, NSError *error) {
               if (failure != nil) {
                   failure(error);
               }
           }];
}

@end
