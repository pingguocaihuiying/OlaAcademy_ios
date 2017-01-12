//
//  OrganizationTableCell.m
//  mxedu
//
//  Created by 田晓鹏 on 15/10/19.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import "OrganizationTableCell.h"

#import "SysCommon.h"
#import "Masonry.h"
#import "AuthManager.h"
#import "OrganizationManager.h"

#import "UIImageView+WebCache.h"

@implementation OrganizationTableCell{
    
    UIImageView *_avatarImage;
    UILabel *_nameLabel;
    UILabel *_countLabel;
    UILabel *_orgLabel;
    
    UIButton *_checkinButton;
    
    Organization *_organiztion;
}

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _nameLabel = [UILabel new];
        _nameLabel.textColor = RGBCOLOR(51, 51, 51);
        _nameLabel.font = LabelFont(32);
        [self addSubview:_nameLabel];
        
        _countLabel = [UILabel new];
        _countLabel.textColor = RGBCOLOR(144, 144, 144);
        _countLabel.font = LabelFont(24);
        [self addSubview:_countLabel];
        
        UIView *lineView1 = [[UIView alloc]init];
        lineView1.backgroundColor = RGBCOLOR(236, 236, 236);
        [self addSubview:lineView1];
        
        _avatarImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, GENERAL_SIZE(60), GENERAL_SIZE(60))];
        _avatarImage.layer.cornerRadius=GENERAL_SIZE(30);
        _avatarImage.layer.masksToBounds=YES;
        [self addSubview:_avatarImage];
        
        _orgLabel = [UILabel new];
        _orgLabel.textColor = RGBCOLOR(101, 101, 101);
        _orgLabel.font = LabelFont(24);
        [self addSubview:_orgLabel];
        
        _checkinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _checkinButton.titleLabel.font = LabelFont(32);
        [self addSubview:_checkinButton];
        
        UIView *divideView = [[UIView alloc]init];
        divideView.backgroundColor = RGBCOLOR(240, 240, 240);
        [self addSubview:divideView];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(20);
            make.left.equalTo(self).offset(15);
        }];
        
        [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nameLabel.mas_bottom).offset(10);
            make.left.equalTo(self).offset(15);
        }];
        
        [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_countLabel.mas_bottom).offset(6);
            make.height.equalTo(@1);
            make.left.equalTo(self).offset(15);
            make.right.equalTo(self);
        }];
        
        [_avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineView1.mas_bottom).offset(15);
            make.left.equalTo(self.mas_left).offset(15);
            make.width.equalTo(@(GENERAL_SIZE(60)));
            make.height.equalTo(@(GENERAL_SIZE(60)));
        }];

        [_orgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_avatarImage);
            make.left.equalTo(_avatarImage.mas_right).offset(5);
        }];
        
        [_checkinButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_avatarImage);
            make.right.equalTo(self).offset(-15);
        }];
        
        [divideView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_avatarImage.mas_bottom).offset(15);
            make.width.equalTo(@(SCREEN_WIDTH));
            make.height.equalTo(@5);
        }];
        
    }
    return self;
    
}

-(void)setCellWithModel:(Organization*)org Path:(NSIndexPath*)indexPath{
    _indexPath = indexPath;
    _organiztion = org;
    
    [_avatarImage sd_setImageWithURL:[NSURL URLWithString:org.logo] placeholderImage:nil];
    _nameLabel.text = org.name;
    _countLabel.text = [NSString stringWithFormat:@"已有%@人报名",org.checkinCount];
    _orgLabel.text = org.org;
    if ([org.checkedIn isEqualToString:@"1"]) {
        [_checkinButton setBackgroundImage:[UIImage imageNamed:@"icon_checkedIn"] forState:UIControlStateNormal];
        [_checkinButton setTitle:@"已报名" forState:UIControlStateNormal];
    }else{
        [_checkinButton setBackgroundImage:[UIImage imageNamed:@"icon_checkingIn"] forState:UIControlStateNormal];
        [_checkinButton setTitle:@"立即报名" forState:UIControlStateNormal];
    }
    [_checkinButton addTarget:self action:@selector(checkin) forControlEvents:UIControlEventTouchDown];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.firstLineHeadIndent = 30;
    style.lineSpacing = 5;
    NSMutableAttributedString *profile = [[NSMutableAttributedString alloc] initWithString:org.profile];
    [profile addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, profile.length)];
}

-(void)checkin{
    if ([_organiztion.checkedIn isEqualToString:@"1"]) {
        return;
    }
    AuthManager *am = [[AuthManager alloc]init];
    if (!am.isAuthenticated) {
        [self showLoginView];
        return;
    }
    _checkinButton.enabled = NO;
    OrganizationManager *om =[[OrganizationManager alloc]init];
    [om checkInWithOrgId:_organiztion.orgId CheckinTime:[self currentDate] UserPhone:am.userInfo.phone UserLocal:@"" Type:@"1" Success:^(CommonResult *result) {
         _checkinButton.enabled = YES;
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"报名成功" message:@"报名成功，报名信息已发往欧拉学院" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        if (_delegate) {
            _organiztion.checkedIn = @"1";
            [_delegate cell:_organiztion local:_indexPath didTapButton:_checkinButton];
        }
        
    } Failure:^(NSError *error) {
        _checkinButton.enabled = YES;
    }];
}

-(NSString*)currentDate{
    // 获取系统当前时间
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    
    //设置时间输出格式：
    NSDateFormatter * df = [[NSDateFormatter alloc] init ];
    [df setDateFormat:@"yyyy-MM-dd"];
    return [df stringFromDate:currentDate];
}

-(void)showLoginView{
    if (_delegate) {
        [_delegate showLoginView];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
