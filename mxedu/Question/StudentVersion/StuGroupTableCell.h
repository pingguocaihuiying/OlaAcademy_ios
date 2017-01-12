//
//  StuGroupTableCell.h
//  mxedu
//
//  Created by 田晓鹏 on 16/9/1.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Group.h"

@protocol StuGroupCellDelegate <NSObject>

-(void)clickAttendWithRowIndex:(NSInteger)rowIndex Type:(NSString*)type;

@end

@interface StuGroupTableCell : UITableViewCell

@property (nonatomic) id<StuGroupCellDelegate> delelgate;

-(void)setupCellWithModel:(Group*)group RowIndex:(NSInteger)rowIndex;

@end

