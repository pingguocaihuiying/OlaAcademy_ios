//
//  PDFView.h
//  mxedu
//
//  Created by 田晓鹏 on 16/9/18.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CourseVideo.h"
#import "Material.h"

@protocol PDFViewDelegate <NSObject>

-(void)didClickSendMail:(CourseVideo*) video;

@end

@interface PDFView : UIView

@property (nonatomic) id<PDFViewDelegate> delegate;

-(void)loadPDF:(CourseVideo*)video;
-(void)loadPDFWithmaterial:(Material*)material;

@end
