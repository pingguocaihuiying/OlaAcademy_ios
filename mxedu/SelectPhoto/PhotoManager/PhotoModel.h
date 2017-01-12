//
//  QYPhotoModel.h
//  Frank
//
//  Created by Frank on 15/3/6.
//  Copyright (c) 2015年 Frank. All rights reserved.
//

#import "JSONModel.h"

@interface PhotoModel : JSONModel

/**
 *  缩略图
 */
@property (nonatomic, strong) NSData *thumbnailData;

/**
 *  大图
 */
@property (nonatomic, strong) NSData *photoData;

/**
 *  图片名称
 */
@property (nonatomic, copy) NSString *photoName;

@end
