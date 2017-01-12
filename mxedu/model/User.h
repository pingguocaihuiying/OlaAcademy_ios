//
//  OWTUser.h
//  Weitu
//
//  Created by Su on 6/27/14.
//  Copyright (c) 2014 SparkingSoft Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, copy) NSString* userId;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* avatar;
@property (nonatomic, copy) NSString* sex;
@property (nonatomic, copy) NSString* age;
@property (nonatomic, copy) NSString* signature;
@property (nonatomic, copy) NSString* phone;
@property (nonatomic, copy) NSString* email;
@property (nonatomic, copy) NSString* local;
@property (nonatomic, copy) NSString* vipTime;

@end
