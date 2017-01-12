//
//  UserPostResult.h
//  mxedu
//
//  Created by 田晓鹏 on 16/12/27.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserPost.h"

@interface UserPostResult : NSObject

@property (nonatomic) NSString *code;
@property (nonatomic) NSString *message;
@property (nonatomic) UserPost *userPost;

@end
