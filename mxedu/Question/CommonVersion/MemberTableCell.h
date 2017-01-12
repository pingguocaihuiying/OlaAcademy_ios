//
//  MemberTableCell.h
//  mxedu
//
//  Created by 田晓鹏 on 16/11/4.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "User.h"

@interface MemberTableCell : UITableViewCell

-(void)setupCellWithModel:(User*)user;

@end
