//
//  teacherCertifyCell.m
//  mxedu
//
//  Created by zhufeng on 2017/1/11.
//  Copyright © 2017年 田晓鹏. All rights reserved.
//

#import "teacherCertifyCell.h"
#import "SysCommon.h"
#import "Masonry.h"

@implementation teacherCertifyCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupSubViews];
    }
    
    return self;
}
-(void)setupSubViews {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = LabelFont(34);
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(GENERAL_SIZE(25));
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(GENERAL_SIZE(160));
    }];
    _valueText = [[UITextField alloc] init];
    _valueText.font = LabelFont(34);
    _valueText.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_valueText];
    
    [_valueText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-GENERAL_SIZE(20));
        make.left.equalTo(_titleLabel.mas_right).offset(GENERAL_SIZE(10));
        make.centerY.equalTo(self.mas_centerY);
    }];
    _slideView = [[UIView alloc] init];
    _slideView.backgroundColor = RGBCOLOR(235, 235, 235);
    [self.contentView addSubview:_slideView];
    
    [_slideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@1);
    }];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
