//
//  CorrectTableCell.h
//  mxedu
//
//  Created by 田晓鹏 on 16/4/27.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CorrectTableCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) NSArray *answerArray;

-(void)setupCell:(NSArray*)answerArray;

@end
