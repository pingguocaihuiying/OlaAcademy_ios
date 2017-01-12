//
//  MaterialTableCell.m
//  mxedu
//
//  Created by 田晓鹏 on 16/10/29.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "MaterialTableCell.h"

#import "SysCommon.h"
#import "Masonry.h"
#import "UIImageView+AsyncDownload.h"

@implementation MaterialTableCell{
    UIImageView *_videoImage;
    UILabel *_nameLabel;
    UILabel *_buyerLabel;
    UILabel *_orgLabel;
    UILabel *_priceLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH-20, 20)];
        _nameLabel.textColor = RGBCOLOR(50, 50, 50);
        _nameLabel.font = LabelFont(32);
        [self addSubview:_nameLabel];
        
        _buyerLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 35, 200, 20)];
        _buyerLabel.textColor = RGBCOLOR(144, 144, 144);
        _buyerLabel.font = LabelFont(24);
        [self addSubview:_buyerLabel];
        
        UIImageView *lineImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 60, SCREEN_WIDTH-30, 1)];
        lineImage.backgroundColor = BACKGROUNDCOLOR;
        [self addSubview:lineImage];
        
        _videoImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 75, 30, 30)];
        _videoImage.layer.cornerRadius=15;
        _videoImage.layer.masksToBounds=YES;
        [self addSubview:_videoImage];
        
        _orgLabel = [[UILabel alloc]init];
        _orgLabel.font = LabelFont(24);
        _orgLabel.textColor = RGBCOLOR(101, 101, 101);
        [self addSubview:_orgLabel];
        
        [_orgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_videoImage);
            make.left.equalTo(_videoImage.mas_right).offset(10);
        }];
        
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.font = LabelFont(28);
        _priceLabel.textColor = RGBCOLOR(255, 108, 0);
        [self addSubview:_priceLabel];
        
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_videoImage);
            make.right.equalTo(self.mas_right).offset(-20);
        }];
        
        
        UIImageView *dividerImage = [[UIImageView alloc]init];
        dividerImage.backgroundColor = BACKGROUNDCOLOR;
        [self addSubview:dividerImage];
        
        [dividerImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_videoImage.mas_bottom).offset(10);
            make.width.equalTo(@(SCREEN_WIDTH));
            make.height.equalTo(@5);
        }];
    }
    return self;
}

-(void)setupCellWithModel:(Material*) material{
    [_videoImage setImageWithURL:[NSURL URLWithString: material.pic] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
    _nameLabel.text = material.title;
    _buyerLabel.text = [NSString stringWithFormat:@"文件大小 %@， 浏览量 %@",material.size,material.count];
    _orgLabel.text = [NSString stringWithFormat:@"由%@提供",material.provider];
    if([material.price isEqualToString:@"0"]){
        _priceLabel.text = @"免费";
    }else if([material.status isEqualToString:@"1"]){
        _priceLabel.text = @"已兑换";
    }else{
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@币",material.price]];
        [str addAttribute:NSFontAttributeName
                    value:LabelFont(32)
                    range:NSMakeRange(0,material.price.length)];
        [str addAttribute:NSFontAttributeName
                    value:LabelFont(20)
                    range:NSMakeRange(str.length-1, 1)];
        _priceLabel.attributedText = str;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end


