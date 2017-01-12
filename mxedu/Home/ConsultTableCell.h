//
//  ConsultTableCell.h
//  mxedu
//
//  Created by 田晓鹏 on 16/8/23.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Consult.h"

@interface ConsultTableCell : UITableViewCell

-(void)setupCellWithModel:(Consult*)consult AtRow:(NSInteger)rowIndex;

@end
