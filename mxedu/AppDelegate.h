//
//  AppDelegate.h
//  mxedu
//
//  Created by 田晓鹏 on 15/8/2.
//  Copyright (c) 2015年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourSectionViewController.h"

#import "DataMappingManager.h"
#import "SideslipViewController.h"

#import "UMSocial.h"
#import "UMSocialWechatHandler.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CourSectionViewController *vc;

@property (strong, nonatomic, readonly) DataMappingManager* dataManager;
@property (strong, nonatomic, readonly)  SideslipViewController * slideViewController;

-(void)pushToMainView;

@end

