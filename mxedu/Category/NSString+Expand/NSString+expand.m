//
//  NSString+expand.m
//  Tetter
//
//  Created by 周冉 on 14-12-10.
//  Copyright (c) 2014年 周冉. All rights reserved.
//

#import "NSString+expand.h"

#import "CMSingleObjcManager.h"
#import <CommonCrypto/CommonCrypto.h>


@implementation NSString (expand)

/**
 *    @brief    MD5加密.
 *
 *    @return   返回 value.
 *
 */
- (NSString *)MD5Hash {
    
    if(self.length == 0) {
        return nil;
    }
    
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15]];
}

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
                                                       andBodyString:(NSString *)string{
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:lineSpace];
    [paragraphStyle1 setFirstLineHeadIndent:firstHeader];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1
                              range:NSMakeRange(0, [string length])];
    return attributedString1;
}

#pragma mark 适配函数
- (CGSize)sizeWithFontCompatible:(UIFont *)font
{
    if([self respondsToSelector:@selector(sizeWithAttributes:)] == YES)
    {
        NSDictionary *dictionaryAttributes = @{NSFontAttributeName:font};
        CGSize stringSize = [self sizeWithAttributes:dictionaryAttributes];
        return CGSizeMake(ceil(stringSize.width), ceil(stringSize.height));
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
		return [self sizeWithFont:font];
#pragma clang diagnostic pop
    }
}

- (CGSize)sizeWithFontCompatible:(UIFont *)font forWidth:(CGFloat)width
                   lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    if([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)] == YES)
    {
        NSDictionary *dictionaryAttributes = @{NSFontAttributeName:font,};
		
        CGRect stringRect = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                               options:NSStringDrawingTruncatesLastVisibleLine
                                            attributes:dictionaryAttributes
                                               context:nil];
        
        CGFloat widthResult = stringRect.size.width;
        if(widthResult - width >= 0.0000001)
        {
            widthResult = width;
        }
        
        return CGSizeMake(widthResult, ceil(stringRect.size.height));
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
		return [self sizeWithFont:font forWidth:width lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
}

- (CGSize)sizeWithFontCompatible:(UIFont *)font constrainedToSize:(CGSize)size
{
    if([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)] == YES)
    {
        NSDictionary *dictionaryAttributes = @{NSFontAttributeName:font};
        CGRect stringRect = [self boundingRectWithSize:size
											   options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:dictionaryAttributes
                                               context:nil];
        
        return CGSizeMake(ceil(stringRect.size.width), ceil(stringRect.size.height));
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
		return [self sizeWithFont:font constrainedToSize:size];
#pragma clang diagnostic pop
    }
}

- (CGSize)sizeWithFontCompatible:(UIFont *)font constrainedToSize:(CGSize)size
                   lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    if([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)] == YES)
    {
        NSDictionary *dictionaryAttributes = @{NSFontAttributeName:font,};
        CGRect stringRect = [self boundingRectWithSize:size
											   options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:dictionaryAttributes
                                               context:nil];
        
        return CGSizeMake(ceil(stringRect.size.width), ceil(stringRect.size.height));
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
		return [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
}

- (void)drawAtPointCompatible:(CGPoint)point withFont:(UIFont *)font
{
    if([self respondsToSelector:@selector(drawAtPoint:withAttributes:)] == YES)
    {
        NSDictionary *dictionaryAttributes = @{NSFontAttributeName:font};
        [self drawAtPoint:point withAttributes:dictionaryAttributes];
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
		[self drawAtPoint:point withFont:font];
#pragma clang diagnostic pop
    }
}

- (void)drawInRectCompatible:(CGRect)rect withFont:(UIFont *)font
{
    if([self respondsToSelector:@selector(drawWithRect:options:attributes:context:)] == YES)
    {
        NSDictionary *dictionaryAttributes = @{NSFontAttributeName:font};
        [self drawWithRect:rect
                   options:NSStringDrawingUsesLineFragmentOrigin
                attributes:dictionaryAttributes
                   context:nil];
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
		[self drawInRect:rect withFont:font];
#pragma clang diagnostic pop
    }
}

- (void)drawInRectCompatible:(CGRect)rect withFont:(UIFont *)font
               lineBreakMode:(NSLineBreakMode)lineBreakMode
                   alignment:(NSTextAlignment)alignment
{
    if([self respondsToSelector:@selector(drawWithRect:options:attributes:context:)] == YES)
    {
		NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
		[paragraphStyle setAlignment:alignment];
        NSDictionary *dictionaryAttributes = @{NSFontAttributeName:font,
											   NSParagraphStyleAttributeName:paragraphStyle};
        [self drawWithRect:rect
                   options:NSStringDrawingUsesLineFragmentOrigin
                attributes:dictionaryAttributes
                   context:nil];
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
		[self drawInRect:rect withFont:font lineBreakMode:lineBreakMode alignment:alignment];
#pragma clang diagnostic pop
    }
}

/**
 *    @brief    计算文本字符长度.
 *
 *    @return   返回 字符长度 value.
 *
 */
- (NSInteger)textLength {
    /// 字符串长度为空.
    if((self == nil) || ([self length] == 0))
    {
        return 0;
    }
    
    NSInteger characterLen = 0;
    for(NSInteger i = 0; i < [self length]; i++)
    {
        unichar character = [self characterAtIndex:i];
        
        /// 中文.
        if((character >= 0x4e00) && (character <= 0x9fbb))
        {
            /// 一个中文算2个长度.
            characterLen += 2;
        }
        else
        {
            characterLen += 1;
        }
    }
    
    return characterLen;
}

/**
 *    @brief    截取医院.
 *    @param    string 原字符串
 *    @return   返回value
 */
+ (NSMutableArray *)sepStringWithString:(NSString *)string {
    
    NSMutableArray *retunArr = [[NSMutableArray alloc]init];
    if (string && string.length >0) {
        if ([string rangeOfString:@","].location != NSNotFound) {
            NSArray *arr = [string componentsSeparatedByString:@","];
            NSMutableArray *tempIdArray = [[NSMutableArray alloc]init];
            NSMutableArray *tempNameArray = [[NSMutableArray alloc]init];
            for ( NSString *str in arr) {
                if ([str rangeOfString:@"_"].location != NSNotFound) {
                    NSArray *stringArr = [str componentsSeparatedByString:@"_"] ;
                    [tempIdArray addObject:[stringArr firstObject]];
                    [tempNameArray addObject:[stringArr lastObject]];
                }
            }
            NSString *sepId = [tempIdArray componentsJoinedByString:@","];
            NSString *sepName = [tempNameArray componentsJoinedByString:@","];
            
            [retunArr addObject:sepId];
            [retunArr addObject:sepName];
        }else{
            
            if ([string rangeOfString:@"_"].location != NSNotFound) {
                NSArray *arr = [string componentsSeparatedByString:@"_"];
                [retunArr addObject:[arr firstObject]];
                [retunArr addObject:[arr lastObject]];
            }
        }
        return retunArr;
    }else{
        return nil;
    }
}

/**
 *    @brief    转换时间为字符串.
 *
 *    @param    date        时间.
 *    @param    formatter   时间格式.
 *
 */
+ (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter * dateFormatter = [CMDateFormatter sharedDateManager];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    NSString * destDateString = [dateFormatter stringFromDate:(NSDate *)date];
    return destDateString;
}

/**
 *    @brief    转换时间为字符串.
 *
 *    @param    date        时间.
 *    @param    formatter   时间格式.
 *
 */
+ (NSString *)stringFromDate:(NSDate *)date formatter:(NSString *)formatter {
    NSDateFormatter * dateFormatter = [CMDateFormatter sharedDateManager];
    [dateFormatter setDateFormat:formatter];
    NSString * stringDate = [dateFormatter stringFromDate:date];
    return stringDate;
}

/**
 *    @brief    转换时间.
 *
 *    @param    date        时间.
 *    @param    formatter   时间格式.
 *
 */
+ (NSString *)transmitTime:(NSString *)timeString {
    NSDateFormatter * dateFormater = [[NSDateFormatter alloc] init];
    
    [dateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate * date = [dateFormater dateFromString:timeString];
    
    NSDate * now = [NSDate date];
    
    NSTimeInterval cha = [now timeIntervalSinceDate:date];
    
    NSString * returnString = nil;
    if (cha < 60) {
        return @"刚刚";
    }else if (cha/3600 <= 1) {
        returnString = [NSString stringWithFormat:@"%f", cha/60];
        returnString = [returnString substringToIndex:returnString.length-7];
        returnString = [NSString stringWithFormat:@"%@分钟前", returnString];
        
    } else if (cha/(24 * 3600) <= 1) {
        returnString = [NSString stringWithFormat:@"%f", cha/3600];
        returnString = [returnString substringToIndex:returnString.length-7];
        returnString = [NSString stringWithFormat:@"%@小时前", returnString];
    }else if (cha/(7 * 24 * 3600) <= 1)
    {
        returnString = [NSString stringWithFormat:@"%f", cha/(24 * 3600)];
        returnString = [returnString substringToIndex:returnString.length-7];
        returnString = [NSString stringWithFormat:@"%@天前", returnString];
    }else if (cha/(7 * 24 * 3600) > 1)
    {
        NSDateComponents *components = [[NSCalendar currentCalendar]
                                        components:NSDayCalendarUnit |
                                        NSMonthCalendarUnit |
                                        NSYearCalendarUnit
                                        fromDate:date];
        
        NSInteger year  = [components year];
        NSInteger month = [components month];
        NSInteger day   = [components day];
        
        NSDateComponents *componentsCur = [[NSCalendar currentCalendar]
                                           components:NSDayCalendarUnit |
                                           NSMonthCalendarUnit |
                                           NSYearCalendarUnit
                                           fromDate:[NSDate date]];
        
        NSInteger curYear = [componentsCur year];
        
        if(year == curYear) {
            returnString = [NSString stringWithFormat:@"%ld-%ld",(long)month,(long)day];
        }
        else  {
            returnString = [NSString stringWithFormat:@"%lld-%ld-%ld",(long long)year,(long)month,(long)day];
        }
    }
    return returnString;
}

/**
 *    @brief    截取数字.
 *
 */
- (NSString *)numSubString {
    NSScanner * scanner = [NSScanner scannerWithString:self];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
    int number = 0;
    [scanner scanInt:&number];
    NSString * stringNum = [NSString stringWithFormat:@"%ld",(long)number];
    return stringNum;
}


/**
 *    @brief    获取时间戳.
 *
 *    @param    index        index.
 *
 */
+ (NSString *)getTimeStamp:(NSInteger)index {
    NSDate *datenow = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:datenow];
    NSDate * localeDate = [datenow  dateByAddingTimeInterval: interval];
    return [NSString stringWithFormat:@"%lld", (long long)([localeDate timeIntervalSince1970] +index)];
}


/**
 *    @brief    截取用户的职称 1-4级（截取职称 5_讲师,4_主任医师,8_硕士生导师 1-4 5-7 8-9））.
 *
 *    @param    string        要截取的string.
 *    @return   返回 时间 value.
 *
 */
+ (NSString *)getMedicalTitleOneToFour:(NSString *)string
{
    if (string) {
        NSArray *arrTmp = [string componentsSeparatedByString:@","];
        if(arrTmp)
        {
            BOOL contains = NO;
            for(NSString *str in arrTmp)
            {
                if([str hasPrefix:@"1"] || [str hasPrefix:@"2"] || [str hasPrefix:@"3"] || [str hasPrefix:@"4"])
                {
                    if([str rangeOfString:@"_"].location != NSNotFound && [str rangeOfString:@"_"].location)
                    {
                        if(str.length > [str rangeOfString:@"_"].location)
                        {
                            contains = YES;
                            string = [str substringFromIndex:[str rangeOfString:@"_"].location + 1];
                            return string;
                        }
                    }
                }
            }
            if(contains == NO)
            {
                return @"";
            }
        }
    }
    return @"";
}

/**
 *    @brief    截取用户的职称 5-7级 （5_讲师,4_主任医师,8_硕士生导师 5-7）.
 *
 *    @param    string        要截取的string.
 *    @return   返回 时间 value.
 *
 */
+ (NSString *)getMedicalTitleFiveToSeven:(NSString *)string
{
    if (string) {
        NSArray *arrTmp = [string componentsSeparatedByString:@","];
        if(arrTmp)
        {
            BOOL contains = NO;
            for(NSString *str in arrTmp)
            {
                if([str hasPrefix:@"7"] || [str hasPrefix:@"6"] || [str hasPrefix:@"5"])
                {
                    if([str rangeOfString:@"_"].location != NSNotFound && [str rangeOfString:@"_"].location)
                    {
                        if(str.length > [str rangeOfString:@"_"].location)
                        {
                            contains = YES;
                            string = [str substringFromIndex:[str rangeOfString:@"_"].location + 1];
                            return string;
                        }
                    }
                }
            }
            if(contains == NO)
            {
                return @"";
            }
        }
    }
    return @"";
}

/**
 *    @brief    截取用户的职称 8-9级 （截取职称 5_讲师,4_主任医师,8_硕士生导师 1-4 5-7 8-9）.
 *
 *    @param    string        要截取的string.
 *    @return   返回 时间 value.
 *
 */
+ (NSString *)getMedicalTitleEightToNine:(NSString *)string
{
    if (string) {
        NSArray *arrTmp = [string componentsSeparatedByString:@","];
        if(arrTmp)
        {
            BOOL contains = NO;
            for(NSString *str in arrTmp)
            {
                if([str hasPrefix:@"8"] || [str hasPrefix:@"9"])
                {
                    if([str rangeOfString:@"_"].location != NSNotFound && [str rangeOfString:@"_"].location)
                    {
                        if(str.length > [str rangeOfString:@"_"].location)
                        {
                            contains = YES;
                            string = [str substringFromIndex:[str rangeOfString:@"_"].location + 1];
                            return string;
                        }
                    }
                }
            }
            if(contains == NO)
            {
                return @"";
            }
        }
    }
    return @"";
}

/**
 *    @brief    获取资源类型.
 *
 *    @param    sourType        资源类型sourType.
 *    @return   返回 资源类型 value.
 *
 */
//+ (NSString *)sourseType:(NSInteger)sourType {
//    switch (sourType) {
//        case eVideo:
//            return @"视频";
//            break;
//        case eDocument:
//            return @"文库";
//            break;
//        case eMeeting:
//            return @"会议";
//            break;
//        case eTopic:
//            return @"话题";
//            break;
//        case eCase:
//            return @"病例";
//            break;
//        case eReview:
//            return @"评论";
//            break;
//        case ePerson:
//            return @"用户";
//            break;
//        default:
//            break;
//    }
//    return nil;
//}
//
///**
// *    @brief    获取回复你的TA的xxx.
// *
// *    @param    typeString      typeString.
// *    @return   返回 value.
// *
// */
//+ (NSString *)getTypeWordWithType:(NSString *)typeString {
//    NSInteger type =[typeString integerValue];
//    switch (type) {
//        case eInfoALL:
//            return @"TA的";
//            break;
//        case eVideo:
//            return @"TA的视频";
//            break;
//        case eDocument:
//            return @"TA的文库";
//            break;
//        case eMeeting:
//            return @"TA的会议";
//            break;
//        case eTopic:
//            return @"TA的话题";
//            break;
//        case eNote:
//            return @"TA的笔记";
//            break;
//        case eTag:
//            return @"TA的标签";
//            break;
//        case eCase:
//            return @"TA的病例";
//            break;
//        case eReview:
//            return @"TA的评论";
//            
//            break;
//        case ePerson:
//            return @"TA的用户";
//            break;
//        default:
//            return @"TA的";
//            break;
//    }
//}

/**
 *    @brief    获取字号大小.
 *
 *    @param    type      type.
 *    @return   返回 value.
 *
 */
//+ (NSString *)getFontTypeWithType:(NSInteger)type {
//
//    switch (type) {
//        case esettingFontSmall:
//            return @"小号字体";
//            break;
//        case esettingFontMeddile:
//            return @"中号字体";
//            break;
//        case esettingFontBig:
//            return @"大号字体";
//            break;
//        case esettingFontSuperBig:
//            return @"超大号字体";
//            break;
//        default:
//            return @"大号字体";
//            break;
//    }
//}

/**
 *    @brief    获取10000+数字.
 *
 *    @param    targetString      10000+ targetString.
 *    @return   返回 value.
 *
 */
+ (NSString *)adjumentNumberWithTag:(NSString *)targetString{
    NSInteger targetNumber = [targetString integerValue];
    NSString *finalString = nil;
    /*
    if (targetNumber > 19999) {
        finalString = @"2万+";
    }else
     */
    if(targetNumber > 9999){
       finalString = @"1万+";
    }
    else{
        finalString = targetString;
    }
    return finalString;
}

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        return nil;
    }
    return dic;
}

@end
