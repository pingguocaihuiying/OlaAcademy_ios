//
//  HomeworkTableCell.h
//  mxedu
//
//  Created by 田晓鹏 on 16/8/3.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Homework.h"

@interface HomeworkTableCell : UITableViewCell

-(void)setupCellWithModel:(Homework*)homework;

@end
