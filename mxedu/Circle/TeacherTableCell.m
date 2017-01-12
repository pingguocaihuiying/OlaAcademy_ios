//
//  TeacherTableCell.m
//  mxedu
//
//  Created by 田晓鹏 on 16/12/9.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "TeacherTableCell.h"

#import "SysCommon.h"
#import "UIColor+HexColor.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

@implementation TeacherTableCell{
    UIImageView *_avatar;
    UILabel *_nameL;
    UILabel *_timeL;
    UILabel *_numberL;
    UIButton *_inviteBtn;
    
    User *chosenUser;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _avatar = [[UIImageView alloc]initWithFrame:CGRectMake(10, GENERAL_SIZE(20), GENERAL_SIZE(80), GENERAL_SIZE(80))];
        _avatar.layer.masksToBounds = YES;
        _avatar.layer.cornerRadius = GENERAL_SIZE(40);
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
        
        _inviteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _inviteBtn.backgroundColor = COMMONBLUECOLOR;
        _inviteBtn.layer.cornerRadius = 5.0f;
        [_inviteBtn setTitle:@"邀请" forState:UIControlStateNormal];
        _inviteBtn.titleLabel.font = LabelFont(24);
        [_inviteBtn addTarget:self action:@selector(inviteUser) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_inviteBtn];
        
        [_inviteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.width.equalTo(@(GENERAL_SIZE(120)));
            make.right.equalTo(self.mas_right).offset(-GENERAL_SIZE(30));
        }];
    }
    return self;
}

-(void)setupCellWithModel:(User*)user{
    chosenUser = user;
    if (user.avatar) {
        if ([user.avatar rangeOfString:@".jpg"].location == NSNotFound) {
            [_avatar sd_setImageWithURL:[NSURL URLWithString: [BASIC_IMAGE_URL stringByAppendingString:user.avatar]] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
        }else{
            [_avatar sd_setImageWithURL:[NSURL URLWithString: [@"http://api.olaxueyuan.com/upload/" stringByAppendingString:user.avatar]] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
        }
    }else{
        _avatar.image = [UIImage imageNamed:@"ic_avatar"];
    }
    _nameL.text = user.name;
}

-(void)inviteUser{
    if (_delegate) {
        [_delegate didClickInvite:chosenUser];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
