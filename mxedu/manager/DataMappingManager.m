//
//  DataMappingManager.m
//  NTreat
//
//  Created by 田晓鹏 on 15-4-24.
//  Copyright (c) 2015年 田晓鹏. All rights reserved.
//

#import "DataMappingManager.h"

#import "AuthResult.h"
#import "CommonResult.h"
#import "UploadResult.h"
#import "MediaUploadResult.h"
#import "User.h"
#import "UserInfoResult.h"
#import "SignInStatusResult.h"
#import "Location.h"
#import "LocationResult.h"
#import "SysCommon.h"

#import "Banner.h"
#import "HomeDataList.h"
#import "HomeListResult.h"

#import "Course.h"
#import "CourseListResult.h"
#import "CoursePoint.h"
#import "CourseVideo.h"
#import "VideoBox.h"
#import "VideoInfoResult.h"
#import "Question.h"
#import "QuestionOption.h"
#import "QuestionListResult.h"

#import "Mistake.h"
#import "MistakeListResult.h"

#import "Material.h"
#import "MaterialListResult.h"

#import "Group.h"
#import "GroupListResult.h"
#import "GroupMemberResult.h"

#import "Examination.h"
#import "ExamListRsult.h"

#import "Organization.h"
#import "OrganizationResult.h"

#import "OrgInfoList.h"
#import "OrgInfoListResult.h"

#import "Teacher.h"
#import "TeacherResult.h"

#import "Keyword.h"
#import "KeywordListResult.h"

#import "VideoBoxResult.h"
#import "VideoListResult.h"

#import "VideoCollection.h"
#import "VideoCollectionResult.h"

#import "CollectionVideo.h"
#import "CollectionListResult.h"

#import "CheckIn.h"
#import "CheckInResult.h"
#import "CheckInListResult.h"

#import "CoinHistory.h"
#import "CoinHistoryListResult.h"

#import "Commodity.h"
#import "CommodityListRsult.h"
#import "StatusResult.h"

#import "WXApiObject.h"
#import "PayReqResult.h"

#import "AliPayInfo.h"
#import "AliPayResult.h"

#import "ThirdPay.h"
#import "ThirdPayResult.h"

#import "OlaCircle.h"
#import "VideoHistoryResult.h"
#import "CircleDetailResult.h"
#import "StatisticsListResult.h"

#import "UserPost.h"
#import "UserPostResult.h"

#import "Comment.h"
#import "CommentListResult.h"

#import "CirclePraise.h"
#import "PraiseListResult.h"

#import "Message.h"
#import "MessageListResult.h"
#import "MessageUnreadResult.h"

#import "Consult.h"
#import "HomeworkListResult.h"
#import "StatisticsUser.h"
#import "WorkStatistics.h"
#import "WorkStatisticsListResult.h"

@implementation DataMappingManager

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    NSURL* rootURL = [NSURL URLWithString:BASIC_URL];
    _objectManager = [RKObjectManager managerWithBaseURL:rootURL];
    [RKObjectManager setSharedManager:_objectManager];
    
    // 注册rest 所允许接收的返回类型 （默认不包含text/plain text/html）
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/html"];
    
    AFHTTPClient* client = [RKObjectManager sharedManager].HTTPClient;
    [client setDefaultHeader:@"Accept-Encoding" value:@"gzip, deflate"];
    
    [self setupAuthTokenMappings];
    [self setupCommonMappings];
    [self setupUserMappings];
    [self setupSignInStatusResultMapping];
    [self setupUploadMappings];
    [self setupMediaUploadMappings];
    [self setupLoactionResultMapping];
    [self setupHomeDataListMapping];
    [self setupCourseListMapping];
    [self setupGroupListMapping];
    [self setupKeywordListMapping];
    [self setupVideoInfoMapping];
    [self setupVideoBoxMapping];
    [self setupVideoListMapping];
    [self setupOrganizationListMapping];
    [self setupOrgInfoListMapping];
    [self setupTeacherListMapping];
    [self setupUserCollectionMapping];
    [self setupCollectionStateMapping];
    [self setupCheckInMapping];
    [self setupCheckInListMapping];
    [self setupQuestionListMapping];
    [self setupHomeworkListMapping];
    [self setupWorkStatisticsListMapping];
    [self setupExamListMapping];
    [self setupCommodityListMapping];
    [self setupPayReqResultMapping];
    [self setupAliPayResultMapping];
    [self setupVideoHistoryListMapping];
    [self setupCircleDetailMapping];
    [self setupUserPostMapping];
    [self setupCommentListMapping];
    [self setupPraiseListMapping];
    [self setupStatisticsListMapping];
    [self setupBannerList];
    [self setupStatusMapping];
    [self setupThirdPayResultMapping];
    [self setupMessageListMapping];
    [self setupUnreadMessageMapping];
    [self setupCoinHistoryListResultMapping];
    [self setupMaterialListMapping];
    [self setupGroupMemberListMapping];
    [self setupMistakeListMapping];
}


-(void)setupAuthTokenMappings{
    
    _accessTokenMapping = [RKObjectMapping mappingForClass:[User class]];
    [_accessTokenMapping addAttributeMappingsFromDictionary:@{
                                                          @"id":         @"userId",
                                                          @"name":       @"name",
                                                          @"realName":   @"realName",
                                                          @"phone":      @"phone",
                                                          @"avator":     @"avatar",
                                                          @"age":        @"age",
                                                          @"sex":        @"sex",
                                                          @"isActive":   @"isActive",
                                                          @"sign":       @"signature",
                                                          @"coin":       @"coin",
                                                          @"examtype":   @"examType"
                                                          }];
    
    _authResultMapping = [RKObjectMapping mappingForClass:[AuthResult class]];
    [_authResultMapping addAttributeMappingsFromDictionary:@{
                                                             @"apicode":   @"code",
                                                             @"message":   @"message"
                                                              }];
    [_authResultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"data" toKeyPath:@"userInfo" withMapping:_accessTokenMapping]];
}

-(void)setupCommonMappings{
    _commonResultMapping = [RKObjectMapping mappingForClass:[CommonResult class]];
    [_commonResultMapping addAttributeMappingsFromDictionary:@{
                                                             @"apicode":   @"code",
                                                             @"message":   @"message"
                                                             }];
}

-(void)setupUserMappings{
    _userMapping  = [RKObjectMapping mappingForClass:[User class]];
    [_userMapping addAttributeMappingsFromDictionary:@{
                                                          @"id":         @"userId",
                                                          @"name":       @"name",
                                                          @"realName":   @"realName",
                                                          @"age":      @"age",
                                                          @"sex":      @"sex",
                                                          @"avator":   @"avatar",
                                                          @"local":      @"local",
                                                          @"phone":    @"phone",
                                                          @"isActive": @"isActive",
                                                          @"vipTime":    @"vipTime",
                                                          @"sign":    @"signature",
                                                          @"coin":  @"coin",
                                                          @"examtype":  @"examType"
                                                          }];
    
    _userInfoResultMapping = [RKObjectMapping mappingForClass:[UserInfoResult class]];
    [_userInfoResultMapping addAttributeMappingsFromDictionary:@{
                                                                @"apicode":     @"code",
                                                                @"message":   @"message"
                                                                }];
    [_userInfoResultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"data" toKeyPath:@"userInfo" withMapping:_userMapping]];
    
}

// 签到等任务状态
- (void)setupSignInStatusResultMapping
{
    RKObjectMapping *signInStatus = [RKObjectMapping mappingForClass:[SignInStatus class]];
    [signInStatus addAttributeMappingsFromDictionary:@{
                                                        @"status":        @"status",
                                                        @"lastSignIn":    @"lastSignIn",
                                                        @"signInDays":    @"signInDays",
                                                        @"coin":          @"coin",
                                                        @"todayCoin":     @"todayCoin",
                                                        @"profileTask":   @"profileTask",
                                                        @"vipTask":       @"vipTask",
                                                        @"courseTask":    @"courseTask",
                                                        @"courseCollectNum" : @"courseCollectNum",
                                                        @"coursBuyNum" : @"coursBuyNum"
                                                           }];
    _signInStatusResultMapping = [RKObjectMapping mappingForClass:[SignInStatusResult class]];
    [_signInStatusResultMapping addAttributeMappingsFromDictionary:@{
                                                                  @"code": @"code",
                                                                  @"message": @"message"
                                                                  }];
    [_signInStatusResultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"signInStatus" withMapping:signInStatus]];
}

//欧拉币明细
- (void)setupCoinHistoryListResultMapping
{
    RKObjectMapping *coinHistory = [RKObjectMapping mappingForClass:[CoinHistory class]];
    [coinHistory addAttributeMappingsFromDictionary:@{
                                                       @"id":        @"historyId",
                                                       @"userId":    @"userId",
                                                       @"name":      @"name",
                                                       @"type":      @"type",
                                                       @"date":      @"date",
                                                       @"dealNum":   @"dealNum"
                                                       }];
    _coinHistoryListResultMapping = [RKObjectMapping mappingForClass:[CoinHistoryListResult class]];
    [_coinHistoryListResultMapping addAttributeMappingsFromDictionary:@{
                                                                     @"code": @"code",
                                                                     @"message": @"message"
                                                                     }];
    [_coinHistoryListResultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"historyArray" withMapping:coinHistory]];
}

-(void)setupUploadMappings{
    _uploadResultMapping = [RKObjectMapping mappingForClass:[UploadResult class]];
    [_uploadResultMapping addAttributeMappingsFromDictionary:@{
                                                            @"code":   @"code",
                                                            @"message":   @"message",
                                                            @"imgGid":   @"imgGid"
                                                               }];
}

-(void)setupMediaUploadMappings{
    _mediaUploadResultMapping = [RKObjectMapping mappingForClass:[MediaUploadResult class]];
    [_mediaUploadResultMapping addAttributeMappingsFromDictionary:@{
                                                            @"code":   @"code",
                                                            @"message":@"message",
                                                            @"pic":    @"imgGid",
                                                            @"url":    @"movieUrl"
                                                               }];
}

- (void)setupLoactionResultMapping
{
    _locationMapping = [RKObjectMapping mappingForClass:[Location class]];
    [_locationMapping addAttributeMappingsFromDictionary:@{
                                                          @"code":         @"code",
                                                          @"name":       @"name",
                                                          @"level":      @"level"
                                                          }];
    _loacationResultMapping = [RKObjectMapping mappingForClass:[LocationResult class]];
    [_loacationResultMapping addAttributeMappingsFromDictionary:@{
                                                                      @"code": @"code",
                                                                      @"message": @"message"
                                                                      }];
    [_loacationResultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result_data" toKeyPath:@"locationArray" withMapping:_locationMapping]];
}

-(void)setupHomeDataListMapping{
    
    RKObjectMapping* commodityMapping = [RKObjectMapping mappingForClass:[Commodity class]];
    [commodityMapping addAttributeMappingsFromDictionary:@{
                                                           @"id":           @"comId",
                                                           @"name":         @"name",
                                                           @"detail":       @"detail",
                                                           @"org":      @"org",
                                                           @"attentionnum": @"attentionnum",
                                                           @"paynum":    @"paynum",
                                                           @"price":     @"price",
                                                           @"status":    @"status",
                                                           @"type":      @"type",
                                                           @"totaltime":    @"totaltime",
                                                           @"videonum":    @"videonum",
                                                           @"suitto":    @"suitto",
                                                           @"leanstage":    @"leanstage",
                                                           @"image":        @"image",
                                                           @"url":        @"url"
                                                           }];
    
    RKObjectMapping *bannerMapping = [RKObjectMapping mappingForClass:[Banner class]];
    [bannerMapping addAttributeMappingsFromDictionary:@{
                                                        @"id":         @"bannerId",
                                                        @"name":       @"name",
                                                        @"objectId":   @"objectId",
                                                        @"type":       @"type",
                                                        @"pic":        @"pic",
                                                        @"url":        @"url",
                                                        }];
    [bannerMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"commodity" toKeyPath:@"commodity" withMapping:commodityMapping]];
    
    RKObjectMapping *consultMapping = [RKObjectMapping mappingForClass:[Consult class]];
    [consultMapping addAttributeMappingsFromDictionary:@{
                                                        @"id":         @"consultId",
                                                        @"content":    @"content",
                                                        @"number":     @"number",
                                                        @"time":       @"time",
                                                        }];
    
    RKObjectMapping* courseMapping = [RKObjectMapping mappingForClass:[Course class]];
    [courseMapping addAttributeMappingsFromDictionary:@{
                                                          @"id":         @"courseId",
                                                          @"name":       @"name",
                                                          @"pid":        @"pid",
                                                          @"profile":    @"profile",
                                                          @"address":    @"address",
                                                          @"type":       @"type",
                                                          @"subNum":     @"subNum",
                                                          @"subAllNum":  @"subAllNum",
                                                          @"playcount":  @"playcount",
                                                          @"totalTime":  @"totalTime"
                                                          }];
    
    RKObjectMapping *homeDataListMapping = [RKObjectMapping mappingForClass:[HomeDataList class]];
    [homeDataListMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"bannerList" toKeyPath:@"bannerArray" withMapping:bannerMapping]];
    [homeDataListMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"questionList" toKeyPath:@"consultArray" withMapping:consultMapping]];
    [homeDataListMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"goodsList" toKeyPath:@"comodityArray" withMapping:commodityMapping]];
    [homeDataListMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"courseList" toKeyPath:@"courseArray" withMapping:courseMapping]];
    
    _homeListResultMapping = [RKObjectMapping mappingForClass:[HomeListResult class]];
    [_homeListResultMapping addAttributeMappingsFromDictionary:@{
                                                                   @"apicode": @"code",
                                                                   @"message": @"message"
                                                                   }];
    [_homeListResultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"homeData" withMapping:homeDataListMapping]];

}

-(void)setupCourseListMapping{
    
    RKObjectMapping* _courseMapping1 = [RKObjectMapping mappingForClass:[Course class]];
    [_courseMapping1 addAttributeMappingsFromDictionary:@{
                                                          @"id":         @"courseId",
                                                          @"name":       @"name",
                                                          @"pid":        @"pid",
                                                          @"profile":    @"profile",
                                                          @"address":    @"address",
                                                          @"type":       @"type",
                                                          @"subNum":     @"subNum",
                                                          @"subAllNum":  @"subAllNum",
                                                          @"playcount":  @"playcount",
                                                          @"totalTime":  @"totalTime"
                                                           }];

    [_courseMapping1 addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"child" toKeyPath:@"subList" withMapping:_courseMapping1]];
    
    RKObjectMapping* _courseMapping2 = [RKObjectMapping mappingForClass:[Course class]];
    [_courseMapping2 addAttributeMappingsFromDictionary:@{
                                                          
                                                          @"id":         @"courseId",
                                                          @"name":       @"name",
                                                          @"profile":    @"profile",
                                                          @"address":    @"address",
                                                          @"subNum":     @"subNum",
                                                          @"subAllNum":  @"subAllNum",
                                                          @"bannerPic":  @"bannerPic"
                                                          }];
    RKObjectMapping* homeworkMapping = [RKObjectMapping mappingForClass:[Homework class]];
    [homeworkMapping addAttributeMappingsFromDictionary:@{
                                                          @"id":         @"homeworkId",
                                                          @"name":       @"name",
                                                          @"userName":   @"userName",
                                                          @"avatar":     @"avatar",
                                                          @"groupId":    @"groupId",
                                                          @"groupName":  @"groupName",
                                                          @"count":      @"count",
                                                          @"finishedCount": @"finishedCount",
                                                          @"time":       @"time"
                                                          }];
    [_courseMapping2 addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"homework" toKeyPath:@"homework" withMapping:homeworkMapping]];
    [_courseMapping2 addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"child" toKeyPath:@"subList" withMapping:_courseMapping1]];
    
    _courseListResultMapping = [RKObjectMapping mappingForClass:[CourseListResult class]];
    [_courseListResultMapping addAttributeMappingsFromDictionary:@{
                                                                  @"apicode": @"code",
                                                                  @"message": @"message"
                                                                  }];
    [_courseListResultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"course" withMapping:_courseMapping2]];
}

-(void)setupMistakeListMapping{
    RKObjectMapping* mistakeMapping = [RKObjectMapping mappingForClass:[Mistake class]];
    [mistakeMapping addAttributeMappingsFromDictionary:@{
                                                       @"id":         @"mistakeId",
                                                       @"name":       @"name",
                                                       @"subAllNum":  @"subAllNum",
                                                       @"wrongNum":   @"wrongNum"
                                                       }];
    _mistakeListResultMapping = [RKObjectMapping mappingForClass:[MistakeListResult class]];
    [_mistakeListResultMapping addAttributeMappingsFromDictionary:@{
                                                                  @"apicode": @"code",
                                                                  @"message": @"message"
                                                                  }];
    [_mistakeListResultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"mistakeArray" withMapping:mistakeMapping]];
}


-(void)setupGroupListMapping{
    RKObjectMapping* groupMapping = [RKObjectMapping mappingForClass:[Group class]];
    [groupMapping addAttributeMappingsFromDictionary:@{
                                                       @"id":         @"groupId",
                                                       @"name":       @"name",
                                                       @"profile":    @"profile",
                                                       @"avatar":     @"avatar",
                                                       @"createUser": @"createUserId",
                                                       @"isMember":   @"isMember",
                                                       @"number":     @"number",
                                                       @"time":       @"time"
                                                       }];
    _groupListResultMapping = [RKObjectMapping mappingForClass:[GroupListResult class]];
    [_groupListResultMapping addAttributeMappingsFromDictionary:@{
                                                                  @"apicode": @"code",
                                                                  @"message": @"message"
                                                                  }];
    [_groupListResultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"groupArray" withMapping:groupMapping]];
}

-(void)setupGroupMemberListMapping{
    RKObjectMapping* userMapping = [RKObjectMapping mappingForClass:[User class]];
    [userMapping addAttributeMappingsFromDictionary:@{
                                                      @"id":         @"userId",
                                                      @"name":       @"name",
                                                      @"realName":   @"realName",
                                                      @"phone":      @"phone",
                                                      @"avator":     @"avatar",
                                                      @"age":        @"age",
                                                      @"sex":        @"sex",
                                                      @"isActive":   @"isActive",
                                                      @"sign":       @"signature",
                                                      @"coin":       @"coin",
                                                      @"examtype":   @"examType"
                                                       }];
    _memberListResultMapping = [RKObjectMapping mappingForClass:[GroupMemberResult class]];
    [_memberListResultMapping addAttributeMappingsFromDictionary:@{
                                                                  @"apicode": @"code",
                                                                  @"message": @"message"
                                                                  }];
    [_memberListResultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"memberArray" withMapping:userMapping]];
}

-(void)setupHomeworkListMapping{
    RKObjectMapping* homeworkMapping = [RKObjectMapping mappingForClass:[Homework class]];
    [homeworkMapping addAttributeMappingsFromDictionary:@{
                                                          @"id":         @"homeworkId",
                                                          @"name":       @"name",
                                                          @"userName":   @"userName",
                                                          @"avatar":     @"avatar",
                                                          @"groupId":    @"groupId",
                                                          @"groupName":  @"groupName",
                                                          @"count":      @"count",
                                                          @"finishedCount": @"finishedCount",
                                                          @"finishedPercent": @"finishedPercent",
                                                          @"time":       @"time"
                                                          }];
    _homeworkListResultMapping = [RKObjectMapping mappingForClass:[HomeworkListResult class]];
    [_homeworkListResultMapping addAttributeMappingsFromDictionary:@{
                                                                   @"apicode": @"code",
                                                                   @"message": @"message"
                                                                   }];
    [_homeworkListResultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"homeworkArray" withMapping:homeworkMapping]];

}

-(void)setupWorkStatisticsListMapping{
    RKObjectMapping* statisticsUserMapping = [RKObjectMapping mappingForClass:[StatisticsUser class]];
    [statisticsUserMapping addAttributeMappingsFromDictionary:@{
                                                          @"userId":     @"userId",
                                                          @"userName":   @"userName",
                                                          @"userAvatar": @"userAvatar",
                                                          @"location":   @"location",
                                                          @"finished":   @"finished"
                                                          }];
    
    RKObjectMapping* workStatisticsMapping = [RKObjectMapping mappingForClass:[WorkStatistics class]];
    [workStatisticsMapping addAttributeMappingsFromDictionary:@{
                                                    @"unfinishedCount": @"unfinishedCount",
                                                    @"finishedCount":   @"finishedCount",
                                                    @"correctness":     @"correctness"
                                                            }];
    [workStatisticsMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"statisticsList" toKeyPath:@"statisticsList" withMapping:statisticsUserMapping]];
    
    _workStatisticsListResultMapping = [RKObjectMapping mappingForClass:[WorkStatisticsListResult class]];
    [_workStatisticsListResultMapping addAttributeMappingsFromDictionary:@{
                                                                     @"apicode": @"code",
                                                                     @"message": @"message"
                                                                     }];
    [_workStatisticsListResultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"workStatistics" withMapping:workStatisticsMapping]];
    
}

-(void)setupBannerList{
    RKObjectMapping* _courseMapping = [RKObjectMapping mappingForClass:[Course class]];
    [_courseMapping addAttributeMappingsFromDictionary:@{
                                                          @"id":         @"courseId",
                                                          @"name":       @"name",
                                                          @"pid":        @"pid",
                                                          @"profile":    @"profile",
                                                          @"address":    @"address",
                                                          @"type":       @"type",
                                                          @"subNum":     @"subNum",
                                                          @"subAllNum":  @"subAllNum",
                                                          @"playcount":  @"playcount",
                                                          @"totalTime":  @"totalTime"
                                                          }];
    
    _bannerListResultMapping = [RKObjectMapping mappingForClass:[BannerListResult class]];
    [_bannerListResultMapping addAttributeMappingsFromDictionary:@{
                                                                   @"apicode": @"code",
                                                                   @"message": @"message"
                                                                   }];
    [_bannerListResultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"bannerArray" withMapping:_courseMapping]];
}

-(void)setupVideoInfoMapping{
    
    RKObjectMapping* _videoMapping = [RKObjectMapping mappingForClass:[CourseVideo class]];
    [_videoMapping addAttributeMappingsFromDictionary:@{
                                                        @"id":         @"videoId",
                                                        @"address":    @"address",
                                                        @"name":       @"name",
                                                        @"content":    @"content",
                                                        @"timeSpan":   @"timeSpan",
                                                        @"playCount":  @"playCount",
                                                        @"weight":     @"weight",
                                                        @"pic":        @"pic",
                                                        @"isfree":     @"isfree"
                                                        }];
    
    _videoInfoResultMapping = [RKObjectMapping mappingForClass:[VideoInfoResult class]];
    [_videoInfoResultMapping addAttributeMappingsFromDictionary:@{
                                                                @"apicode": @"code",
                                                                @"message": @"message"
                                                                         }];
    [_videoInfoResultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"video" withMapping:_videoMapping]];
}

-(void)setupExamListMapping{
    
    RKObjectMapping* _examMapping = [RKObjectMapping mappingForClass:[Examination class]];
    [_examMapping addAttributeMappingsFromDictionary:@{
                                                        @"cid":          @"cid",
                                                        @"id":           @"examId",
                                                        @"coverpoint":   @"coverpoint",
                                                        @"degree":       @"degree",
                                                        @"source":       @"source",
                                                        @"learnNum":     @"learnNum",
                                                        @"name":         @"name",
                                                        @"target":       @"target",
                                                        @"rank":         @"rank",
                                                        @"progress":     @"progress",
                                                        @"isfree":       @"isfree"
                                                        }];
    
    _examListResultMapping = [RKObjectMapping mappingForClass:[ExamListRsult class]];
    [_examListResultMapping addAttributeMappingsFromDictionary:@{
                                                                  @"apicode": @"code",
                                                                  @"message": @"message"
                                                                  }];
    [_examListResultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"examArray" withMapping:_examMapping]];
}

-(void)setupQuestionListMapping{
    
    RKObjectMapping* _optionMapping = [RKObjectMapping mappingForClass:[QuestionOption class]];
    [_optionMapping addAttributeMappingsFromDictionary:@{
                                                           @"id":         @"optionId",
                                                           @"sid":    @"sid",
                                                           @"type":         @"type",
                                                           @"isanswer":    @"isanswer",
                                                           @"content":         @"content"
                                                           }];
    
    RKObjectMapping* _questionMapping = [RKObjectMapping mappingForClass:[Question class]];
    [_questionMapping addAttributeMappingsFromDictionary:@{
                                                             @"id":         @"questionId",
                                                             @"article":    @"article",
                                                             @"question":    @"question",
                                                             @"type":         @"type",
                                                             @"degree":    @"degree",
                                                             @"hint":         @"hint",
                                                             @"allcount":    @"allcount",
                                                             @"rightcount":   @"rightcount",
                                                             @"avgtime":    @"avgtime",
                                                             @"pic":    @"pic",
                                                             @"hintpic":    @"hintpic",
                                                             @"videourl":    @"videourl"
                                                             }];
     [_questionMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"optionList" toKeyPath:@"optionList" withMapping:_optionMapping]];
    
    _questionListResultMapping = [RKObjectMapping mappingForClass:[QuestionListResult class]];
    [_questionListResultMapping addAttributeMappingsFromDictionary:@{
                                                                        @"apicode": @"code",
                                                                        @"message": @"message"
                                                                        }];
    [_questionListResultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"questionArray" withMapping:_questionMapping]];
}

-(void)setupCollectionStateMapping{
    
    RKObjectMapping* _collectionMapping = [RKObjectMapping mappingForClass:[VideoCollection class]];
    [_collectionMapping addAttributeMappingsFromDictionary:@{
                                                        @"isCollect":         @"isCollect",
                                                        @"collectCount":    @"collectCount"
                                                        }];
    
    _collectionStateResultMapping = [RKObjectMapping mappingForClass:[VideoCollectionResult class]];
    [_collectionStateResultMapping addAttributeMappingsFromDictionary:@{
                                                                  @"apicode": @"code",
                                                                  @"message": @"message"
                                                                  }];
    [_collectionStateResultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"collection" withMapping:_collectionMapping]];
}

-(void)setupUserCollectionMapping{
    
    RKObjectMapping* _videoMapping = [RKObjectMapping mappingForClass:[CollectionVideo class]];
    [_videoMapping addAttributeMappingsFromDictionary:@{
                                                        @"videoId":    @"videoId",
                                                        @"videoName":  @"videoName",
                                                        @"videoPic":   @"videoPic",
                                                        @"videoUrl":   @"videoUrl",
                                                        @"courseId":   @"courseId",
                                                        @"coursePic":  @"coursePic",
                                                        @"totalTime":  @"totalTime",
                                                        @"subAllNum":  @"subAllNum",
                                                        @"type":  @"type"
                                                        }];
    
    _collectionListResultMapping = [RKObjectMapping mappingForClass:[CollectionListResult class]];
    [_collectionListResultMapping addAttributeMappingsFromDictionary:@{
                                                                  @"apicode": @"code",
                                                                  @"message": @"message"
                                                                  }];
    [_collectionListResultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"collectionArray" withMapping:_videoMapping]];
}

-(void)setupKeywordListMapping{
    
    RKObjectMapping* _keywordMapping = [RKObjectMapping mappingForClass:[Keyword class]];
    [_keywordMapping addAttributeMappingsFromDictionary:@{
                                                        @"id":         @"keyId",
                                                        @"name":       @"name",
                                                        @"weight":     @"weight"
                                                        }];
    
    _keywordListResultMapping = [RKObjectMapping mappingForClass:[KeywordListResult class]];
    [_keywordListResultMapping addAttributeMappingsFromDictionary:@{
                                                                  @"apicode": @"code",
                                                                  @"message": @"message"
                                                                  }];
    [_keywordListResultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"keywordList" withMapping:_keywordMapping]];
}

-(void)setupVideoBoxMapping{
    
    RKObjectMapping* _videoBoxMapping = [RKObjectMapping mappingForClass:[VideoBox class]];
    [_videoBoxMapping addAttributeMappingsFromDictionary:@{
                                                        @"isCollect":  @"isCollect"
                                                        }];

    
    RKObjectMapping* _videoMapping = [RKObjectMapping mappingForClass:[CourseVideo class]];
    [_videoMapping addAttributeMappingsFromDictionary:@{
                                                        @"id":         @"videoId",
                                                        @"address":    @"address",
                                                        @"name":       @"name",
                                                        @"content":    @"content",
                                                        @"timeSpan":   @"timeSpan",
                                                        @"playCount":  @"playCount",
                                                        @"weight":     @"weight",
                                                        @"orgname":    @"orgName",
                                                        @"pic":        @"pic",
                                                        @"isfree":     @"isfree",
                                                        @"attachmentId":@"attachmentId",
                                                        @"url":     @"url"
                                                        }];
    [_videoBoxMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"videoList" toKeyPath:@"videoList" withMapping:_videoMapping]];
    
    _videoBoxResultMapping = [RKObjectMapping mappingForClass:[VideoBoxResult class]];
    [_videoBoxResultMapping addAttributeMappingsFromDictionary:@{
                                                                  @"apicode": @"code",
                                                                  @"message": @"message"
                                                                  }];
    [_videoBoxResultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"videoBox" withMapping:_videoBoxMapping]];
}

-(void)setupVideoListMapping{
    
    RKObjectMapping* _videoMapping = [RKObjectMapping mappingForClass:[CourseVideo class]];
    [_videoMapping addAttributeMappingsFromDictionary:@{
                                                          @"id":         @"videoId",
                                                          @"address":    @"address",
                                                          @"name":       @"name",
                                                          @"content":    @"content",
                                                          @"timeSpan":   @"timeSpan",
                                                          @"playCount":  @"playCount",
                                                          @"weight":     @"weight",
                                                          @"orgname":    @"orgName",
                                                          @"pic":        @"pic",
                                                          @"isfree":     @"isfree",
                                                          @"attachmentId":@"attachmentId",
                                                          @"url":     @"url"
                                                          }];
    
    _videoListResultMapping = [RKObjectMapping mappingForClass:[VideoListResult class]];
    [_videoListResultMapping addAttributeMappingsFromDictionary:@{
                                                                @"apicode": @"code",
                                                                @"message": @"message",
                                                                @"orderStatus":@"orderStatus",
                                                                @"isCollect":@"isCollect"
                                                                }];
    [_videoListResultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"videoList" withMapping:_videoMapping]];
}

-(void)setupCommodityListMapping{
    
    RKObjectMapping* commodityMapping = [RKObjectMapping mappingForClass:[Commodity class]];
    [commodityMapping addAttributeMappingsFromDictionary:@{
                                                        @"id":           @"comId",
                                                        @"name":         @"name",
                                                        @"detail":       @"detail",
                                                        @"org":      @"org",
                                                        @"attentionnum": @"attentionnum",
                                                        @"paynum":    @"paynum",
                                                        @"price":     @"price",
                                                        @"status":    @"status",
                                                        @"type":      @"type",
                                                        @"totaltime":    @"totaltime",
                                                        @"videonum":    @"videonum",
                                                        @"suitto":    @"suitto",
                                                        @"leanstage":    @"leanstage",
                                                        @"image":        @"image",
                                                        @"url":        @"url"
                                                        }];
    
    _commodityListResultMapping = [RKObjectMapping mappingForClass:[CommodityListRsult class]];
    [_commodityListResultMapping addAttributeMappingsFromDictionary:@{
                                                                  @"apicode": @"code",
                                                                  @"message": @"message"
                                                                  }];
    [_commodityListResultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"commodityArray" withMapping:commodityMapping]];
}

// 资料库
-(void)setupMaterialListMapping{
    
    RKObjectMapping* materialMapping = [RKObjectMapping mappingForClass:[Material class]];
    [materialMapping addAttributeMappingsFromDictionary:@{
                                                           @"id":       @"materialId",
                                                           @"title":     @"title",
                                                           @"provider":  @"provider",
                                                           @"pic":       @"pic",
                                                           @"url":       @"url",
                                                           @"size":      @"size",
                                                           @"time":      @"time",
                                                           @"type":      @"type",
                                                           @"price":     @"price",
                                                           @"count":     @"count",
                                                           @"status":    @"status",
                                                           }];
    
    _materialListResultMapping = [RKObjectMapping mappingForClass:[MaterialListResult class]];
    [_materialListResultMapping addAttributeMappingsFromDictionary:@{
                                                                      @"apicode": @"code",
                                                                      @"message": @"message"
                                                                      }];
    [_materialListResultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"materialArray" withMapping:materialMapping]];
}

-(void)setupThirdPayResultMapping{
    
    RKObjectMapping* thirdPayMapping = [RKObjectMapping mappingForClass:[ThirdPay class]];
    [thirdPayMapping addAttributeMappingsFromDictionary:@{
                                                           @"version":      @"version",
                                                           @"thirdPay":     @"thirdPay"
                                                           }];
    
    _thirdPayResultMapping = [RKObjectMapping mappingForClass:[ThirdPayResult class]];
    [_thirdPayResultMapping addAttributeMappingsFromDictionary:@{
                                                               @"apicode": @"code",
                                                               @"message": @"message"
                                                               }];
    [_thirdPayResultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"thirdPay" withMapping:thirdPayMapping]];
}

-(void)setupStatusMapping{
    
    _statusResultMapping = [RKObjectMapping mappingForClass:[StatusResult class]];
    [_statusResultMapping addAttributeMappingsFromDictionary:@{
                                                               @"apicode": @"code",
                                                               @"message": @"message",
                                                               @"result":  @"status"
                                                                      }];
}

-(void)setupOrganizationListMapping{
    
    RKObjectMapping* _orgMapping = [RKObjectMapping mappingForClass:[Organization class]];
    [_orgMapping addAttributeMappingsFromDictionary:@{
                                                        @"id":            @"orgId",
                                                        @"address":       @"address",
                                                        @"name":          @"name",
                                                        @"org":           @"org",
                                                        @"logo":          @"logo",
                                                        @"type":          @"type",
                                                        @"profile":       @"profile",
                                                        @"checkinCount":  @"checkinCount",
                                                        @"attendCount":   @"attendCount",
                                                        @"checkedIn":     @"checkedIn"
                                                        }];
    
    _orgListResultMapping = [RKObjectMapping mappingForClass:[OrganizationResult class]];
    [_orgListResultMapping addAttributeMappingsFromDictionary:@{
                                                                  @"apicode": @"code",
                                                                  @"message": @"message"
                                                                  }];
    [_orgListResultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"orgList" withMapping:_orgMapping]];
}

// 首页我要报名
-(void)setupOrgInfoListMapping{
    
    RKObjectMapping* orgMapping = [RKObjectMapping mappingForClass:[Organization class]];
    [orgMapping addAttributeMappingsFromDictionary:@{
                                                      @"id":            @"orgId",
                                                      @"address":       @"address",
                                                      @"name":          @"name",
                                                      @"org":           @"org",
                                                      @"logo":          @"logo",
                                                      @"type":          @"type",
                                                      @"profile":       @"profile"
                                                      }];
    
    RKObjectMapping* orgInfoListMapping = [RKObjectMapping mappingForClass:[OrgInfoList class]];
    [orgInfoListMapping addAttributeMappingsFromDictionary:@{
                                                                @"optionName": @"optionName"
                                                                }];
    [orgInfoListMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"optionList" toKeyPath:@"optionList" withMapping:orgMapping]];
    
    _orgInfoListResultMapping = [RKObjectMapping mappingForClass:[OrgInfoListResult class]];
    [_orgInfoListResultMapping addAttributeMappingsFromDictionary:@{
                                                                @"apicode": @"code",
                                                                @"message": @"message"
                                                                }];
    [_orgInfoListResultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"orgInfoArray" withMapping:orgInfoListMapping]];
}

-(void)setupCheckInMapping{
    
    RKObjectMapping* _checkInMapping = [RKObjectMapping mappingForClass:[CheckIn class]];
    [_checkInMapping addAttributeMappingsFromDictionary:@{
                                                          @"orgId":         @"orgId",
                                                          @"userLocal":     @"userLocal",
                                                          @"orgPic":        @"orgPic",
                                                          @"userPhone":     @"userPhone",
                                                          @"type":          @"type",
                                                          @"orgName":       @"orgName",
                                                          @"checkinTime":   @"checkinTime"
                                                          }];
    
    _checkInResultMapping = [RKObjectMapping mappingForClass:[CheckInResult class]];
    [_checkInResultMapping addAttributeMappingsFromDictionary:@{
                                                                    @"apicode": @"code",
                                                                    @"message": @"message"
                                                                    }];
    [_checkInResultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"checkInfo" withMapping:_checkInMapping]];
}


-(void)setupCheckInListMapping{
    
    RKObjectMapping* _checkInMapping = [RKObjectMapping mappingForClass:[CheckIn class]];
    [_checkInMapping addAttributeMappingsFromDictionary:@{
                                                          @"checkId":       @"checkId",
                                                          @"orgId":         @"orgId",
                                                          @"userLocal":     @"userLocal",
                                                          @"orgPic":        @"orgPic",
                                                          @"userPhone":     @"userPhone",
                                                          @"type":          @"type",
                                                          @"orgName":       @"orgName",
                                                          @"checkinTime":   @"checkinTime"
                                                      }];
    
    _checkInListResultMapping = [RKObjectMapping mappingForClass:[CheckInListResult class]];
    [_checkInListResultMapping addAttributeMappingsFromDictionary:@{
                                                                @"apicode": @"code",
                                                                @"message": @"message"
                                                                }];
    [_checkInListResultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"checkInList" withMapping:_checkInMapping]];
}

-(void)setupTeacherListMapping{
    
    RKObjectMapping* _teacherMapping = [RKObjectMapping mappingForClass:[Teacher class]];
    [_teacherMapping addAttributeMappingsFromDictionary:@{
                                                      @"id":            @"teacherId",
                                                      @"name":          @"name",
                                                      @"avatar":        @"avatar",
                                                      @"profile":       @"profile"
                                                      }];
    
    _teacherListResultMapping = [RKObjectMapping mappingForClass:[TeacherResult class]];
    [_teacherListResultMapping addAttributeMappingsFromDictionary:@{
                                                                @"apicode": @"code",
                                                                @"message": @"message"
                                                                }];
    [_teacherListResultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"teacherList" withMapping:_teacherMapping]];
}

-(void)setupVideoHistoryListMapping{
    
    RKObjectMapping* _historyMapping = [RKObjectMapping mappingForClass:[OlaCircle class]];
    [_historyMapping addAttributeMappingsFromDictionary:@{
                                                          @"circleId": @"circleId",
                                                          @"userId": @"userId",
                                                          @"userName": @"userName",
                                                          @"userAvatar": @"userAvatar",
                                                          @"videoId": @"videoId",
                                                          @"courseId": @"courseId",
                                                          @"title": @"title",
                                                          @"content": @"content",
                                                          @"imageGids": @"imageGids",
                                                          @"location": @"location",
                                                          @"praiseNumber": @"praiseNumber",
                                                          @"readNumber": @"readNumber",
                                                          @"commentNumber": @"commentNumber",
                                                          @"time": @"time",
                                                          @"type": @"type"
                                                          }];
    
    _historyListResultMapping = [RKObjectMapping mappingForClass:[VideoHistoryResult class]];
    [_historyListResultMapping addAttributeMappingsFromDictionary:@{
                                                                    @"apicode": @"code",
                                                                    @"message": @"message"
                                                                    }];
    [_historyListResultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"historyArray" withMapping:_historyMapping]];
}

-(void)setupCircleDetailMapping{
    RKObjectMapping* circleMapping = [RKObjectMapping mappingForClass:[OlaCircle class]];
    [circleMapping addAttributeMappingsFromDictionary:@{
                                                          @"id":       @"circleId",
                                                          @"userId":   @"userId",
                                                          @"userName": @"userName",
                                                          @"userAvatar": @"userAvatar",
                                                          @"videoId": @"videoId",
                                                          @"courseId": @"courseId",
                                                          @"title": @"title",
                                                          @"content": @"content",
                                                          @"imageGids": @"imageGids",
                                                          @"location": @"location",
                                                          @"isPraised": @"isPraised",
                                                          @"praiseNumber": @"praiseNumber",
                                                          @"readNumber": @"readNumber",
                                                          @"commentNumber": @"commentNumber",
                                                          @"time": @"time",
                                                          @"type": @"type"
                                                          }];
    _circleDetailResultMapping = [RKObjectMapping mappingForClass:[CircleDetailResult class]];
    [_circleDetailResultMapping addAttributeMappingsFromDictionary:@{
                                                                    @"message":   @"message",
                                                                    @"apicode":   @"code"
                                                                    }];
    [_circleDetailResultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"circleDetail" withMapping:circleMapping]];
    
}

// 个人主页
-(void)setupUserPostMapping{
    RKObjectMapping* circleMapping = [RKObjectMapping mappingForClass:[OlaCircle class]];
    [circleMapping addAttributeMappingsFromDictionary:@{
                                                        @"id":       @"circleId",
                                                        @"userName": @"userName",
                                                        @"userAvatar": @"userAvatar",
                                                        @"videoId": @"videoId",
                                                        @"courseId": @"courseId",
                                                        @"title": @"title",
                                                        @"content": @"content",
                                                        @"imageGids": @"imageGids",
                                                        @"location": @"location",
                                                        @"praiseNumber": @"praiseNumber",
                                                        @"readNumber": @"readNumber",
                                                        @"commentNumber": @"commentNumber",
                                                        @"time": @"time",
                                                        @"type": @"type"
                                                        }];
    RKObjectMapping* userPostMapping = [RKObjectMapping mappingForClass:[UserPost class]];
    [userPostMapping addAttributeMappingsFromDictionary:@{
                                                        @"id":       @"userId",
                                                        @"name":     @"name",
                                                        @"avator":   @"avator",
                                                        @"sign":     @"sign"
                                                        }];
    [userPostMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"deployList" toKeyPath:@"deployList" withMapping:circleMapping]];
    [userPostMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"replyList" toKeyPath:@"replyList" withMapping:circleMapping]];
    
    _userPostResultMapping = [RKObjectMapping mappingForClass:[UserPostResult class]];
    [_userPostResultMapping addAttributeMappingsFromDictionary:@{
                                                                     @"message":   @"message",
                                                                     @"apicode":   @"code"
                                                                     }];
    [_userPostResultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"userPost" withMapping:userPostMapping]];
    
}

-(void)setupCommentListMapping{
    RKObjectMapping *commentMapping = [RKObjectMapping mappingForClass:[Comment class]];
    [commentMapping addAttributeMappingsFromDictionary:@{
                                                          @"commentId":    @"data_id",
                                                          @"userId":       @"userId",
                                                          @"userName":     @"username",
                                                          @"content":      @"content",
                                                          @"postId":       @"postId",
                                                          @"title":        @"title",
                                                          @"imageIds":     @"imageIds",
                                                          @"videoUrls":    @"videoUrls",
                                                          @"videoImgs":    @"videoImgs",
                                                          @"audioUrls":    @"audioUrls",
                                                          @"location" : @"local",
                                                          @"praiseNumber" :@"like_count",
                                                          @"subCount" :@"subCount",
                                                          @"userAvatar":    @"profile_image",
                                                          @"time":      @"passtime",
                                                          @"toUserId":      @"rpyToUserId",
                                                          @"toUserName":    @"rpyToUserName",
                                                          @"praiseReply" :@"isPraised",
                                                          @"isRead"      :@"isRead"
                                                          }];
    
    _commentListResultMapping = [RKObjectMapping mappingForClass:[CommentListResult class]];
    [_commentListResultMapping addAttributeMappingsFromDictionary:@{
                                                                @"message":     @"message",
                                                                @"apicode":     @"code"
                                                                }];
    [_commentListResultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"commentArray" withMapping:commentMapping]];

}

// 点赞列表
-(void)setupPraiseListMapping{
    RKObjectMapping *praiseMapping = [RKObjectMapping mappingForClass:[CirclePraise class]];
    [praiseMapping addAttributeMappingsFromDictionary:@{
                                                         @"praiseId":    @"praiseId",
                                                         @"postId":      @"postId",
                                                         @"title":       @"title",
                                                         @"userId":      @"userId",
                                                         @"userAvatar" : @"userAvatar",
                                                         @"userName" :   @"userName",
                                                         @"time":      @"time",
                                                         @"isRead":    @"isRead"
                                                         }];
    
    _praiseListResultMapping = [RKObjectMapping mappingForClass:[PraiseListResult class]];
    [_praiseListResultMapping addAttributeMappingsFromDictionary:@{
                                                                    @"message":  @"message",
                                                                    @"apicode":  @"code"
                                                                    }];
    [_praiseListResultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"praiseArray" withMapping:praiseMapping]];
    
}

// 系统消息列表
-(void)setupMessageListMapping{
    RKObjectMapping *messageMapping = [RKObjectMapping mappingForClass:[Message class]];
    [messageMapping addAttributeMappingsFromDictionary:@{
                                                         @"id":         @"messageId",
                                                         @"title":       @"title",
                                                         @"content":      @"content",
                                                         @"otherId" :   @"otherId",
                                                         @"url" :   @"url",
                                                         @"type":    @"type",
                                                         @"time":      @"time",
                                                         @"imageUrl":    @"imageUrl",
                                                         @"status" :    @"status"
                                                         }];
    
    _messageListResultMapping = [RKObjectMapping mappingForClass:[MessageListResult class]];
    [_messageListResultMapping addAttributeMappingsFromDictionary:@{
                                                                    @"message":     @"message",
                                                                    @"apicode":     @"code"
                                                                    }];
    [_messageListResultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"messageArray" withMapping:messageMapping]];
    
}

-(void)setupUnreadMessageMapping{
    
    RKObjectMapping *countMapping = [RKObjectMapping mappingForClass:[MessageCount class]];
    [countMapping addAttributeMappingsFromDictionary:@{
                                                         @"systemCount":   @"systemCount",
                                                         @"circleCount":   @"circleCount",
                                                         @"praiseCount":   @"praiseCount"
                                                         }];
    
    _unreadMessageResultMapping = [RKObjectMapping mappingForClass:[MessageUnreadResult class]];
    [_unreadMessageResultMapping addAttributeMappingsFromDictionary:@{
                                                                    @"message":  @"message",
                                                                    @"apicode":  @"code"
                                                                    }];
    [_unreadMessageResultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"messageCount" withMapping:countMapping]];
}

-(void)setupStatisticsListMapping{
    
    RKObjectMapping* _courseMapping1 = [RKObjectMapping mappingForClass:[Course class]];
    [_courseMapping1 addAttributeMappingsFromDictionary:@{
                                                          @"id":         @"courseId",
                                                          @"name":       @"name",
                                                          @"pid":        @"pid",
                                                          @"profile":    @"profile",
                                                          @"address":    @"address",
                                                          @"playcount":  @"playcount",
                                                          @"type":       @"type",
                                                          @"subNum":     @"subNum",
                                                          @"subAllNum":  @"subAllNum"
                                                          }];
    
    [_courseMapping1 addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"child" toKeyPath:@"subList" withMapping:_courseMapping1]];
    
    RKObjectMapping* _courseMapping2 = [RKObjectMapping mappingForClass:[Course class]];
    [_courseMapping2 addAttributeMappingsFromDictionary:@{
                                                          
                                                          @"id":         @"courseId",
                                                          @"name":       @"name",
                                                          @"profile":    @"profile",
                                                          @"subNum":     @"subNum",
                                                          @"subAllNum":  @"subAllNum"
                                                          }];
    [_courseMapping2 addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"child" toKeyPath:@"subList" withMapping:_courseMapping1]];
    
    _statisticsListResultMapping = [RKObjectMapping mappingForClass:[StatisticsListResult class]];
    [_statisticsListResultMapping addAttributeMappingsFromDictionary:@{
                                                                   @"apicode": @"code",
                                                                   @"message": @"message"
                                                                   }];
    [_statisticsListResultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"courseArray" withMapping:_courseMapping2]];
}


-(void)setupPayReqResultMapping{
    RKObjectMapping *payReqMapping = [RKObjectMapping mappingForClass:[PayReq class]];
    [payReqMapping addAttributeMappingsFromDictionary:@{
                                                        @"appid": @"openID",
                                                        @"noncestr": @"nonceStr",
                                                        @"package": @"package",
                                                        @"partnerid": @"partnerId",
                                                        @"prepayid": @"prepayId",
                                                        @"sign": @"sign",
                                                        @"timestamp": @"timeStamp"
                                                        }];
    _payReqResultMapping = [RKObjectMapping mappingForClass:[PayReqResult class]];
    [_payReqResultMapping addAttributeMappingsFromDictionary:@{
                                                               @"apicode": @"code",
                                                               @"message": @"message"
                                                               }];
    [_payReqResultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"payReq" withMapping:payReqMapping]];
}

-(void)setupAliPayResultMapping{
    RKObjectMapping *payInfoMapping = [RKObjectMapping mappingForClass:[AliPayInfo class]];
    [payInfoMapping addAttributeMappingsFromDictionary:@{
                                                         @"orderInfo": @"orderInfo",
                                                         @"orderNo": @"orderNo"
                                                         }];
    _aliPayResultMapping = [RKObjectMapping mappingForClass:[AliPayResult class]];
    [_aliPayResultMapping addAttributeMappingsFromDictionary:@{
                                                               @"apicode": @"code",
                                                               @"message": @"message"
                                                               }];
    [_aliPayResultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"payInfo" withMapping:payInfoMapping]];
    
}


@end
