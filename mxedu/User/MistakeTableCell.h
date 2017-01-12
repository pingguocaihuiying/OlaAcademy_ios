//
//  MistakeTableCell.h
//  mxedu
//
//  Created by 田晓鹏 on 16/11/10.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Mistake.h"

@interface MistakeTableCell : UITableViewCell

-(void)setupCellWithModel:(Mistake*)mistake;

@end
