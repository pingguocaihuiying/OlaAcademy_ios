//
//  SignInStatusResult.h
//  mxedu
//
//  Created by 田晓鹏 on 16/9/27.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SignInStatus.h"

@interface SignInStatusResult : NSObject

@property (nonatomic) int code;
@property (nonatomic) NSString *message;
@property (nonatomic) SignInStatus *signInStatus;

@end
