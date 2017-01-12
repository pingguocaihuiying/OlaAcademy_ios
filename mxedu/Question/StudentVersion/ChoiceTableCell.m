//
//  ChoiceTableCell.m
//  mxedu
//
//  Created by 田晓鹏 on 16/8/10.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "ChoiceTableCell.h"

#import "Masonry.h"

@implementation ChoiceTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _nameL = [[UILabel alloc] init];
        _nameL.font = [UIFont systemFontOfSize:16.0];
        [self addSubview:_nameL];
        
        _choiceIV = [[UIImageView alloc]init];
        [self addSubview:_choiceIV];
        
        [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self);
        }];
       
        [_choiceIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
