//
//  CourseTableViewCell.m
//  mxedu
//
//  Created by 田晓鹏 on 16/9/28.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "CourseTableViewCell.h"

#import "SysCommon.h"
#import "UIImageView+WebCache.h"

#import "UIImageView+AsyncDownload.h"

@implementation CourseTableViewCell{
    UIImageView *_videoImage;
    UILabel *_nameLabel;
    UILabel *_timeLabel;
    UIImageView *clockIV;
}

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _videoImage = [[UIImageView alloc]initWithFrame:CGRectMake(GENERAL_SIZE(30), GENERAL_SIZE(35), GENERAL_SIZE(260), GENERAL_SIZE(160))];
        [self addSubview:_videoImage];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(GENERAL_SIZE(320), GENERAL_SIZE(35), SCREEN_WIDTH-GENERAL_SIZE(350), 20)];
        _nameLabel.textColor = RGBCOLOR(39, 43, 54);
        _nameLabel.numberOfLines = 0;
        _nameLabel.font = LabelFont(30);
        [self addSubview:_nameLabel];
        
        clockIV = [[UIImageView alloc]initWithFrame:CGRectMake(GENERAL_SIZE(320), CGRectGetMaxY(_nameLabel.frame)+GENERAL_SIZE(24), 16, 16)];
        clockIV.image = [UIImage imageNamed:@"recents"];
        [self addSubview:clockIV];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(clockIV.frame)+5, CGRectGetMaxY(_nameLabel.frame)+GENERAL_SIZE(20), 200, 20)];
        _timeLabel.font = LabelFont(24);
        _timeLabel.textColor = RGBCOLOR(164, 166, 169);
        [self addSubview:_timeLabel];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, GENERAL_SIZE(229), SCREEN_WIDTH, 1)];
        lineView.backgroundColor = RGBCOLOR(240, 240, 240);
        [self addSubview:lineView];
    }
    return self;
}

-(void)setupCell:(NSObject*)model{
    NSString *pic = @"";
    if ([model isKindOfClass:[CollectionVideo class]]) {
        CollectionVideo *video = (CollectionVideo*)model;
        pic = video.videoPic;
        CGSize size = [video.videoName sizeWithFont:LabelFont(30) constrainedToSize:CGSizeMake(SCREEN_WIDTH-GENERAL_SIZE(350),10000.0f)];
        _nameLabel.frame = CGRectMake(GENERAL_SIZE(320), GENERAL_SIZE(35), size.width, size.height);
        _nameLabel.text = video.videoName;
        clockIV.frame = CGRectMake(GENERAL_SIZE(320), CGRectGetMaxY(_nameLabel.frame)+GENERAL_SIZE(24), 16, 16);
        _timeLabel.frame = CGRectMake(CGRectGetMaxX(clockIV.frame)+5, CGRectGetMaxY(_nameLabel.frame)+GENERAL_SIZE(20), 200, 20);
        _timeLabel.text = [NSString stringWithFormat:@"%@学时,%@",video.subAllNum, video.totalTime];
    }else if([model isKindOfClass:[Commodity class]]){
        Commodity *commodity = (Commodity*)model;
        pic = commodity.url;
        CGSize size = [commodity.name sizeWithFont:LabelFont(30) constrainedToSize:CGSizeMake(SCREEN_WIDTH-GENERAL_SIZE(350),10000.0f)];
        _nameLabel.frame = CGRectMake(GENERAL_SIZE(320), GENERAL_SIZE(35), size.width, size.height);
        _nameLabel.text = commodity.name;
        clockIV.frame = CGRectMake(GENERAL_SIZE(320), CGRectGetMaxY(_nameLabel.frame)+GENERAL_SIZE(24), 16, 16);
        _timeLabel.frame = CGRectMake(CGRectGetMaxX(clockIV.frame)+5, CGRectGetMaxY(_nameLabel.frame)+GENERAL_SIZE(20), 200, 20);
        _timeLabel.text = [NSString stringWithFormat:@"%@学时,%@分钟",commodity.videonum, commodity.totaltime];
    }
    
    [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",pic]] options:SDWebImageHighPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (image != nil)
        {
            // 图片剪裁
            CGRect rect = CGRectMake(0, 0, CGImageGetHeight([image CGImage])*260/160,CGImageGetHeight([image CGImage]));
            CGImageRef imagePartRef = CGImageCreateWithImageInRect([image CGImage], rect);
            [_videoImage setImage:[UIImage imageWithCGImage:imagePartRef]];
        }else{
            _videoImage.image = [UIImage imageNamed:@"ic_video"];
        }
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

