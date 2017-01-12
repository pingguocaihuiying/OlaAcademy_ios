//
//  MessageCommentTableCell.m
//  mxedu
//
//  Created by 田晓鹏 on 16/12/14.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "MessageCommonTableCell.h"

#import "SysCommon.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIColor+HexColor.h"

#import "Comment.h"
#import "CirclePraise.h"

@implementation MessageCommonTableCell{
    UIImageView *_userAvatar;
    UILabel *_nameLabel;
    UILabel *_timeLabel;
    UILabel *_readLabel;
    UILabel *_orgLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _userAvatar = [UIImageView new];
        _userAvatar.backgroundColor = [UIColor redColor];
        _userAvatar.layer.cornerRadius = GENERAL_SIZE(50);
        _userAvatar.layer.masksToBounds = YES;
        [self addSubview:_userAvatar];
        
        _nameLabel = [UILabel new];
        _nameLabel.textColor = [UIColor colorWhthHexString:@"#34343f"];
        _nameLabel.font = LabelFont(32);
        [self addSubview:_nameLabel];
        
        _timeLabel = [UILabel new];
        _timeLabel.textColor = [UIColor colorWhthHexString:@"#959595"];
        _timeLabel.font = LabelFont(24);
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_timeLabel];
        
        _readLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, GENERAL_SIZE(12), GENERAL_SIZE(12))];
        _readLabel.layer.cornerRadius=GENERAL_SIZE(6);
        _readLabel.layer.masksToBounds=YES;
        _readLabel.backgroundColor = [UIColor redColor];
        [self addSubview:_readLabel];
        
        _orgLabel = [UILabel new];
        _orgLabel.numberOfLines = 1;
        _orgLabel.textColor = [UIColor colorWhthHexString:@"#959595"];
        _orgLabel.font = LabelFont(24);
        [self addSubview:_orgLabel];
        
        [_userAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).offset(GENERAL_SIZE(20));
            make.width.height.mas_equalTo(GENERAL_SIZE(100));
        }];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_userAvatar);
            make.left.equalTo(_userAvatar.mas_right).offset(GENERAL_SIZE(20));
            make.right.equalTo(self.mas_right).offset(-GENERAL_SIZE(250));
        }];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nameLabel);
            make.right.equalTo(self.mas_right).offset(-GENERAL_SIZE(28));
            make.width.equalTo(@(GENERAL_SIZE(220)));
            make.height.equalTo(@(GENERAL_SIZE(42)));
        }];
        
        [_readLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_timeLabel.mas_bottom).offset(GENERAL_SIZE(10));
            make.right.equalTo(self.mas_right).offset(-15);
            make.width.equalTo(@(GENERAL_SIZE(12)));
            make.height.equalTo(@(GENERAL_SIZE(12)));
        }];
        
        [_orgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-GENERAL_SIZE(20));
            make.left.equalTo(_nameLabel);
            make.right.equalTo(self.mas_right).offset(-GENERAL_SIZE(160));
        }];
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = RGBCOLOR(235, 235, 235);
        [self addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
            make.left.equalTo(self);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@(GENERAL_SIZE(2)));
        }];
        
    }
    return self;
}

-(void)setupCell:(NSObject*)object{
    if ([object isKindOfClass:[Comment class]]) {
        Comment *comment = (Comment*)object;
        if (comment.profile_image) {
            [_userAvatar sd_setImageWithURL:[NSURL URLWithString:[BASIC_IMAGE_URL stringByAppendingString:comment.profile_image]] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
        }
        _nameLabel.text = comment.username;
        //处理时间显示格式
        _timeLabel.text = [self dealWithTimer:comment.passtime];
        
        if(comment.rpyToUserId){
            _orgLabel.text = @"评论了你的评论";
        }else{
            _orgLabel.text = @"回答了问题";
        }
        
        if([comment.isRead isEqualToString:@"1"]){
            _readLabel.hidden = YES;
        }else{
            _readLabel.hidden = NO;
        }
    }else if ([object isKindOfClass:[CirclePraise class]]){
        CirclePraise *praise = (CirclePraise*)object;
        if (praise.userAvatar) {
            [_userAvatar sd_setImageWithURL:[NSURL URLWithString:[BASIC_IMAGE_URL stringByAppendingString:praise.userAvatar]] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
        }
        _nameLabel.text = [NSString stringWithFormat:@"%@",praise.userName];
        //处理时间显示格式
        _timeLabel.text = [self dealWithTimer:praise.time];
        _orgLabel.text = @"赞了你的评论";
        NSRange range = [_orgLabel.text rangeOfString:@"赞了"];
        [self setTextColor:_orgLabel FontNumber:LabelFont(30) AndRange:range AndColor:_orgLabel.textColor];
        if([praise.isRead isEqualToString:@"1"]){
            _readLabel.hidden = YES;
        }else{
            _readLabel.hidden = NO;
        }
    }
}
//设置不同字体颜色
-(void)setTextColor:(UILabel *)label FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:label.text];
    //设置字号
    [str addAttribute:NSFontAttributeName value:font range:range];
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
    
    label.attributedText = str;
}

//处理时间显示格式
-(NSString *)dealWithTimer:(NSString *)timerString {
    //处理时间显示格式
    NSString *timerStr = [timerString substringToIndex:11];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];//格式化
    [df setDateFormat:@"yyyy/MM/dd"];
    NSDate *date = [df dateFromString:timerStr];
    NSString * newTimer = [df stringFromDate:date];
    
    return newTimer;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
