//
//  AlbumListController.m
//  QYER
//
//  Created by Frank on 15/5/19.
//  Copyright (c) 2015年 QYER. All rights reserved.
//

#import "AlbumListController.h"
#import "AlbumTableViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

#import "PhotoPickerController.h"
#import "Masonry.h"

@interface AlbumListController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation AlbumListController
{
    UITableView *_tableView;
    
    NSMutableArray *_dataSource;
    
    ALAssetsLibrary *_assetsLibrary;
    
    UIStatusBarStyle _previousStatusBarStyle;
    
    BOOL _isPushed;
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
    
    
    //表格视图
    [self setupTableView];
    
    //显示相册列表
    [self showAlbumList];
    
    self.title = @"相册列表";
    
    [self setupBackButton];
}

- (void)setupBackButton
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"ic_back_white"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, 0, 20, 20);
    [backBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void)backButtonClicked
{
    if (self.cancelBlock) {
        self.cancelBlock(nil);
        self.cancelBlock = nil;
        self.toggleBlock = nil;
        self.finishBlock = nil;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  默认显示第一个相册的图片
 */
- (void)showPhotoCollection
{
    if (_dataSource.count > 0) {
        if (_isPushed) {
            return;
        }
        _isPushed = YES;
        
        ALAssetsGroup *group = _dataSource[0];
        [self pushPhotoPickerController:group animated:NO];
    }
}

/**
 *  显示相册列表
 */
- (void)showAlbumList
{
    _assetsLibrary = [[ALAssetsLibrary alloc] init];
    
    _dataSource = [[NSMutableArray alloc] init];
    
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                  usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                      if(group) {
                                          //Set saved photos album to be first in the list
                                          if([[group valueForProperty:ALAssetsGroupPropertyType] isEqual:[NSNumber numberWithInteger:ALAssetsGroupSavedPhotos]]) {
                                              [_dataSource insertObject:group atIndex:0];
                                              [_tableView reloadData];
                                          } else {
                                              [_dataSource addObject:group];
                                          }
                                      }
                                  } failureBlock:^(NSError *error) {
                                      //TODO: HANDLE ERROR (NO ACCESS)
                                  }];
}

/**
 *  创建表格
 */
- (void)setupTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [self showPhotoCollection];
    
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44.0;
    ALAssetsGroup *assetsGroup = _dataSource[indexPath.row];
    
    if([assetsGroup isKindOfClass:[ALAssetsGroup class]]) {
        //Get thumbnail size
        CGSize thumbnailSize = CGSizeMake(CGImageGetWidth(assetsGroup.posterImage), CGImageGetHeight(assetsGroup.posterImage));
        
        CGSize itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width - (5*2.0))/4.0, 100);
        height = CGSizeMake(itemSize.width, thumbnailSize.height / thumbnailSize.width * itemSize.width).height;
    }
    return height;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellString = @"cellString";
    AlbumTableViewCell *albumCell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (!albumCell) {
        albumCell = [[AlbumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellString];
    }
    
    ALAssetsGroup *assetsGroup = _dataSource[indexPath.row];
    
    if([assetsGroup isKindOfClass:[ALAssetsGroup class]]) {
        
        
        [albumCell.imageView setImage:[UIImage imageWithCGImage:assetsGroup.posterImage]];
        [albumCell.textLabel setText:[assetsGroup valueForProperty:ALAssetsGroupPropertyName]];
        [albumCell setBackgroundColor:[UIColor clearColor]];
        [albumCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        //Reset
        [albumCell.secondImageView setImage:nil];
        [albumCell.thirdImageView setImage:nil];
        
        //Set new thumbs
        [assetsGroup enumerateAssetsWithOptions:NSEnumerationReverse
                                     usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                         if(result) {
                                             if(index == 1) {
                                                 [albumCell.secondImageView setImage:[UIImage imageWithCGImage:result.thumbnail]];
                                                 *stop = YES;
                                             } else if(index == 2) {
                                                 [albumCell.thirdImageView setImage:[UIImage imageWithCGImage:result.thumbnail]];
                                             }
                                         }
                                     }];
    }
    
    return albumCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ALAssetsGroup *assetsGroup = _dataSource[indexPath.row];
    [self pushPhotoPickerController:assetsGroup animated:YES];
}

- (void)pushPhotoPickerController:(ALAssetsGroup*)assetsGroup animated:(BOOL)animated
{
    PhotoPickerController *ppc = [[PhotoPickerController alloc] init];
    ppc.assetsGroup = assetsGroup;
    ppc.selectedPhotoNames = [self.selectedPhotoNames mutableCopy];
    ppc.toggleBlock = self.toggleBlock;
    ppc.cancelBlock = self.cancelBlock;
    ppc.finishBlock = self.finishBlock;
    ppc.maximumNumberOfImages = self.maximumNumberOfImages;
    [self.navigationController pushViewController:ppc animated:animated];
}

@end
