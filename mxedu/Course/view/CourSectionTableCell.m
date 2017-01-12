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
    UIImageView *_playingIV;
    UILabel *_nameL;
    UILabel *_timeL;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _playingIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_playing"]];
        [self addSubview:_playingIV];
        
        [_playingIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(GENERAL_SIZE(5));
            make.left.equalTo(self.mas_left).offset(20);
        }];
        
        _nameL = [UILabel new];
        _nameL.font = LabelFont(32);
        [self addSubview:_nameL];
        
        [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(GENERAL_SIZE(5));
            make.left.equalTo(_playingIV.mas_left).offset(20);
        }];
        
        _timeL = [UILabel new];
        _timeL.font = LabelFont(28);
        [self addSubview:_timeL];
        
        [_timeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(GENERAL_SIZE(5));
            make.right.equalTo(self.mas_right).offset(-20);
        }];
        //cell 之间的分割线
        UIView *slideView = [[UIView alloc] init];//WithFrame:CGRectMake(20, CGRectGetMaxY(_nameL.frame)+3, SCREEN_WIDTH-40, 1)];
        slideView.backgroundColor = RGBCOLOR(227, 227, 230);
        [self.contentView addSubview:slideView];
        [slideView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(20);
            make.right.equalTo(self.mas_right).offset(-20);
            make.bottom.equalTo(self.mas_bottom).offset(0);
            make.height.mas_equalTo(@1);
        }];
    }
    return self;
    
}

-(void) setCellWithModel:(CourseVideo*)point{
    _nameL.text = point.name;
    _timeL.text = point.timeSpan;
    if (point.isChosen==1) {
        ///正在播放的条目字体颜色为黑色
        _playingIV.hidden = NO;
        _nameL.textColor = COMMONBLUECOLOR;
        _timeL.textColor = COMMONBLUECOLOR;
    }else{
        ///未播放的条目字体颜色为黑色
        _playingIV.hidden = YES;
        _nameL.textColor = [UIColor blackColor];
        _timeL.textColor = [UIColor blackColor];;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
