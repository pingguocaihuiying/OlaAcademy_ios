//
//  MessageManager.h
//  mxedu
//
//  Created by 田晓鹏 on 16/7/19.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CommonResult.h"
#import "MessageListResult.h"
#import "MessageUnreadResult.h"
#import "CommentListResult.h"

@interface MessageManager : NSObject

/**
 *  消息列表 （评论消息）
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchCommentMessageListWithCommentId:(NSString*)commentId
                                     UserId:(NSString*)userId
                                   PageSize:(NSString*)pageSize
                                    Success:(void(^)(CommentListResult *result))success
                                    Failure:(void(^)(NSError* error))failure;

/**
 *  获取未读消息数
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchUnreadCountWithUserId:(NSString*)userId
                          Success:(void(^)(MessageUnreadResult *result))success
                          Failure:(void(^)(NSError* error))failure;

/**
 *  消息列表
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchMessageListWithMessageId:(NSString*)messageId
                              UserId:(NSString*)userId
                            PageSize:(NSString*)pageSize
                             Success:(void(^)(MessageListResult *result))success
                             Failure:(void(^)(NSError* error))failure;

/**
 *  更新消息为状态
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)updateReadStatusWithUserId:(NSString*)userId
                       MessageIds:(NSString*)messageIds
                          Success:(void(^)(CommonResult *result))success
                          Failure:(void(^)(NSError* error))failure;

@end
