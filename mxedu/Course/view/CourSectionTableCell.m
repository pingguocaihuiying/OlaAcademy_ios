//
//  CourSectionTableCell.m
//  mxedu
//
//  Created by 田晓鹏 on 15/12/12.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import "CourSectionTableCell.h"

#import "Masonry.h"
#import "SysCommon.h"

@implementation CourSectionTableCell

{
    UILabel *_nameL;
    UILabel *_timeL;
}

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _nameL = [UILabel new];
        _nameL.font = [UIFont systemFontOfSize:16.0];
        [self addSubview:_nameL];
        
        [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.mas_left).offset(20);
        }];
        
        _timeL = [UILabel new];
        _timeL.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:_timeL];
        
        [_timeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self.mas_right).offset(-20);
        }];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, self.frame.size.height-1, SCREEN_WIDTH-10, 1)];
        line.backgroundColor = RGBCOLOR(225, 225, 225);
        [self addSubview:line];
        
    }
    return self;
    
}

-(void) setCellWithModel:(CourseVideo*)point{
    _nameL.text = point.name;
    _timeL.text = point.timeSpan;
    if (point.isChosen==1) {
        _nameL.textColor = COMMONBLUECOLOR;
        _timeL.textColor = COMMONBLUECOLOR;
    }else{
        _nameL.textColor = RGBCOLOR(153, 153, 153);
        _timeL.textColor = RGBCOLOR(153, 153, 153);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
