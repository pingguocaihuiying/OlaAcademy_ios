//
//  ModelConfig.h
//  mxedu
//
//  Created by 田晓鹏 on 16/9/13.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelConfig : NSObject

+(NSMutableArray*)confgiModelDataWithCoin:(NSString*)coinValue BuyCount:(NSString *)buyCount CollectCount:(NSString *)collectCount ShowSignIn:(int)show;

@end
