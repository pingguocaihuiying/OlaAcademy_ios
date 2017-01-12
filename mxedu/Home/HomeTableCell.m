//
//  HomeTableCell.m
//  mxedu
//
//  Created by 田晓鹏 on 16/8/15.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "HomeTableCell.h"

#import "SysCommon.h"
#import "UIImageView+WebCache.h"
#import "UIColor+HexColor.h"

#import "HomeCollectionCell.h"

@interface HomeTableCell()

@property (nonatomic) NSArray* dataArray;

@end

@implementation HomeTableCell


- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _line = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 1)];
        _line.backgroundColor = RGBCOLOR(235, 235, 235);
        [self addSubview:_line];
        
        //确定是水平滚动，还是垂直滚动
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, GENERAL_SIZE(20), SCREEN_WIDTH, GENERAL_SIZE(275))collectionViewLayout:flowLayout];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = NO;
        _collectionView.allowsSelection = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [_collectionView registerClass:[HomeCollectionCell class] forCellWithReuseIdentifier:@"colletionCell"];
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_collectionView];
        
    }
    return self;
    
}

-(void) setCellWithData:(NSArray*)dataArray{
    _dataArray = dataArray;
    [_collectionView reloadData];
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_dataArray count];
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"colletionCell";
    HomeCollectionCell * cell = (HomeCollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    NSObject *data = [_dataArray objectAtIndex:indexPath.row];
    if ([data isKindOfClass:[Commodity class]]) {
        Commodity *commodity = (Commodity*)data;
        NSString *imageUrl = commodity.url;
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
        cell.nameLabel.text = commodity.name;
        if (indexPath.row==0) {
            cell.markLabel.text = @"热门";
        }else{
            cell.markLabel.text = @"最新";
        }
        cell.timeLabel.text = [NSString stringWithFormat:@"%@分钟",commodity.totaltime];
        cell.visitLabel.text = [NSString stringWithFormat:@"%@购买",commodity.paynum];
    }else if([data isKindOfClass:[Course class]]){
        Course *course = (Course*)data;
        NSString *imageUrl = course.address;
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
        cell.nameLabel.text = course.name;
        cell.timeLabel.text = course.totalTime;
        if (indexPath.row==0) {
            cell.markLabel.text = @"热门";
        }else{
            cell.markLabel.text = @"最新";
        }
        cell.visitLabel.text = [NSString stringWithFormat:@"%@观看",course.playcount];
    }
    
    
    return cell;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH/2-15, GENERAL_SIZE(275));
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate) {
        [self.delegate collectionDidClick:[_dataArray objectAtIndex:indexPath.row]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
