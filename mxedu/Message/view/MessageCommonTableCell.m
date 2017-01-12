//
//  MessageCommentTableCell.m
//  mxedu
//
//  Created by 田晓鹏 on 16/12/14.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "MessageCommonTableCell.h"

#import "SysCommon.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "Comment.h"
#import "CirclePraise.h"

@implementation MessageCommonTableCell{
    
    UILabel *_nameLabel;
    UILabel *_readLabel;
    UILabel *_orgLabel;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _nameLabel = [UILabel new];
        _nameLabel.textColor = RGBCOLOR(164, 166, 170);
        _nameLabel.font = LabelFont(26);
        [self addSubview:_nameLabel];
        
        _readLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, GENERAL_SIZE(12), GENERAL_SIZE(12))];
        _readLabel.layer.cornerRadius=GENERAL_SIZE(6);
        _readLabel.layer.masksToBounds=YES;
        _readLabel.backgroundColor = [UIColor redColor];
        [self addSubview:_readLabel];
        
        _orgLabel = [UILabel new];
        _orgLabel.numberOfLines = 1;
        _orgLabel.textColor = RGBCOLOR(39, 43, 54);
        _orgLabel.font = LabelFont(30);
        [self addSubview:_orgLabel];
        
        [_readLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(15);
            make.right.equalTo(self.mas_right).offset(-15);
            make.width.equalTo(@(GENERAL_SIZE(12)));
            make.height.equalTo(@(GENERAL_SIZE(12)));
        }];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(GENERAL_SIZE(20));
            make.left.equalTo(self).offset(10);
        }];
        
        [_orgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-GENERAL_SIZE(20));
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
        }];
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = RGBCOLOR(235, 235, 235);
        [self addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
            make.left.equalTo(self);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@(GENERAL_SIZE(2)));
        }];
        
    }
    return self;
    
}

-(void)setupCell:(NSObject*)object{
    if ([object isKindOfClass:[Comment class]]) {
        Comment *comment = (Comment*)object;
        if(comment.rpyToUserId){
            _nameLabel.text = [NSString stringWithFormat:@"%@ 在问答中回复了你",comment.username];
        }else{
            _nameLabel.text = [NSString stringWithFormat:@"%@ 回答了问题：",comment.username];
        }
        _orgLabel.text = comment.title;
        if([comment.isRead isEqualToString:@"1"]){
            _readLabel.hidden = YES;
        }else{
            _readLabel.hidden = NO;
        }
    }else if ([object isKindOfClass:[CirclePraise class]]){
        CirclePraise *praise = (CirclePraise*)object;
        _nameLabel.text = [NSString stringWithFormat:@"%@ 赞了你的问答：",praise.userName];
        _orgLabel.text = praise.title;
        if([praise.isRead isEqualToString:@"1"]){
            _readLabel.hidden = YES;
        }else{
            _readLabel.hidden = NO;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
