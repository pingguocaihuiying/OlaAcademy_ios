//
//  ThirdPayResult.h
//  mxedu
//
//  Created by 田晓鹏 on 16/9/5.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ThirdPay.h"

@interface ThirdPayResult : NSObject

@property (nonatomic) int code;
@property (nonatomic) NSString *message;
@property (nonatomic) ThirdPay *thirdPay;

@end
