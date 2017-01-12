//
//  CourseManager.h
//  mxedu
//
//  Created by 田晓鹏 on 15/10/20.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CourseListResult.h"
#import "VideoInfoResult.h"
#import "KeywordListResult.h"
#import "VideoListResult.h"
#import "CommonResult.h"
#import "VideoCollectionResult.h"
#import "CollectionListResult.h"
#import "QuestionListResult.h"
#import "VideoBoxResult.h"
#import "VideoHistoryResult.h"
#import "StatisticsListResult.h"
#import "BannerListResult.h"
#import "MistakeListResult.h"

@interface CourseManager : NSObject

/**
 * 根据课程Id获取子集列表
 * type 1 考点用的课程结构，包含知识点 2 视频用的课程结构
 */
-(void)fetchCourseListWithID:(NSString*)pid
                        Type:(NSString*)type
                      UserId:(NSString*)userId
                     Success:(void(^)(CourseListResult *result))success
                     Failure:(void(^)(NSError* error))failure;
/**
 *  根据课程视频列表
 *
 *  @param pid     <#pid description#>
 *  @param success 返回课程子集及知识点
 *  @param failure <#failure description#>
 */
-(void)fetchSectionVideoWithID:(NSString*)pointId
                        UserId:(NSString*)userId
                       Success:(void(^)(VideoBoxResult *result))success
                       Failure:(void(^)(NSError* error))failure;

/**
 *  根据知识点获取视频信息
 *
 *  @param pointId  知识点ID
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchVideoInfoWithPointID:(NSString*)pointId
                         Success:(void(^)(VideoInfoResult *result))success
                         Failure:(void(^)(NSError* error))failure;

/**
 *  获取搜索页面的推荐关键词
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchKeywordListSuccess:(void(^)(KeywordListResult *result))success
                       Failure:(void(^)(NSError* error))failure;
/**
 *  视频检索
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchVideoListWithKeyword:(NSString*)keyword
                         Success:(void(^)(VideoListResult *result))success
                         Failure:(void(^)(NSError* error))failure;

/**
 *  获取首页banner
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchBannerListSuccess:(void(^)(BannerListResult *result))success
                      Failure:(void(^)(NSError* error))failure;

/**
 *  更新课程观看数量
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)updateCourseInfoWithVideoID:(NSString*)courseId
                           Success:(void(^)(CommonResult *result))success
                           Failure:(void(^)(NSError* error))failure;

/**
 *  更新视频观看数量
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)updateVideoInfoWithVideoID:(NSString*)videoId
                          Success:(void(^)(CommonResult *result))success
                          Failure:(void(^)(NSError* error))failure;

/**
 *  收藏视频
 *
 *  @param type 1:course 2 goods
 *  @param state 0 取消收藏 1 收藏
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)addVideoToCollectionWithUserId:(NSString*)userId
                              VideoId:(NSString*)videoId
                             CourseId:(NSString*)courseId
                                State:(NSString*)state
                                 Type:(NSString*)type
                              Success:(void(^)(CommonResult *result))success
                              Failure:(void(^)(NSError* error))failure;

/**
 *  获取用户收藏的课程或视频
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchVideoListWithUserId:(NSString*)userId
                        Success:(void(^)(CollectionListResult *result))success
                        Failure:(void(^)(NSError* error))failure;

/**
 *  取消当前用户所有收藏
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)removeCollectionWithUserId:(NSString*)userId
                          Success:(void(^)(CommonResult *result))success
                          Failure:(void(^)(NSError* error))failure;

/**
 *  获取知识点对应的试题
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchQuestionWithPointId:(NSString*)pointId
                        Success:(void(^)(QuestionListResult *result))success
                        Failure:(void(^)(NSError* error))failure;

/**
 *  提交试题
 *
 *  @param type 1 考点 2 题库
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)submitQuestionAnswerWithId:(NSString*)userId
                           answer:(NSString*)answer
                             type:(NSString*)type
                          Success:(void(^)(CommonResult *result))success
                          Failure:(void(^)(NSError* error))failure;

/**
 *  知识型谱 知识点做题结果统计
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchStatisticsListWithUserId:(NSString*)userId
                                Type:(NSString*)type
                             Success:(void(^)(StatisticsListResult *result))success
                             Failure:(void(^)(NSError* error))failure;

/**
 *  错题集列表
 *  @param type 1 考点 2 模考 3 真题
 *  @param type 1 数学 2 英语 3 逻辑 4 写作
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchMistakeListWithUserId:(NSString*)userId
                             Type:(NSString*)type
                      SubjetcType:(NSString*)subjectType
                          Success:(void(^)(MistakeListResult *result))success
                          Failure:(void(^)(NSError* error))failure;

/**
 *  错题集
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchWrongSubjectListWithID:(NSString*)courseId
                              Type:(NSString*)type
                            UserId:(NSString*)userId
                           Success:(void(^)(QuestionListResult *result))success
                           Failure:(void(^)(NSError* error))failure;

/**
 *  更新错题集（添加／移除）
 *  @param questionType 1 考点 2 模考或真题
 *  @param type 1 添加错题 2 移除错题
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)updateWrongSetWithUserId:(NSString*)userId
                      SubjectId:(NSString*)subjectId
                   QuestionType:(NSString*)questionType
                           Type:(NSString*)type
                        Success:(void(^)(CommonResult *result))success
                        Failure:(void(^)(NSError* error))failure;

@end
