//
//  MaterialBrowseController.m
//  mxedu
//
//  Created by 田晓鹏 on 16/10/31.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "MaterialBrowseController.h"

#import "SysCommon.h"
#import "PDFView.h"
#import "SVProgressHUD.h"
#import <MessageUI/MessageUI.h>

#import "MaterialManager.h"

@interface MaterialBrowseController ()<MFMailComposeViewControllerDelegate>

@end

@implementation MaterialBrowseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PDFView *pdfView = [[PDFView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-UI_STATUS_BAR_HEIGHT)];
    [self.view addSubview:pdfView];
    
    if (_material) {
        self.title = _material.title;
        [self setupRightButton];
        [self updateBrowseCount];
    }else{
        self.title = _org.profile;
        _material = [[Material alloc]init];
        _material.materialId = [NSString stringWithFormat:@"org%@",_org.orgId];
        _material.url = _org.address;
    }
    [pdfView loadPDFWithmaterial:_material];
}

-(void)setupRightButton{
    UIImageView *slideBtn = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    slideBtn.image = [UIImage imageNamed:@"ic_pdf_share"];
    slideBtn.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendMailInApp)];
    [slideBtn addGestureRecognizer:singleTap];
    [slideBtn sizeToFit];
    
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:slideBtn];
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
}

-(void)updateBrowseCount{
    MaterialManager *mm = [[MaterialManager alloc]init];
    [mm updateBrowseCountWithID:_material.materialId Success:^(CommonResult *result) {
        
    } Failure:^(NSError *error) {
        
    }];
}

#pragma  发送邮件 以及 代理
#pragma mark - 在应用内发送邮件
//激活邮件功能
- (void)sendMailInApp
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (!mailClass) {
        //[self alertWithMessage:@"当前系统版本不支持应用内发送邮件功能，您可以使用mailto方法代替"];
        return;
    }
    if (![mailClass canSendMail]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请先在设置中配置您的邮箱，再进行分享。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        alert.tag = 1003;
        [alert show];
        return;
    }
    [self displayMailPicker];
}

//调出邮件发送窗口
- (void)displayMailPicker
{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    mailPicker.mailComposeDelegate = self;
    
    [mailPicker setSubject: @"欧拉学院讲义"];
    //添加收件人
    //NSArray *toRecipients = [NSArray arrayWithObject: @"forevertxp@gmail.com"];
    //[mailPicker setToRecipients: toRecipients];
    
    //NSString *emailBody = @"<h6><hr id='ht'></h6><div><sup>欧拉学院</sup></div><div><sup>北京市海淀区清华科技园清华x-lab</sup></div><div><sup>我们的征途是星辰和大海！</sup></div>";
    //[mailPicker setMessageBody:emailBody isHTML:YES];
    
    //添加pdf附件
    NSString *fileName = [NSString stringWithFormat:@"material_%@.pdf",_material.materialId];
    NSString* filepath = [[kDocPath stringByAppendingString:kPDFDataPath] stringByAppendingPathComponent:fileName];
    NSData *pdf = [NSData dataWithContentsOfFile:filepath];
    [mailPicker addAttachmentData:pdf mimeType:@"" fileName:_material.title];
    
    [self presentViewController: mailPicker animated:YES completion:nil];
}

#pragma mark - 实现 MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    //关闭邮件发送窗口
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString *msg;
    switch (result) {
        case MFMailComposeResultCancelled:
            msg = @"发送已取消";
            break;
        case MFMailComposeResultSaved:
            msg = @"成功保存邮件";
            break;
        case MFMailComposeResultSent:
            msg = @"邮件已发送";
            break;
        case MFMailComposeResultFailed:
            msg = @"保存或者发送邮件失败";
            break;
    }
    [SVProgressHUD showInfoWithStatus:msg];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
