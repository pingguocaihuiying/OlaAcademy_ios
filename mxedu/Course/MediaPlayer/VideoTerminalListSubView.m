//
//  VideoTerminalListSubView.m
//  NTreat
//
//  Created by 周冉 on 16/5/4.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "VideoTerminalListSubView.h"

#import "SysCommon.h"
#import "SDHeader.h"
#import "SDMediaPlayerVC.h"

@interface VideoTerminalListSubView ()

@end

@implementation VideoTerminalListSubView

- (void)viewDidLoad {
    [super viewDidLoad];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti:) name:PlaybackIsPreparedToPlayDidChangeNotification  object:nil];
    self.view.backgroundColor = [UIColor clearColor];
    [self loadTableView];//加载主的table
}
-(void)noti:(NSNotification *)not
{
    SDMediaPlayerVC *Vc = not.object;
    [Vc pause];
   self.clickType = Vc.clickType;

}

-(void)loadTableView
{
    _rootTable = [[UITableView alloc]init];
    if(self.fullScrenType == 1)
    {
    self.rootTable.frame = CGRectMake(0, 0, kVedioPalyListViewWidth+20, kVedioPalyListViewHeight);
    }
    else
    {
    _rootTable.frame = CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT-SCREEN_WIDTH*9/16.0-42*kScreenHeight-49*kScreenHeight-20);
    }
    _rootTable.delegate = self;
    _rootTable.dataSource = self;
    _rootTable.separatorStyle =UITableViewCellSeparatorStyleNone;
    _rootTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_rootTable];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [_dataArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
