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
        _teamView = [self viewWithName:@"720P" Pic:@"ic_free" Type:0];
        _teamView.frame = CGRectMake(0, 0, SCREEN_WIDTH/4, SCREEN_WIDTH/4);
        
        [self addSubview:_teamView];
        
        _patientView = [self viewWithName:@"畅游课程库" Pic:@"ic_vipcourse" Type:1];
        _patientView.frame = CGRectMake(SCREEN_WIDTH/4, 0, SCREEN_WIDTH/4, SCREEN_WIDTH/4);
        
        [self addSubview:_patientView];
        
        _caseView = [self viewWithName:@"缓存加速" Pic:@"ic_cache" Type:2];
        _caseView.frame = CGRectMake(SCREEN_WIDTH/4*2, 0, SCREEN_WIDTH/4, SCREEN_WIDTH/4);
        
        [self addSubview:_caseView];
        
        _codeView = [self viewWithName:@"送欧拉币" Pic:@"ic_concessions" Type:3];
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
    nameLabel.textColor = RGBCOLOR(224, 178, 112);
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
        make.centerX.equalTo(view.mas_centerX).offset(0);
        make.centerY.equalTo(view).offset(-GENERAL_SIZE(20));
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX).offset(0);
        make.centerY.equalTo(view).offset(GENERAL_SIZE(60));
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
