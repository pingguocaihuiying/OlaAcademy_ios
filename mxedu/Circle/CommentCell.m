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
#import "ImageCell.h"
#import "Util.h"
#import <AVFoundation/AVFoundation.h>

@interface CommentCell ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray *picArray;//图片数组
}
@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *content;
@property (nonatomic, weak) UIImageView *mediaView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UILabel *commentL;

@end
@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier]) {
        UIImageView *icon = [[UIImageView alloc] init];
        icon.userInteractionEnabled=YES;
        icon.layer.cornerRadius = GENERAL_SIZE(40);
        icon.layer.masksToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickHeadImage)];
        [icon addGestureRecognizer:tap];
        [self addSubview:icon];
        self.iconView = icon;
        
        UILabel *nameL = [[UILabel alloc] init];
        nameL.font = LabelFont(28);
        nameL.textColor = RGBCOLOR(40, 42, 50);
        [self addSubview:nameL];
        self.nameLabel = nameL;
        
        UILabel *content = [[UILabel alloc] init];
        content.font = [UIFont systemFontOfSize:14.0];
        content.numberOfLines = 0;
        content.lineBreakMode = NSLineBreakByWordWrapping; //以字符为显示单位显示，后面部分省略不显示
        content.textColor = [UIColor colorWhthHexString:@"#333333"];
        [self addSubview:content];
        self.content = content;
        
        //视频
        UIImageView *mediaView = [[UIImageView alloc]init];
        mediaView.userInteractionEnabled = YES;
        UITapGestureRecognizer *mediaTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickMediaView)];
        [mediaView addGestureRecognizer:mediaTap];
        [self addSubview:mediaView];
        
        UIImageView *mediaIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"media_record"]];
        [mediaView addSubview:mediaIV];
        
        [mediaIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(mediaView);
        }];
        
        self.mediaView = mediaView;
        
        UILabel *mediaL = [[UILabel alloc]init];
        mediaL.text = @"¥0.00 学习一下";
        mediaL.font = LabelFont(28);
        mediaL.textColor = [UIColor whiteColor];
        [mediaView addSubview:mediaL];
        
        [mediaL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mediaView).offset(GENERAL_SIZE(20));
            make.bottom.equalTo(mediaView.mas_bottom).offset(-GENERAL_SIZE(20));
        }];
        
        self.mediaView = mediaView;

        //添加图片集合
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-10, 100) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.allowsSelection = YES;
        _collectionView.scrollEnabled = NO;
        
        [_collectionView registerClass:[ImageCell class] forCellWithReuseIdentifier:@"ImageCell"];
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:_collectionView];
        
        UILabel *timeL = [[UILabel alloc] init];
        timeL.font = LabelFont(24);
        timeL.textColor = RGBCOLOR(165, 165, 165);
        timeL.textAlignment = NSTextAlignmentRight;
        [self addSubview:timeL];
        self.timeLabel = timeL;
        
        UILabel *commentL = [[UILabel alloc]init];
        commentL.textAlignment = NSTextAlignmentLeft;
        commentL.font = LabelFont(24);
        commentL.textColor = RGBCOLOR(165, 165, 165);
        [self addSubview:commentL];
        self.commentL = commentL;
        
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

-(void)didClickHeadImage{
    if (_cellDelegate) {
        User *userInfo = [[User alloc]init];
        userInfo.userId = _comment.userId;
        userInfo.name = _comment.username;
        userInfo.avatar = _comment.profile_image;
        [_cellDelegate didClickUserAvatar:userInfo];
    }
}

-(void)didClickAudioView{
    if (_comment.audioUrls&&![_comment.audioUrls isEqualToString:@""]) {
        NSURL * url  = [NSURL URLWithString:[BASIC_Movie_URL stringByAppendingString:_comment.videoUrls]];
        AVPlayerItem * audioItem = [[AVPlayerItem alloc]initWithURL:url];
        AVPlayer * player = [[AVPlayer alloc]initWithPlayerItem:audioItem];
        [player play];
    }
}

-(void)didClickMediaView{
    if (_cellDelegate) {
        [_cellDelegate showMediaContent:_comment];
    }
}

-(void)praiseClick{
    if (_cellDelegate) {
        [_cellDelegate didPraiseAction:self];
    }
}
- (void)setupCellWithFrame:(CommentFrame *)commentR
{
    _comment = commentR.comment;
    
    //布局
    self.iconView.frame = commentR.iconFrame;
    self.nameLabel.frame = commentR.nameFrame;
    self.content.frame = commentR.textFrame;
    self.mediaView.frame = commentR.mediaFrame;
    self.collectionView.frame = commentR.imageFrame;
    self.timeLabel.frame = commentR.timeFrame;
    self.commentL.frame = commentR.praiseFrame;
    
    if(_comment.videoImgs&&![_comment.videoImgs isEqualToString:@""]){
        [self.mediaView sd_setImageWithURL:[NSURL URLWithString: [BASIC_Movie_URL stringByAppendingString:_comment.videoImgs]] placeholderImage:[UIImage imageNamed:@"ic_video"]];
        self.mediaView.hidden = NO;
    }else{
        self.mediaView.hidden = YES;
    }

    if (_comment.profile_image) {
        if ([_comment.profile_image rangeOfString:@".jpg"].location == NSNotFound) {
            [self.iconView sd_setImageWithURL:[NSURL URLWithString: [BASIC_IMAGE_URL stringByAppendingString:_comment.profile_image]] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
        }else{
            [self.iconView sd_setImageWithURL:[NSURL URLWithString: [@"http://api.olaxueyuan.com/upload/" stringByAppendingString:_comment.profile_image]] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
        }
    }
    self.nameLabel.text = _comment.username;
    if (_comment.rpyToUserName) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"@%@ %@",_comment.rpyToUserName,_comment.content]];
        [str addAttribute:NSForegroundColorAttributeName value:COMMONBLUECOLOR range:NSMakeRange(0, _comment.rpyToUserName.length+1)];
        self.content.attributedText = str;
    }else{
        self.content.text = _comment.content;
    }
    self.timeLabel.text = _comment.passtime;
    self.commentL.text = [NSString stringWithFormat:@"回复 %@",_comment.subCount];
    // 图片
    picArray = [NSMutableArray arrayWithCapacity:0];
    NSArray *array = [_comment.imageIds componentsSeparatedByString:@","];
    for (NSString *imageId in array) {
        if (![imageId isEqualToString:@""]) {
            [picArray addObject: [BASIC_IMAGE_URL stringByAppendingString:imageId]];
        }
    }
    [_collectionView reloadData];
}

#pragma mark - UICollectionView Datasource
//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    if (picArray != nil)
    {
        if (picArray.count % 3 == 0) {
            return 3;
        }else {
            if(section == picArray.count / 3){
                return picArray.count % 3;
            }else{
                return 3;
            }
        }
    }
    return 0;
}
//每个section的item个数
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    if (picArray != nil)
    {
        return picArray.count % 3 == 0? picArray.count/3:picArray.count/3+ 1;
    }
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCell *cell = (ImageCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"ic_loading"];
    
    //加载图片
    if (picArray != nil) {
        NSString *imageUrl;
        if (indexPath.section==0) {
            imageUrl = [picArray objectAtIndex:indexPath.row];
        }else{
            imageUrl = [picArray objectAtIndex:indexPath.row+3*indexPath.section];
        }
        [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imageUrl]] options:SDWebImageHighPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (image != nil)
            {
                if (picArray.count==1) {
                    // 图片剪裁
                    CGFloat width = CGImageGetWidth([image CGImage]);
                    CGFloat height = CGImageGetHeight([image CGImage]);
                    CGRect rect = CGRectMake(0, 0, width,width*9/16);
                    if (width*9/16.0<height) {
                        rect = CGRectMake(0, (height-width*9/16.0)/2.0, width,width*9/16);
                    }
                    CGImageRef imagePartRef = CGImageCreateWithImageInRect([image CGImage], rect);
                    [cell.imageView setImage:[UIImage imageWithCGImage:imagePartRef]];
                }else{
                    cell.imageView.image = [Util imageBy:image withWidth:SCREEN_WIDTH/4 withHight:SCREEN_WIDTH/4];
                }
            }else{
                cell.imageView.image = [UIImage imageNamed:@"ic_loading"];
            }
        }];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger position;
    if (indexPath.section==0) {
        position = indexPath.row;
    }else{
        position = indexPath.row+3*indexPath.section;
    }
    [self browsePhoto:position];
}

#pragma mark - 图片浏览器
- (void)browsePhoto:(NSInteger)position
{
    //创建图片浏览
    MJPhotoBrowser *photoBrowser = [[MJPhotoBrowser alloc] init];
    
    NSMutableArray *photos = [NSMutableArray array];
    
    for (NSString* imageUrl in picArray) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        //浏览时查看原图
        photo.url = [NSURL URLWithString:[imageUrl stringByAppendingString:@"&type=original"]];
        // photo.url = [NSURL URLWithString:imageUrl];
        photo.save = YES;
        photo.srcImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_loading"]];
        [photos addObject:photo];
    }
    
    photoBrowser.photos = photos;
    photoBrowser.currentPhotoIndex = position;
    
    //显示
    [photoBrowser show];
    
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (picArray.count > 1) {
        return CGSizeMake(SCREEN_WIDTH/4, SCREEN_WIDTH/4);
    }else{
        return CGSizeMake(SCREEN_WIDTH-100, (SCREEN_WIDTH-100)*9/16);
    }
    
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 0, 5, 0);
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"comment";
    CommentCell *cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    return cell;
}
@end
