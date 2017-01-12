//
//  OWTUserInfoViewCon.h
//  Weitu
//
//  Created by Su on 4/12/14.
//  Copyright (c) 2014 SparkingSoft Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>

#import "User.h"

@interface UserInfoView : UICollectionReusableView<CLLocationManagerDelegate>

@property(nonatomic,retain) CLLocationManager* locationmanager;

@property (nonatomic) UILabel *nameLabel;
@property (nonatomic, strong) User* user;
@property (nonatomic, strong) UIButton *collectButton;

-(void)refreshUserInfo;

@end
