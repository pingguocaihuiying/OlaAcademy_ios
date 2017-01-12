//
//  UploadManager.m
//  NTreat
//
//  Created by 田晓鹏 on 15-5-21.
//  Copyright (c) 2015年 田晓鹏. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "SysCommon.h"
#import "UploadManager.h"
#import "UploadResult.h"
#import "MediaUploadResult.h"
#import "mediaModel.h"
#import "AuthManager.h"
#import "DataMappingManager.h"


@implementation UploadManager

- (void)uploadCommentMdeiaDatas:(NSArray*)mediaDatas
                         angles:(NSArray*)imgAngles
                       progress:(void (^)(NSInteger, NSInteger))progress
                        success:(void (^)())success
                        failure:(void (^)(NSError*))failure
{
    AuthManager* am = [[AuthManager alloc]init];
    _imageGids = [NSMutableArray arrayWithCapacity:0];
    _audioGids = [NSMutableArray arrayWithCapacity:0];
    _viedoGids = [NSMutableArray arrayWithCapacity:0];
    _movieImageS = [NSMutableArray arrayWithCapacity:0];
    if (!am.isAuthenticated)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请先登录" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSMutableArray* pendingMeidaDatas = [NSMutableArray arrayWithArray:mediaDatas];
    
    dispatch_queue_t dq = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(dq, ^{
        while (pendingMeidaDatas.count > 0)
        {
            mediaModel *model = [pendingMeidaDatas firstObject];
            NSMutableArray* pendingAngles = [NSMutableArray arrayWithArray:imgAngles];
            
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            
            __block BOOL failed = NO;
            __block NSError* uploadError = nil;
            if ([model.type isEqualToString:@"1"]) {
                NSData *imageData = model.imgData;
                NSString* imageAngle = [pendingAngles firstObject];
                [self uploadImageData:imageData
                                  angle:imageAngle
                                 success:^{
                                     dispatch_semaphore_signal(sema);
                                 }
                                 failure:^(NSError* error) {
                                     uploadError = error;
                                     failed = YES;
                                     dispatch_semaphore_signal(sema);
                                 }];
            }else if ([model.type isEqualToString:@"2"]){
                NSData *audioData = [NSData dataWithContentsOfFile:model.localpath];
                [self uploadAdudioDatas:audioData
                                 angles:imgAngles
                                success:^{
                                    dispatch_semaphore_signal(sema);
                                }
                                failure:^(NSError* error) {
                                    uploadError = error;
                                    failed = YES;
                                    dispatch_semaphore_signal(sema);
                                }];
            }else{
                NSURL *choiceurl = [NSURL URLWithString:model.localpath];
                NSData *audioData = [NSData dataWithContentsOfURL:choiceurl];
                [self uploadMoveDatas:audioData
                               angles:imgAngles
                              success:^{
                                  dispatch_semaphore_signal(sema);
                              }
                              failure:^(NSError* error) {
                                  uploadError = error;
                                  failed = YES;
                                  dispatch_semaphore_signal(sema);
                              }];
            }
            
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            
            if (failed)
            {
                if (failure != nil)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{ failure(uploadError); });
                    return;
                }
            }
            else
            {
                [pendingMeidaDatas removeObjectAtIndex:0];
                
                if (progress != nil)
                {
                    NSInteger uploadedImageNum = mediaDatas.count - pendingMeidaDatas.count;
                    NSInteger totalImageNum = mediaDatas.count;
                    dispatch_async(dispatch_get_main_queue(), ^{ progress(uploadedImageNum, totalImageNum); });
                }
                
                if (pendingMeidaDatas.count == 0)
                {
                    if (success != nil)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{ success(); });
                    }
                }
            }
        }
    });
}


- (void)uploadImageDatas:(NSArray*)imageDatas
                  angles:(NSArray*)imgAngles
                progress:(void (^)(NSInteger, NSInteger))progress
                 success:(void (^)())success
                 failure:(void (^)(NSError*))failure
{
    _imageGids = [NSMutableArray arrayWithCapacity:0];
    
    NSMutableArray* pendingImageDatas = [NSMutableArray arrayWithArray:imageDatas];
    NSMutableArray* pendingAngles = [NSMutableArray arrayWithArray:imgAngles];
    
    dispatch_queue_t dq = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(dq, ^{
        while (pendingImageDatas.count > 0)
        {
            NSData* imageData = [pendingImageDatas firstObject];
            NSString* imageAngle = [pendingAngles firstObject];
            
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            
            __block BOOL failed = NO;
            __block NSError* uploadError = nil;
            
            [self uploadImageData:imageData
                            angle:imageAngle
                          success:^{
                              dispatch_semaphore_signal(sema);
                          }
                          failure:^(NSError* error) {
                              uploadError = error;
                              failed = YES;
                              dispatch_semaphore_signal(sema);
                          }];
            
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            
            if (failed)
            {
                if (failure != nil)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{ failure(uploadError); });
                    return;
                }
            }
            else
            {
                [pendingImageDatas removeObjectAtIndex:0];
                
                if (progress != nil)
                {
                    NSInteger uploadedImageNum = imageDatas.count - pendingImageDatas.count;
                    NSInteger totalImageNum = imageDatas.count;
                    dispatch_async(dispatch_get_main_queue(), ^{ progress(uploadedImageNum, totalImageNum); });
                }
                
                if (pendingImageDatas.count == 0)
                {
                    if (success != nil)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{ success(); });
                    }
                }
            }
        }
    });
}

- (void)uploadImageData:(NSData*)imageData
                  angle:(NSString*)imgAngle
                success:(void (^)())success
                failure:(void (^)(NSError*))failure
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    params[@"picType"] = @"jpg";
    if (imgAngle)
    {
        params[@"imgAngle"] = imgAngle;
    }
    
    NSMutableURLRequest* request;
    
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.uploadResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    
    NSURL* rootURL = [NSURL URLWithString:@"http://upload.olaxueyuan.com"];
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:rootURL];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    request = [objectManager multipartFormRequestWithObject:nil
                                                     method:RKRequestMethodPOST
                                                       path:@"/SDpic/common/picUpload"
                                                 parameters:params
                                  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                      [formData appendPartWithFileData:imageData
                                                                  name:@"imgData"
                                                              fileName:@"uploading-image.jpg"
                                                              mimeType:@"application/octet-stream"];
                                  }];
    
    RKObjectRequestOperation* operation;
    operation = [objectManager objectRequestOperationWithRequest:request
                                                         success:^(RKObjectRequestOperation* o, RKMappingResult* result) {
                                                             
                                                             UploadResult *uploadResult = result.firstObject;
                                                             _imageGid = uploadResult.imgGid;
                                                            [_imageGids addObject: _imageGid];
                                                             
                                                             if (success != nil)
                                                             {
                                                                 success();
                                                             }
                                                         }
                                                         failure:^(RKObjectRequestOperation* o, NSError* error) {
                                                             if (failure != nil)
                                                             {
                                                                 failure(error);
                                                             }
                                                         }];
    
    [[RKObjectManager sharedManager] enqueueObjectRequestOperation:operation];
}


-(void)uploadMoveDatas:(NSData *)moveData
                angles:(NSArray*)imgAngles
               success:(void (^)())success
               failure:(void (^)(NSError*))failure{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    params[@"movType"] = @"mp4";
    if (imgAngles != nil)
    {
        params[@"movType"] = [imgAngles objectAtIndex:0];
    }
    
    NSMutableURLRequest* request;
    
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.mediaUploadResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    
    NSURL* rootURL = [NSURL URLWithString:BASIC_Movie_URL];
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:rootURL];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    request = [objectManager multipartFormRequestWithObject:nil
                                                     method:RKRequestMethodPOST
                                                       path:@"/SDpic/common/movieUpload"
                                                 parameters:params
                                  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                      [formData appendPartWithFileData:moveData
                                                                  name:@"movData"
                                                              fileName:@"uploading-movie.mp4"
                                                              mimeType:@"application/octet-stream"];
                                  }];
    
    RKObjectRequestOperation* operation;
    operation = [objectManager objectRequestOperationWithRequest:request
                                                         success:^(RKObjectRequestOperation* o, RKMappingResult* result) {
                                                             
                                                             MediaUploadResult *uploadResult = result.firstObject;
                                                             _imageGid=uploadResult.imgGid;
                                                             _movieurl=uploadResult.movieUrl;
                                                             [_viedoGids addObject:uploadResult.movieUrl];
                                                             [_movieImageS addObject:_imageGid];
                                                             if (success != nil)
                                                             {
                                                                 success();
                                                             }
                                                         }
                                                         failure:^(RKObjectRequestOperation* o, NSError* error) {
                                                             if (failure != nil)
                                                             {
                                                                 failure(error);
                                                             }
                                                         }];
    
    [[RKObjectManager sharedManager] enqueueObjectRequestOperation:operation];
}
-(void)uploadAdudioDatas:(NSData *)moveData
                  angles:(NSArray*)imgAngles
                 success:(void (^)())success
                 failure:(void (^)(NSError*))failure{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    params[@"movType"] = @"mp3";
    if (imgAngles != nil)
    {
        params[@"movType"] = [imgAngles objectAtIndex:0];
    }
    
    NSMutableURLRequest* request;
    
    DataMappingManager *dm = GetDataManager();
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:dm.mediaUploadResultMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
    
    NSURL* rootURL = [NSURL URLWithString:BASIC_Movie_URL];
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:rootURL];
    [objectManager addResponseDescriptor:responseDescriptor];
    
    request = [objectManager multipartFormRequestWithObject:nil
                                                     method:RKRequestMethodPOST
                                                       path:@"/SDpic/common/movieUpload"
                                                 parameters:params
                                  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                      [formData appendPartWithFileData:moveData
                                                                  name:@"movData"
                                                              fileName:@"uploading-movie.mp3"
                                                              mimeType:@"application/octet-stream"];
                                  }];
    
    RKObjectRequestOperation* operation;
    operation = [objectManager objectRequestOperationWithRequest:request
                                                         success:^(RKObjectRequestOperation* o, RKMappingResult* result) {
                                                             
                                                             MediaUploadResult *uploadResult = result.firstObject;
                                                             _imageGid=uploadResult.imgGid;
                                                             _movieurl=uploadResult.movieUrl;
                                                             [_audioGids addObject:uploadResult.movieUrl];
                                                             if (success != nil)
                                                             {
                                                                 success();
                                                             }
                                                         }
                                                         failure:^(RKObjectRequestOperation* o, NSError* error) {
                                                             if (failure != nil)
                                                             {
                                                                 failure(error);
                                                             }
                                                         }];
    
    [[RKObjectManager sharedManager] enqueueObjectRequestOperation:operation];
}


@end
