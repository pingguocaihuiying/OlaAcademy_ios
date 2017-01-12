//
//  WorkStatisticsListResult.h
//  mxedu
//
//  Created by 田晓鹏 on 16/10/17.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WorkStatistics.h"

@interface WorkStatisticsListResult : NSObject

@property (nonatomic) int code;
@property (nonatomic) NSString *message;
@property (nonatomic) WorkStatistics *workStatistics;

@end
