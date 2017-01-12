//
//  CollectionTableCell.h
//  mxedu
//
//  Created by 田晓鹏 on 16/5/4.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CollectionVideo.h"

@interface CollectionTableCell : UITableViewCell

-(void)setupCellWithModel:(CollectionVideo*) model;

@end
