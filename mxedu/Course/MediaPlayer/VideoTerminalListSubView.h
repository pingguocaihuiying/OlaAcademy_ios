//
//  VideoTerminalListSubView.h
//  NTreat
//
//  Created by 周冉 on 16/5/4.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoTerminalListSubView;
@protocol VideoTerminalListSubViewDelegat <NSObject>

// 全频时点击table列表切换视频代理
-(void)didSelectRowAtIndexPathModal:(id)object indexPath:(NSIndexPath *)path;

@end
@interface VideoTerminalListSubView :  UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic ,strong)UITableView *rootTable;//主的列表
@property(nonatomic ,strong)NSMutableArray *dataArray;//请求下来的数据
@property(nonatomic ,strong)NSString *gid;//视频id

@property(nonatomic ,strong)UIViewController *selfVC;//上级视图
@property(nonatomic ,assign)id<VideoTerminalListSubViewDelegat>delegat;//子视图下载
@property(nonatomic ,strong)NSIndexPath *path;//选择当前行数
@property(nonatomic ,assign)NSInteger fullScrenType;
@property(nonatomic ,assign)BOOL clickType;//能否点击

@end
