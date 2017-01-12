//
//  ALAlertView.h
//  TestAlert
//
//  Created by 周冉 on 2013. 12. 19..
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#define DO_RGB(r, g, b)     [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define DO_RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define BgColor  [UIColor colorWithRed:12/255. green:142/255. blue:243/255. alpha:1]


// color set 2
#define DO_NORMALBG_COLOR              DO_RGB(255, 255, 255)
#define DO_NORMALTEXT_COLOR            DO_RGB(0, 0, 0)
#define DO_GRAYBG_COLOR                DO_RGBA(0, 0, 0, 0.7)
#define DO_GRAYBGTEXT_COLOR            DO_RGB(255, 255, 255)
#define DO_DIMMED_COLOR                DO_RGBA(0, 0, 0, 0.7)

#define DO_TEXT_FONT        [UIFont systemFontOfSize:14]

#define DO_LABEL_INSET      UIEdgeInsetsMake(20, 10, 20, 10)
#define DO_TITLE_INSET      UIEdgeInsetsMake(15, 10, 15, 10)
#define DO_VIEW_WIDTH       CGRectGetWidth([UIScreen mainScreen].bounds) - 50

#define DO_YES_TAG          100
#define DO_NO_TAG           200

#define DO_ROUND            3

typedef NS_ENUM(int, ALAlertViewTransitionStyle) {
    ALTransitionStyleTopDown = 0,
    ALTransitionStyleBottomUp,
    ALTransitionStyleFade,
    ALTransitionStylePop,
    ALTransitionStyleLine,
};

typedef NS_ENUM(int, ALAlertViewContentType) {
    ALContentNone = 0,
    ALContentImage,
    ALContentMap,
};

@class ALAlertView;
typedef void(^ALAlertViewHandler)(ALAlertView *alertView);

@interface ALAlertView : UIView <MKMapViewDelegate>
{
@private
    NSString                *_strAlertTitle;
    NSString                *_strAlertBody;
    NSString                *_strAlertCancel;
    NSString                *_strAlertOk;
    BOOL                    _bNeedNo;

    ALAlertViewHandler      _doYes;
    ALAlertViewHandler      _doNo;
    ALAlertViewHandler      _doDone;
}

@property (nonatomic,strong)UIWindow        *alertWindow;
@property (nonatomic,strong)  UIView        *vAlert;

@property (readwrite)   NSInteger           nAnimationType;
@property (readwrite)   NSInteger           nContentMode;

@property (readwrite)   double              dRound;
@property (readwrite)   BOOL                bGrayBg;

@property (readonly)    NSInteger           nTag;
@property (nonatomic,assign) BOOL           showAnimate;

// add content
// for UIImageView
@property (nonatomic, strong)   UIImage         *iImage;
// for Map view
@property (nonatomic, strong)   NSDictionary    *dLocation; // latitude, longitude

// With Title, Alert body, Yes button, No button
- (void)doYesNo:(NSString *)strTitle
           body:(NSString *)strBody
         cancel:(NSString *)cancelStr
             ok:(NSString *)okStr
            yes:(ALAlertViewHandler)yes
             no:(ALAlertViewHandler)no;

// With Alert body, Yes button, No button
- (void)doYesNo:(NSString *)strBody
         cancel:(NSString *)cancelStr
             ok:(NSString *)okStr
            yes:(ALAlertViewHandler)yes
             no:(ALAlertViewHandler)no;

// With Title, Alert body, Only yes button
- (void)doYes:(NSString *)strTitle
         body:(NSString *)strBody
       cancel:(NSString *)cancelStr
           ok:(NSString *)okStr
          yes:(ALAlertViewHandler)yes;

// With Alert body, Only yes button
- (void)doYes:(NSString *)strBody
           ok:(NSString *)okStr
          yes:(ALAlertViewHandler)yes;

// Without any button
- (void)doAlert:(NSString *)strTitle
           body:(NSString *)strBody
       duration:(double)dDuration
           done:(ALAlertViewHandler)done;
- (void)hideAlert;

@end
