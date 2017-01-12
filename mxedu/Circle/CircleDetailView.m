//
//  CircleDetailView.m
//  mxedu
//
//  Created by 田晓鹏 on 16/7/7.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "CircleDetailView.h"

#import "CircleFrame.h"
#import "UIImageView+WebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "OlaCircle.h"
#import "UIImage+MJ.h"
#import "Colours.h"
#import "UIView+Extension.h"
#import "ImageCell.h"
#import "SysCommon.h"
#import "UIColor+HexColor.h"
#import "CircleTableViewCell.h"
#import "AuthManager.h"
#import "Util.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface CircleDetailView ()<UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate,UITextViewDelegate>
{
    AVAudioPlayer *avPlay;
}

@end

@implementation CircleDetailView

CircleTableViewCell *cell;
AuthManager *am;

#pragma mark - 初始化方法
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        //1,添加头像
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.userInteractionEnabled=YES;
        iconView.clipsToBounds = YES;
        iconView.layer.cornerRadius = GENERAL_SIZE(40);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickHeadImage)];
        [iconView addGestureRecognizer:tap];
        [self addSubview:iconView];
        self.iconView = iconView;
        
        //2,添加昵称
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = LabelFont(28);
        nameLabel.textColor = RGBCOLOR(41, 42, 47);
        [self addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        //添加 标题按钮
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.font = LabelFont(32);
        titleLabel.textColor = RGBCOLOR(41, 42, 47);
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        //3,添加时间 地点
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.textColor = RGBCOLOR(153, 153, 153);
        timeLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:timeLabel];
        self.timeLabel = timeLabel;

        
        //4,添加正文
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.textColor = RGBCOLOR(102, 102, 102);
        textLabel.font = LabelFont(28);
        // textLabel.textAlignment=NSTextAlignmentJustified;
        textLabel.numberOfLines = 0;
        textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:textLabel];
        self.textlabel = textLabel;
        
        //5.添加图片集合
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
        
        //添加 浏览量
        UILabel *visitLabel = [[UILabel alloc]init];
        visitLabel.font = LabelFont(24);
        visitLabel.textColor = RGBCOLOR(167, 167, 167);
        [self addSubview:visitLabel];
        self.visitLabel = visitLabel;
        
        //点赞
        UIButton *praiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        praiseBtn.titleLabel.font = LabelFont(24);
        [praiseBtn setTitleColor:RGBCOLOR(162, 162, 162) forState:UIControlStateNormal];
        [praiseBtn addTarget:self action:@selector(loveClick:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:praiseBtn];
        self.praiseBtn = praiseBtn;
        
        //6,工具栏
        UIView *toolBar = [[UIView alloc] init];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = RGBCOLOR(230, 230, 230);
        [toolBar addSubview:lineView];
        
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        shareBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, GENERAL_SIZE(90));
        [shareBtn setImage:[UIImage imageNamed:@"ic_circle_share"] forState:UIControlStateNormal];
        [shareBtn setTitle:@"分享好友" forState:UIControlStateNormal];
        [shareBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -GENERAL_SIZE(20), 0.0, 0.0)];
        shareBtn.titleLabel.font = LabelFont(24);
        [shareBtn setTitleColor:RGBCOLOR(162, 162, 162) forState:UIControlStateNormal];
        [shareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchDown];
        [toolBar addSubview:shareBtn];
        
        UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-1, 2, 1, GENERAL_SIZE(80))];
        sepView.backgroundColor = RGBCOLOR(230, 230, 230);
        [toolBar addSubview:sepView];
        
        UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        commentBtn.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, GENERAL_SIZE(90));
        [commentBtn setTitle:@"添加回答" forState:UIControlStateNormal];
        [commentBtn setImage:[UIImage imageNamed:@"ic_circle_reply"] forState:UIControlStateNormal];
        [commentBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -GENERAL_SIZE(20), 0.0, 0.0)];
        [commentBtn setTitleColor:RGBCOLOR(162, 162, 162) forState:UIControlStateNormal];
        commentBtn.titleLabel.font = LabelFont(24);
        [commentBtn addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchDown];
        [toolBar addSubview:commentBtn];
        [self addSubview:toolBar];
        self.toolBar = toolBar;
        
    }
    return self;
}


-(void)didClickHeadImage{
    OlaCircle *circle = _statusFrame.result;
    User *userInfo = [[User alloc]init];
    userInfo.userId = circle.userId;
    userInfo.avatar = circle.userAvatar;
    userInfo.name = circle.userName;
    if (_delegate) {
        [_delegate didClickUserAvatar:userInfo];
    }
}

/**
 *  赞按钮点击监听
 */
- (void)loveClick:(UIButton *)button
{
    if (_delegate) {
        [_delegate didClickLove:_statusFrame.result];
    }
    [button setImage:[UIImage imageNamed:@"ic_praised"] forState:UIControlStateNormal];
    [self setupAddone:CGRectMake(_statusFrame.praiseFrame.origin.x+GENERAL_SIZE(40), _statusFrame.praiseFrame.origin.y-GENERAL_SIZE(10),20, 8)];
}

//添加点击加一效果
- (void)setupAddone:(CGRect)rect
{
    UILabel *label = [[UILabel alloc] init];
    if ([_statusFrame.result.isPraised isEqualToString:@"1"]) {
        label.text = @"-1";
    }else{
        label.text = @"+1";
    }
    label.textColor = [UIColor redColor];
    label.font = [UIFont systemFontOfSize:10];
    label.backgroundColor = [UIColor clearColor];
    label.frame = rect;
    [self addSubview:label];
    [UIView animateWithDuration:0.5 animations:^{
        label.transform = CGAffineTransformMakeScale(1.8, 1.8);
    } completion:^(BOOL finished) {
        [label removeFromSuperview];
    }];
}


/**
 *  分享按钮点击监听
 */
- (void)shareClick:(UIButton *)button
{
    if (_delegate) {
        [_delegate didClickShare:_statusFrame.result];
    }
}
/**
 *  评论按钮点击监听
 */
- (void)commentClick:(UIButton *)button
{
    if (_delegate) {
        [_delegate didClickComment:_statusFrame.result];
    }
}

- (void)setStatusFrame:(CircleFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    OlaCircle *result = statusFrame.result;
    
    _circleType = result.type;
    //1,头像
    if(result.userAvatar){
        if ([result.userAvatar rangeOfString:@".jpg"].location == NSNotFound) {
            [self.iconView sd_setImageWithURL:[NSURL URLWithString: [BASIC_IMAGE_URL stringByAppendingString:result.userAvatar]] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
        }else{
            [self.iconView sd_setImageWithURL:[NSURL URLWithString: [@"http://api.olaxueyuan.com/upload/" stringByAppendingString:result.userAvatar]] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
        }
    }else{
        self.iconView.image = [UIImage imageNamed:@"ic_avatar"];
    }
    
    self.iconView.frame = statusFrame.iconFrame;
    
    self.titleLabel.frame = statusFrame.titleFrame;
    self.titleLabel.text = result.title;
    
    self.visitLabel.frame = statusFrame.visitFrame;
    self.visitLabel.text = [NSString stringWithFormat:@"%@人浏览  %@人评论",result.readNumber,result.commentNumber];
    
    //2,昵称
    NSString *name_location = result.userName;
    if ([result.location length]>0) {
        name_location = [NSString stringWithFormat:@"%@ @%@", result.userName,result.location];
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:name_location];
    [str addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(144, 144, 144) range:NSMakeRange([result.userName length], [name_location length]-[result.userName length])];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange([result.userName length], [name_location length]-[result.userName length])];
    self.nameLabel.attributedText = str;
    self.nameLabel.frame = statusFrame.nameFrame;
    
    //3,时间
    self.timeLabel.text = result.time ;
    self.timeLabel.frame = statusFrame.timeFrame;
    
    //4,正文
    NSMutableParagraphStyle *style =  [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 3.0f;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:result.content];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [result.content length])];
    self.textlabel.attributedText = attributedString;
    self.textlabel.frame = statusFrame.textFrame;
    
    // 图片
    _imageArray = [NSMutableArray arrayWithCapacity:0];
    NSArray *array = [result.imageGids componentsSeparatedByString:@","];
    for (NSString *imageId in array) {
        if (![imageId isEqualToString:@""]) {
            if ([_circleType isEqualToString:@"1"]) { //观看记录
                [_imageArray addObject: imageId];
            }else{
                [_imageArray addObject: [BASIC_IMAGE_URL stringByAppendingString:imageId]];
            }
            
        }
    }
    [_collectionView reloadData];
    
    self.collectionView.frame = statusFrame.imageFrame;
    
    self.praiseBtn.frame = statusFrame.praiseFrame;
    [self.praiseBtn setTitle:result.praiseNumber forState:UIControlStateNormal];
    if([result.isPraised isEqualToString:@"1"]){
        [self.praiseBtn setImage:[UIImage imageNamed:@"ic_praised"] forState:UIControlStateNormal];
        [self.praiseBtn setTitleColor:RGBACOLOR(18, 112, 255,0.8) forState:UIControlStateNormal];
    }else{
        [self.praiseBtn setImage:[UIImage imageNamed:@"ic_praise"] forState:UIControlStateNormal];
        [self.praiseBtn setTitleColor:RGBACOLOR(175, 176, 179,0.8) forState:UIControlStateNormal];
    }
    [self.praiseBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -GENERAL_SIZE(10), 0.0, 0.0)];
    
    self.toolBar.frame = statusFrame.toolFrame;
    
}

#pragma mark - 图片浏览器
- (void)browsePhoto:(NSInteger)position
{
    //创建图片浏览
    MJPhotoBrowser *photoBrowser = [[MJPhotoBrowser alloc] init];
    
    NSMutableArray *photos = [NSMutableArray array];
    
    for (NSString* imageUrl in _imageArray) {
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

#pragma mark - UICollectionView Datasource
//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    if (_imageArray != nil)
    {
        if (_imageArray.count % 3 == 0) {
            return 3;
        }else {
            if(section == _imageArray.count / 3){
                return _imageArray.count % 3;
            }else{
                return 3;
            }
        }
    }
    return 0;
}
//每个section的item个数
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    if (_imageArray != nil)
    {
        return _imageArray.count % 3 == 0? _imageArray.count/3:_imageArray.count/3+ 1;
    }
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCell *cell = (ImageCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"ic_loading"];
    
    //加载图片
    if (_imageArray != nil) {
        NSString *imageUrl;
        if (indexPath.section==0) {
            imageUrl = [_imageArray objectAtIndex:indexPath.row];
        }else{
            imageUrl = [_imageArray objectAtIndex:indexPath.row+3*indexPath.section];
        }
        if ([_circleType isEqualToString:@"2"]) {
            [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imageUrl]] options:SDWebImageHighPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                if (image != nil)
                {
                    if (_imageArray.count==1) {
                        // 图片剪裁
                        CGFloat width = CGImageGetWidth([image CGImage]);
                        CGFloat height = CGImageGetHeight([image CGImage]);
                        CGRect rect = CGRectMake(0, 0, width,width*GENERAL_SIZE(300)/(SCREEN_WIDTH-GENERAL_SIZE(40)));
                        if (width*GENERAL_SIZE(300)/16.0<height) {
                            rect = CGRectMake(0, (height-width*GENERAL_SIZE(300)/(SCREEN_WIDTH-GENERAL_SIZE(40)))/2.0, width,width*GENERAL_SIZE(300)/(SCREEN_WIDTH-GENERAL_SIZE(40)));
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
    if ([_circleType isEqualToString:@"2"]){
        [self browsePhoto:position];
    }
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_imageArray.count > 1) {
        return CGSizeMake((SCREEN_WIDTH-GENERAL_SIZE(80))/3, SCREEN_WIDTH/4);
    }else{
        return CGSizeMake(SCREEN_WIDTH-GENERAL_SIZE(40), GENERAL_SIZE(300));
    }
    
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 0, 5, 0);
}


@end
