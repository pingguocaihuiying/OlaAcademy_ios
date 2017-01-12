//
//  MemberTableCell.m
//  mxedu
//
//  Created by 田晓鹏 on 16/11/4.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "MemberTableCell.h"

#import "SysCommon.h"
#import "UIColor+HexColor.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import "MyLable.h"

@interface MemberTableCell ()

//头像
@property (nonatomic,strong) UIImageView *avatar;
//标题
@property (nonatomic,strong) MyLable *nameL;
//订阅量
@property (nonatomic,strong) MyLable *examtype;
//自我介绍
@property (nonatomic,strong) MyLable *indroLabel;
//订阅按钮
@property (nonatomic,strong) UIButton *subscribeButton;

@end

@implementation MemberTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createdSubViews];
        
    }
    return self;
}
//创建子控件
-(void)createdSubViews {
    //头像
    _avatar = [UIImageView new];
    _avatar = [[UIImageView alloc]init];//WithFrame:CGRectMake(10, GENERAL_SIZE(20), GENERAL_SIZE(140), GENERAL_SIZE(140))];
    _avatar.layer.masksToBounds = YES;
    _avatar.layer.cornerRadius = GENERAL_SIZE(75);
    [self addSubview:_avatar];
    [_avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(GENERAL_SIZE(20));
        make.width.height.mas_equalTo(GENERAL_SIZE(150));
    }];

    //标题
    _nameL = [[MyLable alloc] init];
    _nameL.font = LabelFont(30);
    _nameL.numberOfLines = 0;
    _nameL.lineBreakMode = NSLineBreakByWordWrapping;
    _nameL.textColor = [UIColor colorWhthHexString:@"#51545d"];
    [self.contentView addSubview:_nameL];
    
    [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatar.mas_right).offset(GENERAL_SIZE(20));
        make.top.equalTo(self).offset(GENERAL_SIZE(10));
        make.right.equalTo(self.mas_right).offset(-GENERAL_SIZE(120));
        make.height.equalTo(@(GENERAL_SIZE(60)));
    }];
    
    //职业
    _examtype = [MyLable new];
    _examtype.font = LabelFont(28);
    _examtype.textColor = [UIColor colorWhthHexString:@"#CFCFCF"];
    _examtype.verticalAlignment = VerticalAlignmentTop;
    [self.contentView addSubview:_examtype];
    [_examtype mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatar.mas_right).offset(GENERAL_SIZE(20));
        make.top.equalTo(_nameL.mas_bottom).offset(GENERAL_SIZE(5));
    }];
    //自我介绍
    _indroLabel = [MyLable new];
    _indroLabel.font = LabelFont(24);
    _indroLabel.numberOfLines = 0;
    _indroLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _indroLabel.textColor = [UIColor colorWhthHexString:@"#CFCFCF"];
    _indroLabel.verticalAlignment = VerticalAlignmentTop;
    [self.contentView addSubview:_indroLabel];
    [_indroLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatar.mas_right).offset(GENERAL_SIZE(20));
        make.right.equalTo(self.mas_right).offset(-GENERAL_SIZE(150));
        make.top.equalTo(_examtype.mas_bottom).offset(GENERAL_SIZE(10));
    }];
    //关注按钮
    _subscribeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_subscribeButton setTitle:@"+ 关注" forState:UIControlStateNormal];
    _subscribeButton.layer.borderWidth = 1;
    _subscribeButton.layer.cornerRadius = 6;
    _subscribeButton.layer.masksToBounds = YES;
    _subscribeButton.layer.borderColor = [UIColor colorWithRed:149/255.0 green:184/255.0 blue:208/255.0 alpha:1].CGColor;
    [_subscribeButton setTitleColor:[UIColor colorWithRed:149/255.0 green:184/255.0 blue:208/255.0 alpha:1] forState:UIControlStateNormal];
    [self.contentView addSubview:_subscribeButton];
    
    [_subscribeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-GENERAL_SIZE(20));
        make.centerY.equalTo(self.mas_centerY).offset(GENERAL_SIZE(0));
        make.width.mas_equalTo(GENERAL_SIZE(120));
    }];
    
}
-(void)setupCellWithModel:(User*)user{
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
    _examtype.text = user.examType;
    _indroLabel.text = user.signature;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
