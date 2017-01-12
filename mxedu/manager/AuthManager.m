//
//  AuthManager.m
//  NTreat
//
//  Created by 田晓鹏 on 15-5-10.
//  Copyright (c) 2015年 田晓鹏. All rights reserved.
//

#import "AuthManager.h"
#import "SysCommon.h"
#import "DataMappingManager.h"
#import "AuthResult.h"

static NSString* USERINFO = @"userInfo";

@implementation AuthManager

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        [self load];
    }
    return self;
}

#pragma mark - loading / saving

- (void)load
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSData* data = [defaults objectForKey:USERINFO];
    User* userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [self updateUserInfo:userInfo];
}

- (void)save
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    if (_userInfo != nil&&_userInfo.userId != nil)
    {
        [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:_userInfo] forKey:USERINFO];
    }
    else
    {
        [defaults removeObjectForKey:USERINFO];
    }
    [defaults synchronize];
}

#pragma mark - Authentication

- (BOOL)isAuthenticated
{
    if (_userInfo != nil&& _userInfo.userId!=nil)
    {
        return true;
    }
    else
    {
        return false;
    }
}

- (void)authWithMobile:(NSString*)mobile
              password:(NSString*)pwd
                 success:(void (^)())success
                 failure:(void (^)(NSError*))failure
{
    DataMappingManager *dm = GetDataManager();
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.authResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];

    [om postObject:nil
              path:@"/ola/user/login"
        parameters:@{ @"phone" : mobile,
                      @"passwd" : pwd}
           success:^(RKObjectRequestOperation* o, RKMappingResult* mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[AuthResult class]]) {
                   AuthResult *result = mappingResult.firstObject;
                   if (![result.code isEqualToString:@"10000"]) {
                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:result.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                       [alert show];
                       return;
                   }
                   _userInfo = result.userInfo;
                   [self updateUserInfo:_userInfo];
                   if (success != nil)
                   {
                       success();
                   }
               }
            }
           failure:^(RKObjectRequestOperation* o, NSError* error) {
               if (failure != nil)
               {
                   failure(error);
               }
           }
     ];
}


- (void)updateUserInfo:(User*) userInfo
{
    _userInfo = userInfo;
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    if (userInfo != nil && userInfo.userId!=nil)
    {
        
        // 为所有请求设置请求头信息
        if (userInfo.userId) {
            [om.HTTPClient setDefaultHeader:@"userId"
                                      value:userInfo.userId];
        }

    }
    else
    {
        [om.HTTPClient clearAuthorizationHeader];
    }
    [self save];
}

#pragma mark - logout
- (void)logoutSuccess:(void (^)())success
              failure:(void (^)(NSError*))failure
{
    DataMappingManager *dm = GetDataManager();
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.commonResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    
    [om postObject:nil
              path:@"/ola/user/loginOut"
        parameters:nil
           success:^(RKObjectRequestOperation* o, RKMappingResult* mappingResult) {
               [self updateUserInfo:nil];
               if (success != nil)
               {
                   success();
               }
           }
           failure:^(RKObjectRequestOperation* o, NSError* error) {
               if (failure != nil)
               {
                   failure(error);
               }
           }
     ];
}

@end
