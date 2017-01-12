//
//  CourseTableCell.m
//  mxedu
//
//  Created by 田晓鹏 on 15/10/19.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import "CourseTableCell.h"

#import "SysCommon.h"
#import "UIImageView+WebCache.h"

#import "CourseCollectionView.h"

@implementation CourseTableCell


- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        _nameL = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
        _nameL.font = [UIFont systemFontOfSize:16.0];
        //nameL.textColor = RGBCOLOR(01, 139, 232);
        _nameL.contentMode = UIViewContentModeTop;
        [self addSubview:_nameL];
        
        //确定是水平滚动，还是垂直滚动
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        if (iPhone6Plus) {
            _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 120)collectionViewLayout:flowLayout];
        }else if (iPhone6) {
            _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 110)collectionViewLayout:flowLayout];
        }else{
            _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 90)collectionViewLayout:flowLayout];
        }
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = NO;
        _collectionView.allowsSelection = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [_collectionView registerClass:[CourseCollectionView class] forCellWithReuseIdentifier:@"colletionCell"];
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_collectionView];
        
        if (iPhone6Plus) {
            _line = [[UIImageView alloc]initWithFrame:CGRectMake(10, 178, SCREEN_WIDTH-10, 1)];
        }else if (iPhone6) {
            _line = [[UIImageView alloc]initWithFrame:CGRectMake(10, 168, SCREEN_WIDTH-10, 1)];
        }else{
            _line = [[UIImageView alloc]initWithFrame:CGRectMake(10, 148, SCREEN_WIDTH-10, 1)];
        }
        _line.backgroundColor = RGBCOLOR(225, 225, 225);
        [self addSubview:_line];

    }
    return self;

}

-(void) setCellWithModel:(Course*)course{
    _course = course;
    _nameL.text = course.name;
    [_collectionView reloadData];
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_course.subList count];
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"colletionCell";
    CourseCollectionView * cell = (CourseCollectionView*)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    Course *course = [_course.subList objectAtIndex:indexPath.row];
    NSString *imageUrl = course.address;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
    cell.nameLabel.text = course.name;
    cell.timeLabel.text = course.totalTime;
    cell.visitLabel.text = [NSString stringWithFormat:@"%@观看",course.playcount];
    
    return cell;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (iPhone6Plus) {
        return CGSizeMake(128, 130);
    }else if(iPhone6){
        return CGSizeMake(128, 120);
    }
    return CGSizeMake(110, 110);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 10, 5, 0);
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate) {
        [self.delegate collectionDidClick:[_course.subList objectAtIndex:indexPath.row]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
