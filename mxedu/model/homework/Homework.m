//
//  Homework.m
//  mxedu
//
//  Created by 田晓鹏 on 16/8/3.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "Homework.h"

static NSString * const kFormatString = @"yyyy-MM-dd HH:mm";

@implementation Homework
{
    NSString *_month;
    NSString *_day;
}

- (NSString*)month
{
    if (self.time && ![self.time isEqualToString:@""]){
        if ([_month isEqualToString:@""] || !_month) {
            [self dateFormatter];
        }
    }
    return _month;
}

- (NSString*)day
{
    if (self.time && ![self.time isEqualToString:@""]){
        if ([_day isEqualToString:@""] || !_day) {
            [self dateFormatter];
        }
    }
    return _day;
}

- (void)dateFormatter
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = kFormatString;
    NSDate *date = [format dateFromString:self.time];
    
    format.dateFormat = @"M";
    _month = [format stringFromDate:date];
    
    format.dateFormat = @"dd";
    _day = [format stringFromDate:date];
}


@end
