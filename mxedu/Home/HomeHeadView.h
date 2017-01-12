//
//  HomeHeadView.h
//  mxedu
//
//  Created by 田晓鹏 on 16/8/17.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Banner.h"

@protocol HomeHeadViewDelegate <NSObject>

-(void)didClickConsultView;
-(void)didClickTeacherView;
-(void)didClickMaterialView;
-(void)didClickGroupView;

-(void)didClickBanner:(Banner*)banner;

@end

@interface HomeHeadView : UIView

@property (nonatomic) id<HomeHeadViewDelegate> headViewDelegate;

-(void)setupView:(NSArray*)bannerArray;

@end
