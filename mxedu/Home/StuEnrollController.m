//
//  StuEnrollController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/11/6.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "StuEnrollController.h"

#import "SysCommon.h"
#import "NSString+ContentCheck.h"
#import "AuthManager.h"
#import "OrganizationManager.h"
#import "Organization.h"
#import "OrgInfoList.h"
#import "SVProgressHUD.h"
#import "MaterialBrowseController.h"

@interface StuEnrollController ()<UITextViewDelegate>
{
    
    UITextView *nameT;
    UITextView *phoneT;
    UILabel *brochureL;
    
    NSArray *orgInfoArray; //后台返回的数据
    
    LMComBoxView *nameComBox;
    
    NSMutableArray *orgList;  //机构or院校
    NSArray *nameList; // 具体的机构or院校列表
    
    int currentOrgIndex;
    int currentNameIndex;
    
    NSString *selectedOrg;
    NSString *selectedName;
    
    
    NSMutableArray *subArray;
    
    UIButton *enrollBtn;
    
    UITapGestureRecognizer *wholeTap;
    
}
@end

@implementation StuEnrollController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"报名通道";
    self.view.backgroundColor = RGBCOLOR(246, 247, 248);
    
    currentOrgIndex = _optionIndex;
    currentNameIndex = _nameIndex;
    [self setupData];
    
    wholeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
}

-(void)setupData{
    OrganizationManager *om = [[OrganizationManager alloc]init];
    [om fetchOrganizationInfoSuccess:^(OrgInfoListResult *result) {
        orgInfoArray = result.orgInfoArray;
        // 选项 （机构或学校）
        orgList = [NSMutableArray arrayWithCapacity:result.orgInfoArray.count];
        // 对应的数组集合（机构名数组  学校名数组）
        subArray = [NSMutableArray arrayWithCapacity:result.orgInfoArray.count];

        for (OrgInfoList *orgInfoList in result.orgInfoArray) {
            [orgList addObject:orgInfoList.optionName];
            NSMutableArray *nameArray = [NSMutableArray arrayWithCapacity:orgInfoList.optionList.count];
            for (Organization *org in orgInfoList.optionList) {
                [nameArray addObject:org.name];
            }
            [subArray addObject:nameArray];
        }
        selectedOrg = [orgList objectAtIndex:currentOrgIndex];
        
        nameList = [subArray objectAtIndex:currentOrgIndex];
        selectedName = [nameList objectAtIndex:currentNameIndex];
        
        
        [self setUpView];
        
    } Failure:^(NSError *error) {
        
    }];
}

-(void)setUpView
{
    UIImageView *headIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"head_enroll"]];
    headIV.frame = CGRectMake(0, 0, SCREEN_WIDTH, GENERAL_SIZE(395));
    [self.view addSubview:headIV];
    
    UILabel *tipL = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headIV.frame)+GENERAL_SIZE(30), SCREEN_WIDTH, GENERAL_SIZE(30))];
    tipL.text = @"请填写您的报名需求";
    tipL.textColor = RGBCOLOR(97, 98, 99);
    tipL.font = LabelFont(28);
    tipL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipL];
    
    // 选项 （机构／学校）
    LMComBoxView *comBox = [[LMComBoxView alloc]initWithFrame:CGRectMake(GENERAL_SIZE(40), CGRectGetMaxY(tipL.frame)+GENERAL_SIZE(30), SCREEN_WIDTH-GENERAL_SIZE(80), GENERAL_SIZE(80))];
    comBox.tag = 1001;
    comBox.backgroundColor = [UIColor clearColor];
    comBox.arrowImgName = @"ic_combox";
    comBox.titlesList = [NSMutableArray arrayWithArray:orgList];
    comBox.defaultIndex = currentOrgIndex;
    comBox.delegate = self;
    comBox.supView = self.view;
    [comBox defaultSettings];
    [self.view addSubview:comBox];
    
    //姓名
    UIView *nameView = [[UIView alloc]initWithFrame:CGRectMake(GENERAL_SIZE(40), CGRectGetMaxY(comBox.frame)+GENERAL_SIZE(20), SCREEN_WIDTH-GENERAL_SIZE(80), GENERAL_SIZE(80))];
    nameView.layer.borderColor = [RGBCOLOR(235, 235, 235) CGColor];
    nameView.layer.borderWidth = 1.0f;
    [self.view addSubview:nameView];
    
    nameT = [[UITextView alloc]initWithFrame:CGRectMake(6, GENERAL_SIZE(10), 200, GENERAL_SIZE(60))];
    nameT.backgroundColor = [UIColor clearColor];
    nameT.textColor = RGBCOLOR(97, 98, 99);
    nameT.font = LabelFont(28);
    nameT.delegate = self;
    [nameView addSubview:nameT];
    
    
    //联系方式
    UIView *phoneView = [[UIView alloc]initWithFrame:CGRectMake(GENERAL_SIZE(40), CGRectGetMaxY(nameView.frame)+GENERAL_SIZE(20), SCREEN_WIDTH-GENERAL_SIZE(80), GENERAL_SIZE(80))];
    phoneView.layer.borderColor = [RGBCOLOR(235, 235, 235) CGColor];
    phoneView.layer.borderWidth = 1.0f;
    [self.view addSubview:phoneView];
    
    phoneT = [[UITextView alloc]initWithFrame:CGRectMake(6, GENERAL_SIZE(10), 200, GENERAL_SIZE(60))];
    phoneT.backgroundColor = [UIColor clearColor];
    phoneT.font = LabelFont(28);
    phoneT.textColor = RGBCOLOR(97, 98, 99);
    phoneT.delegate = self;
    [phoneView addSubview:phoneT];
    
    User *userInfo = [AuthManager sharedInstance].userInfo;
    if (userInfo.realName&&![userInfo.realName isEqualToString:@""]) {
        nameT.text = userInfo.realName;
    }else{
        nameT.text = userInfo.name;
    }
    phoneT.text = userInfo.phone;
    
    // 具体对应的机构或学校列表
    nameComBox = [[LMComBoxView alloc]initWithFrame:CGRectMake(GENERAL_SIZE(40), CGRectGetMaxY(phoneView.frame)+GENERAL_SIZE(20), SCREEN_WIDTH-GENERAL_SIZE(80), GENERAL_SIZE(80))];
    nameComBox.tag = 1002;
    nameComBox.backgroundColor = [UIColor clearColor];
    nameComBox.arrowImgName = @"ic_combox";
    nameComBox.titlesList = [NSMutableArray arrayWithArray:nameList];
    nameComBox.defaultIndex = currentNameIndex;
    nameComBox.delegate = self;
    nameComBox.supView = self.view;
    [nameComBox defaultSettings];
    [self.view addSubview:nameComBox];
    
    UIImageView *profileIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_border"]];
    profileIV.frame = CGRectMake(GENERAL_SIZE(40), CGRectGetMaxY(nameComBox.frame)+GENERAL_SIZE(10),  SCREEN_WIDTH-GENERAL_SIZE(80), GENERAL_SIZE(80));
    [self.view addSubview:profileIV];
    
    brochureL = [[UILabel alloc]initWithFrame:CGRectMake(10, 2,SCREEN_WIDTH-GENERAL_SIZE(100), GENERAL_SIZE(80))];
    OrgInfoList *orgInfoList = orgInfoArray[0];
    Organization *org = [orgInfoList.optionList objectAtIndex:0];
    brochureL.text = org.profile;
    brochureL.font = LabelFont(24);
    brochureL.textColor = RGBCOLOR(0, 158, 247);
    [profileIV addSubview:brochureL];
    
    profileIV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showBrochureDetail)];
    [profileIV addGestureRecognizer:tap];
    
    enrollBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [enrollBtn setTitle:@"立即报名" forState:UIControlStateNormal];
    enrollBtn.layer.masksToBounds = YES;
    enrollBtn.layer.cornerRadius = GENERAL_SIZE(6);
    enrollBtn.backgroundColor = COMMONBLUECOLOR;
    enrollBtn.frame = CGRectMake(GENERAL_SIZE(40), CGRectGetMaxY(profileIV.frame)+GENERAL_SIZE(60),  SCREEN_WIDTH-GENERAL_SIZE(80), GENERAL_SIZE(80));
    [enrollBtn addTarget:self action:@selector(checkin) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:enrollBtn];

    UILabel *tipL2 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(enrollBtn.frame)+GENERAL_SIZE(20), SCREEN_WIDTH, GENERAL_SIZE(30))];
    tipL2.text = @"点击报名后，机构/院校招生人员会马上与您取得联系";
    tipL2.textColor = RGBCOLOR(208, 209, 210);
    tipL2.font = LabelFont(24);
    tipL2.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipL2];
}

#pragma mark -LMComBoxViewDelegate
-(void)selectAtIndex:(int)index inCombox:(LMComBoxView *)_combox
{
    switch (_combox.tag) {
        case 1001:
        {
            currentOrgIndex = index;
            selectedOrg =  [orgList objectAtIndex:index];
            
            nameList = [subArray objectAtIndex:index];
            
            //刷新对应的机构或学校
            nameComBox.titlesList = [NSMutableArray arrayWithArray:nameList];
            [nameComBox reloadData];
            
            selectedName = [nameList objectAtIndex:0];
            
            //招生简章
            OrgInfoList *orgInfoList = orgInfoArray[currentOrgIndex];
            Organization *org = [orgInfoList.optionList objectAtIndex:0];
            brochureL.text = org.profile;
            
            break;
        }
        case 1002:
        {
            currentNameIndex = index;
            selectedName = [nameList objectAtIndex:index];
            //招生简章
            OrgInfoList *orgInfoList = orgInfoArray[currentOrgIndex];
            Organization *org = [orgInfoList.optionList objectAtIndex:currentNameIndex];
            brochureL.text = org.profile;
            
            break;
        }
            
        default:
            break;
    }
}

-(void)showBrochureDetail{
    MaterialBrowseController * browseVC = [[MaterialBrowseController alloc]init];
    OrgInfoList *orgInfoList = orgInfoArray[currentOrgIndex];
    browseVC.org = [orgInfoList.optionList objectAtIndex:currentNameIndex];
    [self.navigationController pushViewController:browseVC animated:YES];
}

// 报名
-(void)checkin{
    if(!phoneT.text.isValidChineseCellphoneNumberWithoutPrefix){
        UIAlertView * aView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aView show];
        return;
    }
    [SVProgressHUD showWithStatus:@"请稍后..."];
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    OrganizationManager *om =[[OrganizationManager alloc]init];
    User *userInfo = [AuthManager sharedInstance].userInfo;
    OrgInfoList *orgInfoList = orgInfoArray[currentOrgIndex];
    Organization *org = [orgInfoList.optionList objectAtIndex:currentNameIndex];
    [om checkInWithOrgId:org.orgId CheckinTime:[dateFormatter stringFromDate:currentDate] UserPhone:phoneT.text UserLocal:userInfo.local?userInfo.local:@"" Success:^(CommonResult *result) {
        [SVProgressHUD dismiss];
        if(result.code==10000){
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"报名成功" message:@"稍后客服与您取得联系" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    } Failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    [self.view addGestureRecognizer:wholeTap];
}

/**
 *  隐藏键盘
 */
-(void)dismissKeyboard {
    NSArray *subviews = [self.view subviews];
    for (id objInput in subviews) {
        if ([objInput isKindOfClass:[UITextField class]]) {
            UITextField *theTextField = objInput;
            if ([objInput isFirstResponder]) {
                [theTextField resignFirstResponder];
            }
        }
    }
    [self.view endEditing:YES];
    [self.view removeGestureRecognizer:wholeTap];
}

-(void)viewWillDisappear:(BOOL)animated{
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
