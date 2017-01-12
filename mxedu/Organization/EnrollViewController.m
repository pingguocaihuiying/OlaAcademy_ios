//
//  EnrollViewController.m
//  报名页面
//
//  Created by 田晓鹏 on 15/10/21.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import "EnrollViewController.h"

#import "SysCommon.h"
#import "Masonry.h"
#import "Teacher.h"
#import "User.h"

#import "UIImageView+WebCache.h"
#import "PopPickerView.h"

#import "AuthManager.h"
#import "OrganizationManager.h"

#import "TeacherInfoViewController.h"

@interface EnrollViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@end

@implementation EnrollViewController{
    
    UIImageView *_imageView;
    
    UISegmentedControl *_segmentControl;
    
    UITableView *_teacherTableView;
    UILabel *_introLabel;
    UIView *_checkInView;
    UIButton *_enrollButton;
    
    NSArray *teacherArray;
    
    UITextField *phoneText;
    UILabel *dateLabel;
    UIImageView *michenImageView;
    
    int type; //1通过幂辰报名
    
    User *userInfo;
    
    BOOL isCheckedIn;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"报名";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupBackButton];
    
    isCheckedIn = NO;
    AuthManager *am = [AuthManager sharedInstance];
    if (am.isAuthenticated) {
        userInfo = am.userInfo;
        phoneText.text = userInfo.phone;
        
        OrganizationManager *om = [[OrganizationManager alloc]init];
        [om fetchInfoByUserPhone:userInfo.phone OrgId:_org.orgId Success:^(CheckInResult *result) {
            if (result.checkInfo) {
                isCheckedIn = YES;
            }
            
        } Failure:^(NSError *error) {
            
        }];
    }
    
    [self setupView];
    
    [self setUpForDismissKeyboard];
    
    [self updateAttendCount];
    
}

// 更新机构关注人数
-(void)updateAttendCount{
    OrganizationManager *om =[[OrganizationManager alloc]init];
    [om updateAttendCountWithOrgId: _org.orgId Success:^(CommonResult *result) {
    } Failure:^(NSError *error) {
    }];
}

// 更新机构报名人数
-(void)updateCheckInCount{
    OrganizationManager *om =[[OrganizationManager alloc]init];
    [om updateCheckInCountWithOrgId:_org.orgId Type:@"1" Success:^(CommonResult *result) {
    } Failure:^(NSError *error) {
    }];
}

- (void)setupBackButton
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    [backBtn sizeToFit];
    [backBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

-(void)backButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupView{
    _imageView = [[UIImageView alloc]init];
    _imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*9/16);
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_org.address] placeholderImage:nil];
    [self.view addSubview:_imageView];
    
    [self setupSegmentControl];
    
    [self setupIntroInfo];
    
}

-(void)setupSegmentControl{
    
    NSArray *arrayForSegmentedControl = [NSArray arrayWithObjects:@"简介", @"名师", @"报名", nil];
    _segmentControl = [[UISegmentedControl alloc]initWithItems:arrayForSegmentedControl];
    
    _segmentControl.frame = CGRectMake(20, CGRectGetMaxY(_imageView.bounds)+10, SCREEN_WIDTH-40, 30);
    [_segmentControl setTintColor:COMMONBLUECOLOR];
    _segmentControl.selectedSegmentIndex = 0;
    [self.view addSubview:_segmentControl];
    [_segmentControl addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];
}
    
    -(void)segmentAction:(UISegmentedControl *)Seg{
        
        NSInteger index = Seg.selectedSegmentIndex;
        
        switch (index) {
            case 0:
            {
                _introLabel.hidden = NO;
                _teacherTableView.hidden = YES;
                _checkInView.hidden = YES;
            }
                break;
            case 1:
            {
                [self setupTableView];
            }
                break;
            case 2:
            {
                [self setupCheckinView];

            }
                break;
        }
        
    }


/**
 *  简介
 */
- (void)setupIntroInfo
{
    if (!_introLabel) {
        _introLabel = [UILabel new];
        _introLabel.numberOfLines = 0;
        _introLabel.font = [UIFont systemFontOfSize:14.0];
        _introLabel.textColor = RGBCOLOR(153, 153, 153);
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.firstLineHeadIndent = 30;
        style.lineSpacing = 5;
        NSMutableAttributedString *profile = [[NSMutableAttributedString alloc] initWithString:self.org.profile];
        [profile addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, profile.length)];
        _introLabel.attributedText = profile;
        
        [_introLabel sizeToFit];
        [self.view addSubview:_introLabel];
        
        [_introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_segmentControl.mas_bottom).offset(10);
            make.left.equalTo(self.view.mas_left).offset(10);
            make.right.equalTo(self.view.mas_right).offset(-10);
        }];
    }
}

/**
 *  师资
 */
- (void)setupTableView
{
    if (!_teacherTableView) {
        _teacherTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _teacherTableView.delegate = self;
        _teacherTableView.dataSource = self;
        _teacherTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_teacherTableView];
        
        [_teacherTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_segmentControl.mas_bottom).offset(10);
            make.left.equalTo(self.view.mas_left).offset(5);
            make.right.equalTo(self.view.mas_right).offset(-5);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        
    }
    _introLabel.hidden = YES;
    _teacherTableView.hidden = NO;
    _checkInView.hidden = YES;
    
    [self setTeacherTableData];
}

-(void)setTeacherTableData{
    OrganizationManager *om = [[OrganizationManager alloc]init];
    [om fetchUserListWithOrgId:self.org.orgId Success:^(TeacherResult *result) {
        teacherArray = result.teacherList;
        [_teacherTableView reloadData];
    } Failure:^(NSError *error) {
        
    }];
}


/**
 *  报名
 */
- (void)setupCheckinView
{
    if (!_checkInView) {
        _checkInView = [[UIView alloc]init];
        
        UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 30)];
        phoneLabel.text = @"报名手机";
        [_checkInView addSubview:phoneLabel];
        
        phoneText = [[UITextField alloc]initWithFrame:CGRectMake(110, 5, 200, 30)];
        phoneText.delegate = self;
        phoneText.returnKeyType = UIReturnKeyDone;
        [_checkInView addSubview:phoneText];

        if (userInfo) {
            phoneText.text = userInfo.phone;
        }
        
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, SCREEN_WIDTH, 1)];
        lineView1.backgroundColor = RGBCOLOR(236, 236, 236);
        [_checkInView addSubview:lineView1];
        
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 43, 200, 40)];
        timeLabel.text = @"报名时间";
        [_checkInView addSubview:timeLabel];
        
        dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 43, 200, 40)];
        dateLabel.text = [self currentDate];
        UITapGestureRecognizer *tapGestureRecognizer =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dateLabelClicked:)];
        dateLabel.userInteractionEnabled=YES;
        [dateLabel addGestureRecognizer:tapGestureRecognizer];
        [_checkInView addSubview:dateLabel];
        
        UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 85, SCREEN_WIDTH, 50)];
        typeLabel.text = @"  报名方式";
        typeLabel.backgroundColor = RGBCOLOR(230, 230, 230);
        [_checkInView addSubview:typeLabel];
        
        UILabel *wayLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 135, 250, 40)];
        wayLabel1.text = @"通过『Swift Academy』报名";
        [_checkInView addSubview:wayLabel1];
        
        UIImageView *discountView1 = [[UIImageView alloc]init];
        discountView1.image = [UIImage imageNamed:@"ic_discount1"];
        [discountView1 sizeToFit];
        [_checkInView addSubview:discountView1];
        
        type = 1;
        michenImageView = [[UIImageView alloc]init];
        michenImageView.image = [UIImage imageNamed:@"ic_chosen"];
        [michenImageView sizeToFit];
        michenImageView.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap1 =[[UITapGestureRecognizer alloc]initWithTarget:self
                                                                             action:@selector(chooseMichen)];
        [michenImageView addGestureRecognizer:tap1];
        [_checkInView addSubview:michenImageView];
        
        [michenImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(wayLabel1.mas_centerY).offset(0);
            make.right.equalTo(_checkInView.mas_right).offset(-20);
        }];
        
        [discountView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(wayLabel1.mas_centerY).offset(0);
            make.right.equalTo(michenImageView.mas_left).offset(-10);
        }];

        
        UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 175, SCREEN_WIDTH, 1)];
        lineView2.backgroundColor = RGBCOLOR(236, 236, 236);
        [_checkInView addSubview:lineView2];
        
         _enrollButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (isCheckedIn) {
            [_enrollButton setImage:[UIImage imageNamed:@"ic_checkin_ed"] forState:UIControlStateNormal];
        }else{
            [_enrollButton setImage:[UIImage imageNamed:@"ic_enroll"] forState:UIControlStateNormal];
            [_enrollButton addTarget:self action:@selector(checkin) forControlEvents:UIControlEventTouchDown];
        }
        [_enrollButton sizeToFit];
        [_checkInView addSubview:_enrollButton];
        
        [_enrollButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineView2.mas_bottom).offset(60);
            make.centerX.equalTo(_checkInView.mas_centerX);
        }];

        
        [self.view addSubview:_checkInView];
        
        [_checkInView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_segmentControl.mas_bottom).offset(10);
            make.left.equalTo(self.view.mas_left).offset(0);
            make.right.equalTo(self.view.mas_right).offset(0);
            make.bottom.equalTo(self.view.mas_bottom);
        }];

    }
    
    _introLabel.hidden = YES;
    _teacherTableView.hidden = YES;
    _checkInView.hidden = NO;
    
}

-(void)chooseMichen{
    [michenImageView setImage:[UIImage imageNamed:@"ic_chosen"]];
    type =1 ;
}

- (void)dateLabelClicked:(UITapGestureRecognizer*) recognizer
{
    
    NSString *dateStr = [self currentDate];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [format dateFromString:dateStr];
    
    PopPickerView *pickerView = [[PopPickerView alloc] initWithDate:date withMode:UIDatePickerModeDate];
    pickerView.backgroundColor = [UIColor clearColor];
    pickerView.pickerView.tag = 1002;
    [self.view addSubview:pickerView];

    [pickerView setButtonClickBlock:^(PopPickerView *pickerView, NSInteger index) {
        
        if (index == 1) {
            dateLabel.text = [format stringFromDate:pickerView.datePickerView.date];
            //[_dateButton setTitle:title forState:UIControlStateNormal];
        }
        
        [pickerView removeFromSuperview];
    }];
}

-(void)checkin{
    if ([phoneText.text isEqualToString:@""]) {
        return;
    }
    [_enrollButton setEnabled:NO];
    OrganizationManager *om =[[OrganizationManager alloc]init];
    [om checkInWithOrgId:_org.orgId CheckinTime:dateLabel.text UserPhone:phoneText.text UserLocal:@"" Success:^(CommonResult *result) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"报名成功" message:@"稍后客服与您取得联系" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [_enrollButton setImage:[UIImage imageNamed:@"ic_checkin_ed"] forState:UIControlStateNormal];
        [self updateCheckInCount];
    } Failure:^(NSError *error) {
        [_enrollButton setEnabled:YES];
    }];
}

-(NSString*)currentDate{
    // 获取系统当前时间
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    
    //设置时间输出格式：
    NSDateFormatter * df = [[NSDateFormatter alloc] init ];
    [df setDateFormat:@"yyyy-MM-dd"];
    return [df stringFromDate:currentDate];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [teacherArray count];;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"teacherCell";
    UITableViewCell *teacherCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (teacherCell == nil) {
        teacherCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"teacherCell"];
    }
    Teacher *teacherInfo = [teacherArray objectAtIndex:indexPath.row];
    
    [teacherCell.imageView sd_setImageWithURL:[NSURL URLWithString:teacherInfo.avatar] placeholderImage:nil];
    
    teacherCell.imageView.layer.cornerRadius = 5;
    teacherCell.imageView.layer.masksToBounds = YES;
    teacherCell.imageView.layer.borderWidth = 1;
    teacherCell.imageView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    CGSize itemSize = CGSizeMake(60, 60);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [teacherCell.imageView.image drawInRect:imageRect];
    teacherCell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    teacherCell.textLabel.text = teacherInfo.name;
    teacherCell.detailTextLabel.text = teacherInfo.profile;
    teacherCell.detailTextLabel.textColor = RGBCOLOR(153, 153, 153);
    teacherCell.detailTextLabel.numberOfLines = 3;
    teacherCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    teacherCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return teacherCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Teacher *teacherInfo = [teacherArray objectAtIndex:indexPath.row];
    TeacherInfoViewController *teacherVC = [[TeacherInfoViewController alloc]init];
    teacherVC.teacherInfo = teacherInfo;
    [self.navigationController pushViewController:teacherVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

// 隐藏软键盘
- (void)setUpForDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
