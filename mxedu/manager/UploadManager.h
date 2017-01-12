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

@property (nonatomic,retain) NSMutableArray *viedoGids;
@property (nonatomic,retain) NSMutableArray *audioGids;
@property (nonatomic,retain) NSMutableArray *movieImageS;//视频第一针图片集合

@property (nonatomic,retain) NSString* movieurl;

/*
 * 多张图片 视频 音频
 */
- (void)uploadCommentMdeiaDatas:(NSArray*)mediaDatas
                         angles:(NSArray*)imgAngles
                       progress:(void (^)(NSInteger, NSInteger))progress
                        success:(void (^)())success
                        failure:(void (^)(NSError*))failure;

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
                  angle:(NSString*)imgAngle
                success:(void (^)())success
                failure:(void (^)(NSError*))failure;

@end
