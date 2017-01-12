//
//  MessageMainTableCell.h
//  mxedu
//
//  Created by 田晓鹏 on 16/12/21.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MessageModel.h"

@interface MessageMainTableCell : UITableViewCell

-(void)setupCell:(MessageModel*)message;

@end
