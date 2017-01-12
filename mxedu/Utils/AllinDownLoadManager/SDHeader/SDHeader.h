//
//  SDHeader.h
//  NTreat
//
//  Created by 周冉 on 16/4/13.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDHeader : NSObject
#define  NTUserInfo   @"NTUserInfo"

#define SDAppDelegate        (AppDelegate *)[[UIApplication sharedApplication] delegate]

#define kSelectTextColor  [UIColor colorWithRed:128/255. green:128/255. blue:128/255. alpha:1]//大部分选中大颜色
#define KTextColor   [UIColor colorWithRed:102/255. green:102/255. blue:102/255. alpha:1]

#define kCelleSepCorlor             [UIColor colorWithRed:219/255. green:219/255. blue:219/255. alpha:1.0]//多选控件 被选中使线的颜色
#define kSelfViewBackgroundColor    [UIColor colorWithRed:239/255. green:239/255. blue:244/255. alpha:1.0]
#define kCellGrayTextColor      [UIColor colorWithRed:128/255. green:128/255. blue:128/255. alpha:1]    //.  灰色字体颜色
#define kCellLineColor          [UIColor colorWithRed:219/255. green:219/255. blue:219/255. alpha:1]    //. cell分割线颜色
#define kDownTextColor           [UIColor colorWithRed:213/255. green:213/255. blue:213/255. alpha:1]    //. cell分割线颜色
#define kCellLineHeight                 0.5                  //. cell分割线的高度
#define kNavBgColor  [UIColor colorWithRed:12/255. green:142/255. blue:243/255. alpha:1]

#define kScreenScaleWidth               [UIScreen mainScreen].bounds.size.width/320.0
#define kScreenScaleHeight              [UIScreen mainScreen].bounds.size.height/568.0
#define kScreenHeight                   (kScreenScaleWidth==1?1:kScreenScaleHeight)
//================通用====================
#define UI_NAVIGATION_BAR_HEIGHT        44
#define UI_TOOL_BAR_HEIGHT              44
#define UI_TAB_BAR_HEIGHT               49
#define UI_STATUS_BAR_HEIGHT            20
#define UI_NAVIGATION7_BAR_HEIGHT       64

//====================================
#define UI_MAINSCREEN_HEIGHT_ROTATE     (SCREEN_HEIGHT - UI_STATUS_BAR_HEIGHT)




#define kVedioHeight                    180*kScreenScaleHeight //视频的高度
#define kBottomViewHeight_V             42
#define TopReturnBtnViewWidth       50
#define TopViewHeight                   44
#define kBottomViewHeight_H             72


#define kVedioPalyListViewHeight     SCREEN_WIDTH -TopViewHeight-kBottomViewHeight_H //视频全屏列表高度
#define kVedioPalyListViewWidth       260*kScreenScaleHeight //视频全屏列表宽度



#define SCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width


//RGB color macro
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//算 高加Y坐标的和
#define height_y(view)  view.frame.size.height + view.frame.origin.y


// 下载状态
typedef NS_ENUM(NSInteger,DownloadStatusType) {
    eDownloadStatusWait = 1,     //. 等待下载
    eDownloadStatusOn = 2,       //. 正在下载
    eDownloadStatusPause = 3,    //. 暂停下载
    eDownloadStatusOver = 4,     //. 下载完成
    eDownloadStatusCancel = 5,   //. 下载取消
};
//判断是正在下载还是本地下载
typedef enum SDMyLocalVideoCellTyp{
    eAllinMyLocalVideoCellOver = 0,
    eAllinMyLocalVideoCellDoing,
}SDMyLocalVideoCellTyp;

//判断是否登陆宏
#define  SDlogin   AuthManager *am =[[AuthManager alloc]init];\
if(!am.isAuthenticated)\
{\
LoginViewController* loginViewCon = [[LoginViewController alloc] init];\
UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:loginViewCon];\
    loginViewCon.isFromOther = YES;\
    [self presentViewController:rootNav animated:YES completion:^{}\
];\
    return;\
};\

@end
