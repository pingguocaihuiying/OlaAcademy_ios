//
//  CaseInfoCollectionViewCell.m
//  NTreat
//
//  Created by 刘德胜 on 15/12/16.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import "MediaCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import <UIImageView+WebCache.h>
#import "SysCommon.h"
@interface MediaCollectionViewCell ()
{
    UIImageView *contentImageView;
    
    UIImageView *backImageView;
    
    UIImageView *medicalLogoImageview;//视频图标视图
    
    UIImageView *audioLogoImageview;//音频图标视图
    
    UILabel *timeLongLable;//显示时间长短的标签
    
    mediaModel *selfModel;
    
    UIButton *delBtn;
}
@end
@implementation MediaCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
         [self setupSubViews];
    }
    return self;
}
-(void)setupSubViews{
    
    contentImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self.contentView addSubview:contentImageView];
    
    backImageView = [UIImageView new];
    backImageView.image = [UIImage imageNamed:@"ic_mediback"];
    [self.contentView addSubview:backImageView];
    
    medicalLogoImageview = [UIImageView new];
    medicalLogoImageview.image=[UIImage imageNamed:@"ic_videoLogo"];
    [self.contentView addSubview:medicalLogoImageview];
    
    audioLogoImageview = [UIImageView new];
    audioLogoImageview.image=[UIImage imageNamed:@"ic_audioLogo"];
    [self.contentView addSubview:audioLogoImageview];
    
    timeLongLable = [UILabel new];
    timeLongLable.text=@"0:33";
    timeLongLable.textColor = [UIColor whiteColor];
    timeLongLable.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:timeLongLable];
    
    delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [delBtn setImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(removeCell) forControlEvents:UIControlEventTouchDown];
    [self.contentView addSubview:delBtn];
    
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
        make.height.equalTo(@20);
    }];
    [medicalLogoImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(3);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-4);
        make.width.equalTo(@25);
        make.height.equalTo(@15);
    }];
    
    [audioLogoImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(3);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-4);
        make.width.equalTo(@15);
        make.height.equalTo(@15);
    }];
    [timeLongLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-3);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-4);
        make.width.equalTo(@40);
        make.height.equalTo(@10);
    }];
    
    [delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-3);
        make.top.equalTo(self.contentView).offset(-3);
    }];
}
-(void)setMediaModel:(mediaModel *)mediaModel{
    
    selfModel  = mediaModel;
    self.modelData = mediaModel;
    if ([mediaModel.type isEqualToString:@"1"]) {
        backImageView.hidden=YES;
        medicalLogoImageview.hidden=YES;
        audioLogoImageview.hidden=YES;
        timeLongLable.hidden=YES;
        if (mediaModel.localpath) {
            [contentImageView sd_setImageWithURL:[NSURL URLWithString:[BASIC_IMAGE_URL stringByAppendingString:mediaModel.localpath]] placeholderImage:[UIImage imageNamed:@"doctor_male"]];
        }else{
            contentImageView.image = mediaModel.image;
        }
    }else if ([mediaModel.type isEqualToString:@"3"]){
        backImageView.hidden=NO;
        medicalLogoImageview.hidden=NO;
        audioLogoImageview.hidden=YES;
        timeLongLable.hidden=YES;
        if (mediaModel.videoimg) {
            [contentImageView sd_setImageWithURL:[NSURL URLWithString:[BASIC_Movie_URL stringByAppendingString:mediaModel.videoimg]] placeholderImage:[UIImage imageNamed:@"doctor_male"]];
        }else{
            contentImageView.image = mediaModel.image;
        }
       // timeLongLable.text = mediaModel.timeLong;
    }else{
        backImageView.hidden=NO;
        medicalLogoImageview.hidden=YES;
        audioLogoImageview.hidden=NO;
        timeLongLable.hidden=NO;
        contentImageView.image = mediaModel.image;
        timeLongLable.text = mediaModel.timeLong;
    }
}
-(void)setCaseCellType:(NSInteger)CaseCellType{
    if (CaseCellType==0) {
        medicalLogoImageview.hidden=YES;
        audioLogoImageview.hidden=YES;
        timeLongLable.hidden=YES;
    }else if (CaseCellType==1){
        medicalLogoImageview.hidden=NO;
        audioLogoImageview.hidden=YES;
        timeLongLable.hidden=NO;
    }else{
        medicalLogoImageview.hidden=YES;
        audioLogoImageview.hidden=NO;
        timeLongLable.hidden=YES;
    }
}

-(void)choiceCell{
    if ([self.delegate respondsToSelector:@selector(didChoiceCellWithModel:local:)]) {
        [self.delegate didChoiceCellWithModel:selfModel local:self.localIndexpath];
    }
}

-(void)removeCell{
    if ([self.delegate respondsToSelector:@selector(didRemoveCellWithModel:)]) {
        [self.delegate didRemoveCellWithModel:selfModel];
    }
}
@end
