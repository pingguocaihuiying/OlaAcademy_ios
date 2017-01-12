//
//  Material.h
//  mxedu
//
//  Created by 田晓鹏 on 16/10/29.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Material : NSObject

@property (nonatomic) NSString* materialId;
@property (nonatomic) NSString* title;
@property (nonatomic) NSString* provider;
@property (nonatomic) NSString* pic;
@property (nonatomic) NSString* type;
@property (nonatomic) NSString* url;
@property (nonatomic) NSString* size;
@property (nonatomic) NSString* price;
@property (nonatomic) NSString* count; //浏览量
@property (nonatomic) NSString* status; // 1 免费或已兑换 0付费
@property (nonatomic) NSString* time;

@end
