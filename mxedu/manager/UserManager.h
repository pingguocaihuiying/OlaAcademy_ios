//
//  UserManager.h
//  NTreat
//
//  Created by 田晓鹏 on 15-5-20.
//  Copyright (c) 2015年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserManager : NSObject

@property (nonatomic,retain) User *userInfo;

/**
 * 获取短信验证码
 */
-(void)fetchValidateCodeWithMobile:(NSString*)mobile
                           Success:(void(^)())success
                           Failure:(void(^)(NSError* error))failure;
/**
 * 注册
 */
-(void)registerUserWithMobile:(NSString*)mobile
                 IdentityCode:(NSString*)identityCode
                          Pwd:(NSString*)pwd
                      Success:(void(^)())success
                      Failure:(void(^)(NSError* error))failure;

/**
 * 修改密码
 */
-(void)modifyPasswordWithOldPwd:(NSString*)oldPwd
                         newPwd:(NSString*)newPwd
                        Success:(void(^)())success
                        Failure:(void(^)(NSError* error))failure;

/**
 * 找回并重置密码
 */
-(void)resetPassWithMobile:(NSString*)mobile
                 IdentityCode:(NSString*)identityCode
                          Pwd:(NSString*)newPwd
                      Success:(void(^)())success
                      Failure:(void(^)(NSError* error))failure;

/**
 * 修改用户资料
 */
-(void)updateUserWithUserId:(NSString*)userId
                       Name:(NSString*)name
                        sex:(NSString*)sex
                      local:(NSString*)local
                   descript:(NSString*)descript
                     avatar:(NSString*)avatar
                    Success:(void(^)())success
                    Failure:(void(^)(NSError* error))failure;

/**
 * 根据用户id 或姓名查询用户
 */
-(void)fetchUserWithUserId:(NSString*)userId
                    Success:(void(^)())success
                    Failure:(void(^)(NSError* error))failure;

@end
