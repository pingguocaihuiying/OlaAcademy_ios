//
//  CommentController.h
//  NTreat
//
//  Created by 田晓鹏 on 16/2/23.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OlaCircle.h"
#import "CustomInputView.h"

@class CircleFrame;

@interface CommentController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView* tableView;
@property (nonatomic, strong) IBOutlet CustomInputView* inputView;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint* containerViewBottomConstraint;

@property (nonatomic,strong) CircleFrame *circleFrame;
@property (nonatomic,strong) NSString *postId;

@property (nonatomic,strong) NSString *gdId; // 发帖人或回复人的骨典号

@property (nonatomic, strong) void (^successFunc)(OlaCircle *circle,int type); //1 点赞后的回调
@end
