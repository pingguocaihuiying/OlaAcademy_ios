//
//  HomeListResult.h
//  mxedu
//
//  Created by 田晓鹏 on 16/8/17.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HomeDataList.h"

@interface HomeListResult : NSObject

@property (nonatomic) int code;
@property (nonatomic) NSString *message;
@property (nonatomic) HomeDataList *homeData;

@end
