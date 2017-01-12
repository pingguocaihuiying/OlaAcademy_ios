//
//  WorkStatistics.h
//  mxedu
//
//  Created by 田晓鹏 on 16/10/17.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkStatistics : NSObject

@property (nonatomic) NSString *unfinishedCount;
@property (nonatomic) NSString *finishedCount;
@property (nonatomic) NSString *correctness;
@property (nonatomic) NSArray *statisticsList;

@end
