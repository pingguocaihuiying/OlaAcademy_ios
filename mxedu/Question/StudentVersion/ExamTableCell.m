//
//  ExamTableCell.m
//  mxedu
//
//  Created by 田晓鹏 on 16/8/8.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "ExamTableCell.h"

#import "Masonry.h"
#import "SysCommon.h"
#import "THProgressView.h"

@interface ExamTableCell()

@property (nonatomic) UILabel *nameL;
@property (nonatomic) UILabel *scoreL;
@property (nonatomic) UIImageView *questionImage;
@property (nonatomic) THProgressView *progressView;

@end

@implementation ExamTableCell

- (void)awakeFromNib {
    // Initialization code
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _nameL = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 250, 20)];
        _nameL.font = [UIFont systemFontOfSize:16.0];
        [self addSubview:_nameL];
        
        _progressView = [[THProgressView alloc]init];
        _progressView.borderTintColor = [UIColor whiteColor];
        _progressView.progressTintColor = COMMONBLUECOLOR;
        _progressView.progressBackgroundColor = RGBCOLOR(225, 225, 225);
        [self addSubview:_progressView];
        
        [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameL.mas_left);
            make.width.equalTo(@80);
            make.height.equalTo(@20);
            make.top.equalTo(_nameL.mas_bottom).offset(10);
        }];
        
        _scoreL = [[UILabel alloc] init];
        _scoreL.font = [UIFont systemFontOfSize:12.0];
        _scoreL.textColor =  RGBCOLOR(164, 166, 169);
        [self addSubview:_scoreL];
        
        [_scoreL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_progressView.mas_right).offset(10);
            make.top.equalTo(_nameL.mas_bottom).offset(10);
            make.height.equalTo(@18);
            make.width.equalTo(@60);
        }];
        
        _questionImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_questionlist"]];
        [self addSubview:_questionImage];
        
        [_questionImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self);
        }];
        
    }
    return self;
    
}

-(void) setCellWithModel:(Examination*)examination{
    _nameL.text = examination.name;
    _scoreL.text = [NSString stringWithFormat:@"难度%@",examination.degree];
    NSString *progress=[NSString stringWithFormat:@"%.2lf", [examination.progress intValue]/100.0];
    _progressView.progress = [progress floatValue];
    if ([examination.isfree integerValue]==1) {
        _questionImage.image = [UIImage imageNamed:@"ic_questionlist"];
    }else{
        _questionImage.image = [UIImage imageNamed:@"ic_questionlist_normal"];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

