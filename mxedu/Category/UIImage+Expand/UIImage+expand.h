//
//  UIImage+expand.h
//  AllinmdProject
//
//  Created by ZhangKaiChao on 14-12-17.
//  Copyright (c) 2014年 Mac_Libin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (expand)

//+ (UIImage *)imageNamedWithType:(NSString *)type;

//+ (UIImage *)imageNamedWithTrendsType:(NSString *)type;

+ (UIImage *)imageWithColor:(UIColor *)color imageSize:(CGSize)imageSize;

+ (instancetype)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

- (UIImage *)zipImageWithWidth:(CGFloat)imageWidth imageHeight:(CGFloat)imageHeight;

+ (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;
- (UIImage *) resizedImageByMagick: (NSString *) spec;
- (UIImage *) resizedImageByWidth:  (NSUInteger) width;
- (UIImage *) resizedImageByHeight: (NSUInteger) height;
- (UIImage *) resizedImageWithMaximumSize: (CGSize) size;
- (UIImage *) resizedImageWithMinimumSize: (CGSize) size;
@end
