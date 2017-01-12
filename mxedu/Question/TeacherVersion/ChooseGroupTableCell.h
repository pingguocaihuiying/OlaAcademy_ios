//
//  ChooseGroupTableCell.h
//  mxedu
//
//  Created by 田晓鹏 on 16/10/10.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Group.h"

@interface ChooseGroupTableCell : UITableViewCell

-(void)setupCellWithModel:(Group*)group;

@end
