//
//  CollectionTableCell.m
//  mxedu
//
//  Created by 田晓鹏 on 16/5/4.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "CollectionTableCell.h"

#import "SysCommon.h"

#import "UIImageView+AsyncDownload.h"

@implementation CollectionTableCell{
    UIImageView *_videoImage;
    UILabel *_nameLabel;
    UILabel *_timeLabel;
}

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _videoImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 55)];
        [self addSubview:_videoImage];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 15, 200, 20)];
        _nameLabel.textColor = RGBCOLOR(51, 51, 51);
        [self addSubview:_nameLabel];
        
        UIImageView *clockIV = [[UIImageView alloc]initWithFrame:CGRectMake(100, 47, 16, 16)];
        clockIV.image = [UIImage imageNamed:@"recents"];
        [self addSubview:clockIV];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 45, 200, 20)];
        _timeLabel.font = LabelFont(32);
        _timeLabel.textColor = RGBCOLOR(105, 105, 105);
        [self addSubview:_timeLabel];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_timeLabel.frame)+10, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = RGBCOLOR(240, 240, 240);
        [self addSubview:lineView];
    }
    return self;
}

-(void)setupCellWithModel:(CollectionVideo*) model{
    [_videoImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", model.coursePic]] placeholderImage:[UIImage imageNamed:@"ic_video"]];
    _nameLabel.text = model.videoName;
    _timeLabel.text = [NSString stringWithFormat:@"%@学时，%@",model.subAllNum, model.totalTime];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
