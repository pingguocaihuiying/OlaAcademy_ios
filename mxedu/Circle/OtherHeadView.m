//
//  OtherHeadView.m
//  mxedu
//
//  Created by 田晓鹏 on 16/9/23.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "OtherHeadView.h"

#import "SysCommon.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface OtherHeadView ()
{
    UIImageView *_avatarImageview;
    UILabel *_nameLabel;
    UILabel *_profileLabel;
}

@end

@implementation OtherHeadView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _avatarImageview = [[UIImageView alloc]init];
        _avatarImageview.image = [UIImage imageNamed:@"ic_avatar"];
        _avatarImageview.layer.masksToBounds = YES;
        _avatarImageview.layer.cornerRadius = GENERAL_SIZE(75);
        _avatarImageview.layer.borderColor = [[UIColor whiteColor]CGColor];
        _avatarImageview.layer.borderWidth = 1.0;
        [self addSubview:_avatarImageview];
        
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = LabelFont(32);
        _nameLabel.textColor = RGBCOLOR(81, 83, 93);
        [self addSubview:_nameLabel];
        
        _profileLabel = [[UILabel alloc]init];
        _profileLabel.textColor = RGBCOLOR(160, 161, 163);
        _profileLabel.font = LabelFont(24);
        _profileLabel.textAlignment = NSTextAlignmentCenter;
        _profileLabel.numberOfLines = 2;
        [self addSubview:_profileLabel];
        
        [_avatarImageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(-GENERAL_SIZE(40));
            make.centerX.equalTo(self);
            make.width.equalTo(@(GENERAL_SIZE(150)));
            make.height.equalTo(@(GENERAL_SIZE(150)));
        }];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_avatarImageview.mas_bottom).offset(GENERAL_SIZE(20));
            make.centerX.equalTo(self);
        }];
        
        [_profileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(GENERAL_SIZE(30));
            make.right.equalTo(self.mas_right).offset(-GENERAL_SIZE(30));
            make.top.equalTo(_nameLabel.mas_bottom).offset(GENERAL_SIZE(20));
            make.centerX.equalTo(self);
        }];
        
    }
    return self;
    
    
}

- (void)updateWithUser:(User*)user
{
    if (user) {
        if(user.avatar){
            if ([user.avatar rangeOfString:@".jpg"].location == NSNotFound) {
                [_avatarImageview sd_setImageWithURL:[NSURL URLWithString: [BASIC_IMAGE_URL stringByAppendingString:user.avatar]] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
            }else{
                [_avatarImageview sd_setImageWithURL:[NSURL URLWithString: [@"http://api.olaxueyuan.com/upload/" stringByAppendingString:user.avatar]] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
            }
        }else{
            _avatarImageview.image = [UIImage imageNamed:@"ic_avatar"];
        }
        _nameLabel.text = user.name;
        _profileLabel.text  = user.signature;
    }else{
        _avatarImageview.image = [UIImage imageNamed:@"ic_avatar"];
        _nameLabel.text = @"小欧";
    }
}

@end
