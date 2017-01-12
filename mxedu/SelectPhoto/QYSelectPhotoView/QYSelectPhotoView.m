//
//  QYSelectPhotoView.m
//  Frank
//
//  Created by Frank on 15/5/20.
//  Copyright (c) 2015年 Frank. All rights reserved.
//

#import "QYSelectPhotoView.h"

#import "QYSelectPhotoCell.h"

#import "PhotoModel.h"

#import "PhotoManager.h"

#import <AssetsLibrary/AssetsLibrary.h>

#import "CXPhotoBrowser.h"

#import "ReactiveCocoa.h"
#import "RACEXTScope.h"

#import "UIImageView+WebCache.h"

#import "Masonry.h"
#import "UIColor+HexColor.h"
#import "UIView+Positioning.h"

@interface QYSelectPhotoView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CXPhotoBrowserDelegate, CXPhotoBrowserDataSource>

@end

static NSString* const kCellString = @"QYSelectPhotoViewCell";

/**
 *  图片的宽度
 */
static CGFloat const kWidth = 80;

/**
 *  图片中间的间距
 */
static CGFloat const kSpace = 15;

@implementation QYSelectPhotoView
{
    UICollectionView *_collectionView;
    
    NSMutableArray *_photoNames;
    
    UIButton *_addPhotoButton;
    
    CXPhotoBrowser *_photoBrowser;
    
    CXBrowserNavBarView *_navBarView;
    
    NSMutableArray *_photoDataSource;
    
    NSInteger _photoIndex;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //默认最多选择9张图片
        self.maximumNumberOfImages = 9;
        
        _dataSource = [[NSMutableArray alloc] init];
        _photoNames = [[NSMutableArray alloc] init];
        
        _isEnable = YES;
        
        [self setupSubviews];
    }
    return self;
}

/**
 *  创建一个横向滚动的UICollectionView
 */
- (void)setupSubviews
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = self.isEnable ? UICollectionViewScrollDirectionVertical :UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.collectionViewLayout = layout;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_collectionView];

    [_collectionView registerClass:[QYSelectPhotoCell class] forCellWithReuseIdentifier:kCellString];
    [_collectionView reloadData];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
}

/**
 *  创建『添加按钮』
 */
- (void)setupAddPhotoButton
{
    if (!_addPhotoButton) {
        _addPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addPhotoButton setBackgroundImage:[UIImage imageNamed:@"Photo_AddPhoto"] forState:UIControlStateNormal];
        _addPhotoButton.frame = CGRectMake(_collectionView.bounds.size.width - kWidth, 0, kWidth, kWidth);
        
        @weakify(self)
        _addPhotoButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            
            [self showSelectPhotoView];
            
            return [RACSignal empty];
        }];
        [self addSubview:_addPhotoButton];
    }
}

/**
 *  弹出『拍照』或者『选择照片视图控制器』
 */
- (void)showSelectPhotoView
{
    [self.superview endEditing:YES];
    
    [PhotoManager shareManager].delegate = self.delegate;
    [PhotoManager shareManager].type =2;
    @weakify(self)
    [[PhotoManager shareManager] showPhotoView:^(NSArray *photoModels, PhotoManagerSourceType type) {
        @strongify(self)
        
        if (type == PhotoManagerSourceTypeCancel || type == PhotoManagerSourceTypeOther) {
            //移除图像视图
            if ([self.dataSource count]==0) {
                if (self.isHiddenAdd) {
                     [self removeFromSuperview];
                }
            }
            return ;
        }
        
        if (type == PhotoManagerSourceTypePhotoLibrary) {
            //移除已经选中的图片
//            [self->_dataSource removeAllObjects];
            
            //移除已经存储的图片名字
//            [self->_photoNames removeAllObjects];
        }
        
        if (photoModels.count > 0) {
            
            
            //存储图片和图片名字
            for (PhotoModel *photo in photoModels) {
                BOOL isAdd = YES;
                
                for (PhotoModel *p in self->_dataSource) {
                    if ([p isKindOfClass:[PhotoModel class]]) {
                        if ([p.photoName isEqualToString:photo.photoName]) {
                            isAdd = NO;
                            break;
                        }
                    }
                    
                }
                if (isAdd) {
                    [self->_dataSource addObject:photo];
                }
                
                if (photo.photoName && ![photo.photoName isEqualToString:@""] && ![self->_photoNames containsObject:photo.photoName]) {
                    [self->_photoNames addObject:photo.photoName];
                }
            }
            
        }
        
        if (_photoDelegate) {
            [_photoDelegate didShowSelectPhoto];
        }
        
        [self->_collectionView reloadData];
        
    } withMaxSelect:self.maximumNumberOfImages withSelectedPhotoNames:_photoNames];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    CGFloat right = 0;
    
    NSInteger count = _dataSource.count;
    
    if (!_isEnable) {
        return MIN(count, self.maximumNumberOfImages);
    }
    //选择图片之后，是否还有位置显示『添加按钮』
    CGFloat number = collectionView.bounds.size.width - kSpace * (count + 1) - kWidth * (count + 1);
    
    //如果没有图片，默认显示『拍照按钮』
    if (_dataSource.count == 0) {
        
         count = 1;
 
            [_addPhotoButton removeFromSuperview];
            _addPhotoButton = nil;
    }else if (_dataSource.count < self.maximumNumberOfImages && number > 0) {
        //如果图片数量小于允许最大数，并且还有位置显示『添加按钮』，那么把『添加按钮』显示在Cell中
        
        count = _dataSource.count + 1;
        if (self.isHiddenAdd==NO) {
            [self setupAddPhotoButton];
        }
        [_addPhotoButton removeFromSuperview];
        _addPhotoButton = nil;
        
    }else if (_dataSource.count < self.maximumNumberOfImages && number < 0) {
        //如果图片数量小于允许最大数，但没有位置显示『添加按钮』，那么把『添加按钮』显示在最右侧
        
//        right = kWidth + kSpace;
//        
//        //在右侧显示添加按钮
        if (self.isHiddenAdd==NO) {
             [self setupAddPhotoButton];
        }
        count = _dataSource.count + 1;
        
        [_addPhotoButton removeFromSuperview];
        _addPhotoButton = nil;
        
    }else if (_dataSource.count == self.maximumNumberOfImages) {
        //如果图片数量和最大数相等，去掉『添加按钮』
        
        [_addPhotoButton removeFromSuperview];
        _addPhotoButton = nil;
        
    }
    
    //通过改变『添加按钮』的位置，控制CollectionView距离右侧的距离
    
    collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, right);
    collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, right);
    
    return count;
}

- (QYSelectPhotoCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QYSelectPhotoCell *cell = (QYSelectPhotoCell*)[collectionView dequeueReusableCellWithReuseIdentifier:kCellString forIndexPath:indexPath];
    
    if (self.isEnable) {
        //默认显示『拍照按钮』
        UIImage *image = [UIImage imageNamed:@"ic_choose_photo"];
        
        if (_dataSource.count > 0) {
            
            if (_dataSource.count == indexPath.row) {
                //如果已经选择图片，最后一个cell，显示『添加按钮』
                
                image = [UIImage imageNamed:@"ic_choose_photo"];
                cell.imageView.image = image;
                return cell;
                
            }else{
                //其他Cell显示选择的图片
                
                PhotoModel *model = _dataSource[indexPath.row];
                if ([model isKindOfClass:[PhotoModel class]]) {
                    image = [UIImage imageWithData:model.thumbnailData];
                }
            }
        }
        
        if (_dataSource.count > 0) {
            
            PhotoModel *model = _dataSource[indexPath.row];
            if ([model isKindOfClass:[PhotoModel class]]) {
                cell.imageView.image = image;
            }else {
                [cell.imageView sd_setImageWithURL:_dataSource[indexPath.row]];
            }
        }else{
            if (image) {
                cell.imageView.image = image;
            }
        }
      
        
    }else{
        [cell.imageView sd_setImageWithURL:_dataSource[indexPath.row]];
    }

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kWidth, kWidth);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kSpace;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //点击『拍照按钮』和『添加按钮』，弹出选择照片控制器
    if (((_dataSource.count == 0) || (indexPath.row == _dataSource.count)) && self.isEnable) {
        [self showSelectPhotoView];
    }else{
        [self showPhotoBrowser:indexPath.row];
    }
}

/**
 *  显示图片浏览器
 *
 *  @param index
 */
- (void)showPhotoBrowser:(NSInteger)index
{
    if (!_photoBrowser) {
        _photoBrowser = [[CXPhotoBrowser alloc] initWithDataSource:self delegate:self];
        _photoBrowser.wantsFullScreenLayout = YES;
        _photoBrowser.isFromAlbum = self.isEnable;
    }
    
    _photoDataSource = [[NSMutableArray alloc] init];
    CXPhoto *photo = nil;
    for (id model in _dataSource) {
        if (self.isEnable && [model isKindOfClass:[PhotoModel class]]) {
            PhotoModel *pModel = (PhotoModel*)model;
            photo = [[CXPhoto alloc] initWithImage:[UIImage imageWithData:pModel.photoData]];
        }else {
            photo = [[CXPhoto alloc] initWithURL:model];
            photo.imageUrl = ((NSURL*)model).relativeString;
        }
        
        [_photoDataSource addObject:photo];
    }
    
    [_photoBrowser reloadData];
    
    [_photoBrowser setInitialPageIndex:index];
    
    
    UINavigationController *nav = self.delegate.navigationController;
    
    [nav setNavigationBarHidden:YES];
    [nav.visibleViewController.navigationController pushViewController:_photoBrowser animated:YES];
}

#pragma mark - CXPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(CXPhotoBrowser *)photoBrowser
{
    return _photoDataSource.count;
}

- (id <CXPhotoProtocol>)photoBrowser:(CXPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < _photoDataSource.count)
        return [_photoDataSource objectAtIndex:index];
    return nil;
}

- (CXBrowserNavBarView *)browserNavigationBarViewOfOfPhotoBrowser:(CXPhotoBrowser *)photoBrowser withSize:(CGSize)size {
    
    if (!_navBarView)
    {
        CGRect frame;
        frame.origin = CGPointMake(0, 0);
        frame.size = CGSizeMake(size.width, 64);
        
        _navBarView = [[CXBrowserNavBarView alloc] initWithFrame:frame];
        
        [_photoBrowser.view bringSubviewToFront:_navBarView];
        
        UIView *view = [[UIView alloc] initWithFrame:_navBarView.frame];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.68;
        [_navBarView addSubview:view];
        
        //返回键
        UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.backgroundColor = [UIColor clearColor];
        backButton.frame = CGRectMake(20, 28, 20, 20);
        [backButton setBackgroundImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backFromPhotoViewButton) forControlEvents:UIControlEventTouchUpInside];
        [_navBarView addSubview:backButton];
        
        if (self.isEnable) {
            //删除按钮
            UIButton * delButton = [UIButton buttonWithType:UIButtonTypeCustom];
            delButton.tag = 1003;
            delButton.selected = YES;
            delButton.backgroundColor = [UIColor clearColor];
            delButton.frame = CGRectMake(self.bounds.size.width - 16, 25, 24, 24);
            [delButton setBackgroundImage:[UIImage imageNamed:@"Photo_Delete"] forState:UIControlStateNormal];
            [delButton addTarget:self action:@selector(deleteButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
            [_navBarView addSubview:delButton];
        }
        
    }
    
    return _navBarView;
}

- (void)photoBrowser:(CXPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index
{
    _photoIndex = index;
}

/**
 *  删除按钮触发的方法
 *
 *  @param button
 */
- (void)deleteButtonHandler:(UIButton*)button
{
    //是否从图片名字数组中移除
    BOOL isRemoveFromNames = NO;
    
    //从数据源中删除
    if (_dataSource.count > _photoIndex) {
        PhotoModel *model = _dataSource[_photoIndex];
        
        if ([model isKindOfClass:[PhotoModel class]]) {
            //如果图片是刚拍照获取，图片名称是nil，就不需要从图片名字数组中移除
            isRemoveFromNames = model.photoName;
        }
        
        [_dataSource removeObjectAtIndex:_photoIndex];
        [_collectionView reloadData];
    }
    
    //从图片名称中删除
    if (_photoNames.count > _photoIndex && isRemoveFromNames) {
        [_photoNames removeObjectAtIndex:_photoIndex];
    }
    
    //从图片浏览器中删除
    if (_photoDataSource.count > _photoIndex) {
        
        [_photoDataSource removeObjectAtIndex:_photoIndex];
        
        if (_photoDataSource.count == _photoIndex) {
            _photoIndex--;
        }
        [_photoBrowser setInitialPageIndex:_photoIndex];
        [_photoBrowser reloadData];
        
        //如果图片没了，关闭图片浏览器
        if (_photoDataSource.count == 0) {
            //移除图像视图
            [self removeFromSuperview];
            [self backFromPhotoViewButton];
        }
    }
}

/**
 *  返回上一个视图控制器
 */
- (void)backFromPhotoViewButton {
    UINavigationController *nav = self.delegate.navigationController;
    [nav.visibleViewController.navigationController popViewControllerAnimated:YES];
}

/**
 *  所有的大图数据
 *
 *  @return
 */
- (NSArray*)photoData
{
    NSMutableArray *photos = [NSMutableArray new];
    for (PhotoModel *model in _dataSource) {
        if ([model isKindOfClass:[PhotoModel class]]) {
            [photos addObject:model.photoData];
        }else{
            [photos addObject:model];
        }
        
    }
    return photos;
}
- (NSArray*)smallphotoData
{
    NSMutableArray *photos = [NSMutableArray new];
    for (PhotoModel *model in _dataSource) {
        if ([model isKindOfClass:[PhotoModel class]]) {
            [photos addObject:model.thumbnailData];
        }else{
            [photos addObject:model];
        }
        
    }
    return photos;
}
- (NSArray*)photoAngle
{
    NSMutableArray *angles = [NSMutableArray new];
    for (PhotoModel *model in _dataSource) {
        if ([model isKindOfClass:[PhotoModel class]]) {
            [angles addObject:model.photoAngle?model.photoAngle:@"0"];
        }else{
            [angles addObject:model];
        }
        
    }
    return angles;
}
- (void)setIsEnable:(BOOL)isEnable
{
    if (_isEnable != isEnable) {
        _isEnable = isEnable;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = self.isEnable ? UICollectionViewScrollDirectionHorizontal : UICollectionViewScrollDirectionVertical;
        _collectionView.scrollEnabled = self.isEnable;
        _collectionView.collectionViewLayout = layout;
        [_collectionView reloadData];
    }
}

- (void)reloadData
{
    [_collectionView reloadData];
}

@end
