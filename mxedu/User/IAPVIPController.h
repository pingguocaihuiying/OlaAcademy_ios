//
//  IAPVIPController.h
//  mxedu
//
//  Created by 田晓鹏 on 16/6/21.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <StoreKit/StoreKit.h>

@interface IAPVIPController : UIViewController<SKPaymentTransactionObserver, SKProductsRequestDelegate>

@property (nonatomic) void(^callbackBlock)();

@end
