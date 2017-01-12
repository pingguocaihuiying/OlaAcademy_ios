//
//  NSString+expand.h
//  Tetter
//
//  Created by 周冉 on 14-12-10.
//  Copyright (c) 2014年 周冉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NSString (expand)

/**
 *    @brief    MD5加密.
 *
 *    @return   返回 value.
 *
 */
- (NSString *)MD5Hash;


- (CGSize)sizeWithFontCompatible:(UIFont *)font constrainedToSize:(CGSize)size;


#pragma mark - 富文本
/**
 *    @brief    富文本.
 *
 *    @param    lineSpace           行间距.
 *    @param    firstHeader         首行缩进.
 *    @param    string              文本string.
 *    @return   返回 富文本value.
 *
 */
+ (NSMutableAttributedString *)createMyAttributedStringWithLineSpace:(NSInteger)lineSpace
                                                    andFirstLineHead:(NSInteger)firstHeader
                                                       andBodyString:(NSString *)string;
#pragma mark - 长度
/**
 *    @brief    计算长度.
 *
 *    @param    font        font.
 *    @return   返回 CGSize value.
 *
 */
- (CGSize)sizeWithFontCompatible:(UIFont *)font;

/**
 *    @brief    计算长度.
 *
 *    @param    font            font.
 *    @param    size            size.
 *    @param    lineBreakMode   lineBreakMode.
 *    @return   返回 CGSize value.
 *
 */
- (CGSize)sizeWithFontCompatible:(UIFont *)font constrainedToSize:(CGSize)size
                   lineBreakMode:(NSLineBreakMode)lineBreakMode;

/**
 *    @brief    计算长度.
 *
 *    @param    font            font.
 *    @param    width           width.
 *    @param    lineBreakMode   lineBreakMode.
 *    @return   返回 CGSize value.
 *
 */
- (CGSize)sizeWithFontCompatible:(UIFont *)font forWidth:(CGFloat)width
                   lineBreakMode:(NSLineBreakMode)lineBreakMode;

/**
 *    @brief    绘制文本.
 *
 *    @param    rect        rect.
 *    @param    font        font.
 *
 */
- (void)drawInRectCompatible:(CGRect)rect withFont:(UIFont *)font;

/**
 *    @brief    计算文本字符长度.
 *
 *    @return   返回 字符长度 value.
 *
 */
- (NSInteger)textLength;

#pragma mark - 日期
/**
 *    @brief    获取时间戳.
 *
 *    @param    index        index.
 *    @return   返回 时间戳 value.
 *
 */
+ (NSString *)getTimeStamp:(NSInteger)index;

/**
 *    @brief    转换时间为字符串.
 *
 *    @param    date        时间.
 *    @param    formatter   时间格式.
 *    @return   返回  value.
 *
 */
+ (NSString *)stringFromDate:(NSDate *)date;

/**
 *    @brief    转换时间为字符串.
 *
 *    @param    date        时间.
 *    @param    formatter   时间格式.
 *    @return   返回  value.
 *
 */
+ (NSString *)stringFromDate:(NSDate *)date formatter:(NSString *)formatter;

/**
 *    @brief    转换时间.
 *
 *    @param    date        时间.
 *    @param    formatter   时间格式.
 *    @return   返回 时间 value.
 *
 */
+ (NSString *)transmitTime:(NSString *)timeString;

#pragma mark - 截取
/**
 *    @brief    截取数字.
 *
 */
- (NSString *)numSubString;

/**
 *    @brief    截取医院.
 *    @param    string 原字符串
 *    @return   返回value
 */
+ (NSMutableArray *)sepStringWithString:(NSString *)string;

/**
 *    @brief    截取用户的职称 1-4级.
 *
 *    @param    string        要截取的string.
 *    @return   返回 时间 value.
 *
 */
+ (NSString *)getMedicalTitleOneToFour:(NSString *)string;

/**
 *    @brief    截取用户的职称 5-7级.
 *
 *    @param    string        要截取的string.
 *    @return   返回 时间 value.
 *
 */
+ (NSString *)getMedicalTitleFiveToSeven:(NSString *)string;

/**
 *    @brief    截取用户的职称 8-9级.
 *
 *    @param    string        要截取的string.
 *    @return   返回 时间 value.
 *
 */
+ (NSString *)getMedicalTitleEightToNine:(NSString *)string;

/**
 *    @brief    获取资源类型.
 *
 *    @param    sourType        资源类型sourType.
 *    @return   返回 资源类型 value.
 *
 */
+ (NSString *)sourseType:(NSInteger)sourType;

/**
 *    @brief    获取回复你的TA的xxx.
 *
 *    @param    typeString      typeString.
 *    @return   返回 value.
 *
 */
+ (NSString *)getTypeWordWithType:(NSString *)typeString;

/**
 *    @brief    获取字号大小.
 *
 *    @param    type      type.
 *    @return   返回 value.
 *
 */
+ (NSString *)getFontTypeWithType:(NSInteger)type;

/**
 *    @brief    获取10000+数字.
 *
 *    @param    targetString      10000+ targetString.
 *    @return   返回 value.
 *
 */
+ (NSString *)adjumentNumberWithTag:(NSString *)targetString;

/**
 *    @brief    把格式化的JSON格式的字符串转换成字典.
 *    @param    jsonString JSON格式的字符串.
 *    @return   返回字典value.
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;


@end
