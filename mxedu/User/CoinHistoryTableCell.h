//
//  CoinHistoryTableCell.h
//  mxedu
//
//  Created by 田晓鹏 on 16/10/20.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CoinHistory.h"

@interface CoinHistoryTableCell : UITableViewCell

-(void)setupCellWithModel:(CoinHistory*) model;

@end
