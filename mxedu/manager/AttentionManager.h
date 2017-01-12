//
//  AttentionManager.h
//  关注（好友）
//
//  Created by 田晓鹏 on 16/9/22.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CommonResult.h"

@interface AttentionManager : NSObject

/*
 * 关注／取消关注
 * @param type 1 关注 2 取消
 */
-(void)attendOtherWithUserId:(NSString*)attendId
                  AttendedId:(NSString*)attednedId
                        Type:(NSString*)type
                     success:(void (^)(CommonResult *result))success
                     failure:(void (^)(NSError*))failure;

@end
