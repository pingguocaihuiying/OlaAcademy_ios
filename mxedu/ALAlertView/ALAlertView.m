//
//  ALAlertView.m
//  TestAlert
//
//  Created by 周冉 on 2013. 12. 19..
//

#import "ALAlertView.h"

#import "SUIButton.h"
#import "NSString+expand.h"
#import "UIImage+expand.h"

#pragma mark - ALAlertViewController

@interface ALAlertViewController : UIViewController

@property (nonatomic, strong) ALAlertView *alertView;

@end

@implementation ALAlertViewController

#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view = _alertView;
}

@end


#pragma mark - DoAlertViewController

@implementation ALAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

- (void)doYesNo:(NSString *)strTitle
           body:(NSString *)strBody
         cancel:(NSString *)cancelStr
             ok:(NSString *)okStr
            yes:(ALAlertViewHandler)yes
             no:(ALAlertViewHandler)no
{
    _strAlertTitle  = strTitle;
    _strAlertBody   = strBody;
    _strAlertCancel = cancelStr;
    _strAlertOk = okStr;
    _bNeedNo        = YES;
    
    _doYes  = yes;
    _doNo   = no;
    
    [self showAlertView];
}

// With Alert body, Yes button, No button
- (void)doYesNo:(NSString *)strBody
         cancel:(NSString *)cancelStr
             ok:(NSString *)okStr
            yes:(ALAlertViewHandler)yes
             no:(ALAlertViewHandler)no
{
    _strAlertTitle  = nil;
    _strAlertBody   = strBody;
    _strAlertCancel = cancelStr;
    _strAlertOk = okStr;
    _bNeedNo        = YES;
    
    _doYes  = yes;
    _doNo   = no;
    
    [self showAlertView];
}

// With Title, Alert body, Only yes button
- (void)doYes:(NSString *)strTitle
         body:(NSString *)strBody
       cancel:(NSString *)cancelStr
           ok:(NSString *)okStr
          yes:(ALAlertViewHandler)yes
{
    _strAlertTitle  = strTitle;
    _strAlertBody   = strBody;
    _strAlertCancel = cancelStr;
    _strAlertOk = okStr;
    _bNeedNo        = NO;
    
    _doYes  = yes;
    _doNo   = nil;
    
    [self showAlertView];
}

// With Alert body, Only yes button
- (void)doYes:(NSString *)strBody
           ok:(NSString *)okStr
          yes:(ALAlertViewHandler)yes
{
    _strAlertTitle  = nil;
    _strAlertBody   = strBody;
    _strAlertOk = okStr;
    _bNeedNo        = NO;
    
    _doYes  = yes;
    _doNo   = nil;
    
    [self showAlertView];
}

// Without any button
- (void)doAlert:(NSString *)strTitle
           body:(NSString *)strBody
       duration:(double)dDuration
           done:(ALAlertViewHandler)done
{
    _strAlertTitle  = strTitle;
    _strAlertBody   = strBody;
    _bNeedNo        = NO;
    
    _doYes          = nil;
    _doNo           = nil;
    _doDone         = done;
    
    [self showAlertView];
    
    if (dDuration > 0)
        [NSTimer scheduledTimerWithTimeInterval:dDuration target:self selector:@selector(onTimer) userInfo:nil repeats:NO];
}

- (void)onTimer
{
    [self hideAlert];
}

- (void)hideAlert
{
    _nTag = DO_YES_TAG;
    [self hideAnimation];
}

- (void)showAlertView
{
    double dHeight = 0;
    
    if(!_bGrayBg)
        self.backgroundColor = DO_DIMMED_COLOR;
    else
        self.backgroundColor = [UIColor clearColor];
    
    // make back view -----------------------------------------------------------------------------------------------
    _vAlert = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DO_VIEW_WIDTH, 0)];
    if(!_bGrayBg)
        _vAlert.backgroundColor = [UIColor grayColor];
    else
        _vAlert.backgroundColor = DO_GRAYBG_COLOR;
  
    [self addSubview:_vAlert];
    
    // Title --------------------------------------------------------------------------------------------------------
    if (_strAlertTitle != nil && _strAlertTitle.length > 0)
    {
        UIView *vTitle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _vAlert.frame.size.width, 0)];
        if(!_bGrayBg)
            _vAlert.backgroundColor = DO_NORMALBG_COLOR;
        else
            _vAlert.backgroundColor = DO_GRAYBG_COLOR;
        
        [_vAlert addSubview:vTitle];
        
        UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(DO_TITLE_INSET.left, DO_TITLE_INSET.top,
                                                                     _vAlert.frame.size.width - (DO_TITLE_INSET.left + DO_TITLE_INSET.right) , 0)];
        lbTitle.text = _strAlertTitle;
        [self setLabelAttributes:lbTitle];
        lbTitle.frame = CGRectMake(DO_TITLE_INSET.left, DO_TITLE_INSET.top, lbTitle.frame.size.width, [self getTextHeight:lbTitle]);
        [vTitle addSubview:lbTitle];
        
        vTitle.frame = CGRectMake(0, 0, _vAlert.frame.size.width, lbTitle.frame.size.height + (DO_TITLE_INSET.top + DO_TITLE_INSET.bottom));
        dHeight = vTitle.frame.size.height + 1;
    }
    
    // Body ---------------------------------------------------------------------------------------------------------
    UIView *vBody = [[UIView alloc] initWithFrame:CGRectMake(0, dHeight - 1, _vAlert.frame.size.width, 0)];
    [_vAlert addSubview:vBody];
    if(!_bGrayBg)
        vBody.backgroundColor = DO_NORMALBG_COLOR;
    else
        vBody.backgroundColor = [UIColor clearColor];
    
    // Content ------------------------------------------------------------------------------------------------------
    double dContentOffset = [self addContent:vBody];
    
    // Body text ----------------------------------------------------------------------------------------------------
    UILabel *lbBody = [[UILabel alloc] initWithFrame:CGRectMake(DO_LABEL_INSET.left, DO_LABEL_INSET.top + dContentOffset,
                                                                _vAlert.frame.size.width - (DO_LABEL_INSET.left + DO_LABEL_INSET.right) , 0)];
    lbBody.text = _strAlertBody;
    [self setLabelAttributes:lbBody];
    lbBody.frame = CGRectMake(DO_LABEL_INSET.left, lbBody.frame.origin.y, lbBody.frame.size.width, [self getTextHeight:lbBody]);
    [vBody addSubview:lbBody];
    
    vBody.frame = CGRectMake(0, dHeight - 1, _vAlert.frame.size.width,
                             dContentOffset + lbBody.frame.size.height + (DO_LABEL_INSET.top + DO_LABEL_INSET.bottom) + 1);
    dHeight += vBody.frame.size.height;
    
    // No button -----------------------------------------------------------------------------------------------------
    if (_doNo != nil)
    {
        SUIButton *btNo = [SUIButton buttonWithType:UIButtonTypeCustom];
        btNo.frame = CGRectMake(0, dHeight - 0.5, _vAlert.frame.size.width / 2.0 - 1, 40 + 0.5);
        if(!_bGrayBg)
        {
            btNo.backgroundColor = DO_NORMALBG_COLOR;
            [btNo setTitleColor:BgColor forState:UIControlStateNormal];
        }
        else
        {
            btNo.backgroundColor = [UIColor clearColor];
            [btNo setTitleColor:DO_GRAYBGTEXT_COLOR forState:UIControlStateNormal];
        }
        btNo.tag = DO_NO_TAG;
        [btNo setTitle:_strAlertCancel forState:UIControlStateNormal];
        [btNo addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
        
        [_vAlert addSubview:btNo];
    }
    
    // Yes button -----------------------------------------------------------------------------------------------------
    if (_doYes != nil)
    {
        SUIButton *btYes = [SUIButton buttonWithType:UIButtonTypeCustom];
        if (_doNo == nil)
            btYes.frame = CGRectMake(0, dHeight - 0.5, _vAlert.frame.size.width, 40 + 0.5);
        else
            btYes.frame = CGRectMake(_vAlert.frame.size.width / 2.0 - 0.5, dHeight - 0.5 , _vAlert.frame.size.width / 2.0 + 0.5, 40 + 0.5);
        
        if(!_bGrayBg)
        {
            btYes.backgroundColor = DO_NORMALBG_COLOR;
            [btYes setTitleColor:BgColor forState:UIControlStateNormal];
        }
        else
        {
            btYes.backgroundColor = [UIColor clearColor];
            [btYes setTitleColor:DO_GRAYBGTEXT_COLOR forState:UIControlStateNormal];
        }
        
        btYes.tag = DO_YES_TAG;
        [btYes setTitle:_strAlertOk forState:UIControlStateNormal];
        [btYes addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
        
        [_vAlert addSubview:btYes];
        
        dHeight += 40;
    }
    
    
    _vAlert.frame = CGRectMake(0, 0, DO_VIEW_WIDTH, dHeight);
    
    ALAlertViewController *viewController = [[ALAlertViewController alloc] initWithNibName:nil bundle:nil];
    viewController.alertView = self;
    
    if (!_alertWindow)
    {
        UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        window.opaque = NO;
        window.windowLevel = UIWindowLevelAlert;
        window.rootViewController = viewController;
        _alertWindow = window;
        
        self.frame = window.bounds;
        _vAlert.center = CGPointMake(CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds)/2.0);
    }
    [_alertWindow makeKeyAndVisible];
    
    if (_dRound > 0)
    {
        CALayer *layer = [_vAlert layer];
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:_dRound];
    }
    
    if(_showAnimate)
    {
        [self showAnimation];
    }
}

- (void)buttonTarget:(id)sender
{
    SUIButton *btn = (SUIButton *)sender;
    _nTag = [btn tag];
    [self hideAnimation];
}

- (double)addContent:(UIView *)vBody
{
    double dContentOffset = 0;
    
    switch (_nContentMode) {
        case ALContentImage:
        {
            UIImageView *iv     = nil;
            if (_iImage != nil)
            {
                UIImage *iResized = [_iImage resizedImageWithMaximumSize:CGSizeMake(360, 360)];
                
                iv = [[UIImageView alloc] initWithImage:iResized];
                iv.contentMode = UIViewContentModeScaleAspectFit;
                iv.frame = CGRectMake(DO_LABEL_INSET.left, DO_LABEL_INSET.top, iResized.size.width / 2, iResized.size.height / 2);
                iv.center = CGPointMake(_vAlert.center.x, iv.center.y);
                
                [vBody addSubview:iv];
                dContentOffset = iv.frame.size.height + DO_LABEL_INSET.bottom;
            }
        }
            break;
            
        case ALContentMap:
        {
            if (_dLocation == nil)
            {
                dContentOffset = 0;
                break;
            }
            
            MKMapView *vMap = [[MKMapView alloc] initWithFrame:CGRectMake(DO_LABEL_INSET.left, DO_LABEL_INSET.top,
                                                                          240, 180)];
            vMap.center = CGPointMake(vBody.center.x, vMap.center.y);
            
            vMap.delegate = self;
            vMap.centerCoordinate = CLLocationCoordinate2DMake([_dLocation[@"latitude"] doubleValue], [_dLocation[@"longitude"] doubleValue]);
            vMap.camera.altitude = [_dLocation[@"altitude"] doubleValue];
            vMap.camera.pitch = 70;
            vMap.showsBuildings = YES;
            
            [vBody addSubview:vMap];
            dContentOffset = 180 + DO_LABEL_INSET.bottom;
            
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.coordinate = vMap.centerCoordinate;
            annotation.title = @"Here~";
            [vMap addAnnotation:annotation];
        }
            break;
            
        default:
            break;
    }
    
    return dContentOffset;
}

- (double)getTextHeight:(UILabel *)lbText
{
    CGSize size = [lbText.text sizeWithFontCompatible:lbText.font constrainedToSize:CGSizeMake(lbText.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    return ceil(size.height);
}

- (void)setLabelAttributes:(UILabel *)lb
{
    lb.backgroundColor = [UIColor clearColor];
    lb.textAlignment = NSTextAlignmentCenter;
    lb.numberOfLines = 0;
    
    if (_bGrayBg)
    {
        lb.font = DO_TEXT_FONT;
        
        lb.textColor = DO_GRAYBGTEXT_COLOR;
    }
    else
    {
        lb.font = DO_TEXT_FONT;
        lb.textColor = DO_NORMALTEXT_COLOR;
    }
}

- (void)hideAlertView
{
    if (_doDone != nil)
        _doDone(self);
    else
    {
        if (_nTag == DO_YES_TAG)
            _doYes(self);
        else
            _doNo(self);
    }
    
    [self removeFromSuperview];
    [_alertWindow resignKeyWindow];
    [_alertWindow removeFromSuperview];
    _alertWindow = nil;
    [[[[UIApplication sharedApplication] delegate] window] makeKeyWindow];
}

- (void)showAnimation
{
    CGRect r = _vAlert.frame;
    CGPoint ptCenter = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
    self.alpha = 0.0;
    
    switch (_nAnimationType) {
        case ALTransitionStyleTopDown:
            _vAlert.center = CGPointMake(self.bounds.size.width / 2.0, -self.bounds.size.height / 2.0);
            break;
            
        case ALTransitionStyleBottomUp:
            _vAlert.center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0 + self.bounds.size.height);
            break;
            
        case ALTransitionStyleFade:
            _vAlert.center = ptCenter;
            _vAlert.alpha = 0.0;
            break;
            
        case ALTransitionStylePop:
            _vAlert.alpha = 0.0;
            _vAlert.center = ptCenter;
            _vAlert.transform = CGAffineTransformMakeScale(0.05, 0.05);
            break;
            
        case ALTransitionStyleLine:
            _vAlert.frame = CGRectMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0, 1, 1);
            _vAlert.clipsToBounds = YES;
            break;
            
        default:
            break;
    }
    
    double dDuration = 0.2;
    
    switch (_nAnimationType) {
        case ALTransitionStyleTopDown:
        case ALTransitionStyleBottomUp:
            dDuration = 0.3;
            break;
            
        default:
            break;
    }
    
    [UIView animateWithDuration:dDuration animations:^(void) {
        
        self.alpha = 1.0;
        
        switch (_nAnimationType) {
            case ALTransitionStyleTopDown:
            case ALTransitionStyleBottomUp:
                _vAlert.center = ptCenter;
                break;
                
            case ALTransitionStyleFade:
                _vAlert.alpha = 1.0;
                break;
                
            case ALTransitionStylePop:
                _vAlert.alpha = 1.0;
                _vAlert.transform = CGAffineTransformMakeScale(1.05, 1.05);
                break;
                
            case ALTransitionStyleLine:
                _vAlert.frame = CGRectMake((self.bounds.size.width - DO_VIEW_WIDTH) / 2, self.bounds.size.height / 2.0, DO_VIEW_WIDTH, 1);
                break;
                
        }
        
    } completion:^(BOOL finished) {
        
        switch (_nAnimationType) {
            case ALTransitionStylePop:
            {
                [UIView animateWithDuration:0.1 animations:^(void) {
                    _vAlert.alpha = 1.0;
                    _vAlert.transform = CGAffineTransformMakeScale(1.0, 1.0);
                }];
            }
                break;
                
            case ALTransitionStyleLine:
            {
                [UIView animateWithDuration:0.2 animations:^(void) {
                    [UIView setAnimationDelay:0.1];
                    _vAlert.center = ptCenter;
                    _vAlert.frame = CGRectMake(_vAlert.frame.origin.x, _vAlert.frame.origin.y - r.size.height / 2.0, r.size.width, r.size.height);
                }];
            }
                break;
        }
    }];
}

- (void)hideAnimation
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    double dDuration = 0.2;
    switch (_nAnimationType) {
        case ALTransitionStyleTopDown:
        case ALTransitionStyleBottomUp:
            dDuration = 0.3;
            break;
        case ALTransitionStylePop:
            dDuration = 0.1;
            break;
            
        default:
            break;
    }
    
    [UIView animateWithDuration:dDuration animations:^(void) {
        
        switch (_nAnimationType) {
            case ALTransitionStyleTopDown:
                if (_nTag == DO_YES_TAG)
                    _vAlert.center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0 + self.bounds.size.height);
                else
                    _vAlert.center = CGPointMake(self.bounds.size.width / 2.0, -self.bounds.size.height / 2.0);
                
                [UIView setAnimationDelay:0.1];
                self.alpha = 0.0;
                break;
                
            case ALTransitionStyleBottomUp:
                if (_nTag == DO_YES_TAG)
                    _vAlert.center = CGPointMake(self.bounds.size.width / 2.0, -self.bounds.size.height / 2.0);
                else
                    _vAlert.center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0 + self.bounds.size.height);
                
                [UIView setAnimationDelay:0.1];
                self.alpha = 0.0;
                break;
                
            case ALTransitionStyleFade:
                _vAlert.alpha = 0.0;
                
                [UIView setAnimationDelay:0.1];
                self.alpha = 0.0;
                break;
                
            case ALTransitionStylePop:
                _vAlert.transform = CGAffineTransformMakeScale(1.05, 1.05);
                break;
                
            case ALTransitionStyleLine:
                _vAlert.frame = CGRectMake((self.bounds.size.width - DO_VIEW_WIDTH) / 2, self.bounds.size.height / 2.0, DO_VIEW_WIDTH, 1);
                break;
        }
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^(void) {
            
            switch (_nAnimationType) {
                case ALTransitionStylePop:
                    [UIView setAnimationDelay:0.05];
                    self.alpha = 0.0;
                    _vAlert.transform = CGAffineTransformMakeScale(0.05, 0.05);
                    _vAlert.alpha = 0.0;
                    break;
                    
                case ALTransitionStyleLine:
                    [UIView setAnimationDelay:0.1];
                    _vAlert.frame = CGRectMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0, 1, 1);
                    
                    [UIView setAnimationDelay:0.2];
                    self.alpha = 0.0;
                    break;
            }
            
        } completion:^(BOOL finished) {
            [self hideAlertView];
        }];
    }];
}

-(void)receivedRotate: (NSNotification *)notification
{
//    CGAffineTransform at = CGAffineTransformMakeRotation(0);
//    [_vAlert setTransform:at];
//
//    
//    dispatch_async(dispatch_get_main_queue(), ^(void) {
//        
//        [UIView animateWithDuration:0.0 animations:^(void) {
//            
//            _vAlert.alpha = 0.0;
//            
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.0 animations:^(void) {
//                _vAlert.center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
//                _vAlert.alpha = 1.0;
//            }];
//            
//        }];
//    });
}

@end
