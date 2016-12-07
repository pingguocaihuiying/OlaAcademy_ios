//
//  CommentFrame.m
//  mxedu
//
//  Created by 田晓鹏 on 16/11/29.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "CommentFrame.h"

#import "SysCommon.h"

@implementation CommentFrame

- (void)setComment:(Comment *)comment
{
    _comment = comment;
    //间距
    CGFloat mgr = GENERAL_SIZE(16);
    
    //设置图像的frame
    CGFloat iconX = GENERAL_SIZE(30);
    CGFloat iconY = GENERAL_SIZE(16);
    CGFloat iconW = GENERAL_SIZE(80);
    CGFloat iconH = GENERAL_SIZE(80);
    self.iconFrame = CGRectMake(iconX, iconY, iconW, iconH);
    
    //设置昵称frame
    CGFloat nameX = CGRectGetMaxX(self.iconFrame) + mgr;
    CGFloat nameY = iconY+5;
    CGFloat nameW = 220;
    CGFloat nameH = 20;
    self.nameFrame = CGRectMake(nameX, nameY, nameW, nameH);
    
    //设置正文的frame
    CGFloat textX = GENERAL_SIZE(30);
    CGFloat textY = CGRectGetMaxY(self.iconFrame)+mgr/2;
    
    CGFloat maxW = 0.0;
    CGSize textSize;
    
    NSString* contetxt = [comment.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    contetxt = [contetxt stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    contetxt = [contetxt stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //根据普通文本计算正文的范围
    maxW = SCREEN_WIDTH - 2*iconX;
    NSMutableParagraphStyle *style =  [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 5.0f;
    NSDictionary *attributes = @{NSFontAttributeName: LabelFont(30),NSParagraphStyleAttributeName:style};
    CGRect rect = [contetxt boundingRectWithSize:CGSizeMake(maxW, MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attributes
                                         context:nil];
    textSize.width=maxW;
    textSize.height=rect.size.height;
    
//    if (textSize.height>60) {
//        textSize = CGSizeMake(textSize.width, 60);
//    }

    self.textFrame = (CGRect){{textX,textY},textSize};
    
    //设置音视频frame
    CGFloat mediaX = GENERAL_SIZE(30);
    CGFloat mediaY = CGRectGetMaxY(self.textFrame)+5;
    CGFloat mediaW = SCREEN_WIDTH-GENERAL_SIZE(120);
    CGFloat mediaH = 0;
    if((comment.videoUrls&&![comment.videoUrls isEqualToString:@""])||(comment.audioUrls&&![comment.audioUrls isEqualToString:@""])){
        mediaH = GENERAL_SIZE(80);
    }
    self.mediaFrame = CGRectMake(mediaX, mediaY, mediaW, mediaH);
    
    //设置图片的frame
    NSArray *array = [comment.imageIds componentsSeparatedByString:@","];
    NSInteger count = [array count];
    if ([array lastObject]==nil || [[array lastObject] isEqualToString:@""]) {
        count = count -1;
    }
    
    CGFloat imageX = GENERAL_SIZE(30);
    CGFloat imageY = CGRectGetMaxY(self.mediaFrame) + (count==0?0:mgr);
    CGFloat imageW = SCREEN_WIDTH/4 *(count<3?count:3) + (count<3?count:4) * 5; //图片大小为屏幕的1/4
    CGFloat imageH = 0;
    
    if (count <= 3) {
        imageH = SCREEN_WIDTH/3 -20;
    }else if(count <= 6){
        imageH = 2*SCREEN_WIDTH/3 -40;
    }else if(count <= 9){
        imageH = SCREEN_WIDTH -60;
    }else{
        imageH = 4*SCREEN_WIDTH/3 -80;
    }
    
    self.imageFrame = CGRectMake(imageX, imageY, imageW, imageH);
    
    //设置cell的高度
    self.cellHeight = CGRectGetMaxY(self.imageFrame) + 2*mgr;
    
}

@end
