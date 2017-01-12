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
        iconView.layer.cornerRadius = 5;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickHeadImage)];
        [iconView addGestureRecognizer:tap];
        [self addSubview:iconView];
        self.iconView = iconView;
        
        //2,添加昵称
        UILabel *nameLabel = [[UILabel alloc] init];
        if (iPhone6Plus) {
            nameLabel.font = [UIFont systemFontOfSize:18];
        }else if(iPhone6){
            nameLabel.font = [UIFont systemFontOfSize:16];
        }else{
            nameLabel.font = [UIFont systemFontOfSize:14];
        }
        nameLabel.textColor = RGBCOLOR(75, 75, 75);
        [self addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        //添加 回复按钮
        UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:messageButton];
        self.messageButton = messageButton;
        
        //添加 浏览按钮
        UIButton *visitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:visitButton];
        self.visitButton = visitButton;
        
        
        //3,添加时间 地点
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.textColor = RGBCOLOR(153, 153, 153);
        timeLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:timeLabel];
        self.timeLabel = timeLabel;

        
        //4,添加正文
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.textColor = RGBCOLOR(102, 102, 102);
        textLabel.font = LabelFont(30);
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
        
        //6,工具栏
        CircleToolbar *toolBar = [[CircleToolbar alloc] init];
        [self addSubview:toolBar];
        self.toolBar = toolBar;
        self.toolBar.hidden = YES;
        
    }
    return self;
}


-(void)didClickHeadImage{
    
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
    
    self.messageButton.frame = statusFrame.messageFrame;
    [self.messageButton setImage: [UIImage imageNamed:@"ic_message"] forState:UIControlStateNormal];
    self.messageButton.titleLabel.font =[UIFont systemFontOfSize:14.0f];
    [self.messageButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0,6,0.0,0.0)];
    [self.messageButton setTitleColor:RGBCOLOR(27, 26, 36) forState:UIControlStateNormal];
    [self.messageButton setContentMode:UIViewContentModeCenter];
    
    self.visitButton.frame = statusFrame.visitFrame;
    [self.visitButton setImage: [UIImage imageNamed:@"ic_visit"] forState:UIControlStateNormal];
    NSString *numberString = result.readNumber;
    if ([result.readNumber intValue]>=1000) {
        numberString = [NSString stringWithFormat:@"%.1fk", [result.readNumber floatValue]/1000.0];
    }
    [self.visitButton setTitle:numberString forState:UIControlStateNormal];
    [self.visitButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0,6,0.0,0.0)];
    self.visitButton.titleLabel.font =[UIFont systemFontOfSize:14.0f];
    [self.visitButton setTitleColor:RGBCOLOR(27, 26, 36) forState:UIControlStateNormal];
    [self.visitButton setContentMode:UIViewContentModeCenter];
    
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
    self.textlabel.text = result.content;
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
    
    self.toolBar.frame = statusFrame.toolFrame;
    self.toolBar.circle = _statusFrame.result;
    if ([statusFrame.result.type isEqualToString:@"1"]) {
        self.toolBar.hidden = YES;
    }else{
        self.toolBar.hidden = NO;
    }
    
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
                        cell.imageView.image = [Util imageBy:image withWidth:SCREEN_WIDTH-100  withHight:(SCREEN_WIDTH-100)*9/16];
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


@end
