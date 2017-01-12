//
//  UploadManager.h
//  NTreat
//
//  Created by 田晓鹏 on 15-5-21.
//  Copyright (c) 2015年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadManager : NSObject

@property (nonatomic,retain) NSString* imageGid;
@property (nonatomic,retain) NSMutableArray* imageGids;

/*
 * 多张图片
 */
- (void)uploadImageDatas:(NSArray*)imageDatas
                  angles:(NSArray*)imgAngles
                progress:(void (^)(NSInteger, NSInteger))progress
                 success:(void (^)())success
                 failure:(void (^)(NSError*))failure;

/*
 * 一张图片
 */
- (void)uploadImageData:(NSData*)imageData
                 angles:(NSArray*)imgAngles
                success:(void (^)())success
                failure:(void (^)(NSError*))failure;

@end
