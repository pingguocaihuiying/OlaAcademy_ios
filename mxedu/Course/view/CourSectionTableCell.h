//
//  CourSectionTableCell.h
//  mxedu
//
//  Created by 田晓鹏 on 15/12/12.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CourseVideo.h"

@interface CourSectionTableCell : UITableViewCell

-(void) setCellWithModel:(CourseVideo*)point;

@end
