//
//  UserTableCell.h
//  mxedu
//
//  Created by 田晓鹏 on 16/9/13.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserCellModel.h"

@interface UserTableCell : UITableViewCell

-(void)setupCellWithModel:(UserCellModel*) model;

@end
