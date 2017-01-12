//
//  Banner.h
//  mxedu
//
//  Created by 田晓鹏 on 16/8/17.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Commodity.h"

@interface Banner : NSObject

@property (nonatomic) NSString* bannerId;
@property (nonatomic) NSString* name;
@property (nonatomic) NSString* objectId;
@property (nonatomic) NSString* pic;
@property (nonatomic) int type;
@property (nonatomic) NSString* url;
@property (nonatomic) Commodity *commodity;

@end
