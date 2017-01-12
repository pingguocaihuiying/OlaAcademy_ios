//
//  CourSectionViewController.h
//  课程章节分类及视频 页面
//
//  Created by 田晓鹏 on 15/10/21.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CourseManager.h"
#import "CoursePoint.h"
#import "PlayerManager.h"
#import "Commodity.h"

@interface CourSectionViewController : UIViewController

@property (nonatomic) NSString *objectId;
@property (nonatomic) Commodity *commodity;
@property (nonatomic) int type; //1 course 2 goods
@property (strong, nonatomic) PlayerManager *player;

-(void)setupData;

@end
