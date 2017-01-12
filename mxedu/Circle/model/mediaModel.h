//
//  mediaModel.h
//  NTreat
//
//  Created by 刘德胜 on 15/12/25.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface mediaModel : NSObject

@property (nonatomic,copy) NSString *type;

@property (nonatomic,copy) NSString *timeLong;

@property (nonatomic,retain) UIImage *image;

@property (nonatomic,retain) NSData *imgData;

@property (nonatomic,copy) NSString *localpath;

@property (nonatomic,copy) NSString *videoimg;//视频第一针图片

@property (nonatomic,assign) BOOL isExit;//标记是否是已经上传过的

@property (nonatomic,copy) NSString *gid;//如果已经上传的这个gid有值

@end
