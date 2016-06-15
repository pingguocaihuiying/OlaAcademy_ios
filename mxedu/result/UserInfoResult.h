//
//  UserInfoResult.h
//  NTreat
//
//  Created by 田晓鹏 on 15/5/26.
//  Copyright (c) 2015年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserInfoResult : NSObject

@property (nonatomic) int code;
@property (nonatomic) NSString *message;
@property (nonatomic) User *userInfo;

@end
