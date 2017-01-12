//
//  CoinManager.h
//  mxedu
//
//  Created by 田晓鹏 on 16/10/19.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CoinHistoryListResult.h"

@interface CoinManager : NSObject


/**
 *  欧拉币明细列表
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchCoinHistoryListWithUserId:(NSString*)userId
                              Success:(void(^)(CoinHistoryListResult *result))success
                              Failure:(void(^)(NSError* error))failure;

@end
