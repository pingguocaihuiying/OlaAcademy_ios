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
#import "AuthManager.h"
#import "DataMappingManager.h"


@implementation UploadManager

- (void)uploadImageDatas:(NSArray*)imageDatas
                  angles:(NSArray*)imgAngles
                progress:(void (^)(NSInteger, NSInteger))progress
                 success:(void (^)())success
                 failure:(void (^)(NSError*))failure
{
    _imageGids = [NSMutableArray arrayWithCapacity:0];
    
    NSMutableArray* pendingImageDatas = [NSMutableArray arrayWithArray:imageDatas];
    
    dispatch_queue_t dq = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(dq, ^{
        while (pendingImageDatas.count > 0)
        {
            NSData* imageData = [pendingImageDatas firstObject];
            
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            
            __block BOOL failed = NO;
            __block NSError* uploadError = nil;
            
            [self uploadImageData:imageData
                           angles:imgAngles
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
                 angles:(NSArray*)imgAngles
                success:(void (^)())success
                failure:(void (^)(NSError*))failure
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    params[@"picType"] = @"jpg";
    if (imgAngles != nil)
    {
        params[@"imgAngle"] = [imgAngles objectAtIndex:0];
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


@end
