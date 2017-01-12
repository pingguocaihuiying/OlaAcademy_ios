//
//  WorkStatisticsTableCell.m
//  mxedu
//
//  Created by 田晓鹏 on 16/10/17.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "WorkStatisticsTableCell.h"

#import "SysCommon.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@implementation WorkStatisticsTableCell{
    UIImageView *_avatar;
    UILabel *_nameL;
    UILabel *_finishL;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _avatar = [[UIImageView alloc]initWithFrame:CGRectMake(GENERAL_SIZE(20), GENERAL_SIZE(30), GENERAL_SIZE(80), GENERAL_SIZE(80))];
        [self addSubview:_avatar];
        
        _avatar.layer.masksToBounds = YES;
        _avatar.layer.cornerRadius = GENERAL_SIZE(40);
        
        _nameL = [[UILabel alloc] init];
        _nameL.font = LabelFont(30);
        _nameL.textColor = RGBCOLOR(39, 42, 54);
        [self addSubview:_nameL];
        
        [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatar.mas_right).offset(GENERAL_SIZE(20));
            make.centerY.equalTo(self);
        }];
        
        _finishL = [[UILabel alloc] init];
        _finishL.font = LabelFont(30);
        _finishL.textColor = RGBCOLOR(39, 42, 54);
        [self addSubview:_finishL];
        
        [_finishL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-GENERAL_SIZE(20));
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

-(void)setupCellWithModel:(StatisticsUser*)user{
    if (user.userAvatar) {
        if ([user.userAvatar rangeOfString:@".jpg"].location == NSNotFound) {
            [_avatar sd_setImageWithURL:[NSURL URLWithString: [BASIC_IMAGE_URL stringByAppendingString:user.userAvatar]] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
        }else{
            [_avatar sd_setImageWithURL:[NSURL URLWithString: [@"http://api.olaxueyuan.com/upload/" stringByAppendingString:user.userAvatar]] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
        }
    }else{
        _avatar.image = [UIImage imageNamed:@"ic_avatar"];
    }
    if (user.location&&![user.location isEqualToString:@""]) {
        _nameL.text = [NSString stringWithFormat:@"%@@%@",user.userName,user.location];
    }else{
         _nameL.text = user.userName;
    }
    _finishL.text = [NSString stringWithFormat:@"%@％",user.finished];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
