//
//  CourseListTableCell.m
//  mxedu
//
//  Created by 田晓鹏 on 16/8/15.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "CourseListTableCell.h"
#import "Masonry.h"
#import "SysCommon.h"
#import "UIImageView+WebCache.h"

#import "UIImageView+AsyncDownload.h"

@implementation CourseListTableCell//{
//    UIImageView *_videoImage;
//    UILabel *_nameLabel;
//    UILabel *_timeLabel;
//    UIImageView *clockIV;
//}
{
    UIImageView *_videoImage;
    UILabel *_titleLabel;
    UILabel *_timeLabel;
    UILabel *_nameLabel;
    UILabel *_studyLabel;
    UIImageView *clockIV;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH-20, 20)];
        _titleLabel.textColor = RGBCOLOR(50, 50, 50);
        _titleLabel.font = LabelFont(32);
        [self addSubview:_titleLabel];
        clockIV = [[UIImageView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_titleLabel.frame)+5, 16, 16)];
        clockIV.image = [UIImage imageNamed:@"recents"];
        [self addSubview:clockIV];
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(clockIV.frame)+5, CGRectGetMaxY(_titleLabel.frame)+2, 200, 20)];
        _timeLabel.textColor = RGBCOLOR(144, 144, 144);
        _timeLabel.font = LabelFont(24);
        [self addSubview:_timeLabel];
        
        UIImageView *lineImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 60, SCREEN_WIDTH-30, 1)];
        lineImage.backgroundColor = BACKGROUNDCOLOR;
        [self addSubview:lineImage];
        
        _videoImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 75, 30, 30)];
        _videoImage.layer.cornerRadius=15;
        _videoImage.layer.masksToBounds=YES;
        [self addSubview:_videoImage];
        
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = LabelFont(24);
        _nameLabel.textColor = RGBCOLOR(101, 101, 101);
        [self addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_videoImage);
            make.left.equalTo(_videoImage.mas_right).offset(10);
        }];
        
        _studyLabel = [[UILabel alloc]init];
        _studyLabel.font = LabelFont(24);
        _studyLabel.textColor = RGBCOLOR(255, 108, 0);
        [self addSubview:_studyLabel];
        
        [_studyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
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

-(void)setupCell:(Course*)course{
    [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",course.address]] options:SDWebImageHighPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (image != nil)
        {
            // 图片剪裁
            CGRect rect = CGRectMake(0, 0, CGImageGetHeight([image CGImage])*260/160,CGImageGetHeight([image CGImage]));
            CGImageRef imagePartRef = CGImageCreateWithImageInRect([image CGImage], rect);
            [_videoImage setImage:[UIImage imageWithCGImage:imagePartRef]];
        }else{
            _videoImage.image = [UIImage imageNamed:@"ic_video"];
        }
    }];
    _titleLabel.text = course.name;
    _timeLabel.text = [NSString stringWithFormat:@"%@学时,%@",course.subAllNum,course.totalTime];
    _nameLabel.text = @"陈剑";
    _studyLabel.text = [NSString stringWithFormat:@"%@人学习",course.playcount];
    
    NSRange range = [_studyLabel.text rangeOfString:@"人学习"];
    [self setTextColor:_studyLabel FontNumber:_studyLabel.font AndRange:range AndColor:[UIColor blackColor]];

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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
