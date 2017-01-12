//
//  HomeworkView.m
//  mxedu
//
//  Created by 田晓鹏 on 16/8/3.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "HomeworkView.h"

#import "Masonry.h"
#import "SysCommon.h"
#import "UIColor+HexColor.h"

#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"
#import "MDRadialProgressLabel.h"

@implementation HomeworkView{
    
    UILabel *nameLabel;
    UILabel *timeLabel;
    UILabel *countLabel;
    UILabel *groupLabel;
    MDRadialProgressView *progressView;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *dividerView = [[UIView alloc]init];
        dividerView.backgroundColor = RGBCOLOR(235, 235, 235);
        [self addSubview:dividerView];
        
        UIImageView *titleImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_today"]];
        [self addSubview:titleImage];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"今日作业";
        titleLabel.textColor = RGBCOLOR(39, 42, 54);
        titleLabel.font = [UIFont boldSystemFontOfSize:GENERAL_SIZE(34)];
        [self addSubview:titleLabel];
        
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        moreBtn.frame = CGRectMake(SCREEN_WIDTH-100, 20, 100, 20);
        [moreBtn setTitle:@"显示全部" forState:UIControlStateNormal];
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:GENERAL_SIZE(24)];
        [moreBtn setTitleColor:RGBCOLOR(168, 168, 168) forState:UIControlStateNormal];
        [moreBtn addTarget:self action:@selector(browseMore) forControlEvents:UIControlEventTouchDown];
        [self addSubview:moreBtn];
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = RGBCOLOR(230, 230, 230);
        [self addSubview:lineView];
        
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
        
        [dividerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.width.equalTo(@(SCREEN_WIDTH));
            make.height.equalTo(@10);
        }];
        
        [titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.centerY.equalTo(titleLabel);
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleImage.mas_right).offset(10);
            make.top.equalTo(dividerView.mas_bottom).offset(GENERAL_SIZE(20));
        }];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(GENERAL_SIZE(20));
            make.left.equalTo(self).offset(5);
            make.right.equalTo(self.mas_right).offset(-5);
            make.height.equalTo(@1);
        }];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineView.mas_bottom).offset(GENERAL_SIZE(20));
            make.left.equalTo(titleImage.mas_left);
        }];
        
        [timeImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleImage.mas_left);
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
            make.left.equalTo(titleImage.mas_left);
        }];
        
        progressView = [[MDRadialProgressView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-GENERAL_SIZE(160), GENERAL_SIZE(120), GENERAL_SIZE(120), GENERAL_SIZE(120))];
        progressView.theme.completedColor = [UIColor redColor];
        progressView.theme.incompletedColor = RGBCOLOR(235, 235, 235);
        progressView.label.font = LabelFont(24);
        progressView.label.textColor = [UIColor redColor];
        progressView.theme.sliceDividerHidden = YES;
        progressView.theme.thickness = 10;
        
        progressView.progressTotal = 100;
        progressView.progressCounter = 0;
        progressView.label.text = @"完成率\n0％";
        
        [self addSubview:progressView];
        
    }
    return self;
}

-(void)setupViewWithModel:(Homework*)homework{
    if(homework){
        nameLabel.text = homework.name;
        timeLabel.text = homework.time;
        countLabel.text = [NSString stringWithFormat:@"%@道小题",homework.count];
        groupLabel.text = [NSString stringWithFormat:@" %@ ",homework.groupName];
        int progress = 0;
        if (homework.finishedCount) {
            progress = [homework.finishedCount intValue]*100/[homework.count intValue];
        }
        progressView.progressCounter = progress;
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
        progressView.label.text = [NSString stringWithFormat:@"完成率\n%d％",progress];
    }else{
        progressView.progressCounter = 0;;
        progressView.label.text = @"完成率\n0％";
        progressView.theme.completedColor = [UIColor colorWhthHexString:@"#f01c06"];
        progressView.label.textColor = [UIColor colorWhthHexString:@"#f01c06"];
    }
}

-(void)browseMore{
    if (_delegate) {
        [_delegate didClickBrowseMore];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
