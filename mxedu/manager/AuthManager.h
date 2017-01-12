//
//  AuthManager.h
//  NTreat
//
//  Created by 田晓鹏 on 15-5-10.
//  Copyright (c) 2015年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface AuthManager : NSObject

@property (nonatomic, assign, readonly) BOOL isAuthenticated;
@property (nonatomic, strong, readonly) User* userInfo;

-(void)load;

- (void)authWithMobile:(NSString*)mobile
              password:(NSString*)psd
               success:(void (^)())success
               failure:(void (^)(NSError*))failure;

- (void)logoutSuccess:(void (^)())success
              failure:(void (^)(NSError*))failure;

@end
