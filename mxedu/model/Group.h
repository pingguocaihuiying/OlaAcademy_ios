//
//  Group.h
//  mxedu
//
//  Created by 田晓鹏 on 16/8/29.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Group : NSObject

@property (nonatomic, copy) NSString* groupId;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* profile;
@property (nonatomic, copy) NSString* createUserId;
@property (nonatomic, copy) NSString* avatar;
@property (nonatomic, copy) NSString* time;
@property (nonatomic, copy) NSString* isMember; // 是否已加入
@property (nonatomic, copy) NSString* number;  //群成员数

@property (nonatomic) int isChosen;

@end
