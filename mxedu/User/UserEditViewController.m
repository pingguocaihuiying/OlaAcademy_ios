//
//  UserEditViewController.m
//  NTreat
//
//  Created by 田晓鹏 on 15-5-20.
//  Copyright (c) 2015年 田晓鹏. All saveBtn reserved.
//

#import "UserEditViewController.h"
#import "SysCommon.h"
#import "UserManager.h"
#import "UploadManager.h"
#import <RETableViewManager.h>
#import <UIImageView+WebCache.h>
#import <SVProgressHUD.h>
#import "Masonry.h"
#import "LocationManager.h"
#import "Location.h"
#import "AuthManager.h"

#import <FSMediaPicker.h>

@interface UserEditViewController ()<RETableViewManagerDelegate,FSMediaPickerDelegate,UITextViewDelegate, UIAlertViewDelegate>

@property (strong, readwrite, nonatomic) RETableViewManager *manager;

@property (nonatomic) NSArray *provinceDetailArray; //包含code信息
@property (nonatomic) NSArray *cityDetailArray;
@property (nonatomic) NSMutableArray *hospitalArray;
@property (nonatomic) UIImagePickerController *imagePicker;
@property (nonatomic) RERadioItem *nameItem;
@property (nonatomic) RERadioItem *realNameItem;
@property (nonatomic) REPickerItem *sexPicker;
@property (nonatomic) REPickerItem *examPicker;
@property (nonatomic) REPickerItem *cityPicker;

@end

@implementation UserEditViewController

User *userInfo;
UIButton *saveBtn;
UIImageView *avatarImage;
UIImage *selectedImage;
UILabel *label;
UITextView *editText;
NSMutableArray *provinces, *cities; // 本地plist中的地区信息

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavBar];
    self.view.backgroundColor = [UIColor whiteColor];
    
    AuthManager *am = [AuthManager sharedInstance];
    
    userInfo = am.userInfo;
    
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
    self.manager.tableView.backgroundColor = RGBCOLOR(235, 235, 235);
    
    provinces = [[NSMutableArray alloc]initWithCapacity:0];
    cities = [[NSMutableArray alloc]initWithCapacity:0];
    _hospitalArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    _provinceDetailArray = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city.plist" ofType:nil]];
    for (int i=0; i<[_provinceDetailArray count]; i++) {
        [provinces addObject:[[_provinceDetailArray objectAtIndex:i] objectForKey:@"name"]];
    }
    _cityDetailArray = [[_provinceDetailArray objectAtIndex:0] objectForKey:@"citys"];
    for (int i=0; i<[_cityDetailArray count]; i++) {
        [cities addObject:[[_cityDetailArray objectAtIndex:i] objectForKey:@"name"]];
    }
    
    [self setupAvatarSection];
    [self setupNameSection];
    [self setupRealNameSection];
    [self setupSexSection];
    [self setupProfileSection];
    [self setupDomainSection];
    [self setupLocationSection];
}

-(void)setNavBar
{
    [self.navigationItem setTitle:@"个人资料"];
    self.navigationController.navigationBar.translucent = NO;
    //保存按钮
    saveBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame=CGRectMake(0, 0, 50, 25);
    [saveBtn setTitleColor:COMMONBLUECOLOR forState:UIControlStateNormal];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    
    [saveBtn addTarget:self action:@selector(saveUserInfo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightbtn=[[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = rightbtn;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    [backBtn sizeToFit];
    [backBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

-(void)backButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupAvatarSection{
    
    UIView *avatarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, GENERAL_SIZE(230))];
    avatarView.backgroundColor = [UIColor whiteColor];
    UIImageView *photoImage = [[UIImageView alloc]init];
    photoImage.image = [UIImage imageNamed:@"ic_photo_small"];
    [photoImage sizeToFit];
    avatarImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, GENERAL_SIZE(150), GENERAL_SIZE(150))];
    avatarImage.layer.masksToBounds = YES;
    avatarImage.layer.cornerRadius = GENERAL_SIZE(75);
    avatarImage.layer.borderWidth = 1.0f;
    avatarImage.layer.borderColor = [RGBCOLOR(235, 235, 235) CGColor];
    avatarImage.center = avatarView.center;
    if (userInfo.avatar) {
        if ([userInfo.avatar rangeOfString:@".jpg"].location == NSNotFound) {
            [avatarImage sd_setImageWithURL:[NSURL URLWithString: [BASIC_IMAGE_URL stringByAppendingString:userInfo.avatar]] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
        }else{
            [avatarImage sd_setImageWithURL:[NSURL URLWithString: [@"http://api.olaxueyuan.com/upload/" stringByAppendingString:userInfo.avatar]] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
        }
    }else{
        [avatarImage setImage:[UIImage imageNamed:@"ic_avatar"]];
    }
    
    [avatarView addSubview:avatarImage];
    [avatarView addSubview:photoImage];
    
    [photoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(avatarImage.mas_right);
        make.bottom.equalTo(avatarImage.mas_bottom);
    }];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(GENERAL_SIZE(35), GENERAL_SIZE(228), SCREEN_WIDTH-GENERAL_SIZE(35),0.6)];
    line.backgroundColor = RGBCOLOR(213, 213, 213);
    [avatarView addSubview:line];
    
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImage)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [avatarView addGestureRecognizer:singleRecognizer];
    
    self.manager.tableView.tableHeaderView = avatarView;
    self.manager.tableView.tableFooterView = [[UIView alloc]init];;
}

-(void)setupNameSection{
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:nil];
    NSString *userName =  userInfo.name;
    _nameItem = [RERadioItem itemWithTitle:@"用户昵称" value:userName selectionHandler:^(RERadioItem *item) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"用户昵称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 1;
        alert.alertViewStyle=UIAlertViewStylePlainTextInput;
        UITextField *textField= [alert textFieldAtIndex:0];
        textField.text=userInfo.name;
        [alert show];
        
    }];
    _nameItem.accessoryType = UITableViewCellAccessoryNone;
    [section addItem:_nameItem];
    [self.manager addSection:section];

}

-(void)setupRealNameSection{
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:nil];
    NSString *userName =  userInfo.realName?userInfo.realName:@"";
    _realNameItem = [RERadioItem itemWithTitle:@"真实姓名" value:userName selectionHandler:^(RERadioItem *item) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"真实姓名" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 2;
        alert.alertViewStyle=UIAlertViewStylePlainTextInput;
        UITextField *textField= [alert textFieldAtIndex:0];
        textField.text=userInfo.realName?userInfo.realName:@"";
        [alert show];
        
    }];
    _realNameItem.accessoryType = UITableViewCellAccessoryNone;
    [section addItem:_realNameItem];
    [self.manager addSection:section];
    
}

-(void)setupSexSection{
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:nil];
    NSString *sex;
    if ([userInfo.sex isEqualToString:@"1"]) {
        sex = @"男";
    }else{
        sex = @"女";
    }
    _sexPicker = [REPickerItem itemWithTitle:@"性别" value:@[sex] placeholder:nil options:@[@[@"男", @"女"]]];
    _sexPicker.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _sexPicker.onChange = ^(REPickerItem *item){
    };
    _sexPicker.inlinePicker = NO;
    
    [section addItem:_sexPicker];
    [self.manager addSection:section];
}

-(void)setupProfileSection{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *profileL = [[UILabel alloc]initWithFrame:CGRectMake(GENERAL_SIZE(35), 0, 200, 40)];
    profileL.text = @"个人签名";
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(GENERAL_SIZE(35), 0, SCREEN_WIDTH-GENERAL_SIZE(35), 1)];
    line.backgroundColor = RGBCOLOR(235, 235, 235);
    [view addSubview:profileL];
    [view addSubview:line];
    
    UIView *editView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    editView.backgroundColor = [UIColor whiteColor];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(3, 3, 200, 20)];
    label.enabled = NO;
    label.text = @"在您的资料中添加个性签名";
    label.font =  [UIFont systemFontOfSize:15];
    label.textColor = [UIColor blackColor];
    
    editText = [UITextView new];
    if (userInfo.signature&&![editText.text = userInfo.signature isEqualToString:@""]) {
        editText.text = userInfo.signature;
        label.text= @"";
    }
    editText.returnKeyType=UIReturnKeyDone;
    editText.delegate = self;
    editText.font=[UIFont systemFontOfSize:16];
    editText.backgroundColor = [UIColor whiteColor];
    [editText addSubview:label];
    [editView addSubview:editText];
    
    UIView *bottomline = [[UIView alloc]initWithFrame:CGRectMake(GENERAL_SIZE(35), 119, SCREEN_WIDTH-GENERAL_SIZE(35), 0.6)];
    bottomline.backgroundColor = RGBCOLOR(213, 213, 213);
    [editView addSubview:bottomline];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(0, GENERAL_SIZE(35), 10, 10);
    [editText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(editView).with.insets(padding);
    }];
    
    RETableViewSection* section = [RETableViewSection  sectionWithHeaderView:view footerView:editView];
    [self.manager addSection:section];
}

-(void)setupDomainSection{
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:nil];
    NSString *examType = userInfo.examType&&![userInfo isEqual:@""]?userInfo.examType:@"研究生管理类联考";
    NSArray *optionArray = [NSArray arrayWithObjects:@"工商管理硕士(MBA)",@"会计硕士(MPAcc)",@"审计硕士(MAud)",@"公共管理硕士(MPA)",@"工程管理硕士(MEM)",@"旅游管理硕士(MTA)",@"图书情报硕士(MLis)", @"其他管理硕士(Other)",nil];
    if([optionArray indexOfObject:examType] == NSNotFound){
        examType = [optionArray objectAtIndex:0];
    }
    _examPicker = [REPickerItem itemWithTitle:@"关注领域" value:@[examType] placeholder:nil options:@[optionArray]];
    _examPicker.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _examPicker.onChange = ^(REPickerItem *item){
    };
    _examPicker.inlinePicker = NO;
    
    [section addItem:_examPicker];
    [self.manager addSection:section];
    
}

-(void)setupLocationSection{
    RETableViewSection* section = [RETableViewSection sectionWithHeaderTitle:nil];
    
    __weak UserEditViewController *wself = self;
    
    NSArray *localInfo;
    if (userInfo.local) {
        localInfo = [userInfo.local componentsSeparatedByString: @"," ];
        NSString *province = [localInfo objectAtIndex:0];
        NSUInteger index = [provinces indexOfObject:province];
        NSArray *cityArray = [[wself.provinceDetailArray objectAtIndex:index] objectForKey:@"citys"];
        [cities removeAllObjects];
        for (int i=0; i<[cityArray count]; i++) {
            [cities addObject:[[cityArray objectAtIndex:i] objectForKey:@"name"]];
        }
        
    }else{
        localInfo = @[@"北京市", @"海淀区"];
    }
    
    _cityPicker = [REPickerItem itemWithTitle:@"所在地" value:localInfo placeholder:nil options:@[provinces,cities]];
    _cityPicker.onChange = ^(REPickerItem *item){
        NSUInteger index = [provinces indexOfObject:[item.value objectAtIndex:0]];
        NSArray *cityArray = [[wself.provinceDetailArray objectAtIndex:index] objectForKey:@"citys"];
        [cities removeAllObjects];
        for (int i=0; i<[cityArray count]; i++) {
            [cities addObject:[[cityArray objectAtIndex:i] objectForKey:@"name"]];
        }
        item.options = @[provinces,cities];
    };
    
    _cityPicker.inlinePicker = NO;
    [section addItem:_cityPicker];
    
    [self.manager addSection:section];
}

-(void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text length] == 0) {
        [label setHidden:NO];
    }else{
        [label setHidden:YES];
    }
}

#pragma imagepicker delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    selectedImage = info[UIImagePickerControllerOriginalImage];
    [avatarImage setImage:selectedImage];
}

#pragma mark alertview delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==1&&buttonIndex==1) {
        _nameItem.value = [alertView textFieldAtIndex:0].text;
        [_nameItem reloadRowWithAnimation:UITableViewRowAnimationNone];
    }
    if (alertView.tag==2&&buttonIndex==1) {
        _realNameItem.value = [alertView textFieldAtIndex:0].text;
        [_realNameItem reloadRowWithAnimation:UITableViewRowAnimationNone];
    }
}

-(void)chooseImage{
    FSMediaPicker *mediaPicker = [[FSMediaPicker alloc] init];
    mediaPicker.mediaType = FSMediaTypePhoto;
    mediaPicker.editMode = FSMediaTypePhoto;
    mediaPicker.delegate = self;
    [mediaPicker showFromView:self.view];
}

#pragma mediaPicker delegate

- (void)mediaPicker:(FSMediaPicker *)mediaPicker didFinishWithMediaInfo:(NSDictionary *)mediaInfo
{
    if (mediaPicker.editMode == FSEditModeNone) {
        selectedImage = mediaInfo.originalImage;
    } else {
        selectedImage = mediaPicker.editMode == FSEditModeCircular? mediaInfo.circularEditedImage:mediaInfo.editedImage;
    }
    [avatarImage setImage:selectedImage];
}

- (void)mediaPickerDidCancel:(FSMediaPicker *)mediaPicker{
}

-(void)saveUserInfo{
    [saveBtn setTitleColor:RGBCOLOR(153, 153, 153) forState:UIControlStateNormal];
    if (selectedImage) {
        [self uploadImage];
    }else{
        NSString* imgGid = userInfo.avatar?userInfo.avatar:@"";
        [self updateUserInfo:imgGid];
    }
}

- (void)uploadImage
{
    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"保存中，请稍后..."]];
    
    UploadManager* um = [[UploadManager alloc]init];
     NSData* imageData = UIImageJPEGRepresentation(selectedImage, 0.8);
    [um uploadImageData:imageData angle:nil success:^{
        NSString *imageGid =  um.imageGid;
        [self updateUserInfo:imageGid];
    } failure:^(NSError *error) {
        [saveBtn setTitleColor:RGBCOLOR(01, 139, 232) forState:UIControlStateNormal];
    }];
}

-(void)updateUserInfo:(NSString*)imageGid{
    NSString *userLocation = _cityPicker.value!=nil?[[[_cityPicker.value objectAtIndex:0]stringByAppendingString:@","] stringByAppendingString:[_cityPicker.value objectAtIndex:1]]:@"";
    NSString *sex = [[_sexPicker.value objectAtIndex:0] isEqualToString:@"男"]?@"1":@"2";
    NSString *descript = editText.text;
    NSString *examType =_examPicker.value?[_examPicker.value objectAtIndex:0]:@"";
    UserManager *um = [[UserManager alloc]init];
    [um updateUserWithUserId:userInfo.userId Name:_nameItem.value RealName:_realNameItem.value sex:sex local:userLocation ExamType:examType descript:descript
                      avatar:imageGid Success:^{
                          [SVProgressHUD showSuccessWithStatus:@"更新成功"];
                          if (_successFunc != nil)
                          {
                              _successFunc();
                          }
                          [self.navigationController popViewControllerAnimated:YES];
    } Failure:^(NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"保存失败"];
        [saveBtn setTitleColor:RGBCOLOR(01, 139, 232) forState:UIControlStateNormal];
    }];
    
}

#pragma 服务器获取地区信息，暂未使用
// 省、直辖市
-(void)fetchProvinceList{
    LocationManager *lm = [[LocationManager alloc]init];
    [lm fetchLocationWithCode:@"" level:@"1" Success:^{
        NSMutableArray *provinceArray = [NSMutableArray arrayWithCapacity:0];
        _provinceDetailArray =lm.locationArray;
        for(Location *province in lm.locationArray) {
            [provinceArray addObject:province.name];
        }
    } Failure:^(NSError *error) {
        
    }];
}
// 地级市
-(void)fetchCityList:(NSString*)code{
    LocationManager *lm = [[LocationManager alloc]init];
    [lm fetchLocationWithCode:code level:@"2" Success:^{
        NSMutableArray *cityArray = [NSMutableArray arrayWithCapacity:0];
        for(Location *city in lm.locationArray) {
            [cityArray addObject:city.name];
        }
    } Failure:^(NSError *error) {
        
    }];
}

//点击return
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
