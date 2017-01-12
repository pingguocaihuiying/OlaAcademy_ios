//
//  TestCell.m
//  CustomProgress
//
//  Created by Admin on 2016/10/18.
//  Copyright © 2016年 杨文磊. All rights reserved.
//

#import "CommentAudioCell.h"

#import "UIColor+HexColor.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface CommentAudioCell()<CustomProgressDelegate>
{
    UIImageView *icon;
    UILabel *nameL;
    UILabel *content;
    CustomProgress *custompro;
    UILabel *timeL;
    UIButton *praiseBtn;
}

@end

@implementation CommentAudioCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier])
    {
        icon = [[UIImageView alloc] initWithFrame:CGRectMake(GENERAL_SIZE(30), GENERAL_SIZE(16), GENERAL_SIZE(80), GENERAL_SIZE(80))];
        icon.userInteractionEnabled=YES;
        icon.layer.cornerRadius = GENERAL_SIZE(40);
        icon.layer.masksToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickHeadImage)];
        [icon addGestureRecognizer:tap];
        [self addSubview:icon];
        
        nameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame) + GENERAL_SIZE(16), GENERAL_SIZE(16), 200, GENERAL_SIZE(80))];
        nameL.font = [UIFont systemFontOfSize:16.0];
        nameL.textColor = [UIColor colorWhthHexString:@"#000000"];
        [self addSubview:nameL];
        
        content = [[UILabel alloc] initWithFrame:CGRectMake(GENERAL_SIZE(30), CGRectGetMaxY(nameL.frame)+GENERAL_SIZE(20), SCREEN_WIDTH-GENERAL_SIZE(60), 20)];
        content.font = [UIFont systemFontOfSize:14.0];
        content.numberOfLines = 0;
        content.lineBreakMode = NSLineBreakByWordWrapping; //以字符为显示单位显示，后面部分省略不显示
        content.textColor = [UIColor colorWhthHexString:@"#333333"];
        [self addSubview:content];

        custompro = [[CustomProgress alloc] initWithFrame:CGRectMake(GENERAL_SIZE(30), CGRectGetMaxY(content.frame)+GENERAL_SIZE(20), GENERAL_SIZE(630), GENERAL_SIZE(80))];
        
        custompro.maxValue = 60;
        //设置背景色
        custompro.bgimg.backgroundColor = RGBCOLOR(20, 126, 251);
        custompro.leftimg.backgroundColor =[UIColor colorWithRed:252/255.0 green:252/255.0 blue:252/255.0 alpha:0.35];
        
        custompro.presentlab.textColor = [UIColor whiteColor];
        
        custompro.delegate = self;
        
        [self.contentView addSubview:custompro];
        
        timeL = [[UILabel alloc] init];
        timeL.font = LabelFont(24);
        timeL.textColor = RGBCOLOR(165, 165, 165);
        timeL.textAlignment = NSTextAlignmentRight;
        [self addSubview:timeL];
        
        praiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [praiseBtn setImage:[UIImage imageNamed:@"ic_praise"] forState:UIControlStateNormal];
        [praiseBtn setTitleColor:RGBACOLOR(175, 176, 179,0.8) forState:UIControlStateNormal];
        [praiseBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -GENERAL_SIZE(10), 0.0, 0.0)];
        praiseBtn.titleLabel.font = LabelFont(24);
        [praiseBtn setTitleColor:RGBCOLOR(165, 165, 165) forState:UIControlStateNormal];
        [self addSubview:praiseBtn];
        
        UIView *lineView =[[UIView alloc]init];
        lineView.backgroundColor = RGBCOLOR(235, 235, 235);
        [self addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-1);
            make.height.equalTo(@1);
            make.left.equalTo(self).offset(GENERAL_SIZE(20));
            make.right.equalTo(self.mas_right).offset(-GENERAL_SIZE(20));
        }];
        
    }
    return self;
}

-(void)setSdModel:(Comment *)sdModel
{
    _sdModel = sdModel;
    custompro.sdmodel = sdModel;
    
    CGFloat maxW = 0.0;
    
    NSString* contetxt = [_sdModel.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    contetxt = [contetxt stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    contetxt = [contetxt stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //根据普通文本计算正文的范围
    maxW = SCREEN_WIDTH - 2*GENERAL_SIZE(30);
    NSMutableParagraphStyle *style =  [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 3.0f;
    NSDictionary *attributes = @{NSFontAttributeName: LabelFont(30),NSParagraphStyleAttributeName:style};
    CGRect rect = [contetxt boundingRectWithSize:CGSizeMake(maxW, MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attributes
                                         context:nil];
    
    content.frame = CGRectMake(GENERAL_SIZE(30), CGRectGetMaxY(nameL.frame)+GENERAL_SIZE(20), maxW, (contetxt.length==0?0:rect.size.height));
    custompro.frame = CGRectMake(GENERAL_SIZE(30), CGRectGetMaxY(content.frame)+GENERAL_SIZE(20), GENERAL_SIZE(630), GENERAL_SIZE(80));
    timeL.frame = CGRectMake(SCREEN_WIDTH-GENERAL_SIZE(230), CGRectGetMaxY(custompro.frame)+GENERAL_SIZE(30), GENERAL_SIZE(200), GENERAL_SIZE(30));
    praiseBtn.frame = CGRectMake(GENERAL_SIZE(30), CGRectGetMaxY(custompro.frame)+GENERAL_SIZE(30), GENERAL_SIZE(60), GENERAL_SIZE(30));

    
    if (_sdModel.profile_image) {
        if ([_sdModel.profile_image rangeOfString:@".jpg"].location == NSNotFound) {
            [icon sd_setImageWithURL:[NSURL URLWithString: [BASIC_IMAGE_URL stringByAppendingString:_sdModel.profile_image]] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
        }else{
            [icon sd_setImageWithURL:[NSURL URLWithString: [@"http://api.olaxueyuan.com/upload/" stringByAppendingString:_sdModel.profile_image]] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
        }
    }
    nameL.text = _sdModel.username;
    if (_sdModel.rpyToUserName) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"@%@ %@",_sdModel.rpyToUserName,_sdModel.content]];
        [str addAttribute:NSForegroundColorAttributeName value:COMMONBLUECOLOR range:NSMakeRange(0, _sdModel.rpyToUserName.length+1)];
        content.attributedText = str;
    }else{
        content.text = _sdModel.content;
    }
    timeL.text = _sdModel.passtime;
    [praiseBtn setTitle:_sdModel.like_count forState:UIControlStateNormal];

}

-(void)didClickHeadImage{
    if (_cellDelegate) {
        User *userInfo = [[User alloc]init];
        userInfo.userId = _sdModel.userId;
        userInfo.name = _sdModel.username;
        userInfo.avatar = _sdModel.profile_image;
        [_cellDelegate didClickUserAvatar:userInfo];
    }
}

#pragma mark -- 实现代理方法..
-(void)customProgressDidTapWithPlayState:(PlayState)state andWithUrl:(NSString *)urlString
{
    if ([self.delegate respondsToSelector:@selector(customProgressDidTapWithPlayState:andWithUrl:)]) {
        [self.delegate customProgressDidTapWithPlayState:state andWithUrl:urlString];
    }
}



@end
