//
//  MessageMainTableCell.m
//  mxedu
//
//  Created by 田晓鹏 on 16/12/21.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "MessageMainTableCell.h"

#import "SysCommon.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation MessageMainTableCell{
    
    UIImageView *_avatarImage;
    UILabel *_nameLabel;
    UILabel *_readLabel;
    UILabel *_orgLabel;
    
    UIButton *_checkinButton;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _avatarImage = [[UIImageView alloc]init];
        [self addSubview:_avatarImage];
        
        _nameLabel = [UILabel new];
        _nameLabel.textColor = RGBCOLOR(51, 51, 51);
        _nameLabel.font = LabelFont(28);
        [self addSubview:_nameLabel];
        
        _readLabel = [[UILabel alloc]init];
        _readLabel.layer.cornerRadius=GENERAL_SIZE(20);
        _readLabel.layer.masksToBounds=YES;
        _readLabel.textColor = [UIColor whiteColor];
        _readLabel.font = LabelFont(24);
        _readLabel.textAlignment = NSTextAlignmentCenter;
        _readLabel.backgroundColor = [UIColor redColor];
        [self addSubview:_readLabel];
        
        _orgLabel = [UILabel new];
        _orgLabel.numberOfLines = 0;
        _orgLabel.textColor = RGBCOLOR(101, 101, 101);
        _orgLabel.font = LabelFont(24);
        [self addSubview:_orgLabel];
        
        _checkinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _checkinButton.titleLabel.font = LabelFont(32);
        [self addSubview:_checkinButton];
        
        [_readLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_avatarImage.mas_top).offset(-GENERAL_SIZE(10));
            make.right.equalTo(_avatarImage.mas_right).offset(GENERAL_SIZE(10));
            make.width.equalTo(@(GENERAL_SIZE(40)));
            make.height.equalTo(@(GENERAL_SIZE(40)));
        }];
        
        [_avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self);
        }];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_avatarImage.mas_top).offset(1);
            make.left.equalTo(_avatarImage.mas_right).offset(10);
        }];
        
        [_orgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_avatarImage.mas_bottom).offset(-1);
            make.left.equalTo(_avatarImage.mas_right).offset(10);
        }];
        
        [_checkinButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_avatarImage);
            make.right.equalTo(self).offset(-15);
        }];
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = RGBCOLOR(235, 235, 235);
        [self addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
            make.left.equalTo(self).offset(GENERAL_SIZE(20));
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@(GENERAL_SIZE(2)));
        }];
        
    }
    return self;
    
}

-(void)setupCell:(MessageModel*)message{
    _nameLabel.text = message.title;
    _avatarImage.image = [UIImage imageNamed:message.image];
    _orgLabel.text = message.detail;
    if([message.count isEqualToString:@"0"]){
        _readLabel.hidden = YES;
    }else{
        _readLabel.hidden = NO;
        _readLabel.text = message.count;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
