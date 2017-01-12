//
//  CMSingleObjcManager.h
//  AllinmdProject
//
//  Created by ZhangKaiChao on 16/2/29.
//  Copyright © 2016年 Mac_Allin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMSingleObjcManager : NSObject
@end


/// 日期formatter单例
@interface CMDateFormatter : NSObject

+ (id)sharedDateManager;

@end