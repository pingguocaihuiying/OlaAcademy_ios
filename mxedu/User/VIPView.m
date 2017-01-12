//
//  HealthHeadView.m
//  NTreat
//
//  Created by 田晓鹏 on 16/3/7.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "VIPView.h"

#import "SysCommon.h"
#import "Masonry.h"

@interface VIPView()

@property (nonatomic) UIView *teamView;
@property (nonatomic) UIView *patientView;
@property (nonatomic) UIView *caseView;
@property (nonatomic) UIView *codeView;

@property (nonatomic) UILabel *countLabel;

@end

@implementation VIPView


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _teamView = [self viewWithName:@"3000+课程" Pic:@"ic_vipcourse" Type:0];
        _teamView.frame = CGRectMake(0, 0, SCREEN_WIDTH/4, SCREEN_WIDTH/4);
        
        [self addSubview:_teamView];
        
        _patientView = [self viewWithName:@"全免费" Pic:@"ic_free" Type:1];
        _patientView.frame = CGRectMake(SCREEN_WIDTH/4, 0, SCREEN_WIDTH/4, SCREEN_WIDTH/4);
        
        [self addSubview:_patientView];
        
        _caseView = [self viewWithName:@"视频缓存" Pic:@"ic_cache" Type:2];
        _caseView.frame = CGRectMake(SCREEN_WIDTH/4*2, 0, SCREEN_WIDTH/4, SCREEN_WIDTH/4);
        
        [self addSubview:_caseView];
        
        _codeView = [self viewWithName:@"报名优惠" Pic:@"ic_concessions" Type:3];
        _codeView.frame = CGRectMake(SCREEN_WIDTH/4*3, 0, SCREEN_WIDTH/4, SCREEN_WIDTH/4);
        
        [self addSubview:_codeView];
        
    }
    return self;
}


-(UIView*)viewWithName:(NSString*)name Pic:(NSString*)pic Type:(int)type{
    UIView *view = [UIView new];
    UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:pic]];;
    [view addSubview:icon];
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.font = LabelFont(28);
    nameLabel.textColor = COMMONBLUECOLOR;
    nameLabel.text = name;
    [view addSubview:nameLabel];
    
    UITapGestureRecognizer *tap;
    switch (type) {
        case 0:
            tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickTeam)];
            break;
        case 1:
            tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickPatient)];
            break;
        case 2:
            tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickCase)];
            break;
        case 3:
            tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickCode)];
            break;
            
        default:
            break;
    }
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:tap];
    
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_top).offset(GENERAL_SIZE(40));
        make.centerX.equalTo(view.mas_centerX).offset(0);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX).offset(0);
        make.top.equalTo(icon.mas_bottom).offset(GENERAL_SIZE(30));
        make.bottom.equalTo(view.mas_top).offset(GENERAL_SIZE(190));
    }];
    
    return view;
}

-(void)didClickTeam{
    if (_headViewDelegate) {
        [_headViewDelegate didClickTeamView];
    }
}

-(void)didClickPatient{
    if (_headViewDelegate) {
        [_headViewDelegate didClickPatientView];
    }
}

-(void)didClickCase{
    if (_headViewDelegate) {
        [_headViewDelegate didClickCaseView];
    }
}

-(void)didClickCode{
    if (_headViewDelegate) {
        [_headViewDelegate didClickCodeView];
    }
}

@end
