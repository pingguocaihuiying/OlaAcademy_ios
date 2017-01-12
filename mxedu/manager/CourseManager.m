//
//  CourseManager.m
//  mxedu
//
//  Created by 田晓鹏 on 15/10/20.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import "CourseManager.h"

#import "DataMappingManager.h"
#import "SysCommon.h"

@implementation CourseManager

-(void)fetchCourseListWithID:(NSString*)pid
                        Type:(NSString*)type
                      UserId:(NSString*)userId
                     Success:(void(^)(CourseListResult *result))success
                     Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.courseListResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    [om getObjectsAtPath:@"/ola/cour/getCourList" parameters:@{ @"pid" : pid,
                                                                @"type": type,
                                                                @"userid": userId
                                                                    }
                 success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                     if ([mappingResult.firstObject isKindOfClass:[CourseListResult class]]) {
                         CourseListResult *result = mappingResult.firstObject;
                         if (result.code!=10000) {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:result.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                             [alert show];
                         }
                         if (success != nil) {
                             success(result);
                         }
                     }
                     
                 } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                     if (failure != nil) {
                         failure(error);
                     }
                 }];
}

-(void)fetchSectionVideoWithID:(NSString*)pointId
                        UserId:(NSString*)userId
                       Success:(void(^)(VideoBoxResult *result))success
                       Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.videoBoxResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    [om getObjectsAtPath:@"/ola/cour/getVideoByPoi" parameters:@{ @"pointId" : pointId,
                                                                  @"userId" : userId
                                                                }
                 success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                     if ([mappingResult.firstObject isKindOfClass:[VideoBoxResult class]]) {
                         VideoBoxResult *result = mappingResult.firstObject;
                         if (result.code!=10000) {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:result.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                             [alert show];
                         }
                         if (success != nil) {
                             success(result);
                         }
                     }
                     
                 } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                     if (failure != nil) {
                         failure(error);
                     }
                 }];
    
}

-(void)updateCourseInfoWithVideoID:(NSString*)courseId
                          Success:(void(^)(CommonResult *result))success
                          Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.commonResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    [om getObjectsAtPath:@"/ola/cour/updateCourseInfo" parameters:@{ @"courseId" : courseId
                                                                   }
                 success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                     if ([mappingResult.firstObject isKindOfClass:[CommonResult class]]) {
                         CommonResult *result = mappingResult.firstObject;
                         if (success != nil) {
                             success(result);
                         }
                     }
                     
                 } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                     if (failure != nil) {
                         failure(error);
                     }
                 }];
    
    
}

-(void)fetchBannerListSuccess:(void(^)(BannerListResult *result))success
                      Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.bannerListResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    [om getObjectsAtPath:@"/ola/cour/getBannerList" parameters:nil
                 success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                     if ([mappingResult.firstObject isKindOfClass:[BannerListResult class]]) {
                         BannerListResult *result = mappingResult.firstObject;
                         if (result.code!=10000) {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:result.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                             [alert show];
                         }
                         if (success != nil) {
                             success(result);
                         }
                     }
                     
                 } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                     if (failure != nil) {
                         failure(error);
                     }
                 }];
    
}


-(void)fetchVideoInfoWithPointID:(NSString*)pointId
                          Success:(void(^)(VideoInfoResult *result))success
                          Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.videoInfoResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    [om getObjectsAtPath:@"/ola/cour/getVideoByPoi" parameters:@{ @"pointId" : pointId
                                                                   }
                 success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                     if ([mappingResult.firstObject isKindOfClass:[VideoInfoResult class]]) {
                         VideoInfoResult *result = mappingResult.firstObject;
                         if (result.code!=10000) {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:result.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                             [alert show];
                         }
                         if (success != nil) {
                             success(result);
                         }
                     }
                     
                 } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                     if (failure != nil) {
                         failure(error);
                     }
                 }];
    
    
}

-(void)updateVideoInfoWithVideoID:(NSString*)videoId
                         Success:(void(^)(CommonResult *result))success
                         Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.commonResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    [om getObjectsAtPath:@"/ola/cour/updVideoInfo" parameters:@{ @"videoId" : videoId
                                                                  }
                 success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                     if ([mappingResult.firstObject isKindOfClass:[CommonResult class]]) {
                         CommonResult *result = mappingResult.firstObject;
                         if (success != nil) {
                             success(result);
                         }
                     }
                     
                 } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                     if (failure != nil) {
                         failure(error);
                     }
                 }];
    
    
}

-(void)fetchKeywordListSuccess:(void(^)(KeywordListResult *result))success
                        Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.keywordListResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    [om getObjectsAtPath:@"/ola/cour/getKeywordList" parameters:nil
                 success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                     if ([mappingResult.firstObject isKindOfClass:[KeywordListResult class]]) {
                         KeywordListResult *result = mappingResult.firstObject;
                         if (result.code!=10000) {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:result.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                             [alert show];
                         }
                         if (success != nil) {
                             success(result);
                         }
                     }
                     
                 } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                     if (failure != nil) {
                         failure(error);
                     }
                 }];
}

-(void)fetchVideoListWithKeyword:(NSString*)keyword
                         Success:(void(^)(VideoListResult *result))success
                        Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.videoListResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    // 采用post方式，get方式可能产生中文乱码
    [om postObject:nil path:@"/ola/cour/getVideoByKeyWord" parameters:@{ @"keyword" : keyword
                                                                           }
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[VideoListResult class]]) {
                   VideoListResult *result = mappingResult.firstObject;
                   if (result.code!=10000) {
                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:result.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                       [alert show];
                   }
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

-(void)addVideoToCollectionWithUserId:(NSString*)userId
                              VideoId:(NSString*)videoId
                             CourseId:(NSString*)courseId
                                State:(NSString*)state
                         Success:(void(^)(CommonResult *result))success
                         Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.commonResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    // 采用post方式，get方式可能产生中文乱码
    [om postObject:nil path:@"/ola/collection/collectionVideo" parameters:@{ @"userId" : userId,
                                                                             @"videoId" : videoId,
                                                                             @"courseId" : courseId,
                                                                             @"state" : state
                                                                             }
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[CommonResult class]]) {
                   CommonResult *result = mappingResult.firstObject;
                   if (result.code!=10000) {
                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:result.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                       [alert show];
                   }
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

-(void)fetchVideoListWithUserId:(NSString*)userId
                         Success:(void(^)(CollectionListResult *result))success
                         Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.collectionListResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    // 采用post方式，get方式可能产生中文乱码
    [om postObject:nil path:@"/ola/collection/getCollectionByUserId" parameters:@{ @"userId" : userId
                                                                         }
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[CollectionListResult class]]) {
                   CollectionListResult *result = mappingResult.firstObject;
                   if (result.code!=10000) {
                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:result.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                       [alert show];
                   }
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

-(void)fetchCollectionStateWithUserId:(NSString*)userId
                         CollectionId:(NSString*)collectionId
                                 Type:(NSString*)type
                        Success:(void(^)(VideoCollectionResult *result))success
                        Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.collectionStateResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    // 采用post方式，get方式可能产生中文乱码
    [om postObject:nil path:@"/ola/collection/getColletionState" parameters:@{ @"userId" : userId,
                                                                               @"collectionId" : collectionId,
                                                                               @"type" : type
                                                                                       }
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[VideoCollectionResult class]]) {
                   VideoCollectionResult *result = mappingResult.firstObject;
                   if (result.code!=10000) {
                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:result.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                       [alert show];
                   }
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


-(void)removeCollectionWithUserId:(NSString*)userId
                          Success:(void(^)(CommonResult *result))success
                          Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.commonResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    // 采用post方式，get方式可能产生中文乱码
    [om postObject:nil path:@"/ola/collection/removeColletionByUserId" parameters:@{ @"userId" : userId
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

/**
 *  获取知识点对应的试题
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchQuestionWithPointId:(NSString*)pointId
                        Success:(void(^)(QuestionListResult *result))success
                        Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.questionListResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    // 采用post方式，get方式可能产生中文乱码
    [om postObject:nil path:@"/ola/cour/getPoiSubList" parameters:@{ @"pointId" : pointId
                                                                                       }
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[QuestionListResult class]]) {
                   QuestionListResult *result = mappingResult.firstObject;
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
                          Success:(void(^)(QuestionListResult *result))success
                          Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.commonResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    // 采用post方式，get方式可能产生中文乱码
    [om postObject:nil path:@"/ola/cour/checkAnswer" parameters:@{ @"userId" : userId,
                                                                   @"answer" : answer,
                                                                   @"type" : type
                                                                     }
           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
               if ([mappingResult.firstObject isKindOfClass:[QuestionListResult class]]) {
                   QuestionListResult *result = mappingResult.firstObject;
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

/**
 *  知识型谱 知识点做题结果统计
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)fetchStatisticsListWithUserId:(NSString*)userId
                                Type:(NSString*)type
                             Success:(void(^)(StatisticsListResult *result))success
                             Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.statisticsListResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    [om getObjectsAtPath:@"/ola/cour/getStatisticsList" parameters:@{   @"userid": userId,
                                                                        @"type": type
                                                                        }
                 success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                     if ([mappingResult.firstObject isKindOfClass:[StatisticsListResult class]]) {
                         StatisticsListResult *result = mappingResult.firstObject;
                         if (result.code!=10000) {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:result.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                             [alert show];
                         }
                         if (success != nil) {
                             success(result);
                         }
                     }
                     
                 } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                     if (failure != nil) {
                         failure(error);
                     }
                 }];
}

// 错题集
-(void)fetchWrongSubjectListWithID:(NSString*)courseId
                        Type:(NSString*)type
                      UserId:(NSString*)userId
                     Success:(void(^)(QuestionListResult *result))success
                     Failure:(void(^)(NSError* error))failure{
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.questionListResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    // 通过shareManager 共享 baseurl及请求头等
    RKObjectManager* om = [RKObjectManager sharedManager];
    
    [om addResponseDescriptor:responseDescriptor];
    [om getObjectsAtPath:@"/ola/cour/getWrongSubSet" parameters:@{ @"cid" : courseId,
                                                                @"type": type,
                                                                @"userid": userId
                                                                }
                 success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                     if ([mappingResult.firstObject isKindOfClass:[QuestionListResult class]]) {
                         QuestionListResult *result = mappingResult.firstObject;
                         if (result.code!=10000) {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:result.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                             [alert show];
                         }
                         if (success != nil) {
                             success(result);
                         }
                     }
                     
                 } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                     if (failure != nil) {
                         failure(error);
                     }
                 }];
}

@end
