//
//  CirclePraise.h
//  mxedu
//
//  Created by 田晓鹏 on 16/12/19.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CirclePraise : NSObject

@property(nonatomic,copy)NSString *praiseId;
@property(nonatomic,copy)NSString *postId;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *userId;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *userAvatar;
@property(nonatomic,copy)NSString *time;
@property(nonatomic,copy)NSString *isRead;

@end
