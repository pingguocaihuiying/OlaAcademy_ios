//
//  SubjectTableCell.h
//  mxedu
//
//  Created by 田晓鹏 on 16/3/7.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Course.h"

@interface SubjectTableCell : UITableViewCell

-(void) setCellWithModel:(Course*)course;

@end
