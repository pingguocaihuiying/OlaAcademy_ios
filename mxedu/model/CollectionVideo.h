//
//  CollectionVideo.h
//  mxedu
//
//  Created by 田晓鹏 on 16/5/4.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectionVideo : NSObject

@property (nonatomic, copy) NSString* videoId;
@property (nonatomic, copy) NSString* videoName;
@property (nonatomic, copy) NSString* videoPic;
@property (nonatomic, copy) NSString* videoUrl;
@property (nonatomic, copy) NSString* courseId;
@property (nonatomic, copy) NSString* coursePic;
@property (nonatomic, copy) NSString* totalTime;
@property (nonatomic, copy) NSString* subAllNum;
@property (nonatomic, copy) NSString* type;  // 1 course 2 goods

@end
