//
//  HomeCollectionCell.m
//  mxedu
//
//  Created by 田晓鹏 on 16/8/15.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "HomeCollectionCell.h"

#import "SysCommon.h"
#import "Masonry.h"

@implementation HomeCollectionCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc]init];
        _imageView.frame = CGRectMake(10, 0, SCREEN_WIDTH/2-15, GENERAL_SIZE(170));
        [self addSubview:_imageView];
        
        _markLabel = [[UILabel alloc]init];
        _markLabel.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
        _markLabel.textColor = [UIColor whiteColor];
        _markLabel.font = LabelFont(20);
        _markLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_markLabel];
        
        [_markLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_imageView);
            make.right.equalTo(_imageView);
            make.width.equalTo(@(GENERAL_SIZE(60)));
            make.height.equalTo(@(GENERAL_SIZE(30)));
        }];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(self.imageView.frame)+5, SCREEN_WIDTH/2-15, 20)];
        _nameLabel.font = LabelFont(28);
        _nameLabel.textColor = RGBACOLOR(33, 33, 33, 200);
        [self addSubview:_nameLabel];
        
        UIImageView *timeImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_time"]];
        [self addSubview:timeImage];
        
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = LabelFont(24);
        _timeLabel.textColor = RGBCOLOR(128, 128, 128);
        [self addSubview:_timeLabel];
        
        [timeImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_timeLabel);
            make.left.equalTo(_imageView.mas_left);
        }];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nameLabel.mas_bottom).offset(5);
            make.left.equalTo(timeImage.mas_right).offset(3);
        }];
        
        UIImageView *visitImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_browse"]];
        [self addSubview:visitImage];
        
        _visitLabel = [[UILabel alloc]init];
        _visitLabel.font = LabelFont(24);
        _visitLabel.textColor = RGBCOLOR(128, 128, 128);
        [self addSubview:_visitLabel];
        CGFloat imageW = GENERAL_SIZE(45);
        CGFloat imageX = (_imageView.width - imageW) / 2.0;
        CGFloat imageY = (_imageView.height - imageW) / 2.0;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageW)];
        imageView.image = [UIImage imageNamed:@"media_record"];
        [_imageView addSubview:imageView];
        
        [_visitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nameLabel.mas_bottom).offset(5);
            make.left.equalTo(visitImage.mas_right).offset(3);
        }];
        
        [visitImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_visitLabel);
            make.left.equalTo(_timeLabel.mas_right).offset(15);
        }];
        
    }
    return self;
}

@end

