//
//  GroupTableCell.m
//  mxedu
//
//  Created by 田晓鹏 on 16/8/29.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "GroupTableCell.h"

#import "SysCommon.h"
#import "UIColor+HexColor.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

@implementation GroupTableCell{
    UIImageView *_avatar;
    UILabel *_nameL;
    UILabel *_timeL;
    UILabel *_numberL;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _avatar = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 80)];
        _avatar.layer.masksToBounds = YES;
        _avatar.layer.cornerRadius = 40;
        [self addSubview:_avatar];
        
        _nameL = [[UILabel alloc] init];
        _nameL.font = LabelFont(30);
        _nameL.numberOfLines = 0;
        _nameL.lineBreakMode = NSLineBreakByWordWrapping;
        _nameL.textColor = [UIColor colorWhthHexString:@"#51545d"];
        [self addSubview:_nameL];
        
        [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatar.mas_right).offset(GENERAL_SIZE(20));
            make.top.equalTo(self).offset(GENERAL_SIZE(20));
            make.right.equalTo(self.mas_right).offset(-GENERAL_SIZE(120));
            make.height.equalTo(@(GENERAL_SIZE(80)));
        }];
        
        _timeL = [[UILabel alloc]init];
        _timeL.font = LabelFont(22);
        _timeL.textColor = [UIColor colorWhthHexString:@"#a4a6a9"];
        [self addSubview:_timeL];
        
        [_timeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatar.mas_right).offset(GENERAL_SIZE(20));
            make.top.equalTo(_nameL.mas_bottom).offset(GENERAL_SIZE(10));
        }];
        
    }
    return self;
}

-(void)setupCellWithModel:(Group*)group{
    if (group.avatar) {
        if ([group.avatar rangeOfString:@".jpg"].location == NSNotFound) {
            [_avatar sd_setImageWithURL:[NSURL URLWithString: [BASIC_IMAGE_URL stringByAppendingString:group.avatar]] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
        }else{
            [_avatar sd_setImageWithURL:[NSURL URLWithString: [@"http://api.olaxueyuan.com/upload/" stringByAppendingString:group.avatar]] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
        }
    }else{
        _avatar.image = [UIImage imageNamed:@"ic_avatar"];
    }
    _nameL.text = group.name;
    _timeL.text = group.time;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

