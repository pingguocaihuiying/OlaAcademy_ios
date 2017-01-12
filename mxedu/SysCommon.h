//
//  SysCommon.h
//  NTreat
//
//  Created by 田晓鹏 on 15-4-24.
//  Copyright (c) 2015年 田晓鹏. All rights reserved.
//

#pragma once

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "DataMappingManager.h"
#import "UIView+Positioning.h"

@interface SysCommon : NSObject

#if __cplusplus
extern "C" {
#endif
    AppDelegate* GetAppDelegate();
    DataMappingManager* GetDataManager();
    
#if __cplusplus
}
#endif

#pragma mark ---- color functions

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define BACKGROUNDCOLOR [UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1]
#define COMMONBLUECOLOR [UIColor colorWithRed:66/255.0f green:133/255.0f blue:244/255.0f alpha:1]

#pragma mark ----Size ,X,Y, View ,Frame

#define UI_STATUS_BAR_HEIGHT 20

//get the  size of the Screen
#define SCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width
#define HEIGHT_SCALE  ([[UIScreen mainScreen]bounds].size.height/480.0)

//get the  size of the Application
#define APP_HEIGHT [[UIScreen mainScreen]applicationFrame].size.height
#define APP_WIDTH [[UIScreen mainScreen]applicationFrame].size.width

#define APP_SCALE_H  ([[UIScreen mainScreen]applicationFrame].size.height/480.0)
#define APP_SCALE_W  ([[UIScreen mainScreen]applicationFrame].size.width/320.0)

#define defaultWith 750 //根据iphone6而来 可根据具体情况修改
#define LabelFont(I)  [UIFont systemFontOfSize:(int)(SCREEN_WIDTH/defaultWith*I)]

#define GENERAL_SIZE(I)  (int)(SCREEN_WIDTH/defaultWith*I)

#define BASIC_URL @"http://123.59.129.137:8080"
//#define BASIC_URL @"http://api.olaxueyuan.com"

#define BASIC_IMAGE_URL @"http://upload.olaxueyuan.com/SDpic/common/picSelect?gid="
#define BASIC_Movie_URL @"http://upload.olaxueyuan.com/"

#define GET_IMAGE_URL(url) [NSString stringWithFormat:@"%@%@", BASIC_IMAGE_URL, url]

//判断iphone5
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : 0)

//判断iphone6
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)


//判断iphone6+
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define kScreenScaleWidth               [UIScreen mainScreen].bounds.size.width/320.0
#define kScreenScaleHeight              [UIScreen mainScreen].bounds.size.height/568.0
#define kScreenHeight                   (kScreenScaleWidth==1?1:kScreenScaleHeight)

//================通用====================
#define UI_NAVIGATION_BAR_HEIGHT        44
#define UI_TOOL_BAR_HEIGHT              44
#define UI_TAB_BAR_HEIGHT               49
#define UI_STATUS_BAR_HEIGHT            20
#define UI_NAVIGATION7_BAR_HEIGHT       64

#define UI_MAINSCREEN_HEIGHT_ROTATE     (SCREEN_HEIGHT - UI_STATUS_BAR_HEIGHT)

#define kBottomViewHeight_V             42
#define TopReturnBtnViewWidth           50
#define TopViewHeight                   44
#define kBottomViewHeight_H             72

//判断是否登陆宏
#define  OLA_LOGIN   AuthManager *am =[AuthManager sharedInstance];\
if(!am.isAuthenticated)\
{\
LoginViewController* loginViewCon = [[LoginViewController alloc] init];\
UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:loginViewCon];\
[self presentViewController:rootNav animated:YES completion:^{}\
];\
return;\
};\

#define SDUserID   AuthManager *authManger = [AuthManager sharedInstance];\
return  authManger.userInfo.userId;

//====================== 归档 / 解档=========================
#define OBJC_STRING(x) @#x
#define Decode(x) self.x = [aDecoder decodeObjectForKey:OBJC_STRING(x)]
#define Encode(x) [aCoder encodeObject:self.x forKey:OBJC_STRING(x)]
//==========================================================

#define kDocPath         [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, \
NSUserDomainMask, YES) objectAtIndex:0]

#define kCachPath        [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, \
NSUserDomainMask, YES) objectAtIndex:0]

#define kTmpPath          NSTemporaryDirectory()


// 视频路径
//======================================================
#define kVedioDataPath  @"/DownLoad"
#define kVedioTempPath  @"/DownLoad/Temp"
#define kVedioListPath  @"/DownLoad/VideoList"

// 图片路径
//======================================================
#define kImgDataPath    @"/Images"
#define kImgListPath    @"/Images/ImageList"

// 讲义路径
#define kPDFDataPath  @"/PDF"



#define kShareVideoActionDataPath   @"/Actions/video"

@end
