//
//  PhotoPickerController.m
//  QYER
//
//  Created by Frank on 15/5/19.
//  Copyright (c) 2015年 QYER. All rights reserved.
//

#import "PhotoPickerController.h"
#import "PhotoCollectionViewCell.h"
#import "Masonry.h"

#import "ReactiveCocoa.h"
#import "RACEXTScope.h"
#import "UIColor+HexColor.h"

#import "NTFont.h"

@interface PhotoPickerController () <UICollectionViewDelegate, UICollectionViewDataSource>
@end

static NSString *kPhotoCell = @"PhotoCollectionViewCell";

/**
 *  底部高度
 */
static CGFloat const kBottomViewHeight = 49;

@implementation PhotoPickerController
{
    UICollectionView *_collectionView;
    
    /**
     *  数据源
     */
    NSMutableArray *_dataSource;

    /**
     *  选中的图片
     */
    NSMutableArray *_selectedPhotos;
    
    /**
     *  选中个数的label
     */
    UILabel *_countLabel;
    
    UIStatusBarStyle _previousStatusBarStyle;

}

- (void)viewWillAppear:(BOOL)animated
{
//    [super viewWillAppear:animated];
    
    _previousStatusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
//    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:_previousStatusBarStyle animated:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //显示相册名字
    self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    
    //视图
    [self setupCollectionView];
    
    //底部工具栏
    [self setupBottomView];
    
    //显示相册中的照片
    [self showAlbumPhotos];
    
    _selectedPhotos = [[NSMutableArray alloc] init];
    
    //[self setupBackButton];
    
    [self setupCancelButton];
}

- (void)setupBackButton
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, 0, 11, 20);
    [backBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void)backButtonClicked
{
    [self->_selectedPhotos removeAllObjects];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupCancelButton
{
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setTitle:@"取消" forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    button.frame = CGRectMake(0, 0, 11, 20);
//    [button addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelButtonClicked)];
    self.navigationItem.rightBarButtonItem = cancelButtonItem;
}

- (void)cancelButtonClicked
{
    if (self.cancelBlock) {
        self.cancelBlock(nil);
        self.cancelBlock = nil;
        self.finishBlock = nil;
        self.toggleBlock = nil;
    }
}

/**
 *  设置底部工具栏
 */
- (void)setupBottomView
{
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:bottomView];
    
    //提交按钮
    UIButton *button = [UIButton new];
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = [NTFont systemFontOfSize:16];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWhthHexString:@"#018BE6"] forState:UIControlStateNormal];
    [bottomView addSubview:button];
    
    [button addTarget:self action:@selector(sendButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    //当前选中的个数
    _countLabel = [UILabel new];
    _countLabel.backgroundColor = [UIColor colorWhthHexString:@"#018BE6"];
    _countLabel.font = [NTFont systemFontOfSize:12];
    _countLabel.hidden = YES;
    _countLabel.textColor = [UIColor whiteColor];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.layer.cornerRadius = 7.5;
    _countLabel.layer.masksToBounds = YES;
    [bottomView addSubview:_countLabel];
    
    @weakify(self)
    [RACObserve(_countLabel, text) subscribeNext:^(NSString *text) {
        @strongify(self)
        self->_countLabel.hidden = !text || [text isEqualToString:@"0"] || [text isEqualToString:@""];
    }];
    
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.offset(kBottomViewHeight);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bottomView.mas_centerX);
        make.centerY.equalTo(bottomView.mas_centerY);
        make.width.offset(100);
        make.height.offset(40);
    }];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top).offset(10);
        make.left.offset(self.view.bounds.size.width / 2 + 12);
        make.width.offset(15);
        make.height.offset(15);
    }];

}

- (void)sendButtonClicked
{
    if (self.finishBlock) {
        self.finishBlock(self->_selectedPhotos);
        self.finishBlock = nil;
        self.cancelBlock = nil;
        self.toggleBlock = nil;
    }
}

/**
 *  显示相册中的图片
 */
- (void)showAlbumPhotos
{
    _dataSource = [[NSMutableArray alloc] init];
    
    [self.assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
 
    [self.assetsGroup enumerateAssetsWithOptions:NSEnumerationReverse
                                  usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                      if(result) {
                                          [_dataSource addObject:result];
                                      }
                                  }];
    
    //倒序，NSEnumerationConcurrent有BUG
    _dataSource = [[[_dataSource reverseObjectEnumerator] allObjects] mutableCopy];
    [_collectionView reloadData];
    
    //滚动到最底部
    NSInteger row = _dataSource.count - 1;
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

/**
 *  设置CollectionView
 */
- (void)setupCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.allowsMultipleSelection = YES;
    _collectionView.contentInset = UIEdgeInsetsMake(0, 0, kBottomViewHeight, 0);
    _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, kBottomViewHeight, 0);
    _collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_collectionView];

    [_collectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:kPhotoCell];
}

#pragma mark - QYCollectionView DataSource

/**
 *  每个Section里面有多少个Cell
 *
 *  @param collectionView
 *  @param section
 *
 *  @return
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSource.count;
}

/**
 *  每个cell的宽度和高度
 *
 *  @param collectionView
 *  @param collectionViewLayout
 *  @param indexPath
 *
 *  @return
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.view.bounds.size.width - 3 ) / 4, (self.view.bounds.size.width - 3 ) / 4);
}

/**
 *  cell，上、左、下、右的间距
 *
 *  @param collectionView
 *  @param collectionViewLayout
 *  @param section
 *
 *  @return
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 1, 0);
}

/**
 *  Cell之间的最小间距
 *
 *  @param collectionView
 *  @param collectionViewLayout
 *  @param section
 *
 *  @return
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

/**
 *  行之间的最小间距
 *
 *  @param collectionView
 *  @param collectionViewLayout
 *  @param section
 *
 *  @return
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

/**
 *  每个Cell具体显示的内容
 *
 *  @param collectionView
 *  @param indexPath
 *
 *  @return
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCell forIndexPath:indexPath];
    
    ALAsset *asset = _dataSource[indexPath.row];
    
    if([asset isKindOfClass:[ALAsset class]]) {
        [cell.imageView setImage:[UIImage imageWithCGImage:asset.thumbnail]];
    }
    
    @weakify(self)
    [[[cell.selectButton rac_signalForControlEvents:UIControlEventTouchUpInside]
            takeUntil:cell.rac_prepareForReuseSignal]
        subscribeNext:^(UIButton *button) {
         @strongify(self)
         
         [self selectImageWithIndexPath:indexPath onButton:button];
         
    }];
    
    //通过图片名字判断，是否选中
    BOOL isSelected = [self.selectedPhotoNames containsObject:asset.defaultRepresentation.filename];
    cell.selectButton.selected = isSelected;
    
    if (isSelected) {
        if (![self->_selectedPhotos containsObject:asset]) {
            [self->_selectedPhotos addObject:asset];
        }
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell *cell = (PhotoCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    [self selectImageWithIndexPath:indexPath onButton:cell.selectButton];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell *cell = (PhotoCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    [self selectImageWithIndexPath:indexPath onButton:cell.selectButton];
}

/**
 *  选中/取消选中
 *
 *  @param indexPath
 *  @param button
 */
- (void)selectImageWithIndexPath:(NSIndexPath*)indexPath onButton:(UIButton*)button
{
    if (self->_selectedPhotos.count == self.maximumNumberOfImages && !button.isSelected) {
        return ;
    }
    
    ALAsset *asset = _dataSource[indexPath.row];
    
    if (button.isSelected) {
        button.selected = NO;
        
        if ([self->_selectedPhotos containsObject:asset]) {
            [self->_selectedPhotos removeObject:asset];
        }
    }else{
        button.selected = YES;
        
        if (![self->_selectedPhotos containsObject:asset]) {
            [self->_selectedPhotos addObject:asset];
        }
    }
    
    _countLabel.text = [NSString stringWithFormat:@"%ld", self->_selectedPhotos.count];
    
    if (self.toggleBlock) {
        self.toggleBlock(asset, button.isSelected);
    }
}

@end
