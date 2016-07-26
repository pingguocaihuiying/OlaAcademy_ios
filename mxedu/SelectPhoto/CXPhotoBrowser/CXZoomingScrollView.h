//
//  CXZoomingScrollView.h
//  CXPhotoBrowserDemo
//
//  Created by ChrisXu on 13/4/19.
//  Copyright (c) 2013年 QYER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXPhotoProtocol.h"
#import "CXTapDetectingImageView.h"
#import "CXTapDetectingView.h"
#import "CXPhotoLoadingView.h"

@class CXPhotoBrowser, CXPhoto, CXLoadingPlaceholder;
@interface CXZoomingScrollView : UIScrollView
<UIScrollViewDelegate, CXTapDetectingImageViewDelegate, CXTapDetectingViewDelegate>
{
    __weak CXPhotoBrowser *_photoBrowser;
    id<CXPhotoProtocol> _photo;
    
    CXTapDetectingView *_tapView;
    CXTapDetectingImageView *_photoImageView;
    CXPhotoLoadingView *_photoLoadingView;
}
@property (nonatomic) BOOL isPhotoSupportedPanGesture; //default is YES
@property (nonatomic) BOOL isPhotoSupportedReload;
@property (nonatomic) BOOL isFromAlbum;
@property (nonatomic, strong) id<CXPhotoProtocol> photo;
- (id)initWithPhotoBrowser:(CXPhotoBrowser *)browser;
- (void)displayImageStartLoading;
- (void)displayImage;
- (void)displayImageFailure;
- (void)setMaxMinZoomScalesForCurrentBounds;
- (void)prepareForReuse;

@end
