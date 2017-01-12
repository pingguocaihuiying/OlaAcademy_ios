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
#import "User.h"
#import "UserInfoResult.h"
#import "Location.h"
#import "LocationResult.h"
#import "SysCommon.h"

#import "Course.h"
#import "CourseListResult.h"
#import "CoursePoint.h"
#import "CourseVideo.h"
#import "VideoBox.h"
#import "VideoInfoResult.h"
#import "Question.h"
#import "QuestionOption.h"
#import "QuestionListResult.h"

#import "Examination.h"
#import "ExamListRsult.h"

#import "Organization.h"
#import "OrganizationResult.h"

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

#import "Commodity.h"
#import "CommodityListRsult.h"
#import "StatusResult.h"

#import "WXApiObject.h"
#import "PayReqResult.h"

#import "AliPayInfo.h"
#import "AliPayResult.h"

#import "OlaCircle.h"
#import "VideoHistoryResult.h"
#import "StatisticsListResult.h"

#import "Comment.h"
#import "CommentListResult.h"

#import "Message.h"
#import "MessageListResult.h"
#import "MessageUnreadResult.h"

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
    [self setupUploadMappings];
    [self setupLoactionResultMapping];
    
    [self setupCourseListMapping];
    [self setupKeywordListMapping];
    [self setupVideoInfoMapping];
    [self setupVideoBoxMapping];
    [self setupVideoListMapping];
    [self setupOrganizationListMapping];
    [self setupTeacherListMapping];
    [self setupUserCollectionMapping];
    [self setupCollectionStateMapping];
    [self setupCheckInMapping];
    [self setupCheckInListMapping];
    [self setupQuestionListMapping];
    [self setupExamListMapping];
    [self setupCommodityListMapping];
    [self setupPayReqResultMapping];
    [self setupAliPayResultMapping];
    [self setupVideoHistoryListMapping];
    [self setupCommentListMapping];
    [self setupStatisticsListMapping];
    [self setupBannerList];
    [self setupStatusMapping];
    [self setupMessageListMapping];
    [self setupUnreadMessageMapping];
}


-(void)setupAuthTokenMappings{
    
    _accessTokenMapping = [RKObjectMapping mappingForClass:[User class]];
    [_accessTokenMapping addAttributeMappingsFromDictionary:@{
                                                          @"id":         @"userId",
                                                          @"name":       @"name",
                                                          @"phone":      @"phone",
                                                          @"avator":     @"avatar",
                                                          @"age":        @"age",
                                                          @"sex":        @"sex",
                                                          @"sign":       @"signature"
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
                                                          @"age":      @"age",
                                                          @"sex":      @"sex",
                                                          @"avator":   @"avatar",
                                                          @"local":      @"local",
                                                          @"phone":    @"phone",
                                                          @"vipTime":    @"vipTime",
                                                          @"sign":    @"signature"
                                                          }];
    
    _userInfoResultMapping = [RKObjectMapping mappingForClass:[UserInfoResult class]];
    [_userInfoResultMapping addAttributeMappingsFromDictionary:@{
                                                                @"apicode":     @"code",
                                                                @"message":   @"message"
                                                                }];
    [_userInfoResultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"data" toKeyPath:@"userInfo" withMapping:_userMapping]];
    
}

-(void)setupUploadMappings{
    _uploadResultMapping = [RKObjectMapping mappingForClass:[UploadResult class]];
    [_uploadResultMapping addAttributeMappingsFromDictionary:@{
                                                               @"code":   @"code",
                                                               @"message":   @"message",
                                                               @"imgGid":   @"imgGid"
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
    [_courseMapping2 addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"child" toKeyPath:@"subList" withMapping:_courseMapping1]];
    
    _courseListResultMapping = [RKObjectMapping mappingForClass:[CourseListResult class]];
    [_courseListResultMapping addAttributeMappingsFromDictionary:@{
                                                                  @"apicode": @"code",
                                                                  @"message": @"message"
                                                                  }];
    [_courseListResultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"course" withMapping:_courseMapping2]];
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
                                                        @"subAllNum":  @"subAllNum"
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
                                                        @"isfree":     @"isfree"
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
                                                          @"isfree":     @"isfree"
                                                          }];
    
    _videoListResultMapping = [RKObjectMapping mappingForClass:[VideoListResult class]];
    [_videoListResultMapping addAttributeMappingsFromDictionary:@{
                                                                    @"apicode": @"code",
                                                                    @"message": @"message"
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
                                                          @"userName": @"userName",
                                                          @"userAvatar": @"userAvatar",
                                                          @"videoId": @"videoId",
                                                          @"courseId": @"courseId",
                                                          @"title": @"title",
                                                          @"content": @"content",
                                                          @"imageGids": @"imageGids",
                                                          @"location": @"location",
                                                          @"praiseNumber": @"praiseNumber",
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

-(void)setupCommentListMapping{
    RKObjectMapping *commentMapping = [RKObjectMapping mappingForClass:[Comment class]];
    [commentMapping addAttributeMappingsFromDictionary:@{
                                                          @"commentId":         @"data_id",
                                                          @"userId":       @"userId",
                                                          @"userName":       @"username",
                                                          @"content":      @"content",
                                                          @"location" : @"local",
                                                          @"praiseNumber" :@"like_count",
                                                          @"userAvatar":    @"profile_image",
                                                          @"time":      @"passtime",
                                                          @"toUserId":      @"rpyToUserId",
                                                          @"toUserName":    @"rpyToUserName",
                                                          @"praiseReply" :@"isPraised"
                                                          }];
    
    _commentListResultMapping = [RKObjectMapping mappingForClass:[CommentListResult class]];
    [_commentListResultMapping addAttributeMappingsFromDictionary:@{
                                                                @"message":     @"message",
                                                                @"apicode":     @"code"
                                                                }];
    [_commentListResultMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"result" toKeyPath:@"commentArray" withMapping:commentMapping]];

}

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
    
    _unreadMessageResultMapping = [RKObjectMapping mappingForClass:[MessageUnreadResult class]];
    [_unreadMessageResultMapping addAttributeMappingsFromDictionary:@{
                                                                    @"message":     @"message",
                                                                    @"apicode":     @"code",
                                                                    @"result":      @"count"
                                                                    }];
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
