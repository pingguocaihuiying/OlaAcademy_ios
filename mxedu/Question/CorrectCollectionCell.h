//
//  HealthCollectionCell.h
//  NTreat
//
//  Created by 田晓鹏 on 16/3/8.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Correctness.h"

@interface CorrectCollectionCell : UICollectionViewCell

-(void)setupCellWithModel:(Correctness*) correctness Index:(NSInteger)index;

@end
