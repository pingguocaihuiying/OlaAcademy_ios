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
    UILabel *_signInLabel;
    UIView *lineView;
    UILabel *_localLabel;
}


@end

@implementation UserInfoView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = COMMONBLUECOLOR;
        
        _settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _settingButton.frame = CGRectMake(SCREEN_WIDTH-50, GENERAL_SIZE(50), 50, 30);
        [_settingButton setImage:[UIImage imageNamed:@"icon_setting"] forState:UIControlStateNormal];
        [self addSubview:_settingButton];
        
        _avatarImageview = [[UIImageView alloc]init];
        _avatarImageview.image = [UIImage imageNamed:@"ic_avatar"];
        _avatarImageview.layer.masksToBounds = YES;
        _avatarImageview.layer.cornerRadius = GENERAL_SIZE(60);
        _avatarImageview.layer.borderColor = [[UIColor whiteColor]CGColor];
        _avatarImageview.layer.borderWidth = 1.0;
        [self addSubview:_avatarImageview];
        
        UIImageView *nextIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_next"]];
        [self addSubview:nextIV];
        
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = LabelFont(32);
        _nameLabel.textColor = [UIColor whiteColor];
        [self addSubview:_nameLabel];
        
        _signInLabel = [[UILabel alloc]init];
        _signInLabel.textColor = [UIColor whiteColor];
        _signInLabel.font = LabelFont(28);
        [self addSubview:_signInLabel];
        
        lineView = [[UIView alloc]init];
        lineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:lineView];
        
        _localLabel = [[UILabel alloc]init];
        _localLabel.textColor = [UIColor whiteColor];
        _localLabel.font = LabelFont(28);
        [self addSubview:_localLabel];
        
        [_avatarImageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(32);
            make.left.equalTo(self.mas_left).offset(10);
            make.width.equalTo(@(GENERAL_SIZE(120)));
            make.height.equalTo(@(GENERAL_SIZE(120)));
        }];
        
        [nextIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_avatarImageview);
            make.right.equalTo(self.mas_right).offset(-GENERAL_SIZE(20));
        }];

        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_avatarImageview.mas_top).offset(5);
            make.left.equalTo(_avatarImageview.mas_right).offset(10);
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
    AuthManager *authManager = [AuthManager sharedInstance];
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
    [self updateOlaCoin:user.coin];
    [self updateLocal:user.vipTime];
    
    [_signInLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatarImageview.mas_right).offset(10);
        make.top.equalTo(_nameLabel.mas_bottom).offset(GENERAL_SIZE(30));
    }];
    
    [lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_signInLabel.mas_right).offset(5);
        make.centerY.equalTo(_signInLabel);
        make.height.equalTo(@(GENERAL_SIZE(24)));
        make.width.equalTo(@1);
    }];
    
    [_localLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView.mas_right).offset(5);
        make.top.equalTo(_nameLabel.mas_bottom).offset(GENERAL_SIZE(30));
    }];
    
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

- (void)updateOlaCoin:(NSString*)coin
{
    if (coin != nil)
    {
        _signInLabel.text = [NSString stringWithFormat:@"%@欧拉币",coin];
    }
    else
    {
        _signInLabel.text = @"0天签到";
    }
}

- (void)updateLocal:(NSString*)local
{
    if (local != nil)
    {
        //_localLabel.text = local;
        _localLabel.text = [NSString stringWithFormat:@"%@天会员",local];
    }
    else
    {
        _localLabel.text = @"0天会员";
        //_localLabel.text = @"北京";
    }
}


@end
