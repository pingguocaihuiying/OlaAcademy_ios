//
//  PayManager.h
//  NTreat
//
//  Created by 田晓鹏 on 16/4/15.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PayReqResult.h"
#import "AliPayResult.h"
#import "StatusResult.h"
#import "CommonResult.h"

@interface PayManager : NSObject

/**
 * 服务器控制是否显示支付相关功能
 */
-(void)fetchPayModuleStatusSuccess:(void(^)(StatusResult*))success
                           Failure:(void(^)(NSError* error))failure;


/**
 * 获取微信支付信息
 * type : 1月度会员 2 年度会员 3 整套视频
 */
-(void)fetchPayReqInfoWithUserId:(NSString*)userId
                          Type:(NSString*)type
                       goodsId:(NSString*)goodsId
                       Success:(void(^)(PayReqResult*))success
                       Failure:(void(^)(NSError* error))failure;

/**
 * 获取支付宝支付信息
 * type : 1月度会员 2 年度会员 3 整套视频
 */
-(void)fetchAliPayInfoWithUserId:(NSString*)userId
                          Type:(NSString*)type
                       goodsId:(NSString*)goodsId
                       Success:(void(^)(AliPayResult*))success
                       Failure:(void(^)(NSError* error))failure;

/**
 * 检验苹果IAP支付结果，并更新VIP状态
 */
-(void)updateVIPByIAPWithUserId:(NSString*)userId
                        Receipt:(NSString*)receipt
                      ProductId:(NSString*)productId
                        Success:(void(^)(CommonResult*))success
                        Failure:(void(^)(NSError* error))failure;

@end
