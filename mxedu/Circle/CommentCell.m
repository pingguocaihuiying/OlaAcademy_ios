//
//  WKCommentCell.m
//  WKDemo
//
//  Created by apple on 14-8-10.
//  Copyright (c) 2014年 com.app. All rights reserved.
//

#import "CommentCell.h"
#import "UIImageView+WebCache.h"
#import "Comment.h"
#import "SysCommon.h"
#import "Masonry.h"
#import "UIColor+HexColor.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface CommentCell ()
{
    NSArray *picArray;//图片数组
}
@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UIImageView *levelView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UIImageView *sexView;
@property (nonatomic, weak) UILabel *content;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UILabel *localLabel;

@end
@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *icon = [[UIImageView alloc] init];
        icon.userInteractionEnabled=YES;
        icon.layer.cornerRadius = 4.0;
        icon.layer.masksToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickHeadImage)];
        [icon addGestureRecognizer:tap];
        [self addSubview:icon];
        self.iconView = icon;
        
        UIImageView *level = [[UIImageView alloc] init];
        [self addSubview:level];
        self.levelView = level;
        
        UILabel *nameL = [[UILabel alloc] init];
        nameL.font = [UIFont systemFontOfSize:16.0];
        //nameL.contentMode = UIViewContentModeTop;
        nameL.textColor = [UIColor colorWhthHexString:@"#000000"];
        [self addSubview:nameL];
        self.nameLabel = nameL;
        
        UILabel *content = [[UILabel alloc] init];
        content.font = [UIFont systemFontOfSize:14.0];
        content.numberOfLines = 0;
        content.lineBreakMode = NSLineBreakByWordWrapping; //以字符为显示单位显示，后面部分省略不显示
        content.textColor = [UIColor colorWhthHexString:@"#333333"];
        [self addSubview:content];
        self.content = content;
        
        UILabel *timeL = [[UILabel alloc] init];
        timeL.font = [UIFont systemFontOfSize:12.0];
        timeL.textColor = [UIColor grayColor];
        timeL.contentMode = UIViewContentModeTopRight;
        [self addSubview:timeL];
        self.timeLabel = timeL;
        
        UILabel *localL = [[UILabel alloc] init];
        localL.font = [UIFont systemFontOfSize:12.0];
        localL.textColor = [UIColor grayColor];
        localL.contentMode = UIViewContentModeTopRight;
        [self addSubview:localL];
        self.localLabel = localL;

    }
    return self;
}
-(void)didClickHeadImage{
}
-(void)praiseClick{
    if (_cellDelegate) {
        [_cellDelegate didPraiseAction:self];
    }
}
- (void)setCommentR:(Comment *)commentR
{
    _commentR = commentR;
    
    //布局
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(5);
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.height.equalTo(@36);
        make.width.equalTo(@36);
    }];
    [self.levelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.iconView.mas_right).offset(0);
        make.bottom.equalTo(self.iconView.mas_bottom).offset(0);
        make.height.equalTo(@10);
        make.width.equalTo(@10);
    }];
    if ([commentR.opproveStatus isEqualToString:@"2"]) {
        self.levelView.image = [UIImage imageNamed:@"ic_opprove"];
    }
    CGSize namesize = [commentR.username sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17.0],NSFontAttributeName, nil]];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(5);
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.height.equalTo(@(namesize.height));
        make.width.equalTo(@(namesize.width));
    }];
    CGFloat contentW = SCREEN_WIDTH-55;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15.0]};
    CGRect rect = [commentR.content isEqualToString:@""] ? CGRectZero :[commentR.content boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:attributes
                                                 context:nil];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(5);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.height.equalTo(@(rect.size.height));
        make.width.equalTo(@(SCREEN_WIDTH-55));
    }];

    CGSize timesize = [commentR.passtime sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13.0],NSFontAttributeName, nil]];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(5);
        make.top.equalTo(self.content.mas_bottom).offset(5);
        make.height.equalTo(@(timesize.height));
        make.width.equalTo(@(timesize.width+5));
    }];
    CGSize localsize = [commentR.local sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13.0],NSFontAttributeName, nil]];
    [self.localLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_right).offset(5);
        make.top.equalTo(self.content.mas_bottom).offset(5);
        make.height.equalTo(@(localsize.height));
        make.width.equalTo(@(localsize.width));
    }];

    if (commentR.profile_image) {
        if ([commentR.profile_image rangeOfString:@".jpg"].location == NSNotFound) {
            [self.iconView sd_setImageWithURL:[NSURL URLWithString: [BASIC_IMAGE_URL stringByAppendingString:commentR.profile_image]] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
        }else{
            [self.iconView sd_setImageWithURL:[NSURL URLWithString: [@"http://api.olaxueyuan.com/upload/" stringByAppendingString:commentR.profile_image]] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
        }
    }else{
        self.iconView.image = [UIImage imageNamed:@"ic_avatar"];
    }
    

    self.nameLabel.text = commentR.username;
    
    self.timeLabel.text = commentR.passtime;
    
    if (commentR.rpyToUserName) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"@%@ %@",commentR.rpyToUserName,commentR.content]];
        [str addAttribute:NSForegroundColorAttributeName value:COMMONBLUECOLOR range:NSMakeRange(0, commentR.rpyToUserName.length+1)];
        self.content.attributedText = str;
    }else{
        self.content.text = commentR.content;
    }
 
    self.timeLabel.text = commentR.passtime;
    
    self.localLabel.text = commentR.local;

}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"comment";
    CommentCell *cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    return cell;
}
@end
