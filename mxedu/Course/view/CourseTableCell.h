//
//  CourseTableCell.h
//  mxedu
//
//  Created by 田晓鹏 on 15/10/19.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"

@class CourseTableCell;
@protocol CollectionCellDelegate <NSObject>

-(void)collectionDidClick:(Course*)course;

@end

@interface CourseTableCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic) UILabel *nameL;
@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) UIImageView *line;

@property (nonatomic) id<CollectionCellDelegate> delegate;

@property (nonatomic) Course *course;

-(void) setCellWithModel:(Course*)course;

@end
