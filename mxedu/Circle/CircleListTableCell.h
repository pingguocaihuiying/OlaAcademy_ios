//
//  CircleListTableCell.h
//  mxedu
//
//  Created by 田晓鹏 on 16/12/10.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OlaCircle.h"
#import "User.h"

@protocol CircleListTableCellDelegate <NSObject>

-(void)didClickUserAvatar:(User*)userInfo;

@end

@interface CircleListTableCell : UITableViewCell

@property (nonatomic) id<CircleListTableCellDelegate> delegate;

@property (nonatomic) OlaCircle *olaCircle;

-(void)setupCellWithModel:(OlaCircle*)circle;

@end
