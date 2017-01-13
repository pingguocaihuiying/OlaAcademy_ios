//
//  HomeHeadView.m
//  mxedu
//
//  Created by 田晓鹏 on 16/8/17.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "HomeHeadView.h"

#import "SysCommon.h"
#import "Masonry.h"
#import "XLCycleScrollView.h"
#import "Banner.h"
#import "UIImageView+WebCache.h"
#import "UIColor+HexColor.h"

@interface HomeHeadView()<XLCycleScrollViewDatasource, XLCycleScrollViewDelegate>

@property (nonatomic) XLCycleScrollView *bannerView;
@property (nonatomic) NSArray *bannerArray;

@property (nonatomic) UIView *teamView;
@property (nonatomic) UIView *patientView;
@property (nonatomic) UIView *caseView;
@property (nonatomic) UIView *codeView;

@property (nonatomic) UILabel *countLabel;

@end

@implementation HomeHeadView


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _bannerView = [[XLCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, GENERAL_SIZE(400))];
        _bannerView.delegate = self;
        _bannerView.datasource = self;
        _bannerView.tapEnabled = YES;
        [self addSubview:_bannerView];
        
        _teamView = [self viewWithName:@"我要提问" Pic:@"ic_request" Type:0];
        _teamView.frame = CGRectMake(0, GENERAL_SIZE(400), SCREEN_WIDTH/4, GENERAL_SIZE(170));
        
        [self addSubview:_teamView];
        
        _patientView = [self viewWithName:@"我要报名" Pic:@"ic_signup" Type:1];
        _patientView.frame = CGRectMake(SCREEN_WIDTH/4, GENERAL_SIZE(400), SCREEN_WIDTH/4, GENERAL_SIZE(170));
        
        [self addSubview:_patientView];
        
        _countLabel = [UILabel new];
        _countLabel.layer.masksToBounds = YES;
        _countLabel.layer.cornerRadius = GENERAL_SIZE(10);
        _countLabel.backgroundColor = [UIColor redColor];
        _countLabel.hidden = YES;
        [_patientView addSubview:_countLabel];
        
        [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(GENERAL_SIZE(20)));
            make.height.equalTo(@(GENERAL_SIZE(20)));
            make.top.equalTo(_patientView.mas_top).offset(20);
            make.left.equalTo(_patientView.mas_right).offset(-30);
        }];
        
        _caseView = [self viewWithName:@"我的资料" Pic:@"ic_myMaterial" Type:2];
        _caseView.frame = CGRectMake(SCREEN_WIDTH/4*2, GENERAL_SIZE(400), SCREEN_WIDTH/4, GENERAL_SIZE(170));
        
        [self addSubview:_caseView];
        
        _codeView = [self viewWithName:@"我要入群" Pic:@"ic_myGroup" Type:3];
        _codeView.frame = CGRectMake(SCREEN_WIDTH/4*3, GENERAL_SIZE(400), SCREEN_WIDTH/4, GENERAL_SIZE(170));
        
        [self addSubview:_codeView];
        
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

-(UIView*)viewWithName:(NSString*)name Pic:(NSString*)pic Type:(int)type{
    UIView *view = [UIView new];
    UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:pic]];;
    [view addSubview:icon];
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.textColor = [UIColor colorWhthHexString:@"#979797"];
    nameLabel.font = LabelFont(24);
    nameLabel.text = name;
    [view addSubview:nameLabel];
    
    UITapGestureRecognizer *tap;
    switch (type) {
        case 0:
            tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickConsult)];
            break;
        case 1:
            tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickTeacher)];
            break;
        case 2:
            tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickMaterial)];
            break;
        case 3:
            tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickGroup)];
            break;
            
        default:
            break;
    }
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:tap];
    
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_top).offset(GENERAL_SIZE(35));
        make.centerX.equalTo(view);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(icon.mas_bottom).offset(GENERAL_SIZE(20));
    }];
    
    return view;
}

-(void)didClickConsult{
    if (_headViewDelegate) {
        [_headViewDelegate didClickConsultView];
    }
}

-(void)didClickTeacher{
    if (_headViewDelegate) {
        [_headViewDelegate didClickTeacherView];
    }
}

-(void)didClickMaterial{
    if (_headViewDelegate) {
        [_headViewDelegate didClickMaterialView];
    }
}

-(void)didClickGroup{
    if (_headViewDelegate) {
        [_headViewDelegate didClickGroupView];
    }
}

-(void)setupView:(NSArray *)bannerArray{
    _bannerArray = bannerArray;
    [_bannerView reloadData];
}

#pragma mark - XLCycleScrollViewDelegate

- (NSInteger)numberOfPages
{
    return [_bannerArray count];
}

- (UIView *)pageAtIndex:(NSInteger)index
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, GENERAL_SIZE(290));
    Banner *banner = [_bannerArray objectAtIndex:index];
    [imageView sd_setImageWithURL:[NSURL URLWithString:banner.pic] placeholderImage:nil];
    return imageView;
}

-(void)didClickPage:(XLCycleScrollView *)csView atIndex:(NSInteger)index{
    Banner *banner = [_bannerArray objectAtIndex:index];
    if (_headViewDelegate) {
        [_headViewDelegate didClickBanner:banner];
    }
}

@end
