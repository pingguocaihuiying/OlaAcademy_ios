//
//  HealthCollectionCell.m
//  NTreat
//
//  Created by 田晓鹏 on 16/3/8.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "CorrectCollectionCell.h"

#import "SysCommon.h"
#import "Masonry.h"
#import <UIImageView+WebCache.h>

@interface CorrectCollectionCell()

@property (nonatomic) UILabel *questionLabel;

@end

@implementation CorrectCollectionCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _questionLabel = [UILabel new];
        _questionLabel.font = LabelFont(28);
        _questionLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_questionLabel];
        
        _questionLabel.layer.masksToBounds = YES;
        _questionLabel.layer.cornerRadius = GENERAL_SIZE(44);
        
        [_questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.mas_top).offset(GENERAL_SIZE(20));
            make.width.equalTo(@(GENERAL_SIZE(88)));
            make.height.equalTo(@(GENERAL_SIZE(88)));
        }];
    }
    return self;
}

-(void)setupCellWithModel:(Correctness*) correctness Index:(NSInteger)index{
    if ([correctness.isCorrect isEqualToString:@"0"]) { //错误
        _questionLabel.textColor = [UIColor whiteColor];
        _questionLabel.backgroundColor = RGBCOLOR(255, 104, 94);
    }else if([correctness.isCorrect isEqualToString:@"1"]){ //正确
        _questionLabel.textColor = [UIColor whiteColor];
        _questionLabel.backgroundColor = COMMONBLUECOLOR;
    }else{ // 未答
        _questionLabel.textColor = COMMONBLUECOLOR;
        _questionLabel.layer.borderColor = [COMMONBLUECOLOR CGColor];
        _questionLabel.layer.borderWidth = 1;
    }
    _questionLabel.text = [NSString stringWithFormat:@"%ld",index+1];
}

@end
