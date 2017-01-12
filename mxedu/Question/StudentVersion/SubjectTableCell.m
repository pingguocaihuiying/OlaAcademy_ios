//
//  SubjectTableCell.m
//  mxedu
//
//  Created by 田晓鹏 on 16/3/7.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "SubjectTableCell.h"

#import "Masonry.h"
#import "SysCommon.h"
#import "THProgressView.h"

@interface SubjectTableCell()

@property (nonatomic) UILabel *nameL;
@property (nonatomic) THProgressView *progressView;
@property (nonatomic) UILabel *progressL;

@property (nonatomic) Course* course;

@end

@implementation SubjectTableCell

- (void)awakeFromNib {
    // Initialization code
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *pointImage = [[UIView alloc]initWithFrame:CGRectMake(15, 12, GENERAL_SIZE(30), GENERAL_SIZE(30))];
        pointImage.backgroundColor = [UIColor clearColor];
        pointImage.layer.cornerRadius = GENERAL_SIZE(15);
        pointImage.layer.masksToBounds = YES;
        [self addSubview:pointImage];
        
        UIView *lineImage = [[UIView alloc]initWithFrame:CGRectMake(20, 35, 1, GENERAL_SIZE(80))];
        lineImage.backgroundColor = [UIColor clearColor];
        [self addSubview:lineImage];
        
        _nameL = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 200, 20)];
        _nameL.textColor = RGBCOLOR(81, 84, 93);
        _nameL.font = [UIFont systemFontOfSize:16.0];
        [self addSubview:_nameL];
        
        _progressView = [[THProgressView alloc]init];
        _progressView.borderTintColor = [UIColor whiteColor];
        _progressView.progressTintColor = COMMONBLUECOLOR;
        _progressView.progressBackgroundColor = RGBCOLOR(225, 225, 225);
        [self addSubview:_progressView];
        
        [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameL.mas_left).offset(-5);
            make.width.equalTo(@80);
            make.height.equalTo(@20);
            make.top.equalTo(_nameL.mas_bottom).offset(10);
        }];

        _progressL = [[UILabel alloc] init];
        _progressL.textColor = RGBCOLOR(144, 144, 144);
        _progressL.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:_progressL];
        
        [_progressL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_progressView.mas_right).offset(10);
            make.top.equalTo(_nameL.mas_bottom).offset(10);
        }];

        
        UIImageView *questionImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_questionlist"]];
        [self addSubview:questionImage];
        
        [questionImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self);
        }];
        
        UIView *dividerImage = [[UIView alloc]init];
        dividerImage.backgroundColor = RGBCOLOR(233, 233, 233);
        [self addSubview:dividerImage];
        
        [dividerImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameL.mas_left);
            make.right.equalTo(questionImage.mas_left);
            make.top.equalTo(self.mas_top);
            make.height.equalTo(@1);
        }];
        
    }
    return self;
    
}

-(void) setCellWithModel:(Course*)course{
    _course = course;
    _nameL.text = course.name;
    [_progressView setProgress:[course.subNum floatValue]/[course.subAllNum floatValue] animated:YES];
    _progressL.text = [NSString stringWithFormat:@"%@/%@",course.subNum,course.subAllNum];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
