//
//  SDSlideSwichViewController.h
//  NTreat
//
//  Created by 周冉 on 16/4/14.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "QCSlideSwitchView.h"

@class SDSlideSwichViewController,VideoTerminalListSubView;
#define kCellSelectTextColor    [UIColor colorWithRed:128/255. green:128/255. blue:128/255. alpha:1]    //.  选中字体颜色
#define TITLE_BACKGROUND_COLOR [UIColor colorWithRed:12.0/255.0f green:142.0/255.0f blue:243.0/255.0f alpha:0.9f]

@interface SDSlideSwichViewController : UIViewController<QCSlideSwitchViewDelegate>

@property (nonatomic ,strong)QCSlideSwitchView *switchView;//选择table控制器
@property (nonatomic ,strong)NSMutableArray *VCArray;//装有视图的数组
@property (nonatomic ,assign)BOOL fristLoade;//第一次进入页面 马上改变 防止两次请求数据  在viewdidApper方法中使用
@property (nonatomic ,assign)NSInteger seclect;//选择第几个视图
@property (nonatomic ,strong)UIViewController *selfVC;
-(void)upLoadSwitchViewContent;//加载传入得table页面


-(void)searchInfoWithTag:(NSInteger)tag andMainString:(NSString *)str;
@end
