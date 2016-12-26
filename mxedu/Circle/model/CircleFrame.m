//
//  WKCellModel.m
//  WKDemo
//
//  Created by wangzhaohui-Mac on 14-8-5.
//  Copyright (c) 2014年 com.app. All rights reserved.
//

#import "CircleFrame.h"
#import "OlaCircle.h"
#import "SysCommon.h"
#import "sys/utsname.h"

@implementation CircleFrame
- (void)setResult:(OlaCircle *)result
{
    _result = result;
    //间距
    CGFloat mgr = GENERAL_SIZE(16);
    
    //1,设置图像的frame
    CGFloat iconX = GENERAL_SIZE(20);
    CGFloat iconY = GENERAL_SIZE(16);
    CGFloat iconW = GENERAL_SIZE(80);
    CGFloat iconH = GENERAL_SIZE(80);
    self.iconFrame = CGRectMake(iconX, iconY, iconW, iconH);
    
    //2,设置昵称frame
    CGFloat nameX = CGRectGetMaxX(self.iconFrame) + mgr;
    CGFloat nameY = iconY+GENERAL_SIZE(20);
    CGFloat nameW = 220;
    CGFloat nameH =  GENERAL_SIZE(40);
    self.nameFrame = CGRectMake(nameX, nameY, nameW, nameH);
    
    //3,设置时间的frame
    CGSize timeSize = [result.time sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    CGFloat timeX = SCREEN_WIDTH-timeSize.width-20;
    CGFloat timeY = iconY+GENERAL_SIZE(20);
    CGFloat timeW = timeSize.width+20;
    CGFloat timeH =  GENERAL_SIZE(40);
    
    self.timeFrame = CGRectMake(timeX, timeY, timeW, timeH);
    
    //设置标题frame
    CGFloat titelX = GENERAL_SIZE(20);
    CGFloat titleY = CGRectGetMaxY(self.iconFrame)+mgr;;
    CGFloat titleW = SCREEN_WIDTH-GENERAL_SIZE(40);
    CGFloat titleH = GENERAL_SIZE(30);
    self.titleFrame = CGRectMake(titelX, titleY, titleW, titleH);
    
    //5,设置图片的frame
    NSArray *array = [result.imageGids componentsSeparatedByString:@","];
    NSInteger count = [array count];
    if ([array lastObject]==nil || [[array lastObject] isEqualToString:@""]) {
        count = count -1;
    }
    
    CGFloat imageX = GENERAL_SIZE(20);
    CGFloat imageY = CGRectGetMaxY(self.titleFrame) + ([result.imageGids length]==0?0:mgr/2);
    CGFloat imageW = (SCREEN_WIDTH-GENERAL_SIZE(80))/3 *(count<3?count:3) + (count<3?count:4) * 5; 
    CGFloat imageH = 0;
    
    //图片
    if (count==1) {
        imageW= SCREEN_WIDTH-GENERAL_SIZE(40);
        imageH = GENERAL_SIZE(300);
    }else if(count>1){
        if (count <= 3) {
            imageH = SCREEN_WIDTH/3 -20;
        }else if(count <= 6){
            imageH = 2*SCREEN_WIDTH/3 -40;
        }else if(count <= 9){
            imageH = SCREEN_WIDTH -60;
        }else{
            imageH = 4*SCREEN_WIDTH/3 -80;
        }
    }
    
    self.imageFrame = CGRectMake(imageX, imageY, imageW, imageH);
    
    //设置正文的frame
    CGFloat textX = GENERAL_SIZE(20);
    CGFloat textY = CGRectGetMaxY(self.imageFrame)+GENERAL_SIZE(10);
    CGFloat maxW = 0.0;
    CGSize textSize;
    
    NSString* contetxt = [_result.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    contetxt = [contetxt stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    contetxt = [contetxt stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //根据普通文本计算正文的范围
    maxW = SCREEN_WIDTH - GENERAL_SIZE(40);
    NSMutableParagraphStyle *style =  [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 3.0f;
    NSDictionary *attributes = @{NSFontAttributeName: LabelFont(28),NSParagraphStyleAttributeName:style};
    CGRect rect = [contetxt boundingRectWithSize:CGSizeMake(maxW, MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attributes
                                         context:nil];
    textSize.width=maxW;
    textSize.height=rect.size.height;
    self.textFrame = (CGRect){{textX,textY},textSize};
    
    //设置浏览量frame
    CGFloat visitX = GENERAL_SIZE(20);
    CGFloat visitY = CGRectGetMaxY(self.textFrame)+GENERAL_SIZE(30);
    CGFloat visitW = SCREEN_WIDTH-GENERAL_SIZE(40);
    CGFloat visitH = GENERAL_SIZE(30);
    self.visitFrame = CGRectMake(visitX, visitY, visitW, visitH);
    
    //设置点赞frame
    CGFloat praiseX = SCREEN_WIDTH-GENERAL_SIZE(80);
    CGFloat praiseY = CGRectGetMaxY(self.textFrame)+GENERAL_SIZE(30);
    CGFloat praiseW = GENERAL_SIZE(60);
    CGFloat praiseH = GENERAL_SIZE(30);
    self.praiseFrame = CGRectMake(praiseX, praiseY, praiseW, praiseH);
    
    //6,设置工具栏的frame
    CGFloat toolbarX = 0;
    CGFloat toolbarY = CGRectGetMaxY(self.visitFrame)+GENERAL_SIZE(30);
    CGFloat toolbarW = SCREEN_WIDTH;
    CGFloat toolbarH = GENERAL_SIZE(106);
    
    self.toolFrame = CGRectMake(toolbarX, toolbarY, toolbarW, toolbarH);
    
    //设置cell的高度
    self.cellHeigth = CGRectGetMaxY(self.toolFrame);
    
}

//获得设备型号
-(NSString*)deviceString
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone6,1"]) return @"iPhone 5s ";
    if ([deviceString isEqualToString:@"iPhone6,2"]) return @"iPhone 5s ";
    if ([deviceString isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    return deviceString;
}
@end
