//
//  UserPostTableCell.m
//  mxedu
//
//  Created by 田晓鹏 on 2016/12/27.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "UserPostTableCell.h"

#import "SysCommon.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "Comment.h"
#import "CirclePraise.h"

@implementation UserPostTableCell{
    
    UILabel *_nameLabel;
    UILabel *_orgLabel;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _nameLabel = [UILabel new];
        _nameLabel.textColor = RGBCOLOR(164, 166, 170);
        _nameLabel.font = LabelFont(24);
        [self addSubview:_nameLabel];
        
        _orgLabel = [UILabel new];
        _orgLabel.numberOfLines = 1;
        _orgLabel.textColor = RGBCOLOR(39, 43, 54);
        _orgLabel.font = LabelFont(28);
        [self addSubview:_orgLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(GENERAL_SIZE(20));
            make.left.equalTo(self).offset(10);
        }];
        
        [_orgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-GENERAL_SIZE(20));
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
        }];
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = RGBCOLOR(235, 235, 235);
        [self addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
            make.left.equalTo(self);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@(GENERAL_SIZE(2)));
        }];
        
    }
    return self;
    
}

-(void)setupCell:(OlaCircle*)circle Type:(NSInteger)type{
    if (type==0) {
        _nameLabel.text = [NSString stringWithFormat:@"%@ 发表了问答",circle.userName];
    }else{
        _nameLabel.text = [NSString stringWithFormat:@"%@ 回复了问答",circle.userName];
    }
    _orgLabel.text = circle.title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
