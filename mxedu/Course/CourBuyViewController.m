//
//  CourBuyViewController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/5/28.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "CourBuyViewController.h"

#import "SysCommon.h"
#import "Masonry.h"
#import "CommodityPayVC.h"

@interface CourBuyViewController ()

@end

@implementation CourBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"课程详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupBackButton];
    
    [self setupSubView];
    
}

- (void)setupBackButton
{
    self.navigationController.navigationBarHidden = NO;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    [backBtn sizeToFit];
    [backBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

-(void)setupSubView{
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300, 20)];
    nameLabel.text = _commodity.name;
    nameLabel.font = LabelFont(32);
    [self.view addSubview:nameLabel];
    
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(nameLabel.frame)+10, 200, 20)];
    numberLabel.font = LabelFont(24);
    numberLabel.text = _commodity.leanstage;
    numberLabel.font = LabelFont(30);
    numberLabel.textColor = RGBCOLOR(143, 143, 143);
    [self.view addSubview:numberLabel];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(numberLabel.frame)+10, SCREEN_WIDTH, 1)];
    lineView1.backgroundColor = RGBCOLOR(236, 236, 236);
    [self.view addSubview:lineView1];
    
    UIImageView *orgIV = [[UIImageView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(lineView1.frame)+15, 20, 20)];
    orgIV.layer.cornerRadius=10;
    orgIV.layer.masksToBounds=YES;
    [self.view addSubview:orgIV];
    [orgIV setImageWithURL:[NSURL URLWithString: _commodity.image] placeholderImage:[UIImage imageNamed:@"ic_video"]];
    
    UILabel *orgLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(orgIV.frame)+10, CGRectGetMaxY(lineView1.frame)+10, 200, 30)];
    orgLabel.text = _commodity.org;
    orgLabel.font = LabelFont(24);
    orgLabel.textColor = RGBCOLOR(51, 51, 51);
    [self.view addSubview:orgLabel];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(orgLabel.frame)+10, SCREEN_WIDTH, 10)];
    lineView2.backgroundColor = RGBCOLOR(236, 236, 236);
    [self.view addSubview:lineView2];
    
    UILabel *suitLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView2.frame)+10, 100, 30)];
    suitLabel.text = @"适用教材";
    suitLabel.font = LabelFont(32);
    [self.view addSubview:suitLabel];
    
    UILabel *suitContent = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(suitLabel.frame)+10, SCREEN_WIDTH-10, 30)];
    suitContent.text = _commodity.suitto;
    suitContent.font = LabelFont(30);
    suitContent.textColor = RGBCOLOR(143, 143, 143);
    [self.view addSubview:suitContent];
    
    UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(suitContent.frame)+10, SCREEN_WIDTH, 1)];
    lineView3.backgroundColor = RGBCOLOR(236, 236, 236);
    [self.view addSubview:lineView3];
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView3.frame)+10, 100, 30)];
    timeLabel.text = @"课程时长";
    timeLabel.font = LabelFont(32);
    [self.view addSubview:timeLabel];
    
    UILabel *timeContent = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(timeLabel.frame)+10, 300, 30)];
    timeContent.text = [NSString stringWithFormat:@"共%@课，%@分钟",_commodity.videonum,_commodity.totaltime];
    timeContent.font = LabelFont(30);
    timeContent.textColor = RGBCOLOR(143, 143, 143);
    [self.view addSubview:timeContent];
    
    UIView *lineView4 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(timeContent.frame)+10, SCREEN_WIDTH, 10)];
    lineView4.backgroundColor = RGBCOLOR(236, 236, 236);
    [self.view addSubview:lineView4];

    UILabel *descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView4.frame)+10, 100, 30)];
    descriptionLabel.text = @"课程描述";
    descriptionLabel.font = LabelFont(32);
    [self.view addSubview:descriptionLabel];
    
    UITextView *descriptionTV = [UITextView new];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:LabelFont(28),
                                 NSForegroundColorAttributeName: RGBCOLOR(144, 144, 144),
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    descriptionTV.attributedText = [[NSAttributedString alloc] initWithString: _commodity.detail attributes:attributes];
    [self.view addSubview:descriptionTV];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT-GENERAL_SIZE(96)-UI_NAVIGATION7_BAR_HEIGHT, SCREEN_WIDTH, GENERAL_SIZE(96))];
    [self.view addSubview:bottomView];
    
    UIView *lineView5 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    lineView5.backgroundColor = RGBCOLOR(236, 236, 236);
    [bottomView addSubview:lineView5];
    
    UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 50, GENERAL_SIZE(96))];
    priceLabel.textColor = RGBCOLOR(255, 106, 0);
    priceLabel.text = [NSString stringWithFormat:@"¥%@",_commodity.price];
    [bottomView addSubview:priceLabel];
    
    UILabel *buyerLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 0, 100, GENERAL_SIZE(96))];
    buyerLabel.text = [NSString stringWithFormat:@"%@人购买",_commodity.paynum];
    buyerLabel.font = LabelFont(24);
    buyerLabel.textColor = RGBCOLOR(143, 143, 143);
    [bottomView addSubview:buyerLabel];

    UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyButton setBackgroundImage:[UIImage imageNamed:@"btn_buy"] forState:UIControlStateNormal];
    [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyButton sizeToFit];
    [buyButton addTarget:self action:@selector(buyCourse) forControlEvents:UIControlEventTouchDown];
    [bottomView addSubview:buyButton];
    
    [buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView);
        make.right.equalTo(bottomView.mas_right).offset(-10);
    }];
    
    [descriptionTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descriptionLabel.mas_bottom);
        make.bottom.equalTo(bottomView.mas_top);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
    }];

}

-(void)buyCourse{
    CommodityPayVC *payVC = [[CommodityPayVC alloc]init];
    payVC.commodity = _commodity;
    [self.navigationController pushViewController:payVC animated:YES];
}

-(void)backButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
