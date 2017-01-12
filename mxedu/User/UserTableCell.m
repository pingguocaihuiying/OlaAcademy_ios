//
//  UserTableCell.m
//  mxedu
//
//  Created by 田晓鹏 on 16/9/13.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "UserTableCell.h"

#import "SysCommon.h"
#import "Masonry.h"

@implementation UserTableCell{
    UIView *_dividerView;
    UIImageView *_videoImage;
    UILabel *_nameLabel;
    UILabel *_descLabel;
    UIImageView *_redIV;
    UIImageView *_nextIV;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _dividerView = [[UIView alloc]init];
        _dividerView.backgroundColor = RGBCOLOR(235, 235, 235);
        [self addSubview:_dividerView];
        
        [_dividerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(SCREEN_WIDTH));
            make.height.equalTo(@1);
        }];
        
        _videoImage = [[UIImageView alloc]init];
        [self addSubview:_videoImage];
        
        [_videoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(GENERAL_SIZE(20));
            make.centerY.equalTo(self);
        }];
        
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = LabelFont(32);
        _nameLabel.textColor = RGBCOLOR(81, 83, 83);
        [self addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_videoImage.mas_right).offset(GENERAL_SIZE(20));
            make.centerY.equalTo(_videoImage);
        }];
        
        _nextIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_next"]];
        [self addSubview:_nextIV];
        
        [_nextIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-GENERAL_SIZE(20));
            make.centerY.equalTo(_videoImage);
        }];
        
        _descLabel = [[UILabel alloc]init];
        _descLabel.font = LabelFont(28);
        _descLabel.textColor = RGBCOLOR(151, 152, 158);
        [self addSubview:_descLabel];
        
        [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_nextIV.mas_left).offset(-GENERAL_SIZE(20));
            make.centerY.equalTo(_videoImage);
        }];
        
        _redIV = [[UIImageView alloc]init];
        _redIV.backgroundColor = [UIColor redColor];
        _redIV.layer.masksToBounds = YES;
        _redIV.layer.cornerRadius = GENERAL_SIZE(6);
        [self addSubview:_redIV];
        _redIV.hidden = YES;
        
        [_redIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_descLabel).offset(-GENERAL_SIZE(4));
            make.left.equalTo(_descLabel.mas_right);
            make.width.equalTo(@(GENERAL_SIZE(12)));
            make.height.equalTo(@(GENERAL_SIZE(12)));
        }];

    }
    return self;
}

-(void)setupCellWithModel:(UserCellModel*) model{
    if (model.isSection==1) {
        [_dividerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(SCREEN_WIDTH));
            make.height.equalTo(@(GENERAL_SIZE(20)));
        }];
        
        [_videoImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(GENERAL_SIZE(20));
            make.centerY.equalTo(self).offset(GENERAL_SIZE(10));
        }];
    }
    if(model.desc){
        _descLabel.text = model.desc;
    }
    if(model.type==2){
        [_descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-GENERAL_SIZE(20));
            make.centerY.equalTo(_videoImage);
        }];
        _nextIV.hidden = YES;
    }else{
        _nextIV.hidden = NO;
    }
    if(model.showRedTip ==1){
        _redIV.hidden = NO;
    }else{
        _redIV.hidden = YES;
    }
    _videoImage.image = [UIImage imageNamed:model.icon];
    [_videoImage sizeToFit];
    _nameLabel.text = model.title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
