//
//  SignInStatus.h
//  mxedu
//
//  Created by 田晓鹏 on 16/9/27.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignInStatus : NSObject

@property (nonatomic) int status; // 1 已签到 0 未签到
@property (nonatomic) NSString *lastSignIn; // 最近签到
@property (nonatomic) NSString *signInDays; // 连续签到
@property (nonatomic) NSString *coin; // 欧拉币
@property (nonatomic) NSString *todayCoin; // 今日欧拉币
@property (nonatomic) int profileTask; //完善个人资料
@property (nonatomic) int vipTask; //首次购买会员
@property (nonatomic) int courseTask; //首次购买精品课
@property (nonatomic) int coursBuyNum; //我的购买量
@property (nonatomic) int courseCollectNum; //我的收藏量

@end
