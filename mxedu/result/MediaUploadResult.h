//
//  MediaUploadResult.h
//  mxedu
//
//  Created by 田晓鹏 on 16/11/28.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MediaUploadResult : NSObject

@property (nonatomic) int code;
@property (nonatomic) NSString *message;
@property (nonatomic) NSString *imgGid;
@property (nonatomic) NSString *movieUrl;

@end
