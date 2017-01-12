//
//  OrganizationManager.m
//  mxedu
//
//  Created by 田晓鹏 on 15/10/20.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import "OrganizationManager.h"

#import "DataMappingManager.h"
#import "SysCommon.h"

@implementation OrganizationManager

-(void)fetchOrganizationListWithUserId:(NSString*)userId
                               Success:(void(^)(OrganizationResult *result))success
                               Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.orgListResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    [om getObjectsAtPath:@"/ola/organization/getAllOrganization" parameters:@{ @"userId":userId }
                 success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                     if ([mappingResult.firstObject isKindOfClass:[OrganizationResult class]]) {
                         OrganizationResult *result = mappingResult.firstObject;
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

-(void)fetchOrganizationInfoSuccess:(void(^)(OrgInfoListResult *result))success
                            Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.orgInfoListResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    [om getObjectsAtPath:@"/ola/organization/getOrganizationInfo" parameters: nil
                 success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                     if ([mappingResult.firstObject isKindOfClass:[OrgInfoListResult class]]) {
                         OrgInfoListResult *result = mappingResult.firstObject;
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

-(void)updateAttendCountWithOrgId:(NSString*)orgId
                          Success:(void(^)(CommonResult *result))success
                          Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.commonResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    [om postObject:nil path:@"/ola/organization/updateAttendCount" parameters:@{@"orgId" : orgId} success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        CommonResult *result = mappingResult.firstObject;
        if (success != nil) {
            success(result);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (failure != nil) {
            failure(error);
        }
    }];
}

-(void)updateCheckInCountWithOrgId:(NSString*)orgId
                              Type:(NSString*)type
                          Success:(void(^)(CommonResult *result))success
                          Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.commonResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    [om postObject:nil path:@"/ola/organization/updateCheckInCount" parameters:@{@"orgId" : orgId,
                                                                                 @"type" : type
                                                                                 }
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
    {
        CommonResult *result = mappingResult.firstObject;
        if (success != nil) {
            success(result);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (failure != nil) {
            failure(error);
        }
    }];
}

-(void)fetchUserListWithOrgId:(NSString*)orgId
                      Success:(void(^)(TeacherResult *result))success
                      Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.teacherListResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    [om getObjectsAtPath:@"/ola/organization/getTeacherListByOrgId" parameters:@{@"orgId" : orgId}
                 success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                     if ([mappingResult.firstObject isKindOfClass:[TeacherResult class]]) {
                         TeacherResult *result = mappingResult.firstObject;
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

-(void)checkInWithOrgId:(NSString*)orgId
             CheckinTime:(NSString*)checkinTime
               UserPhone:(NSString*)userPhone
               UserLocal:(NSString*)userLocal
                 Success:(void(^)(CommonResult *result))success
                 Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.commonResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    [om postObject:nil path:@"/ola/organization/checkin" parameters:@{@"orgId" : orgId,
                                                                      @"checkinTime":checkinTime,
                                                                      @"userPhone":userPhone,
                                                                      @"userLocal":userLocal
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
 * 根据手机号获取报名列表
 */
-(void)fetchListByUserPhone:(NSString*)userPhone
                    Success:(void(^)(CheckInListResult *result))success
                    Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.checkInListResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    if(!userPhone)
        return;
    [om postObject:nil path:@"/ola/organization/getListByPhone" parameters:@{ @"userPhone" : userPhone,
                                                                                        }
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[CheckInListResult class]]) {
                   CheckInListResult *result = mappingResult.firstObject;
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
 * 取消报名
 */
-(void)removeCheckInfo:(NSString*)checkId
                    Success:(void(^)(CommonResult *result))success
                    Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.commonResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];

    [om postObject:nil path:@"/ola/organization/cancelCheckIn" parameters:@{ @"checkId" : checkId,
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

-(void)fetchInfoByUserPhone:(NSString*)userPhone
                   OrgId:(NSString*)orgId
                 Success:(void(^)(CheckInResult *result))success
                 Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.checkInResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    [om postObject:nil path:@"/ola/organization/getInfoByUserPhoneAndOrg" parameters:@{ @"userPhone" : userPhone,
                                                                       @"orgId" : orgId
                                                                       }
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[CheckInResult class]]) {
                   CheckInResult *result = mappingResult.firstObject;
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

@end
