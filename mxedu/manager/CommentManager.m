//
//  CommentManager.m
//  mxedu
//
//  Created by 田晓鹏 on 16/7/11.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "CommentManager.h"

#import "SysCommon.h"
#import "DataMappingManager.h"

@implementation CommentManager

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
                          Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.commentListResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    // 采用post方式，get方式可能产生中文乱码
    [om postObject:nil path:@"/ola/comment/getCommentList" parameters:@{@"postId": postId,
                                                                      @"type": type
                                                                      }
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[CommentListResult class]]) {
                   CommentListResult *result = mappingResult.firstObject;
                   if (success != nil) {
                       success(result);
                   }
               }
               
           }
           failure:^(RKObjectRequestOperation *operation, NSError *error) {
               if (failure != nil) {
                   failure(error);
               }
           }];
}

/*
 * 发表评论
 * postId  帖子或课程id
 * commentContent	评论的内容
 * replyToId	被回复人的id
 */
-(void)addPostReplyToUserId:(NSString*)replyToId
                     detail:(NSString*)content
                   imageIds:(NSString*)imageIds
                  videoUrls:(NSString*)videoUrls
                  videoImgs:(NSString*)videoImgs
                  audioUrls:(NSString*)audioUrls
                      postId:(NSString*)postId
              currentUserId:(NSString*)userId
                       type:(NSString*)type
                   location:(NSString*)location
                    success:(void (^)(CommonResult *result))success
                    failure:(void (^)(NSError*))failure
{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.commonResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    // 采用post方式，get方式可能产生中文乱码
    [om postObject:nil path:@"/ola/comment/addComment" parameters:@{
                                                            @"userId": userId,
                                                            @"postId": postId,
                                                            @"toUserId": replyToId,
                                                            @"type": type,
                                                            @"imageIds": imageIds,
                                                            @"videoUrls": videoUrls,
                                                            @"videoImgs": videoImgs,
                                                            @"audioUrls": audioUrls,
                                                            @"content": content,
                                                            @"location": location
                                                                        }
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[CommonResult class]]) {
                   CommonResult *result = mappingResult.firstObject;
                   if (success != nil) {
                       success(result);
                   }
               }
               
           }
           failure:^(RKObjectRequestOperation *operation, NSError *error) {
               if (failure != nil) {
                   failure(error);
               }
           }];
}


@end
