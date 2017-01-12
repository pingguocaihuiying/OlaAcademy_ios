//
//  GroupTableCell.m
//  mxedu
//
//  Created by 田晓鹏 on 16/8/29.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "StuGroupTableCell.h"

#import "SysCommon.h"
#import "UIColor+HexColor.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

@implementation StuGroupTableCell{
    UIImageView *_avatar;
    UILabel *_nameL;
    UIView *_numberV;
    UILabel *_numberL;
    UILabel *_profileL;
    UILabel *attend;
    
    NSInteger _rownIndex;
    NSString *_type;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _avatar = [[UIImageView alloc]initWithFrame:CGRectMake(GENERAL_SIZE(20), GENERAL_SIZE(25), GENERAL_SIZE(140), GENERAL_SIZE(140))];
        _avatar.layer.masksToBounds = YES;
        _avatar.layer.cornerRadius = GENERAL_SIZE(70);
        [self addSubview:_avatar];
        
        _nameL = [[UILabel alloc] init];
        _nameL.font = LabelFont(30);
        _nameL.numberOfLines = 0;
        _nameL.lineBreakMode = NSLineBreakByWordWrapping;
        _nameL.textColor = [UIColor colorWhthHexString:@"#51545d"];
        [self addSubview:_nameL];
        
        [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatar.mas_right).offset(GENERAL_SIZE(20));
            make.top.equalTo(self).offset(GENERAL_SIZE(30));
        }];
        
        _numberV = [[UIView alloc]init];
        _numberV.layer.masksToBounds = YES;
        _numberV.layer.cornerRadius = 2;
        _numberV.backgroundColor = COMMONBLUECOLOR;
        [self addSubview:_numberV];
        
        UIImageView *numberIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_groupnumber"]];
        [self addSubview:numberIV];
        
        [numberIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nameL.mas_bottom).offset(GENERAL_SIZE(18));
            make.left.equalTo(_avatar.mas_right).offset(GENERAL_SIZE(30));
        }];
        
        _numberL = [[UILabel alloc]init];
        _numberL.font = LabelFont(22);
        _numberL.textColor = [UIColor whiteColor];
        [self addSubview:_numberL];
        
        [_numberL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(numberIV.mas_right).offset(GENERAL_SIZE(10));
            make.centerY.equalTo(numberIV);
        }];

        [_numberV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(numberIV.mas_top).offset(-GENERAL_SIZE(8));
            make.bottom.equalTo(numberIV.mas_bottom).offset(GENERAL_SIZE(8));
            make.left.equalTo(_avatar.mas_right).offset(GENERAL_SIZE(20));
            make.right.equalTo(_numberL.mas_right).offset(GENERAL_SIZE(10));
        }];
        
        _profileL = [[UILabel alloc]init];
        _profileL.font = LabelFont(22);
        _profileL.textColor = RGBCOLOR(164, 166, 169);
        _profileL.numberOfLines = 2;
        [self addSubview:_profileL];
        
        attend = [[UILabel alloc]init];
        attend.clipsToBounds = YES;
        attend.layer.cornerRadius = 5;
        attend.layer.borderWidth = 1.0;
        attend.layer.borderColor = [COMMONBLUECOLOR CGColor];
        attend.textColor = COMMONBLUECOLOR;
        attend.text = @"关注";
        attend.font = LabelFont(24);
        attend.textAlignment = NSTextAlignmentCenter;
        [self addSubview:attend];
        
        [attend mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_avatar);
            make.right.equalTo(self.mas_right).offset(-GENERAL_SIZE(20));
            make.width.equalTo(@(GENERAL_SIZE(120)));
            make.height.equalTo(@(GENERAL_SIZE(50)));
        }];
        
        [_profileL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatar.mas_right).offset(GENERAL_SIZE(20));
            make.top.equalTo(_numberL.mas_bottom).offset(GENERAL_SIZE(10));
            make.right.equalTo(attend.mas_left).offset(-GENERAL_SIZE(20));
        }];
        
    }
    return self;
}

-(void)setupCellWithModel:(Group*)group RowIndex:(NSInteger)rowIndex{
    
    //1,头像
    if(group.avatar){
        [_avatar sd_setImageWithURL:[NSURL URLWithString: [BASIC_IMAGE_URL stringByAppendingString:group.avatar]] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
    }else{
        _avatar.image = [UIImage imageNamed:@"ic_avatar"];
    }
    _nameL.text = group.name;
    _numberL.text = [NSString stringWithFormat:@"%@人",group.number];
    _profileL.text = group.profile;
    if ([group.isMember isEqualToString:@"1"]) {
        attend.text = @"取消";
        _type = @"2";
    }else{
        attend.text = @"关注";
        _type = @"1";
    }
    
    _rownIndex = rowIndex;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickAttend)];
    attend.userInteractionEnabled = YES;
    [attend addGestureRecognizer:tap];
}

-(void)didClickAttend{
    if (_delelgate){
        [_delelgate clickAttendWithRowIndex:_rownIndex Type:_type];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

