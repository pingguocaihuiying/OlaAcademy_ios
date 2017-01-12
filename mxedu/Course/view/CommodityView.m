//
//  CommodityView.m
//  mxedu
//
//  Created by 田晓鹏 on 16/11/9.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "CommodityView.h"

#import "SysCommon.h"
#import "Masonry.h"
#import "CommodityPayVC.h"

@implementation CommodityView{
    
    UIScrollView *scrollView;
    
    UILabel *nameLabel;
    UILabel *numberLabel;
    UIImageView *orgIV;
    UILabel *orgLabel;
    UILabel *suitContent;
    UILabel *timeContent;
    UILabel *descriptionLabel;
    UILabel *descriptionL;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubView];
    }
    return self;
}

-(void)setupSubView{
    
    scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    // 设置内容大小
    scrollView.contentSize = self.bounds.size;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView];
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 20)];
    nameLabel.font = LabelFont(32);
    [scrollView addSubview:nameLabel];
    
    numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(nameLabel.frame)+10, 200, 20)];
    numberLabel.font = LabelFont(24);
    numberLabel.font = LabelFont(30);
    numberLabel.textColor = RGBCOLOR(143, 143, 143);
    [scrollView addSubview:numberLabel];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(numberLabel.frame)+10, SCREEN_WIDTH, 1)];
    lineView1.backgroundColor = RGBCOLOR(236, 236, 236);
    [scrollView addSubview:lineView1];
    
    orgIV = [[UIImageView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(lineView1.frame)+15, 20, 20)];
    orgIV.layer.cornerRadius=10;
    orgIV.layer.masksToBounds=YES;
    [scrollView addSubview:orgIV];
    
    orgLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(orgIV.frame)+10, CGRectGetMaxY(lineView1.frame)+10, 200, 30)];
    orgLabel.font = LabelFont(24);
    orgLabel.textColor = RGBCOLOR(51, 51, 51);
    [scrollView addSubview:orgLabel];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(orgLabel.frame)+10, SCREEN_WIDTH, 10)];
    lineView2.backgroundColor = RGBCOLOR(236, 236, 236);
    [scrollView addSubview:lineView2];
    
    UILabel *suitLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView2.frame)+10, 100, 30)];
    suitLabel.text = @"适用教材";
    suitLabel.font = LabelFont(32);
    [scrollView addSubview:suitLabel];
    
    suitContent = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(suitLabel.frame)+10, SCREEN_WIDTH-10, 30)];
    suitContent.font = LabelFont(30);
    suitContent.textColor = RGBCOLOR(143, 143, 143);
    [scrollView addSubview:suitContent];
    
    UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(suitContent.frame)+10, SCREEN_WIDTH, 1)];
    lineView3.backgroundColor = RGBCOLOR(236, 236, 236);
    [scrollView addSubview:lineView3];
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView3.frame)+10, 100, 30)];
    timeLabel.text = @"课程时长";
    timeLabel.font = LabelFont(32);
    [scrollView addSubview:timeLabel];
    
    timeContent = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(timeLabel.frame)+10, 300, 30)];
    timeContent.font = LabelFont(30);
    timeContent.textColor = RGBCOLOR(143, 143, 143);
    [scrollView addSubview:timeContent];
    
    UIView *lineView4 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(timeContent.frame)+10, SCREEN_WIDTH, 10)];
    lineView4.backgroundColor = RGBCOLOR(236, 236, 236);
    [scrollView addSubview:lineView4];
    
    descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView4.frame)+10, 100, 30)];
    descriptionLabel.text = @"课程描述";
    descriptionLabel.font = LabelFont(32);
    [scrollView addSubview:descriptionLabel];
    
    descriptionL = [[UILabel alloc]init];;
    descriptionL.font = LabelFont(28);
    descriptionL.textColor = RGBCOLOR(143, 143, 143);
    descriptionL.numberOfLines = 0;
    [scrollView addSubview:descriptionL];

}

-(void)setupWithModel:(Commodity*)commodity{
    nameLabel.text = commodity.name;
    numberLabel.text = commodity.leanstage;
    [orgIV setImageWithURL:[NSURL URLWithString: commodity.image] placeholderImage:[UIImage imageNamed:@"ic_video"]];
    orgLabel.text = commodity.org;
    suitContent.text = commodity.suitto;
    timeContent.text = [NSString stringWithFormat:@"共%@课，%@分钟",commodity.videonum,commodity.totaltime];
    
    descriptionL.text = commodity.detail;
    //根据普通文本计算正文的范围
    NSMutableParagraphStyle *style =  [[NSMutableParagraphStyle alloc] init];
    NSDictionary *attributes = @{NSFontAttributeName: LabelFont(30),NSParagraphStyleAttributeName:style};
    CGRect rect = [commodity.detail boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attributes
                                         context:nil];
    descriptionL.frame = CGRectMake(10, CGRectGetMaxY(descriptionLabel.frame), SCREEN_WIDTH-20, rect.size.height);
    
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(descriptionL.frame));
    
}


@end
