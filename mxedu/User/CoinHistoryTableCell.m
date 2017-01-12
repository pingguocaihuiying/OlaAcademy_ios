//
//  CoinHistoryTableCell.m
//  mxedu
//
//  Created by 田晓鹏 on 16/10/20.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "CoinHistoryTableCell.h"

#import "SysCommon.h"
#import "Masonry.h"

@implementation CoinHistoryTableCell{
    UILabel *_nameLabel;
    UILabel *_timeLabel;
    UILabel *_descLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = LabelFont(28);
        _nameLabel.textColor = RGBCOLOR(102, 102, 102);
        [self addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(GENERAL_SIZE(30));
            make.top.equalTo(self).offset(GENERAL_SIZE(30));
        }];
        
        
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = LabelFont(24);
        _timeLabel.textColor = RGBCOLOR(208, 208, 208);
        [self addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(GENERAL_SIZE(30));
            make.top.equalTo(_nameLabel.mas_bottom).offset(GENERAL_SIZE(20));
        }];
        
        
        _descLabel = [[UILabel alloc]init];
        _descLabel.font = LabelFont(36);
        _descLabel.textColor = COMMONBLUECOLOR;
        [self addSubview:_descLabel];
        
        [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-GENERAL_SIZE(30));
            make.centerY.equalTo(self);
        }];
        
        UIView *dividerView = [[UIView alloc]init];
        dividerView.backgroundColor = RGBCOLOR(235, 235, 235);
        [self addSubview:dividerView];
        
        [dividerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(SCREEN_WIDTH));
            make.height.equalTo(@1);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
    }
    return self;
}

-(void)setupCellWithModel:(CoinHistory*) model{
    _nameLabel.text = model.name;
    _timeLabel.text = model.date;
    if (model.dealNum&&[model.dealNum intValue]>0) {
        _descLabel.text = [NSString stringWithFormat:@"+%@",model.dealNum];
        _descLabel.textColor = COMMONBLUECOLOR;
    }else{
        _descLabel.text = model.dealNum;
        _descLabel.textColor = [UIColor redColor];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
