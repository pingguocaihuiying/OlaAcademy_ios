//
//  CommentMediaView.m
//  mxedu
//
//  Created by 田晓鹏 on 16/12/3.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "CommentMediaView.h"

#import "SysCommon.h"
#import "MediaCollectionViewCell.h"
#import "CustomChoiceView.h"

@interface CommentMediaView() <UICollectionViewDataSource,UICollectionViewDelegate,customChoiceViewDelegate,UIImagePickerControllerDelegate,MediaCollectionViewCellDelegate>

@end

@implementation CommentMediaView
{
    CustomChoiceView *choiceView; //选择视图
    UICollectionView *mediaListView;//添加的附加文件九宫格视图
    
    NSMutableArray *_photoNames;
    NSMutableArray *_dataSource;//储存图片model
    
    NSMutableArray *_mediaDataArray;//多媒体数组
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)setup
{
    _dataSource = [[NSMutableArray alloc] init];
    _photoNames = [[NSMutableArray alloc] init];
    _mediaDataArray= [NSMutableArray array];

    [self setupContentView];
    [self setupChoiceView];
}

-(void)setupContentView{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    mediaListView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, GENERAL_SIZE(20), SCREEN_WIDTH, GENERAL_SIZE(210)) collectionViewLayout:flowLayout];
    mediaListView.delegate=self;
    mediaListView.dataSource = self;
    mediaListView.backgroundColor = [UIColor clearColor];
    [mediaListView registerClass:[MediaCollectionViewCell class] forCellWithReuseIdentifier:@"mediaCell"];
    [self addSubview:mediaListView];
}

-(void)setupChoiceView{
    choiceView = [[CustomChoiceView alloc] initWithFrame:CGRectMake(0, GENERAL_SIZE(25), SCREEN_WIDTH, GENERAL_SIZE(150))];
    choiceView.choiceDelegate=self;
    [self addSubview:choiceView];
}

-(void)didChoiceItemView:(NSInteger)itemtag{
    if (itemtag==100){
        //拍照
        if(_delegate){
            [_delegate chooseImage:1];
        }
    }else if (itemtag == 101){
        //相册
        if(_delegate){
            [_delegate chooseImage:0];
        }
    }else if (itemtag == 102){
        //视频
        if(_delegate){
            [_delegate chooseVideoFromDevice];
        }
    }else if (itemtag == 103){
        //录制
        if(_delegate){
            [_delegate shootVideoWithCamera];
        }
    }
}


-(void)refreshViewWithData:(NSMutableArray*)mediaArray{
    _mediaDataArray = mediaArray;
    [mediaListView reloadData];
    if([_mediaDataArray count]==0){
        choiceView.hidden = NO;
    }else{
        choiceView.hidden = YES;
    }
}


//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _mediaDataArray.count;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"mediaCell";
    MediaCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.localIndexpath = indexPath;
    [cell setMediaModel:_mediaDataArray[indexPath.row]];
    cell.delegate=self;
    return cell;
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH/5.0, SCREEN_WIDTH/5.0);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MediaCollectionViewCell *cell = (MediaCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell choiceCell];
    
}

#pragma delegate MediaCollectionViewCell
-(void)didChoiceCellWithModel:(mediaModel *)choiceModel local:(NSIndexPath *)localpath{
    switch ([choiceModel.type intValue]) {
        case 1:
            
            break;
            
        default:
            break;
    }
}

-(void)didRemoveCellWithModel:(mediaModel *)choiceModel{
    
    [_mediaDataArray removeObject:choiceModel];
    [mediaListView reloadData];
    if([_mediaDataArray count]==0){
        choiceView.hidden = NO;
    }
}

@end
