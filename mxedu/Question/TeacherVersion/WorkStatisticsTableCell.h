//
//  WorkStatisticsTableCell.h
//  mxedu
//
//  Created by 田晓鹏 on 16/10/17.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "StatisticsUser.h"

@interface WorkStatisticsTableCell : UITableViewCell

-(void)setupCellWithModel:(StatisticsUser*)user;

@end
