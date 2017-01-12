//
//  DownLoadSubViews.h
//  NTreat
//
//  Created by 周冉 on 16/4/14.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownLoadingCell.h"
#import "DownLoadbottomBar.h"
#import "myCustomerImageView.h"//没有视频下载时候 背景图

@interface DownLoadSubViews : UIViewController<UITableViewDelegate,UITableViewDataSource,DownLoadbottomBarDeleght>
@property(nonatomic ,strong)NSMutableArray *videoArray;//视频数据(父类可接受下载活着没有下载的数据)
@property(nonatomic ,strong)UITableView *rootTable;//当前主的table
@property(nonatomic ,assign)BOOL isEditing ;//是否可编辑界面
@property(nonatomic ,strong)UIButton *editButton;//接受父视图中的按钮
@property(nonatomic ,assign)SDMyLocalVideoCellTyp eSDMyLocalVideoCellOver;//判断是否是本地视频还是正在下载视频
@property(nonatomic ,strong) DownLoadbottomBar *tottomBar;//底部Bar
@property(nonatomic ,strong)UIViewController *selfVC;//跟视图
@property(nonatomic ,strong)myCustomerImageView *noResultImageView;//没有视频下载时候 背景图

-(void)edit:(UIButton *)editBuuton;//点击编辑按钮
-(void)refreshView:(NSNotification *)notion;//更新列表



@end
