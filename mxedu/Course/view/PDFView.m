//
//  PDFView.m
//  mxedu
//
//  Created by 田晓鹏 on 16/9/18.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "PDFView.h"

#import "SysCommon.h"
#import "Masonry.h"
#import "UIColor+HexColor.h"
#import "THProgressView.h"

@interface PDFView()<NSURLConnectionDataDelegate>


@property (nonatomic,strong) NSMutableData* fileData;

/**
 *  用来写数据的文件句柄对象
 */
@property (nonatomic, strong) NSFileHandle *writeHandle;

/**
 *  文件的总长度
 */
@property (nonatomic, assign) long long totalLength;
/**
 *  当前已经写入的总大小
 */
@property (nonatomic, assign) long long  currentLength;
/**
 *  连接对象
 */
@property (nonatomic, strong) NSURLConnection *connection;

@end

@implementation PDFView
{
    CourseVideo *currentVideo;
    NSString * pdfID; // 本地pdf唯一标识
    UIButton *mailBtn;
    UIWebView *webView;
    THProgressView *progressView;
    UIImageView *tipIV;
    UILabel *tipL;
    UIButton *shareImage;
    
    NSFileManager *fileManager;
    NSString *downloadPath;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        fileManager=[NSFileManager defaultManager];
        
        downloadPath = [kDocPath stringByAppendingString:kPDFDataPath];
        if(![fileManager fileExistsAtPath:downloadPath])
        {
            [fileManager createDirectoryAtPath:downloadPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        shareImage = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareImage setImage:[UIImage imageNamed:@"ic_pdf_share"] forState:UIControlStateNormal];
        [shareImage addTarget:self action:@selector(sendMail) forControlEvents:UIControlEventTouchDown];
        [self addSubview:shareImage];
        shareImage.hidden = YES;
        
        [shareImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_top).offset(GENERAL_SIZE(60));
            make.right.equalTo(self.mas_right).offset(-GENERAL_SIZE(50));
        }];
        
        mailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [mailBtn setTitle:@"存储为PDF发送至邮箱" forState:UIControlStateNormal];
        [mailBtn setTitleColor:COMMONBLUECOLOR forState:UIControlStateNormal];
        mailBtn.titleLabel.font = LabelFont(26);
        [mailBtn addTarget:self action:@selector(sendMail) forControlEvents:UIControlEventTouchDown];
        [self addSubview:mailBtn];
        mailBtn.hidden = YES;
        
        [mailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(shareImage);
            make.right.equalTo(shareImage.mas_left).offset(-GENERAL_SIZE(20));
        }];
        
        webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, GENERAL_SIZE(120), self.bounds.size.width, self.bounds.size.height-GENERAL_SIZE(120))];
        [webView setScalesPageToFit:YES];
        webView.backgroundColor = [UIColor whiteColor];
        [self addSubview:webView];
        
        tipL = [[UILabel alloc]init];
        tipL.font = LabelFont(24);
        tipL.textColor = [UIColor colorWhthHexString:@"#a4a6a9"];
        [self addSubview:tipL];
        
        [tipL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        
        progressView = [[THProgressView alloc]init];
        progressView.borderTintColor = [UIColor whiteColor];
        progressView.progressTintColor = COMMONBLUECOLOR;
        progressView.progressBackgroundColor = RGBCOLOR(225, 225, 225);
        [self addSubview:progressView];
        
        [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(tipL.mas_top).offset(-GENERAL_SIZE(20));
            make.width.equalTo(@80);
            make.height.equalTo(@20);
        }];
        
        tipIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_note"]];
        [self addSubview:tipIV];
        
        [tipIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(tipL.mas_top).offset(-GENERAL_SIZE(20));
        }];
        
    }
    return self;
}

-(void)loadPDF:(CourseVideo*)video{
    currentVideo = video;
    pdfID = video.attachmentId;
    
    [self loadPDFWithURL:video.url];
}

-(void)loadPDFWithmaterial:(Material*)material{
    [webView mas_remakeConstraints:^(MASConstraintMaker *make) {
         make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    pdfID = [NSString stringWithFormat:@"material_%@", material.materialId];
    
    [self loadPDFWithURL:material.url];
}

-(void)loadPDFWithURL:(NSString*)url{
    if (pdfID&&url&&![url isEqualToString:@""]) {
        NSString *fileName = [NSString stringWithFormat:@"%@.pdf",pdfID];
        NSString* filepath = [downloadPath stringByAppendingPathComponent:fileName];
        BOOL exist = [fileManager fileExistsAtPath:filepath];
        if (exist) {
            NSData *data = [NSData dataWithContentsOfFile:filepath];
            [webView loadData:data MIMEType:@"application/pdf" textEncodingName:@"GBK" baseURL:nil];
            progressView.hidden = YES;
            tipL.hidden = YES;
            mailBtn.hidden = NO;
            shareImage.hidden = NO;
        }else{
            NSURL* nsurl = [NSURL URLWithString:url];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nsurl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
            [NSURLConnection connectionWithRequest:request delegate:self];
            progressView.hidden = NO;
            tipL.hidden = NO;
            tipL.text = @"加载中...";
        }
        webView.hidden = NO;
        tipIV.hidden = YES;
    }else{
        tipIV.hidden = NO;
        tipL.hidden = NO;
        tipL.text = @"暂无讲义";
        progressView.hidden = YES;
        webView.hidden = YES;
    }
}

-(void)sendMail{
    if (_delegate) {
        [_delegate didClickSendMail:currentVideo];
    }
}

/**
 *  请求失败时调用（请求超时、网络异常）
 *
 *  @param error      错误原因
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    tipL.text = @"加载失败";
    NSString *fileName = [NSString stringWithFormat:@"%@.pdf",pdfID];
    NSString* filepath = [downloadPath stringByAppendingPathComponent:fileName];
    BOOL exist = [fileManager fileExistsAtPath:filepath];
    if(exist){
        [fileManager removeItemAtPath:filepath error:nil];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // 文件路径
    NSString *fileName = [NSString stringWithFormat:@"%@.pdf",pdfID];
    NSString* filepath = [downloadPath stringByAppendingPathComponent:fileName];
    
    // 创建一个空的文件到沙盒中
    NSFileManager* mgr = [NSFileManager defaultManager];
    [mgr createFileAtPath:filepath contents:nil attributes:nil];
    
    // 创建一个用来写数据的文件句柄对象
    self.writeHandle = [NSFileHandle fileHandleForWritingAtPath:filepath];
    
    // 获得文件的总大小
    self.totalLength = response.expectedContentLength;
    
}
/**
 *  2.当接收到服务器返回的实体数据时调用（具体内容，这个方法可能会被调用多次）
 *
 *  @param data       这次返回的数据
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // 移动到文件的最后面
    [self.writeHandle seekToEndOfFile];
    
    // 将数据写入沙盒
    [self.writeHandle writeData:data];
    
    // 累计写入文件的长度
    self.currentLength += data.length;
    
    // 下载进度
    progressView.progress = (double)self.currentLength / self.totalLength;
}
/**
 *  3.加载完毕后调用（服务器的数据已经完全返回后）
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    tipIV.hidden = YES;
    tipL.hidden = YES;
    progressView.hidden = YES;
    mailBtn.hidden = NO;
    shareImage.hidden = NO;
    // 加载文件
    NSString *fileName = [NSString stringWithFormat:@"%@.pdf",pdfID];
    NSString* filepath = [downloadPath stringByAppendingPathComponent:fileName];
    NSData *data = [NSData dataWithContentsOfFile:filepath];
    [webView loadData:data MIMEType:@"application/pdf" textEncodingName:@"GBK" baseURL:nil];
    
    self.currentLength = 0;
    self.totalLength = 0;
    
    // 关闭文件
    [self.writeHandle closeFile];
    self.writeHandle = nil;
}

@end
