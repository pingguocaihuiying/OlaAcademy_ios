//
//  HomeworkChooseController.h
//  mxedu
//
//  Created by 田晓鹏 on 16/9/30.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SysCommon.h"
#import "UIColor+HexColor.h"
#import "SDGroupCell.h"


@class SDGroupCell;

@interface HomeworkChooseController : UITableViewController
{
    NSMutableDictionary *expandedIndexes;
}

@property (nonatomic) NSString *subjectId;//当前科目ID

#pragma mark - Internal

@property (assign) int mainItemsAmt;
@property (strong) NSMutableDictionary *subItemsAmt;

@property (assign) SDGroupCell *groupCell;

- (void) collapsableButtonTapped: (UIControl *)button withEvent: (UIEvent *)event;
- (void) groupCell:(SDGroupCell *)cell didSelectSubCell:(SDGroupCell *)subCell withIndexPath: (NSIndexPath *)indexPath;

@end
