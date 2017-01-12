//
//  OWTUserInfoViewCon.m
//  Weitu
//
//  Created by Su on 4/12/14.
//  Copyright (c) 2014 SparkingSoft Co., Ltd. All rights reserved.
//

#import "UserInfoView.h"
#import "User.h"
#import "SysCommon.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Masonry.h"
#import "AuthManager.h"
#import "UserManager.h"

typedef enum
{
    nWTUserInfoViewActionButtonNone,
    nWTUserInfoViewActionButtonEdit,
    nWTUserInfoViewActionButtonFollow,
    nWTUserInfoViewActionButtonUnfollow,
} EWTUserInfoViewActionButtonType;

@interface UserInfoView ()
{
    UIImageView *_avatarImageview;
    UILabel *_vipLabel;
    UILabel *_localLabel;
}


@end

@implementation UserInfoView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = RGBCOLOR(172, 202, 236);
        
        _collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_collectButton];
        _collectButton.hidden = YES; //暂时隐藏该功能
        
        _avatarImageview = [[UIImageView alloc]init];
        _avatarImageview.image = [UIImage imageNamed:@"ic_avatar"];
        _avatarImageview.layer.masksToBounds = YES;
        _avatarImageview.layer.cornerRadius = GENERAL_SIZE(80);
        [self addSubview:_avatarImageview];
        
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = LabelFont(36);
        _nameLabel.textColor = [UIColor whiteColor];
        [self addSubview:_nameLabel];
        
        _vipLabel = [[UILabel alloc]init];
        _vipLabel.text = @"VIP会员";
        _vipLabel.layer.borderWidth = 1.0;
        _vipLabel.layer.masksToBounds = YES;
        _vipLabel.layer.cornerRadius = 5.0;
        _vipLabel.layer.borderColor = [RGBCOLOR(128, 128, 128) CGColor];
        _vipLabel.backgroundColor = RGBCOLOR(128, 128, 128);
        _vipLabel.textColor = [UIColor whiteColor];
        _vipLabel.textAlignment = NSTextAlignmentCenter;
        _vipLabel.font = LabelFont(24);
        [self addSubview:_vipLabel];
        
        _localLabel = [[UILabel alloc]init];
        _localLabel.textColor = [UIColor whiteColor];
        _localLabel.font = LabelFont(28);
        [self addSubview:_localLabel];
        
        [_avatarImageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.mas_left).offset(10);
            make.width.equalTo(@(GENERAL_SIZE(160)));
            make.height.equalTo(@(GENERAL_SIZE(160)));
        }];

        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_avatarImageview.mas_top).offset(10);
            make.left.equalTo(_avatarImageview.mas_right).offset(20);
            make.width.equalTo(@200);
            make.height.equalTo(@20);
        }];
        
        [_vipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_avatarImageview.mas_right).offset(20);
            make.top.equalTo(_nameLabel.mas_bottom).offset(GENERAL_SIZE(30));
            make.width.equalTo(@(GENERAL_SIZE(120)));
            make.height.equalTo(@(GENERAL_SIZE(36)));
        }];
        
        [_localLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_vipLabel.mas_right).offset(8);
            make.top.equalTo(_nameLabel.mas_bottom).offset(GENERAL_SIZE(30));
            make.width.equalTo(@200);
            make.height.equalTo(@20);
        }];
        
        //[self setupLocltionManager];
        
    }
    return self;

    
}

-(void)setupLocltionManager{
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
}

-(void)refreshUserInfo{
    AuthManager *authManager = [[AuthManager alloc]init];
    if (authManager.isAuthenticated) {
        UserManager *userManager = [[UserManager alloc]init];
        [userManager fetchUserWithUserId:authManager.userInfo.userId Success:^{
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            if (userManager.userInfo)
            {
                [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:userManager.userInfo] forKey: @"userInfo"];
                [authManager load];
            }
            [self updateWithUser:userManager.userInfo];
        } Failure:^(NSError *error) {
            
        }];
    }else{
        [self updateWithUser:nil];
    }
    
}

- (void)updateWithUser:(User*)user
{
    //开始定位
    //[_locationmanager startUpdatingLocation];
    
    _user = user;
    
    [self updateNickname:user.name];
    [self updateLocal:user.vipTime];
    
    _avatarImageview.layer.cornerRadius = 20;
    if(user.avatar){
        if ([user.avatar rangeOfString:@".jpg"].location == NSNotFound) {
            [_avatarImageview sd_setImageWithURL:[NSURL URLWithString: [BASIC_IMAGE_URL stringByAppendingString:user.avatar]] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
        }else{
            [_avatarImageview sd_setImageWithURL:[NSURL URLWithString: [@"http://api.olaxueyuan.com/upload/" stringByAppendingString:user.avatar]] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
        }
    }else{
        _avatarImageview.image = [UIImage imageNamed:@"ic_avatar"];
    }
}

#pragma mark locationManager delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *newLocation = locations[0];
    [manager stopUpdatingLocation];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation
                   completionHandler:^(NSArray *placemarks, NSError *error){
                       
                       for (CLPlacemark *place in placemarks) {
                           NSString *local = [NSString stringWithFormat:@"%@,%@",place.locality,place.subLocality];
                           if (!_user) {
                               _localLabel.text = local;
                           }else if (_user.local==nil||(_user.local!=nil&&[_user.local isEqualToString:@""])) {
                               _localLabel.text = local;
                           }
                       }
                       
                   }];
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"error");
}


#pragma mark - Info updating methods

- (void)updateNickname:(NSString*)nickname;
{
    if (nickname != nil)
    {
        _nameLabel.text = nickname;
    }
    else
    {
        _nameLabel.text = @"登录／注册";
    }
}

- (void)updateLocal:(NSString*)local
{
    if (local != nil)
    {
        //_localLabel.text = local;
        _localLabel.text = [NSString stringWithFormat:@"还剩%@天",local];
    }
    else
    {
        _localLabel.text = @"还剩0天";
        //_localLabel.text = @"北京";
    }
}


@end
