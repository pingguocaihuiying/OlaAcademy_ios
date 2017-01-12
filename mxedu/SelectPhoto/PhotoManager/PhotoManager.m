//
//  PhotoManager.m
//  Frank
//
//  Created by Frank on 15/3/6.
//  Copyright (c) 2015年 Frank. All rights reserved.
//

#import "PhotoManager.h"

#import "QYImageUtil.h"

#import <AssetsLibrary/AssetsLibrary.h>

#import "AlbumListController.h"

#import "ReactiveCocoa.h"
#import "RACEXTScope.h"

@interface PhotoManager () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, copy) PhotoManagerBlock block;

@property (nonatomic, copy) PhotoManagerMultipleBlock multipleBlock;

@property (nonatomic, assign) PhotoManagerSourceType sourceType;

@end


@implementation PhotoManager
{
    NSInteger _maxSelect;
}

+ (PhotoManager *)shareManager {
    
    static dispatch_once_t once;
    static PhotoManager *manager;
    
    dispatch_once(&once, ^{
        manager = [[PhotoManager alloc] init];
    });
    
    return manager;
}

/**
 *  显示获取图片的ActionSheet
 *
 *  @param block
 */
- (void)showPhotoView:(PhotoManagerBlock)block
{
    if (!self.texts) {
        self.texts = @[@"从相册选取", @"拍照"];
    }
    
    [self showPhotoView:block withTitle:self.title withTexts:self.texts];
}

/**
 *  显示获取图片的ActionSheet
 *
 *  @param block
 *  @param title 标题
 *  @param texts 显示内容
 */
- (void)showPhotoView:(PhotoManagerBlock)block withTitle:(NSString*)title withTexts:(NSArray *)texts
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"" destructiveButtonTitle:nil otherButtonTitles:@"从照片库选择", @"拍照" ,nil];
    sheet.tag = 1000;
    [sheet showInView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
    
    [[sheet rac_buttonClickedSignal] subscribeNext:^(NSNumber* x) {
        
        NSInteger index = [x integerValue];
        
        self.sourceType = index;
        
        if (index == -1) { //没有选中，关闭sheet
            if (block) {
                block(nil, PhotoManagerSourceTypeCancel);
            }
        }else{
            self.block = [block copy];
            
            if (index == 0) { //从相册选择
                
                [self getPhotoFromPhotoLibrary];
                
            }else if (index == 1) { //拍照
                [self getPhotoFromCamera];
            }else{
                if (self.block) {
                    self.block(nil, PhotoManagerSourceTypeOther);
                    self.block = nil;
                }
            }
        }
        
    }];
}


/**
 *  显示选择多张图片的视图控制器
 *
 *  @param block              完成的Block
 *  @param maxSelect          最大选择数量
 *  @param selectedPhotoNames 已经选中的图片名字
 */
- (void)showPhotoView:(PhotoManagerMultipleBlock)block withMaxSelect:(NSInteger)maxSelect withSelectedPhotoNames:(NSArray *)selectedPhotoNames
{
    self.sourceType = self.type;
    
    self.multipleBlock = [block copy];
    
    if (self.type == 0) { //从相册选择
        
        [self showPhotoSelectController:maxSelect withSelectedPhotoNames:selectedPhotoNames];
        
    }else if (self.type == 1) { //拍照
        [self getPhotoFromCamera];
    }else if (self.type == 2){  //  弹出提示框
        if (!self.texts) {
            self.texts = @[@"从照片库选取", @"拍照"];
        }
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从照片库选择", @"拍照" ,nil];
        [sheet showInView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
        
        @weakify(self)
        [[sheet rac_buttonClickedSignal] subscribeNext:^(NSNumber *x) {
            @strongify(self)
            NSInteger index = [x integerValue];
            self.sourceType = index;
            
            if (index == -1) { //没有选中，关闭sheet
                if (block) {
                    block(nil, PhotoManagerSourceTypeCancel);
                }
            }else{
//                self.multipleBlock = [block copy];
                
                if (index == 0) { //从相册选择
                    
                    [self showPhotoSelectController:maxSelect withSelectedPhotoNames:selectedPhotoNames];
                    
                }else if (index == 1) { //拍照
                    [self getPhotoFromCamera];
                }else{
                    if (self.multipleBlock) {
                        self.multipleBlock(nil, PhotoManagerSourceTypeOther);
                        self.multipleBlock = nil;
                    }
                }
            }
        }];

    }else{
        
    }
    
}

/**
 *  显示可以选择多张图片的视图控制器
 *
 *  @param maxSelect          最大选择张数
 *  @param selectedPhotoNames 已经选中的图片名字
 */
- (void)showPhotoSelectController:(NSInteger)maxSelect withSelectedPhotoNames:(NSArray *)selectedPhotoNames
{
    AlbumListController *alc = [[AlbumListController alloc] init];
    alc.maximumNumberOfImages = maxSelect;
    alc.selectedPhotoNames = selectedPhotoNames;
    
    UINavigationController *nav = (UINavigationController *)self.delegate.navigationController;
    UIViewController *rootViewController = (UIViewController*)nav.visibleViewController;
    if (rootViewController) {
        [rootViewController presentPhotoPickerController:alc animated:YES completion:nil toggle:^(ALAsset *asset, BOOL select) {
            
            NSString *filename = asset.defaultRepresentation.filename;
            if(select) {
                NSLog(@"%@ 选中", filename);
            } else {
                NSLog(@"%@ 取消选中", filename);
            }
            
        } cancel:^(NSArray *assets) {
           
            [rootViewController dismissViewControllerAnimated:YES completion:nil];
            
            if (self.multipleBlock) {
                self.multipleBlock(nil, PhotoManagerSourceTypeCancel);
                self.multipleBlock = nil;
            }
            
        } finish:^(NSArray *assets) {
            
            [rootViewController dismissViewControllerAnimated:YES completion:nil];
            
            //缩放图片
            [self performSelectorInBackground:@selector(resizeMultipleImages:) withObject:assets];
            
        }];
    }
}

/**
 *  从图片库选择图片
 */
- (void)getPhotoFromPhotoLibrary
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.view.backgroundColor = [UIColor redColor];
        
        imagePickerController.delegate = self;
        [imagePickerController.navigationBar setTintColor:[UIColor colorWithRed:60.0/255 green:60.0/255 blue:60.0/255 alpha:1]];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        UINavigationController *nav = (UINavigationController *)self.delegate.navigationController;
        if (nav) {
            UIViewController *vc = nav.topViewController.presentedViewController;
            if (!vc) {
                vc = nav.topViewController;
            }
            [vc presentViewController:imagePickerController animated:YES completion:nil];
            
        }
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取照片失败"
                                                        message:@"没有可用照片库!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

/**
 *  用摄像头拍照
 */
-(void)getPhotoFromCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        //创建图像选取控制器
        UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
        //设置图像选取控制器的来源模式为相机模式
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        //设置委托对象
        imagePickerController.delegate = self;
        //以模视图控制器的形式显示
        
        UINavigationController *nav = (UINavigationController *)self.delegate.navigationController;
        
        if (nav) {
            UIViewController *vc = nav.topViewController.presentedViewController;
            if (!vc) {
                vc = nav.topViewController;
            }
            [vc presentViewController:imagePickerController animated:YES completion:nil];

        }
    }
}

/**
 *  缩放图片
 *
 *  @param dict
 */
- (void)resizeImage:(NSDictionary*)dict
{
    UIImage *image = dict[@"image"];
    NSData *imageData = [QYImageUtil thumbnailWithImageWithoutScale:image withMaxScale:1080];
    NSData *thumbnailData = [QYImageUtil thumbnailWithImageWithoutScale:image withMaxScale:280];
    
    NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
    [item setValue:thumbnailData forKey:@"thumbnailData"];
    [item setValue:imageData forKey:@"photoData"];
    [item setValue:dict[@"photoName"] forKey:@"photoName"];
    
    [self performSelectorOnMainThread:@selector(getPhotoSuccess:) withObject:item waitUntilDone:NO];
}

/**
 *  缩放图片
 *
 *  @param dict
 */
- (void)resizeMultipleImages:(NSArray*)assets
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (ALAsset *asset in assets) {
        ALAssetRepresentation* representation = [asset defaultRepresentation];
        UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        //原尺寸
        NSData *imageData = [QYImageUtil thumbnailWithImageWithoutScale:image withMaxScale:[representation dimensions].width];
        //小图
        NSData *thumbnailData = [QYImageUtil thumbnailWithImageWithoutScale:image withMaxScale:640];
       // NSData *thumbnailData = UIImageJPEGRepresentation([UIImage imageWithCGImage:asset.thumbnail], 0.8);
        
        PhotoModel *photoModel = [[PhotoModel alloc] init];
        photoModel.photoData = imageData;
        photoModel.thumbnailData = thumbnailData;
        photoModel.photoName = asset.defaultRepresentation.filename;
        
        [array addObject:photoModel];
    }
    
    //调用完成的Block
    [self performSelectorOnMainThread:@selector(getMultiplePhotosSuccess:) withObject:array waitUntilDone:NO];
}

/**
 *  多张图片压缩完成
 *
 *  @param photoModels
 */
- (void)getMultiplePhotosSuccess:(NSArray*)photoModels
{
    if (self.multipleBlock) {
        self.multipleBlock(photoModels, PhotoManagerSourceTypePhotoLibrary);
        self.multipleBlock = nil;
    }
}


/**
 *  获取图片完成
 *
 *  @param item
 */
- (void)getPhotoSuccess:(NSDictionary*)item
{
    PhotoModel *photoModel = [[PhotoModel alloc] init];
    photoModel.photoData = item[@"photoData"];
    photoModel.thumbnailData = item[@"thumbnailData"];
    photoModel.photoName = item[@"photoName"];
    
    if (self.block) {
        self.block(photoModel, self.sourceType);
        self.block = nil;
    }
    else if (self.multipleBlock) {
        self.multipleBlock(@[photoModel], self.sourceType);
        self.multipleBlock = nil;
    }

}

#pragma mark - Image picker delegate

/**
 *  获取图片之后的回调方法
 *
 *  @param picker
 *  @param info
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *asset)
    {
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        NSString *fileName = [representation filename];
        [item setValue:fileName forKey:@"photoName"];
    };
    
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:imageURL
                   resultBlock:resultblock
                  failureBlock:nil];
    
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if (!image) {
        [picker dismissViewControllerAnimated:YES completion:NULL];
        return;
    }
    [item setValue:image forKey:@"image"];
    [self performSelectorInBackground:@selector(resizeImage:) withObject:item];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

/**
 *  取消
 *
 *  @param picker 
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    self.sourceType = PhotoManagerSourceTypeCancel;
    
    if (self.block) {
        self.block(nil, self.sourceType);
        self.block = nil;
    }else if (self.multipleBlock) {
        self.multipleBlock(nil, self.sourceType);
        self.multipleBlock = nil;
    }
    
}

@end
