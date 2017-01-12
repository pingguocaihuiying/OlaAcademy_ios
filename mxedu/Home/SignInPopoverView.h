//
//  SignInPopoverView
//  签到
//
//  Created by 田晓鹏 on 6/2/13.
//  Copyright (c) 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SignInViewDelegate <NSObject>

- (void)didClickOnImageIndex:(NSInteger)imageIndex;

@end

typedef void (^PopoverViewButtonBlock)();

@interface SignInPopoverView : UIView

@property (nonatomic) id<SignInViewDelegate> delegate;

//展示界面
- (void)show;

//消失界面
- (void)dismiss;

//设置取消按钮的标题，不设置，按钮不显示
- (void)setCancelButtonBlock:(PopoverViewButtonBlock)block;

-(void)setupViewWithDay:(NSString*)signDay Coin:(NSString*)coin;

@end

