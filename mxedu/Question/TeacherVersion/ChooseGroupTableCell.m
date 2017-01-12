//
//  ChooseGroupTableCell.m
//  mxedu
//
//  Created by 田晓鹏 on 16/10/10.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "ChooseGroupTableCell.h"

#import "SysCommon.h"
#import "UIColor+HexColor.h"
#import "Masonry.h"

@implementation ChooseGroupTableCell{
    UILabel *_nameL;
    UIImageView *_chooseBtn;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _nameL = [[UILabel alloc] init];
        _nameL.font = LabelFont(30);
        _nameL.lineBreakMode = NSLineBreakByWordWrapping;
        _nameL.textColor = [UIColor colorWhthHexString:@"#51545d"];
        [self addSubview:_nameL];
        
        [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(GENERAL_SIZE(30));
            make.centerY.equalTo(self);
        }];
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = RGBCOLOR(235, 235, 235);
        [self addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(SCREEN_WIDTH));
            make.height.equalTo(@1);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        _chooseBtn = [[UIImageView alloc]init];
        [self addSubview:_chooseBtn];
        
        [_chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self.mas_right).offset(-GENERAL_SIZE(30));
        }];
    }
    return self;
}

-(void)setupCellWithModel:(Group*)group{
    _nameL.text = group.name;
    if (group.isChosen == 1) {
        [_chooseBtn setImage:[UIImage imageNamed:@"icon_choice"]];
    }else{
        [_chooseBtn setImage:[UIImage imageNamed:@"icon_unchoice"]];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

