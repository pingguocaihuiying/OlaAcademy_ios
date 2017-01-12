//
//  BuyTableCell.h
//  mxedu
//
//  Created by 田晓鹏 on 16/6/2.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Commodity.h"

@interface BuyTableCell : UITableViewCell

-(void)setupCellWithModel:(Commodity*) model;

@end
