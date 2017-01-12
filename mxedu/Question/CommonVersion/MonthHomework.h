//
//  MonthHomework.h
//  mxedu
//
//  Created by 田晓鹏 on 16/8/31.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MonthHomework : NSObject

@property (nonatomic, copy) NSString *month;  //按月汇总数据

@property (nonatomic, strong) NSMutableArray *homeworkArray;

@end
