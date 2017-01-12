//
//  HomeTableCell.h
//  mxedu
//
//  Created by 田晓鹏 on 16/8/15.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Course.h"
#import "Commodity.h"

@protocol CollectionCellDelegate <NSObject>

-(void)collectionDidClick:(NSObject*)data;

@end

@interface HomeTableCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) UIImageView *line;

@property (nonatomic) id<CollectionCellDelegate> delegate;

-(void) setCellWithData:(NSArray*)dataArray;

@end
