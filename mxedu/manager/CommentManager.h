//
//  CommentManager.h
//  mxedu
//
//  Created by 田晓鹏 on 16/7/11.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CommentListResult.h"
#import "CommonResult.h"

@interface CommentManager : NSObject

/**
 *  评论列表
 *
 *  @param postId 课程或提子Id
 *  @param type 1 课程评论 2 帖子评论
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchCommentListWithPostId:(NSString*)postId
                             Type:(NSString*)type
                          Success:(void(^)(CommentListResult *result))success
                          Failure:(void(^)(NSError* error))failure;

/*
 * 发表评论
 * postId  帖子或课程id
 * commentContent	评论的内容
 * replyToId	被回复人的id
 */
-(void)addPostReplyToUserId:(NSString*)replyToId
                     detail:(NSString*)content
                     postId:(NSString*)postId
              currentUserId:(NSString*)userId
                       type:(NSString*)type
                   location:(NSString*)location
                    success:(void (^)(CommonResult *result))success
                    failure:(void (^)(NSError*))failure;


@end
