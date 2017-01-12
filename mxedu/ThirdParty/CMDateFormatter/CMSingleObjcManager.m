//
//  CMSingleObjcManager.m
//  AllinmdProject
//
//  Created by ZhangKaiChao on 16/2/29.
//  Copyright © 2016年 Mac_Allin. All rights reserved.
//

#import "CMSingleObjcManager.h"

@implementation CMSingleObjcManager
@end


@implementation CMDateFormatter

+ (id)sharedDateManager
{
    @synchronized(self)
    {
        static NSDateFormatter * sharedCMDateFormatter = nil;

        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedCMDateFormatter = [[NSDateFormatter alloc] init];
        });
        return sharedCMDateFormatter;
    }
}

@end