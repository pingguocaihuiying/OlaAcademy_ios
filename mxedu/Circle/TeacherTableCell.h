//
//  TeacherTableCell.h
//  mxedu
//
//  Created by 田晓鹏 on 16/12/9.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "User.h"

@protocol TeacherTableCellDelegate <NSObject>

-(void)didClickInvite:(User*)user;

@end

@interface TeacherTableCell : UITableViewCell

-(void)setupCellWithModel:(User*)user;

@property (nonatomic) id<TeacherTableCellDelegate> delegate;

@end
