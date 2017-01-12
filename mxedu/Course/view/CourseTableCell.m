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
#import "UIColor+HexColor.h"
#import "Masonry.h"

#import "CourseCollectionView.h"

@implementation CourseTableCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *hLine = [[UIView alloc]initWithFrame:CGRectMake(10, GENERAL_SIZE(27), 2, GENERAL_SIZE(30))];
        hLine.backgroundColor = COMMONBLUECOLOR;
        [self addSubview:hLine];

        _nameL = [[UILabel alloc] initWithFrame:CGRectMake(17, GENERAL_SIZE(20), 200, GENERAL_SIZE(40))];
        _nameL.font =[UIFont boldSystemFontOfSize:GENERAL_SIZE(34)];
        _nameL.textColor = [UIColor colorWhthHexString:@"#272b36"];
        _nameL.contentMode = UIViewContentModeTop;
        [self addSubview:_nameL];
        
        
        UILabel *moreL = [[UILabel alloc]init];
        moreL.text = @"显示全部";
        moreL.textColor = [UIColor colorWhthHexString:@"#a8aaad"];
        moreL.font = LabelFont(24);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showMore)];
        moreL.userInteractionEnabled = YES;
        [moreL addGestureRecognizer:tap];
        [self addSubview:moreL];
        
        [moreL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_nameL);
            make.right.equalTo(self).offset(-10);
        }];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, GENERAL_SIZE(80), SCREEN_WIDTH-20, 1)];
        lineView.backgroundColor = RGBCOLOR(230, 230, 230);
        [self addSubview:lineView];
        
        //确定是水平滚动，还是垂直滚动
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, GENERAL_SIZE(100), SCREEN_WIDTH, GENERAL_SIZE(275))collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = NO;
        _collectionView.allowsSelection = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [_collectionView registerClass:[CourseCollectionView class] forCellWithReuseIdentifier:@"colletionCell"];
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_collectionView];
        _line = [[UIImageView alloc]initWithFrame:CGRectMake(0, GENERAL_SIZE(375), SCREEN_WIDTH, GENERAL_SIZE(20))];
        _line.backgroundColor = RGBCOLOR(230, 230, 230);
        [self addSubview:_line];
        
        

    }
    return self;

}

-(void) setCellWithModel:(Course*)course{
    _course = course;
    _nameL.text = course.name;
    [_collectionView reloadData];
}

-(void)showMore{
    if (_tableCellDelegate) {
        [_tableCellDelegate didClickMore:_course];
    }
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_course.subList count]<=2?[_course.subList count]:2;  //最多显示两条
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
        [self.delegate collectionDidClick:[_course.subList objectAtIndex:indexPath.row]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
