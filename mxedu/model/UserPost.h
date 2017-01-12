//
//  UserPost.h
//  mxedu
//
//  Created by 田晓鹏 on 16/12/27.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserPost : NSObject

@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *avator;
@property (nonatomic) NSString *sign;
@property (nonatomic) NSArray *deployList;
@property (nonatomic) NSArray *replyList;


@end
