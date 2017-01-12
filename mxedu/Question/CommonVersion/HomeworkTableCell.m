//
//  HomeworkTableCell.m
//  mxedu
//
//  Created by 田晓鹏 on 16/8/3.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "HomeworkTableCell.h"

#import "SysCommon.h"
#import "Masonry.h"
#import "UIColor+HexColor.h"

#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"
#import "MDRadialProgressLabel.h"

@implementation HomeworkTableCell{
    
    UILabel *nameLabel;
    UILabel *timeLabel;
    UILabel *countLabel;
    UILabel *groupLabel;
    MDRadialProgressView *progressView;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        nameLabel = [[UILabel alloc]init];
        nameLabel.text = @"欧拉作业——概率与组合";
        nameLabel.font = [UIFont systemFontOfSize:GENERAL_SIZE(32)];
        nameLabel.textColor = RGBCOLOR(39, 42, 54);
        [self addSubview:nameLabel];
        
        UIImageView *timeImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_time"]];
        [self addSubview:timeImage];
        
        timeLabel = [[UILabel alloc]init];
        timeLabel.text = @"07月08日 11:00";
        timeLabel.textColor = RGBCOLOR(164, 166, 169);
        timeLabel.font = [UIFont systemFontOfSize:GENERAL_SIZE(24)];
        [self addSubview:timeLabel];
        
        UIImageView *countImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_count"]];
        [self addSubview:countImage];
        
        countLabel = [[UILabel alloc]init];
        countLabel.text = @"50道小题";
        countLabel.font = [UIFont systemFontOfSize:GENERAL_SIZE(24)];
        countLabel.textColor = RGBCOLOR(164, 166, 169);
        [self addSubview:countLabel];
        
        groupLabel = [[UILabel alloc]init];
        groupLabel.text = @" 欧拉作业群 ";
        groupLabel.font = [UIFont systemFontOfSize:GENERAL_SIZE(26)];
        groupLabel.textColor = [UIColor whiteColor];
        groupLabel.backgroundColor = [UIColor colorWhthHexString:@"#9cbadc"];
        groupLabel.layer.cornerRadius = 2;
        [self addSubview:groupLabel];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(GENERAL_SIZE(30));
            make.left.equalTo(self.mas_left).offset(15);
        }];
        
        [timeImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(timeLabel);
        }];
        
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameLabel.mas_bottom).offset(GENERAL_SIZE(16));
            make.left.equalTo(timeImage.mas_right).offset(5);
        }];
        
        [countImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(timeLabel.mas_right).offset(15);
            make.centerY.equalTo(countLabel);
        }];
        
        [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameLabel.mas_bottom).offset(GENERAL_SIZE(16));
            make.left.equalTo(countImage.mas_right).offset(5);
        }];
        
        [groupLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(timeLabel.mas_bottom).offset(GENERAL_SIZE(20));
            make.left.equalTo(self.mas_left).offset(15);
        }];
        
        progressView = [[MDRadialProgressView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-GENERAL_SIZE(160), GENERAL_SIZE(40), GENERAL_SIZE(120), GENERAL_SIZE(120))];
        progressView.theme.completedColor = [UIColor redColor];
        progressView.theme.incompletedColor = RGBCOLOR(235, 235, 235);
        progressView.label.font = LabelFont(24);
        progressView.label.textColor = [UIColor redColor];
        progressView.theme.sliceDividerHidden = YES;
        progressView.theme.thickness = 10;
        
        progressView.progressTotal = 100;
        progressView.progressCounter = 0;;
        progressView.label.text = @"完成率\n0％";
        
        [self addSubview:progressView];
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWhthHexString:@"#ebebeb"];
        [self addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom);
            make.height.equalTo(@1);
            make.left.equalTo(self).offset(GENERAL_SIZE(20));
            make.right.equalTo(self);
        }];
    }
    return self;
    
}

-(void)setupCellWithModel:(Homework*)homework{
    nameLabel.text = homework.name;
    timeLabel.text = homework.time;
    countLabel.text = [NSString stringWithFormat:@"%@道小题",homework.count];
    groupLabel.text = [NSString stringWithFormat:@" %@ ",homework.groupName];
    int progress = 0;
    if (homework.finishedPercent) {
        progress = [homework.finishedPercent intValue];
    }
    if (progress<30) {
        progressView.theme.completedColor = [UIColor colorWhthHexString:@"#f01c06"];
        progressView.label.textColor = [UIColor colorWhthHexString:@"#f01c06"];
    }else if(progress<80){
        progressView.theme.completedColor = [UIColor colorWhthHexString:@"#ec950d"];
        progressView.label.textColor = [UIColor colorWhthHexString:@"#ec950d"];
    }else{
        progressView.theme.completedColor = [UIColor colorWhthHexString:@"#009688"];
        progressView.label.textColor = [UIColor colorWhthHexString:@"#009688"];
    }
    progressView.progressCounter = progress;
    progressView.label.text = [NSString stringWithFormat:@"完成率\n%d％",progress];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
