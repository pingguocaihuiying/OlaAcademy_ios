//
//  StudyProgressCell.m
//  mxedu
//
//  Created by zhufeng on 2017/1/13.
//  Copyright © 2017年 田晓鹏. All rights reserved.
//

#import "StudyProgressCell.h"
#import "SysCommon.h"
#import "UIColor+HexColor.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface StudyProgressCell () {
    UILabel *_timerLabel;
    UILabel *_doneLabel;
    UILabel *_dayLabel;
    UILabel *_victoryLabel;
    UILabel *_placeLabel; //本周学友排名
    UIImageView *_placeAvatar;
//    UILabel *_timerLabel;
//    UILabel *_timerLabel;
}

@end

@implementation StudyProgressCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        //创建子控件
        [self createdSubViews];
    }
    
    return self;
}

-(void)createdSubViews {
    UIView *slideView1 = [[UIView alloc] initWithFrame:CGRectMake(GENERAL_SIZE(20), 0, SCREEN_WIDTH-GENERAL_SIZE(40), 1)];
    slideView1.backgroundColor = [UIColor colorWhthHexString:@"#e6e6e6"];
    [self addSubview:slideView1];
    
    CGFloat timerW = GENERAL_SIZE(180);
    CGFloat timerH = GENERAL_SIZE(80);
    CGFloat timerX = (SCREEN_WIDTH - timerW) / 2.0;
    CGFloat timerY = CGRectGetMaxY(slideView1.frame)+GENERAL_SIZE(10);
    _timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(timerX, timerY, timerW, timerH)];
    _timerLabel.textAlignment = NSTextAlignmentCenter;
    _timerLabel.textColor = [UIColor colorWhthHexString:@"#979797"];
    _timerLabel.text = @"45分钟";
    _timerLabel.font  = LabelFont(24);
    [self addSubview:_timerLabel];
    NSRange range = [_timerLabel.text rangeOfString:@"45"];
    [self setTextColor:_timerLabel FontNumber:LabelFont(78) AndRange:range AndColor:[UIColor colorWhthHexString:@"#34343f"]];
    
    CGFloat doneLabelW = SCREEN_WIDTH / 3.0;
    CGFloat doneLabelH = GENERAL_SIZE(100);
    CGFloat doneLabelX = 0;
    CGFloat doneLabelWY = CGRectGetMaxY(_timerLabel.frame)+GENERAL_SIZE(15);
    _doneLabel = [[UILabel alloc] initWithFrame:CGRectMake(doneLabelX, doneLabelWY, doneLabelW, doneLabelH)];
    _doneLabel.textAlignment = NSTextAlignmentCenter;
    _doneLabel.numberOfLines = 0;
    _doneLabel.textColor = [UIColor colorWhthHexString:@"#979797"];
    _doneLabel.text = @"完成\n100 道题";
    _doneLabel.font  = LabelFont(24);
    [self addSubview:_doneLabel];
    NSRange doneRange = [_doneLabel.text rangeOfString:@"100"];
    [self setTextColor:_doneLabel FontNumber:LabelFont(48) AndRange:doneRange AndColor:[UIColor colorWhthHexString:@"#34343f"]];
    
    CGFloat dayLabelW = doneLabelW;
    CGFloat dayLabelH = doneLabelH;
    CGFloat dayLabelX = CGRectGetMaxX(_doneLabel.frame);
    CGFloat dayLabelY = doneLabelWY;
    _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(dayLabelX, dayLabelY, dayLabelW, dayLabelH)];
    _dayLabel.textAlignment = NSTextAlignmentCenter;
    _dayLabel.numberOfLines = 0;
    _dayLabel.textColor = [UIColor colorWhthHexString:@"#979797"];
    _dayLabel.text = @"坚持\n30 天";
    _dayLabel.font  = LabelFont(24);
    [self addSubview:_dayLabel];
    NSRange dayRange = [_dayLabel.text rangeOfString:@"30"];
    [self setTextColor:_dayLabel FontNumber:LabelFont(48) AndRange:dayRange AndColor:[UIColor colorWhthHexString:@"#34343f"]];
    
    CGFloat victoryLabelW = doneLabelW;
    CGFloat victoryLabelH = doneLabelH;
    CGFloat victoryLabelX = CGRectGetMaxX(_dayLabel.frame);
    CGFloat victoryLabelY = doneLabelWY;
    _victoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(victoryLabelX, victoryLabelY, victoryLabelW, victoryLabelH)];
    _victoryLabel.textAlignment = NSTextAlignmentCenter;
    _victoryLabel.numberOfLines = 0;
    _victoryLabel.textColor = [UIColor colorWhthHexString:@"#d0d0d0"];
    _victoryLabel.text = @"打败\n50% 学友";
    _victoryLabel.font  = LabelFont(24);
    [self addSubview:_victoryLabel];
    NSRange victoryRange = [_victoryLabel.text rangeOfString:@"50%"];
    [self setTextColor:_victoryLabel FontNumber:LabelFont(48) AndRange:victoryRange AndColor:[UIColor colorWhthHexString:@"#34343f"]];
    
    UIView *slideView2 = [[UIView alloc] initWithFrame:CGRectMake(GENERAL_SIZE(20), CGRectGetMaxY(_victoryLabel.frame)+GENERAL_SIZE(10), SCREEN_WIDTH-GENERAL_SIZE(40), 1)];
    slideView2.backgroundColor = [UIColor colorWhthHexString:@"#e6e6e6"];
    [self addSubview:slideView2];
    
    _placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(GENERAL_SIZE(20), CGRectGetMaxY(slideView2.frame)+GENERAL_SIZE(10), SCREEN_WIDTH - GENERAL_SIZE(150), GENERAL_SIZE(60))];
    _placeLabel.textColor = [UIColor colorWhthHexString:@"#575a63"];
    _placeLabel.text = @"本周学友排名";
    _placeLabel.font = LabelFont(24);
    [self addSubview:_placeLabel];
    
    _placeAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - GENERAL_SIZE(90), CGRectGetMaxY(slideView2.frame)+GENERAL_SIZE(8), GENERAL_SIZE(60), GENERAL_SIZE(60))];
    _placeAvatar.layer.cornerRadius = GENERAL_SIZE(30);
    _placeAvatar.layer.masksToBounds = YES;
    _placeAvatar.backgroundColor = [UIColor redColor];
    [self addSubview:_placeAvatar];
    
}
-(void)setAvatar:(NSString *)avatar {
    if(avatar){
        if ([avatar rangeOfString:@".jpg"].location == NSNotFound) {
            [_placeAvatar sd_setImageWithURL:[NSURL URLWithString: [BASIC_IMAGE_URL stringByAppendingString:avatar]] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
        }else{
            [_placeAvatar sd_setImageWithURL:[NSURL URLWithString: [@"http://api.olaxueyuan.com/upload/" stringByAppendingString:avatar]] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
        }
    }else{
        _placeAvatar.image = [UIImage imageNamed:@"ic_avatar"];
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




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
