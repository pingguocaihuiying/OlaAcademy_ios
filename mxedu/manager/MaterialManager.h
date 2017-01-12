//
//  MaterialManager.h
//  mxedu
//
//  Created by 田晓鹏 on 16/10/29.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MaterialListResult.h"
#import "CommonResult.h"

@interface MaterialManager : NSObject

-(void)fetchMaterialListWithMaterialId:(NSString*)materialId
                              PageSize:(NSString*)pageSize
                                  Type:(NSString*)type
                               Success:(void(^)(MaterialListResult *result))success
                               Failure:(void(^)(NSError* error))failure;

/**
 *  更新浏览量
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)updateBrowseCountWithID:(NSString*)materialId
                       Success:(void(^)(CommonResult *result))success
                       Failure:(void(^)(NSError* error))failure;

@end
