//
//  CourseListTableCell.h
//  mxedu
//
//  Created by 田晓鹏 on 16/8/15.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Course.h"

@interface CourseListTableCell : UITableViewCell

-(void)setupCell:(Course*)course;

@end
