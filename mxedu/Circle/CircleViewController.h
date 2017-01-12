//
//  CircleViewController.h
//  mxedu
//
//  Created by 田晓鹏 on 16/4/8.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleViewController : UIViewController

@property(nonatomic,strong)NSMutableArray *modalDataArray;//筛选数组
-(void)selectedTableRow:(NSIndexPath *)path;//选择第几个

@end
