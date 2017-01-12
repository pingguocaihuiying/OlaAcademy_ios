//
//  ConsultTableCell.m
//  mxedu
//
//  Created by 田晓鹏 on 16/8/23.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "ConsultTableCell.h"

#import "SysCommon.h"
#import "UIColor+HexColor.h"
#import "Masonry.h"

@implementation ConsultTableCell{
    UILabel *_indexL;
    UILabel *_nameL;
    UILabel *_timeL;
    UILabel *_numberL;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(GENERAL_SIZE(20), 0, SCREEN_WIDTH-GENERAL_SIZE(40), 1)];
        line.backgroundColor = [UIColor colorWhthHexString:@"#e6e6e6"];
        [self addSubview:line];
        
        _indexL = [[UILabel alloc]init];
        _indexL.textColor = [UIColor colorWhthHexString:@"#f44336"];
        [self addSubview:_indexL];
        
        [_indexL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(GENERAL_SIZE(20));
            make.top.equalTo(self).offset(GENERAL_SIZE(20));
        }];
        
        _nameL = [[UILabel alloc] init];
        _nameL.font = LabelFont(30);
        //文本最多行数，为0时没有最大行数限制
        _nameL.numberOfLines = 2;
        _nameL.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
        _nameL.textColor = [UIColor colorWhthHexString:@"#51545d"];
        [self addSubview:_nameL];
        
        [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(GENERAL_SIZE(80));
            make.top.equalTo(self).offset(GENERAL_SIZE(20));
            make.right.equalTo(self.mas_right).offset(-GENERAL_SIZE(120));
        }];
        
        _timeL = [[UILabel alloc]init];
        _timeL.font = LabelFont(22);
        _timeL.textColor = [UIColor colorWhthHexString:@"#a4a6a9"];
        [self addSubview:_timeL];
        
        [_timeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(GENERAL_SIZE(80));
            make.top.equalTo(_nameL.mas_top).offset(GENERAL_SIZE(80));
        }];
        
        _numberL = [[UILabel alloc]init];
        _numberL.font = LabelFont(22);
        _numberL.textColor = [UIColor colorWhthHexString:@"#a4a6a9"];
        [self addSubview:_numberL];
        
        [_numberL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_timeL.mas_top);
            make.right.equalTo(self.mas_right).offset(-GENERAL_SIZE(20));
        }];
        
    }
    return self;
}

-(void)setupCellWithModel:(Consult*)consult AtRow:(NSInteger)rowIndex{
    _indexL.text = [NSString stringWithFormat:@"0%ld",rowIndex+1];
    _nameL.text = consult.content;
    _timeL.text = consult.time;
    _numberL.text = [NSString stringWithFormat:@"%@人收听",consult.number];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
