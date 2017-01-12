//
//  DataMappingManager.h
//  NTreat
//
//  Created by 田晓鹏 on 15-4-24.
//  Copyright (c) 2015年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface DataMappingManager : NSObject

@property (nonatomic, strong, readonly) RKObjectManager* objectManager;

@property (nonatomic, strong, readonly) RKObjectMapping* accessTokenMapping;
@property (nonatomic, strong, readonly) RKObjectMapping* authResultMapping;

@property (nonatomic, strong, readonly) RKObjectMapping* commonResultMapping;

@property (nonatomic, strong, readonly) RKObjectMapping* uploadResultMapping;
@property (nonatomic, strong, readonly) RKObjectMapping* mediaUploadResultMapping;

@property (nonatomic, strong, readonly) RKObjectMapping* meetingResultMapping;
@property (nonatomic, strong, readonly) RKObjectMapping* meetingFavResultMapping;
@property (nonatomic, strong, readonly) RKObjectMapping* meetingSummaryResultMapping;
@property (nonatomic, strong, readonly) RKObjectMapping* meetingScheduleResultMapping;

@property (nonatomic, strong, readonly) RKObjectMapping* userMapping;
@property (nonatomic, strong, readonly) RKObjectMapping* userInfoResultMapping;
// 签到状态
@property (nonatomic, strong, readonly) RKObjectMapping* signInStatusResultMapping;

// 欧拉币明细
@property (nonatomic, strong, readonly) RKObjectMapping* coinHistoryListResultMapping;

@property (nonatomic, strong, readonly) RKObjectMapping* homeListResultMapping;
//资料列表
@property (nonatomic, strong, readonly) RKObjectMapping* materialListResultMapping;

@property (nonatomic, strong, readonly) RKObjectMapping* courseListResultMapping;
@property (nonatomic, strong, readonly) RKObjectMapping* bannerListResultMapping;
@property (nonatomic, strong, readonly) RKObjectMapping* examListResultMapping;
@property (nonatomic, strong, readonly) RKObjectMapping* questionListResultMapping;
@property (nonatomic, strong, readonly) RKObjectMapping* homeworkListResultMapping;
@property (nonatomic, strong, readonly) RKObjectMapping* workStatisticsListResultMapping;

// 错题集列表
@property (nonatomic, strong, readonly) RKObjectMapping*mistakeListResultMapping;

// 群列表
@property (nonatomic, strong, readonly) RKObjectMapping* groupListResultMapping;
// 群成员列表
@property (nonatomic, strong, readonly) RKObjectMapping* memberListResultMapping;

@property (nonatomic, strong, readonly) RKObjectMapping* orgListResultMapping;
@property (nonatomic, strong, readonly) RKObjectMapping* orgInfoListResultMapping;
@property (nonatomic, strong, readonly) RKObjectMapping* teacherListResultMapping;

@property (nonatomic, strong, readonly) RKObjectMapping* locationMapping;
@property (nonatomic, strong, readonly) RKObjectMapping* loacationResultMapping;
@property (nonatomic, strong, readonly) RKObjectMapping* videoInfoResultMapping;

@property (nonatomic, strong, readonly) RKObjectMapping* keywordListResultMapping;
@property (nonatomic, strong, readonly) RKObjectMapping* videoBoxResultMapping;
@property (nonatomic, strong, readonly) RKObjectMapping* videoListResultMapping;

@property (nonatomic, strong, readonly) RKObjectMapping* collectionStateResultMapping;
@property (nonatomic, strong, readonly) RKObjectMapping* collectionListResultMapping;

@property (nonatomic, strong, readonly) RKObjectMapping* checkInResultMapping;
@property (nonatomic, strong, readonly) RKObjectMapping* checkInListResultMapping;

@property (nonatomic, strong, readonly) RKObjectMapping* commodityListResultMapping;
@property (nonatomic, strong, readonly) RKObjectMapping* payReqResultMapping;
@property (nonatomic, strong, readonly) RKObjectMapping* aliPayResultMapping;

@property (nonatomic, strong, readonly) RKObjectMapping* historyListResultMapping;
@property (nonatomic, strong, readonly) RKObjectMapping* circleDetailResultMapping;
@property (nonatomic, strong, readonly) RKObjectMapping* statisticsListResultMapping;

@property (nonatomic, strong, readonly) RKObjectMapping* commentListResultMapping;
@property (nonatomic, strong, readonly) RKObjectMapping* messageListResultMapping;
@property (nonatomic, strong, readonly) RKObjectMapping* unreadMessageResultMapping;

//消息 － 点赞列表
@property (nonatomic, strong, readonly) RKObjectMapping* praiseListResultMapping;

//个人主页
@property (nonatomic, strong, readonly) RKObjectMapping* userPostResultMapping;

@property (nonatomic, strong, readonly) RKObjectMapping* statusResultMapping;
@property (nonatomic, strong, readonly) RKObjectMapping* thirdPayResultMapping;

-(id)init;

@end
