//
//  MessageUnreadResult.h
//  mxedu
//
//  Created by 田晓鹏 on 16/7/20.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MessageCount.h"

@interface MessageUnreadResult : NSObject

@property (nonatomic) int code;
@property (nonatomic) NSString *message;
@property (nonatomic) MessageCount *messageCount;

@end
