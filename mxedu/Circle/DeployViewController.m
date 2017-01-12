//
//  AddSubPostViewController.m
//  NTreat
//
//  Created by 田晓鹏 on 16/2/29.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "DeployViewController.h"

#import "DeployViewController.h"
#import "SysCommon.h"
#import "UIImage+Resize.h"
#import "UIView+Positioning.h"
#import <Masonry.h>
#import <SVProgressHUD.h>
#import "BSImagePickerController.h"
#import "UploadManager.h"
#import "QYSelectPhotoView.h"
#import "ALAsset+BSEqual.h"
#import "MCImageInfo.h"
#import "ImageCell.h"
#import "User.h"
#import "AuthManager.h"
#import "CircleManager.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface DeployViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIButton *rights;//导航栏右侧按钮
    
    UILabel *label; //content 的 placehoder
    UITextView *editText;
    
    NSMutableArray *choosenImages;
    UIImageView *addImage;
    UILabel *localtion;
    
    NSString *locationString;
    
    UIView *orgiView;
    UIView *localView;
    
    UIButton *addMediaButton;
    
    dispatch_queue_t _workingQueue;
    
    /**
     *  图片选择视图
     */
    QYSelectPhotoView *_selectPhotoView;
    
    NSURL *choiceURL;//选中视频的URL地址
    
    NSString *meidaType;//上传的媒体样式
    
    UITapGestureRecognizer *wholeTap;
}

@property (nonatomic, strong) BSImagePickerController *imagePicker;
@property (nonatomic, strong) UICollectionView *collectionView;


@end

@implementation DeployViewController

BOOL uploadOrignalImage;

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavBar];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(3, 5, 160, 20)];
    label.enabled = NO;
    label.text = @"说说您的备考经验";
    label.font =  [UIFont systemFontOfSize:16];
    label.textColor = [UIColor blackColor];
    
    editText = [UITextView new];
    editText.tag=1002;
    int height = 100;
    if (iPhone6) {
        height = 110;
    }else if(iPhone6Plus){
        height = 120;
    }
    editText.frame = CGRectMake(5, 5, SCREEN_WIDTH-10, height);
    editText.font=[UIFont systemFontOfSize:16];
    editText.backgroundColor = [UIColor whiteColor];
    editText.delegate = self;
    [editText addSubview:label];
    [self.view addSubview:editText];
    
    UIView *dividerLine3 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(editText.frame), SCREEN_WIDTH, 5)];
    dividerLine3.backgroundColor = BACKGROUNDCOLOR;
    [self.view addSubview:dividerLine3];
    
    localView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(dividerLine3.frame), SCREEN_WIDTH, 44)];
    localView.backgroundColor = [UIColor whiteColor];
    UILabel *localLabel = [[UILabel alloc]init];
    localLabel.text = @"所在位置";
    localLabel.textColor = RGBCOLOR(87, 87, 87);
    localtion = [[UILabel alloc]init];
    localtion.text = @"定位中...";
    [localView addSubview:localLabel];
    [localView addSubview:localtion];
    [self.view addSubview:localView];
    
    [localLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(localView).offset(0);
        make.left.equalTo(localView.mas_left).offset(10);
    }];
    [localtion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(localView).offset(0);
        make.right.equalTo(localView.mas_right).offset(-10);
    }];
    
    UIView *dividerLine4 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(localView.frame), SCREEN_WIDTH, 1)];
    dividerLine4.backgroundColor = BACKGROUNDCOLOR;
    [self.view addSubview:dividerLine4];
    
    
    orgiView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(dividerLine4.frame)+5, SCREEN_WIDTH, 35)];
    orgiView.backgroundColor = [UIColor whiteColor];
    UILabel *oriLabel = [[UILabel alloc]init];
    oriLabel.text = @"上传原图";
    oriLabel.textColor = RGBCOLOR(87, 87, 87);
    UISwitch *switchButton = [[UISwitch alloc]init];
    [switchButton setOn:NO];
    [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [orgiView addSubview:oriLabel];
    [orgiView addSubview:switchButton];
    [self.view addSubview:orgiView];
    
    
    [oriLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(orgiView).offset(0);
        make.left.equalTo(orgiView.mas_left).offset(10);
    }];
    [switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(orgiView).offset(0);
        make.right.equalTo(orgiView.mas_right).offset(-10);
    }];
    
    addMediaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addMediaButton setImage:[UIImage imageNamed:@"ic_choose_photo"] forState:UIControlStateNormal];
    [addMediaButton addTarget:self action:@selector(addPhotoView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addMediaButton];
    
    [addMediaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orgiView.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.width.equalTo(@60);
        make.height.equalTo(@60);
    }];
    
    uploadOrignalImage = NO;
    
    wholeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self setupLocation];
    
}

-(void)setupLocation{
    _locationmanager = [[CLLocationManager alloc]init];
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] > 8.0)
    {
        //设置定位权限 仅ios8有意义
        [_locationmanager requestWhenInUseAuthorization];// 前台定位
        //[_locationmanager requestAlwaysAuthorization];// 前后台同时定位
    }
    //设置定位的精度
    [_locationmanager setDesiredAccuracy:kCLLocationAccuracyBest];
    //实现协议
    _locationmanager.delegate = self;
    
    //开始定位
    [_locationmanager startUpdatingLocation];
}

- (void)setupBackButton
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"ic_back_white"] forState:UIControlStateNormal];
    [backBtn sizeToFit];
    [backBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

-(void)backButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addMedia:(id)sender{
    [self getImages];
}

-(void)setNavBar
{
    [self.navigationItem setTitle:@"欧拉分享"];
    [self setupBackButton];
    
    //发布按钮
    rights=[UIButton buttonWithType:UIButtonTypeCustom];
    rights.frame=CGRectMake(0, 0, 40, 24);
    [rights setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rights setTitle:@"发布" forState:UIControlStateNormal];
    rights.titleLabel.font = LabelFont(28);
    
    [rights addTarget:self action:@selector(deployMessage:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightbtn=[[UIBarButtonItem alloc] initWithCustomView:rights];
    self.navigationItem.rightBarButtonItem = rightbtn;
}

-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        [SVProgressHUD showInfoWithStatus:@"上传原图将耗费较多流量"];
        uploadOrignalImage = YES;
    }else {
        uploadOrignalImage = NO;
    }
}

-(void)deployMessage:(UIButton *)sender{
    if (editText.text.length<2) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"内容不少于两个字" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    sender.enabled=NO;
    if (_selectPhotoView) {
        if (_selectPhotoView.photoData.count>0) {
            [self uploadImages];
        }else{
            [self savePostInfo:@""];
        }
        return;
        
    }
    [self savePostInfo:@""];
}
-(void)uploadImages{
    if (uploadOrignalImage) {
        [self uploadByImageDatas:_selectPhotoView.photoData];
    }else{
        [self uploadByImageDatas:_selectPhotoView.smallphotoData];
    }
}
-(void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text length] == 0) {
        [label setHidden:NO];
    }else{
        [label setHidden:YES];
    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    [self.view addGestureRecognizer:wholeTap];
}

-(void)addPhotoView{
    QYSelectPhotoView *selectPhotoView = [[QYSelectPhotoView alloc] initWithFrame:CGRectZero];
    selectPhotoView.delegate = self;
    selectPhotoView.isEnable = YES;
    selectPhotoView.isHiddenAdd=YES;
    selectPhotoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:selectPhotoView];
    _selectPhotoView = selectPhotoView;
    
    [selectPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orgiView.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
    }];
    [selectPhotoView showSelectPhotoView];
}

-(void)getImages{
    UIActionSheet *sheet =[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",@"拍照", nil];
    [sheet showInView:self.view];
}

- (void)doBSImagePicker:(id)sender
{
    BSImagePickerController *imagePicker = [[BSImagePickerController alloc] init];
    
    [imagePicker setKeepSelection:YES];
    
    [self.navigationController presentImagePickerController:imagePicker
                                                   animated:YES
                                                 completion:nil
                                                     toggle:^(ALAsset *asset, BOOL select) {
                                                         if(select) { //选择图片回调
                                                             
                                                         } else { // 移除选择回调
                                                             
                                                         }
                                                     }
                                                     cancel:^(NSArray *assets) { //取消事件回调
                                                         [imagePicker dismissViewControllerAnimated:YES completion:nil];
                                                     }
                                                     finish:^(NSArray *assets) {  // 完成事件回调
                                                         [imagePicker dismissViewControllerAnimated:YES completion:nil];
                                                         NSMutableArray* imageInfos = [NSMutableArray arrayWithCapacity:assets.count];
                                                         for (ALAsset* asset in assets)
                                                         {
                                                             //获取资源图片的详细资源信息
                                                             ALAssetRepresentation* representation = [asset defaultRepresentation];
                                                             //资源图片url地址
                                                             NSURL* url = [representation url];
                                                             MCImageInfo* imageInfo = [[MCImageInfo alloc] init];
                                                             imageInfo.imageName = [representation filename];
                                                             imageInfo.url = [url absoluteString];
                                                             imageInfo.width = [representation dimensions].width;
                                                             imageInfo.asset = asset;
                                                             imageInfo.height = [representation dimensions].height;
                                                             imageInfo.angle = [self getImageAngle:representation];
                                                             [imageInfos addObject:imageInfo];
                                                         }
                                                         [self setPendingUploadImageInfos:imageInfos];
                                                     }];
}

-(int)getImageAngle:(ALAssetRepresentation*) representation{
    switch ([representation orientation]) { //旋转方向
        case ALAssetOrientationUpMirrored:
            return 0;
        case ALAssetOrientationRight:
            return 90;
        case ALAssetOrientationDown:
            return 180;
        case ALAssetOrientationLeft:
            return 270;
    }
    return 0;
}

- (void)setPendingUploadImages:(NSArray *)pendingUploadImages
{
    _pendingUploadImages = [pendingUploadImages copy];
}

- (void)setPendingUploadImageInfos:(NSArray *)pendingUploadImageInfos
{
    _pendingUploadImageInfos = pendingUploadImageInfos;
    [choosenImages removeAllObjects];
    for (MCImageInfo *imageInfo in _pendingUploadImageInfos) {
        [choosenImages addObject:[UIImage imageWithCGImage:[imageInfo.asset thumbnail]]];
    }
    [choosenImages addObject:[UIImage imageNamed:@"ic_add_photo"]];
    [_collectionView reloadData];
}

- (dispatch_queue_t)wokingQueue
{
    if (_workingQueue == nil)
    {
        _workingQueue = dispatch_queue_create("com.xpown.PendingUploadImageLoadingQueue", 0);
    }
    
    return _workingQueue;
}

- (CGSize)fixedUploadSizeForImage:(UIImage*)image
{
    CGSize originalSize = image.size;
    if (originalSize.width < 640||uploadOrignalImage)
    {
        return originalSize;
    }
    
    return CGSizeMake(640, originalSize.height * 640 / originalSize.width);
}


- (void)upload
{
    [self.view endEditing:YES];
    
    if (_pendingUploadImages != nil && _pendingUploadImages.count > 0)
    {
        dispatch_queue_t dq = [self wokingQueue];
        
        
        dispatch_async(dq, ^{
            NSMutableArray* imageDatas = [NSMutableArray arrayWithCapacity:_pendingUploadImages.count];
            for (UIImage* image in _pendingUploadImages)
            {
                UIImage* uploadImage = image;
                //压缩图片
                uploadImage = [image resizedImage:[self fixedUploadSizeForImage:image] interpolationQuality:kCGInterpolationHigh];
                
                NSData* imageData = UIImageJPEGRepresentation(uploadImage, 0.8);
                [imageDatas addObject:imageData];
            }
            [self uploadByImageDatas:imageDatas];
        });
    }
    else if (_pendingUploadImageInfos != nil && _pendingUploadImageInfos.count > 0)
    {
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        
        NSMutableArray* imageDatas = [NSMutableArray arrayWithCapacity:_pendingUploadImageInfos.count];
        
        dispatch_queue_t dq = [self wokingQueue];
        
        __block NSUInteger pendingImageNum = _pendingUploadImageInfos.count;
        
        [SVProgressHUD show];
        
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset* asset)
        {
            ALAssetRepresentation* rep = [asset defaultRepresentation];
            
            NSError* error;
            NSData* imageData;
            if (true)  // 默认对图片进行压缩
            {
                CGImageRef iref = [rep fullResolutionImage];
                UIImage* image = [UIImage imageWithCGImage:iref];
                image = [image resizedImage:[self fixedUploadSizeForImage:image] interpolationQuality:kCGInterpolationHigh];
                imageData = UIImageJPEGRepresentation(image, 0.8);
            }
            else
            {
                NSMutableData* mutableImageData = [NSMutableData dataWithCapacity:(NSUInteger)rep.size];
                [mutableImageData setLength:(NSUInteger)rep.size];
                NSUInteger buffered = [rep getBytes:[mutableImageData mutableBytes]
                                         fromOffset:0.0
                                             length:(NSUInteger)rep.size
                                              error:&error];
                [mutableImageData setLength:buffered];
                imageData = mutableImageData;
            }
            
            if (imageData != nil && error == nil)
            {
                dispatch_async(dq, ^{
                    [imageDatas addObject:imageData];
                    pendingImageNum--;
                    if (pendingImageNum == 0)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{ [self uploadByImageDatas:imageDatas]; });
                    }
                    else
                    {
                        NSLog(@"pendingImageNum is %lu", (unsigned long)pendingImageNum);
                    }
                });
            }
            else
            {
                dispatch_async(dq, ^{
                    pendingImageNum--;
                    if (pendingImageNum == 0)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{ [self uploadByImageDatas:imageDatas]; });
                    }
                    else
                    {
                        NSLog(@"pendingImageNum is %lu", (unsigned long)pendingImageNum);
                    }
                });
            }
        };
        
        ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
        {
            dispatch_async(dq, ^{
                NSLog (@"booya, cant get image - %@",[myerror localizedDescription]);
                pendingImageNum--;
                if (pendingImageNum == 0)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{ [self uploadByImageDatas:imageDatas]; });
                }
                else
                {
                    NSLog(@"pendingImageNum is %lu", (unsigned long)pendingImageNum);
                }
            });
        };
        
        for (MCImageInfo* imageInfo in _pendingUploadImageInfos)
        {
            NSURL* url = [NSURL URLWithString:imageInfo.url];
            [assetslibrary assetForURL:url
                           resultBlock:resultblock
                          failureBlock:failureblock];
        }
    }
    else
    {
        [SVProgressHUD showSuccessWithStatus:@"上传完毕。"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)uploadByImageDatas:(NSArray*)imageDatas
{
    AuthManager* am = [[AuthManager alloc]init];
    if (!am.isAuthenticated)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请先登录" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (imageDatas == nil || imageDatas.count == 0)
    {
        [SVProgressHUD showSuccessWithStatus:@"上传完毕。"];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    [SVProgressHUD showProgress:0.5 / (float)imageDatas.count
                         status:[NSString stringWithFormat:@"正在上传第%d张图片，共%lu张。", 1, (unsigned long)imageDatas.count]];
    
    UploadManager* um = [[UploadManager alloc]init];
    [um uploadImageDatas:imageDatas
                  angles:nil
                progress:^(NSInteger uploadedImageNum, NSInteger totalImageNum) {
                    float progress = ((float)uploadedImageNum  + 0.5) / (float)totalImageNum;
                    [SVProgressHUD showProgress:progress
                                         status:[NSString stringWithFormat:@"正在上传第%ld张图片，共%ld张。", (long)uploadedImageNum + 1, (long)totalImageNum]];
                }
                 success:^{
                     [SVProgressHUD showSuccessWithStatus:@"上传完毕。"];
                     NSMutableArray *imageGids =  um.imageGids;
                     NSString* imgIDs = @"";
                     int index = 0;
                     for (NSString* imgID in imageGids) {
                         imgIDs = [imgIDs stringByAppendingString:imgID];
                         if (index < [imageGids count]-1) {
                             imgIDs = [imgIDs stringByAppendingString:@","];
                         }
                         index++;
                     }
                     
                     [self savePostInfo:imgIDs];
                     
                 }
                 failure:^(NSError* error) {
                     
                 }];
}

-(void)savePostInfo:(NSString*) lstPic{
    AuthManager *am = [[AuthManager alloc]init];
    CircleManager* cm = [[CircleManager alloc]init];
    [cm addOlaCircleWithUserId:am.userInfo.userId Title:@"欧拉圈" content:editText.text imageGids:lstPic Location:locationString==nil?@"":locationString Type:@"2" Success:^(CommonResult *result) {
        if (_doneAction) {
            _doneAction();
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    } Failure:^(NSError *error) {
        
    }];
}


#pragma mark - UICollectionView Datasource
//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    if (choosenImages != nil)
    {
        if (choosenImages.count % 3 == 0) {
            return 3;
        }else {
            if(section == choosenImages.count / 3){
                return choosenImages.count % 3;
            }else{
                return 3;
            }
        }
    }
    return 0;
}
//每个section的item个数
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    if (choosenImages != nil)
    {
        return choosenImages.count % 3 == 0? choosenImages.count/3:choosenImages.count/3+ 1;
    }
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCell *cell = (ImageCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    
    if (indexPath.row==choosenImages.count-1) {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                                 initWithTarget:self action:@selector(getImages)];
        [tapRecognizer setNumberOfTouchesRequired:1];
        [tapRecognizer setDelegate:(id)self];
        cell.userInteractionEnabled = YES;
        [cell addGestureRecognizer:tapRecognizer];
    }
    //加载图片
    if (choosenImages != nil) {
        if (indexPath.section==0) {
            cell.imageView.image = [choosenImages objectAtIndex:indexPath.row];
        }else{
            cell.imageView.image = [choosenImages objectAtIndex:indexPath.row+3*indexPath.section];
        }
    }
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH/3-15, SCREEN_WIDTH/3-15);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark locationManager delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *newLocation = locations[0];
    [manager stopUpdatingLocation];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation
                   completionHandler:^(NSArray *placemarks, NSError *error){
                       
                       for (CLPlacemark *place in placemarks) {
                           locationString = [NSString stringWithFormat:@"%@%@",place.locality,place.subLocality];
                           localtion.text = [NSString stringWithFormat:@"%@·%@",place.locality,place.subLocality];
                       }
                   }];
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"error");
    localtion.text = @"定位失败";
}

/**
 *  隐藏键盘
 */
-(void)dismissKeyboard {
    NSArray *subviews = [self.view subviews];
    for (id objInput in subviews) {
        if ([objInput isKindOfClass:[UITextField class]]) {
            UITextField *theTextField = objInput;
            if ([objInput isFirstResponder]) {
                [theTextField resignFirstResponder];
            }
        }
    }
    [self.view endEditing:YES];
    [self.view removeGestureRecognizer:wholeTap];
}
@end
