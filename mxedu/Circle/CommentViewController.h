//
//  CommentViewController.h
//  mxedu
//
//  Created by 田晓鹏 on 16/12/3.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OlaCircle.h"
#import "UIBaseViewController.h"

@interface CommentViewController : UIBaseViewController

@property (nonatomic,strong) NSString *postId;

@property (nonatomic, strong) void (^successFunc)(OlaCircle *circle,int type); //1 点赞后的回调

@end
