//
//  UserCellModel.h
//  mxedu
//
//  Created by 田晓鹏 on 16/9/13.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserCellModel : NSObject

@property (nonatomic) NSString *icon;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *desc;
@property (nonatomic) int type;   //1 右侧有箭头 2 右侧只有文本无箭头
@property (nonatomic) int isSection;
@property (nonatomic) int showRedTip;

@end
