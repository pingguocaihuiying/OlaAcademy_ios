//
//  HomeManager.h
//  mxedu
//
//  Created by 田晓鹏 on 16/8/17.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HomeListResult.h"

@interface HomeManager : NSObject

/**
 *  首页列表
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchHomePageListWithUserId:(NSString*)userId
                           Success:(void(^)(HomeListResult *result))success
                           Failure:(void(^)(NSError* error))failure;

@end
