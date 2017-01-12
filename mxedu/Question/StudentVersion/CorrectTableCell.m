//
//  CorrectTableCell.m
//  mxedu
//
//  Created by 田晓鹏 on 16/4/27.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "CorrectTableCell.h"

#import "SysCommon.h"
#import "CorrectCollectionCell.h"

@implementation CorrectTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //确定是水平滚动，还是垂直滚动
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.allowsSelection = YES;
        _collectionView.scrollEnabled = NO;
        
        [_collectionView registerClass:[CorrectCollectionCell class] forCellWithReuseIdentifier:@"CollectCollectionCell"];
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:_collectionView];
    }
    return self;
    
}

-(void)setupCell:(NSArray*)answerArray{
    NSInteger rowCount = [answerArray count]%5==0?[answerArray count]/5:[answerArray count]/5+1;
    _collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_WIDTH/5-10)*rowCount);
    _answerArray = answerArray;
    [_collectionView reloadData];
}


#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [_answerArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CorrectCollectionCell *cell = (CorrectCollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectCollectionCell" forIndexPath:indexPath];
    [cell setupCellWithModel:[_answerArray objectAtIndex:indexPath.row] Index:indexPath.row];
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH/5-10, SCREEN_WIDTH/5-20);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 5, 0, 5);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
