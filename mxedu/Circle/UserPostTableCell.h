//
//  UserPostTableCell.h
//  mxedu
//
//  Created by 田晓鹏 on 2016/12/27.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OlaCircle.h"

@interface UserPostTableCell : UITableViewCell

-(void)setupCell:(OlaCircle*)circle Type:(NSInteger)type;

@end
