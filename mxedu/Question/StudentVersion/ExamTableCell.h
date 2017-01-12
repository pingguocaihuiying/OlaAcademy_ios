//
//  ExamTableCell.h
//  mxedu
//
//  Created by 田晓鹏 on 16/8/8.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Examination.h"

@interface ExamTableCell : UITableViewCell

-(void) setCellWithModel:(Examination*)examination;

@end
