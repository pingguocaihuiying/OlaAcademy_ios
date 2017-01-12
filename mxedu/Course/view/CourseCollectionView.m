//
//  CourseCollectionView.m
//  mxedu
//
//  Created by 田晓鹏 on 15/11/4.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import "CourseCollectionView.h"

#import "SysCommon.h"
#import "Masonry.h"

@implementation CourseCollectionView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc]init];
        if (iPhone6Plus) {
            _imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH/3-10, 80);
        }else if(iPhone6){
            _imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH/3-10, 70);
        }else{
            _imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH/3-10, 60);
        }
        [self addSubview:_imageView];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.imageView.frame)+5, SCREEN_WIDTH/3-10, 20)];
        _nameLabel.font = LabelFont(28);
        _nameLabel.textColor = RGBACOLOR(33, 33, 33, 200);
        [self addSubview:_nameLabel];
        
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = LabelFont(24);
        _timeLabel.textColor = RGBCOLOR(128, 128, 128);
        [self addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nameLabel.mas_bottom).offset(5);
            make.left.equalTo(_imageView.mas_left);
        }];
        
        _visitLabel = [[UILabel alloc]init];
        _visitLabel.font = LabelFont(24);
        _visitLabel.textColor = RGBCOLOR(128, 128, 128);
        [self addSubview:_visitLabel];
        
        [_visitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nameLabel.mas_bottom).offset(5);
            make.right.equalTo(_imageView.mas_right);
        }];
        
        
        
    }
    return self;
}

@end
