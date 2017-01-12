//
//  ExchangeManager.h
//  mxedu
//
//  Created by 田晓鹏 on 16/10/15.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CommonResult.h"

@interface ExchangeManager : NSObject

/*
 * 欧拉币解锁题
 * @param type 1 课程 2 模考
 */
-(void)unlockSubjectWithUserId:(NSString*)userId
                      ObjectId:(NSString*)objectId
                          Type:(NSString*)type
                       success:(void (^)(CommonResult *result))success
                       failure:(void (^)(NSError*))failure;

/*
 * 欧拉币解锁资料
 */
-(void)unlockMaterialWithUserId:(NSString*)userId
                     MaterialId:(NSString*)objectId
                        success:(void (^)(CommonResult *result))success
                        failure:(void (^)(NSError*))failure;

@end
