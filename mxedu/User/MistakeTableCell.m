//
//  MistakeTableCell.m
//  mxedu
//
//  Created by 田晓鹏 on 16/11/10.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "MistakeTableCell.h"


#import "SysCommon.h"
#import "UIColor+HexColor.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import "THProgressView.h"

@implementation MistakeTableCell{
    UILabel *_nameL;
    UILabel *_numberL;
    THProgressView *_progressView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _nameL = [[UILabel alloc] init];
        _nameL.font = LabelFont(30);
        _nameL.numberOfLines = 0;
        _nameL.lineBreakMode = NSLineBreakByWordWrapping;
        _nameL.textColor = [UIColor colorWhthHexString:@"#51545d"];
        [self addSubview:_nameL];
        
        [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(GENERAL_SIZE(30));
            make.top.equalTo(self).offset(GENERAL_SIZE(30));
        }];
        
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
        
        _numberL = [[UILabel alloc]init];
        _numberL.font = LabelFont(24);
        _numberL.textColor = RGBCOLOR(153, 153, 153);
        [self addSubview:_numberL];
        
        [_numberL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_progressView.mas_right).offset(GENERAL_SIZE(20));
            make.centerY.equalTo(_progressView);
        }];
        
        
        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_questionlist"]];
        [self addSubview:image];
        
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self.mas_right).offset(-GENERAL_SIZE(30));
        }];
        
    }
    return self;
}

-(void)setupCellWithModel:(Mistake*)mistake{
    
    _nameL.text = mistake.name;
    [_progressView setProgress:[mistake.wrongNum floatValue]/[mistake.subAllNum floatValue] animated:YES];
    _numberL.text = [NSString stringWithFormat:@"%@ 道题",mistake.wrongNum];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
