//
//  SignInManager.h
//  mxedu
//
//  Created by 田晓鹏 on 16/9/22.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SignInStatusResult.h"
#import "CommonResult.h"

@interface SignInManager : NSObject

/**
 *  获取签到状态
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchSignInStatusWithUserId:(NSString*)userId
                           Success:(void(^)(SignInStatusResult *result))success
                           Failure:(void(^)(NSError* error))failure;

/*
 * 签到
 */
-(void)signInWithUserId:(NSString*)userId
                success:(void (^)(CommonResult *result))success
                failure:(void (^)(NSError*))failure;

/*
 * 分享送欧拉币
 */
-(void)shareWithUserId:(NSString*)userId
               success:(void (^)(CommonResult *result))success
               failure:(void (^)(NSError*))failure;
@end
