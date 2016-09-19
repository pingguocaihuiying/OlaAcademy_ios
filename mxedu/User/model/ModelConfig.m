//
//  ModelConfig.m
//  mxedu
//
//  Created by 田晓鹏 on 16/9/13.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "ModelConfig.h"

#import "UserCellModel.h"

@implementation ModelConfig

+(NSMutableArray*)confgiModelData{
    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:10];
    
    UserCellModel *mistake = [[UserCellModel alloc]init];
    mistake.icon = @"icon_mistake";
    mistake.title = @"错题本";
    mistake.type = 1;
    mistake.isSection = 1;
    [dataArray addObject:mistake];
    
    UserCellModel *vip = [[UserCellModel alloc]init];
    vip.icon = @"icon_vip";
    vip.title = @"VIP购买";
    vip.desc = @"30元/月";
    vip.type = 1;
    vip.isSection = 1;
    [dataArray addObject:vip];
    
    UserCellModel *buy = [[UserCellModel alloc]init];
    buy.icon = @"icon_buy";
    buy.title = @"我的购买";
    buy.isSection = 1;
    buy.type = 1;
    [dataArray addObject:buy];
    
    UserCellModel *collect = [[UserCellModel alloc]init];
    collect.icon = @"icon_collect";
    collect.title = @"我的收藏";
    collect.type = 1;
    [dataArray addObject:collect];
    
    UserCellModel *download = [[UserCellModel alloc]init];
    download.icon = @"icon_download";
    download.title = @"我的下载";
    download.type = 1;
    [dataArray addObject:download];
    
    UserCellModel *email = [[UserCellModel alloc]init];
    email.icon = @"icon_email";
    email.title = @"客服邮箱";
    email.type = 2;
    email.desc = @"service@olaxueyuan.com";
    email.isSection = 1;
    [dataArray addObject:email];
    
    return dataArray;
}

@end
