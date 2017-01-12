//
//  MessageTableCell.m
//  mxedu
//
//  Created by 田晓鹏 on 16/7/19.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "MessageTableCell.h"

#import "SysCommon.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation MessageTableCell{
    
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
        
        _avatarImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, GENERAL_SIZE(100), GENERAL_SIZE(100))];
        _avatarImage.layer.cornerRadius=GENERAL_SIZE(50);
        _avatarImage.layer.masksToBounds=YES;
        [self addSubview:_avatarImage];
        
        _nameLabel = [UILabel new];
        _nameLabel.textColor = RGBCOLOR(51, 51, 51);
        _nameLabel.font = LabelFont(32);
        [self addSubview:_nameLabel];
        
        _readLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, GENERAL_SIZE(12), GENERAL_SIZE(12))];
        _readLabel.layer.cornerRadius=GENERAL_SIZE(6);
        _readLabel.layer.masksToBounds=YES;
        _readLabel.backgroundColor = [UIColor redColor];
        [self addSubview:_readLabel];
        
        UIView *lineView1 = [[UIView alloc]init];
        lineView1.backgroundColor = RGBCOLOR(236, 236, 236);
        [self addSubview:lineView1];
        
        _orgLabel = [UILabel new];
        _orgLabel.textColor = RGBCOLOR(101, 101, 101);
        _orgLabel.font = LabelFont(30);
        [self addSubview:_orgLabel];
        
        _checkinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _checkinButton.titleLabel.font = LabelFont(32);
        [self addSubview:_checkinButton];
        
        [_readLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(15);
            make.right.equalTo(self.mas_right).offset(-15);
            make.width.equalTo(@(GENERAL_SIZE(12)));
            make.height.equalTo(@(GENERAL_SIZE(12)));
        }];
        
        [_avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self);
            make.width.equalTo(@(GENERAL_SIZE(100)));
            make.height.equalTo(@(GENERAL_SIZE(100)));
        }];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(15);
            make.left.equalTo(_avatarImage.mas_right).offset(10);
        }];
        
        [_orgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-15);
            make.left.equalTo(_avatarImage.mas_right).offset(10);
        }];
        
        [_checkinButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_avatarImage);
            make.right.equalTo(self).offset(-15);
        }];
        
    }
    return self;
    
}

-(void)setupCell:(Message*)message{
    _nameLabel.text = message.title;
    _orgLabel.text = message.content;
    if(message.imageUrl){
        if ([message.imageUrl rangeOfString:@".jpg"].location == NSNotFound) {
            [_avatarImage sd_setImageWithURL:[NSURL URLWithString: [BASIC_IMAGE_URL stringByAppendingString:message.imageUrl]] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
        }else{
            [_avatarImage sd_setImageWithURL:[NSURL URLWithString: [@"http://api.olaxueyuan.com/upload/" stringByAppendingString:message.imageUrl]] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
        }
    }else{
        _avatarImage.image = [UIImage imageNamed:@"ic_avatar"];
    }
    if (![message.status isEqualToString:@"1"]) {
        _readLabel.hidden = NO;
    }else{
        _readLabel.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
