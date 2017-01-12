//
//  GroupTableCell.h
//  mxedu
//
//  Created by 田晓鹏 on 16/8/29.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Group.h"

@interface GroupTableCell : UITableViewCell

-(void)setupCellWithModel:(Group*)group;

@end
