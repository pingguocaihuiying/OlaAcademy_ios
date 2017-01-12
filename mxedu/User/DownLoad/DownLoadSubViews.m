//
//  DownLoadSubViews.m
//  NTreat
//
//  Created by 周冉 on 16/4/14.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "DownLoadSubViews.h"
#import "UIView+Frame.h"
#import "DownloadManager.h"
#import "DataManager.h"

@implementation DownLoadSubViews
-(void)viewDidLoad
{
    [super viewDidLoad];

    _videoArray = [NSMutableArray arrayWithCapacity:12];
    [self registerNotice];//下载完成会接受该通知通知

    [self loadTableView];//加载主的tableView
    [self loadBottomBar];//加载底部按钮
    [self dealWithNoData];//加载背景
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //一进来就获得本地或者正在下载的数组
    [self refreshView:nil];
    
}
//底部按钮
-(void)loadBottomBar
{
    NSInteger height;
    if([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
    {
        height = UI_NAVIGATION_BAR_HEIGHT ;
    }
    else
     height = UI_NAVIGATION7_BAR_HEIGHT ;
    
    _tottomBar = [[DownLoadbottomBar alloc]initWithFrame:CGRectMake(0, self.view.height -(height+40*kScreenScaleHeight+UI_TAB_BAR_HEIGHT), SCREEN_WIDTH, UI_TAB_BAR_HEIGHT)];
    _tottomBar.backgroundColor = [UIColor clearColor];
    _tottomBar.deleght = self;
    _tottomBar.hidden = YES;
    [self.view addSubview:_tottomBar];
    
}
-(void)loadTableView
{
    _rootTable = [[UITableView alloc]init];
    _rootTable.allowsSelectionDuringEditing = YES;
    _rootTable.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.height-(UI_TAB_BAR_HEIGHT+UI_NAVIGATION7_BAR_HEIGHT));
    _rootTable.backgroundColor = [UIColor clearColor];
    _rootTable.delegate = self;
    _rootTable.dataSource = self;
    _rootTable.editing = NO;
    _rootTable.separatorStyle =UITableViewCellSeparatorStyleNone;

    [self.view addSubview:_rootTable];
    
}
#pragma mark 下载完成会接受该通知通知
-(void)registerNotice
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView:) name:NSLocalizedString(@"NoticeFreshLocalVideo", ) object:nil];
}
//点击编辑按钮
-(void)edit:(UIButton *)editBuuton
{
    self.editButton = editBuuton;
    _isEditing = !_isEditing;
    _rootTable.editing = _isEditing;
    if(_isEditing)//yes为可编辑状态
    {
        [ self.editButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [ self.editButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.editButton sizeToFit];
        _rootTable.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.height-(UI_TOOL_BAR_HEIGHT+20));
        _tottomBar.hidden = NO;
    }
    else
    {
        [ self.editButton setImage:[UIImage imageNamed:@"icon_delete"] forState:UIControlStateNormal];
        [self.editButton setTitle:@"" forState:UIControlStateNormal];
        [self.editButton sizeToFit];
        _tottomBar.hidden = YES;

        _rootTable.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-(UI_TAB_BAR_HEIGHT+UI_NAVIGATION7_BAR_HEIGHT));

    }
    
if(self.videoArray.count)
{
    for (int row = 0; row < [_videoArray count]; row ++) {
        DownLoadingCell *cell = (DownLoadingCell *)[_rootTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        [cell setIsSEditing:self.isEditing];
    }
}
    [self.rootTable reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [_videoArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * downStrID = @"DownCellID";
    DownLoadingCell *cell = [tableView dequeueReusableCellWithIdentifier: downStrID];
    if(cell == nil)
    {
        cell = [[DownLoadingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:downStrID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    DownloadModal *modal = [self.videoArray objectAtIndex:indexPath.row];
    cell.localVideoCellTyp = _eSDMyLocalVideoCellOver;
    [cell setIsSEditing:tableView.editing];

    [cell setIsSelecting:modal.isSelect];

    [cell reloadSubview:modal];
    
    return  cell ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
if(tableView.editing)
{
    DownloadModal *modal = [_videoArray
                            objectAtIndex:indexPath.row];
    DownLoadingCell *cell = (DownLoadingCell *)[tableView cellForRowAtIndexPath:indexPath];
    modal.isSelect = !modal.isSelect;
    [cell setIsSEditing:tableView.editing];
    [cell setIsSelecting:modal.isSelect];

    [self showAllType];//计算统计还是全选


}
    else
    {
        DownloadModal *modal = [self.videoArray
                                objectAtIndex:indexPath.row];
        DownLoadingCell *cell = (DownLoadingCell *)[tableView cellForRowAtIndexPath:indexPath];
        [self changeDownLoadStatus:modal cell:cell];
    }

}
#pragma mark 在非编译状态后状态
- (void)changeDownLoadStatus:(DownloadModal *)modal cell:(DownLoadingCell *)cell
{
    if([modal downloadStatusType] == eDownloadStatusOn)
    {
        [[DownloadManager sharedDownloadManager] pauseASessionTask:modal];
        [[DownloadManager sharedDownloadManager] remakeDownloads];
    }
    else if([modal downloadStatusType] == eDownloadStatusWait)
    {
        [[DownloadManager sharedDownloadManager] pauseASessionTask:modal];
    }
    else if([modal downloadStatusType] == eDownloadStatusPause)
    {
        [[DownloadManager sharedDownloadManager] startASessionTask:modal];
    }
    [cell setUpViewDownLoadStatus];

    [[NSNotificationCenter defaultCenter] postNotificationName:NSLocalizedString(@"NoticeFreshLocalVideo", ) object:nil];

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_isEditing == YES)
    {
        return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleDelete;
}
#pragma mark 下载完成后 接收通知 加载已下载或者正在下载的
-(void)refreshView:(NSNotification *)notion
{
    [self loadVideoData];
    if(_rootTable)
    {
        [_rootTable reloadData];
    }
}
//加载已经下载数据
-(void)loadVideoData
{
    if(!_videoArray)
    {
        _videoArray = [[NSMutableArray alloc] init];
    }
    
    [_videoArray removeAllObjects];
    
    if(_eSDMyLocalVideoCellOver == eAllinMyLocalVideoCellDoing)
    {
        
        for(DownloadModal *modal in [[DownloadManager sharedDownloadManager] arrayDownLoadSessionModals])
        {
            if([modal.stringCustomId isEqualToString:[DataManager customerId]])
            {
                [_videoArray addObject:modal];
            }
        }
        
    }
    else if(_eSDMyLocalVideoCellOver == eAllinMyLocalVideoCellOver)
    {
        for(DownloadModal *modal in [[DownloadManager sharedDownloadManager] arrayDownLoadedSessionModals])
        {
            if([modal.stringCustomId isEqualToString:[DataManager customerId]])
            {
                [_videoArray addObject:modal];
            }
        }
    }
    //判断是数组是否有数据  没有则显示背景图
    if(_videoArray.count)
    {
        self.noResultImageView.hidden = YES;
    }
    else
    {
        self.noResultImageView.hidden = NO;

    }
}
#pragma mark 底部产出按钮
-(void)delete
{
    for (int row = 0; row < [self.videoArray count]; row ++) {
        
        DownloadModal *modal = [self.videoArray
                                objectAtIndex:row];
        if([modal isSelect] == YES)
        {
            if(_eSDMyLocalVideoCellOver == eAllinMyLocalVideoCellDoing)
            {
                [self deleteAVideo:modal];
            }
            else
            {
                [self deleteLoacVideo:modal];
            }
        }
    }
    //因为这是已下载的视频和正在下载的视频公用的基类 所以 删除队列后要区分  正在下载的需要暂停
    if(_eSDMyLocalVideoCellOver == eAllinMyLocalVideoCellDoing)
    {
    [[DownloadManager sharedDownloadManager] remakeDownloads];
    }
    [self refreshView:nil];
//    [self makeDownloadVideos];

}
//删除本地视频
-(void)deleteLoacVideo:(DownloadModal *)modal
{
    [[DownloadManager sharedDownloadManager] deleteAComletedVideo:modal];
    [[DataManager sharedDataManager] removeDownLoadVideo:modal];
    [[DataManager sharedDataManager] saveDownloadedVideo];

}
// 删除一个正在下载的视频视频
- (void)deleteAVideo:(DownloadModal *)modal
{
    [[DownloadManager sharedDownloadManager] stopASessionTask:modal];
    [[DownloadManager sharedDownloadManager] deleteACompleteSessionTask:modal];
    
    // 删除下载好的图片
    if([modal stringImgDownloadPath] && [[modal stringImgDownloadPath] length])
    {
        [[DataManager sharedDataManager] removeDownLoadImage:modal];
    }
}
#pragma mark 底部bar按钮代理
-(void)clikeBarButton:(UIButton *)send myView:(DownLoadbottomBar *)myView
{
    if(![self.videoArray count]){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"已没有视频" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"删除", nil];
        [alertView show];
    }
   
//    DownLoadingCell *cell = [_rootTable cellForRowAtIndexPath:<#(nonnull NSIndexPath *)#>]
    //全选
    if(send.tag == 10000)
    {
        int i = 0;
    for(DownloadModal *modal in self.videoArray)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        DownLoadingCell *cell = [_rootTable cellForRowAtIndexPath:indexPath];
        modal.isSelect = myView.allType;
        [cell setIsSelecting:modal.isSelect];
        i++;
    }
        [self showAllType];//计算统计还是全选
    }else
    {
        [self delete];

    }

}
//没有下载列表的背景图
- (void)dealWithNoData {
    
    self.noResultImageView = [[myCustomerImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-(49+64+44))];
    self.noResultImageView.image = [UIImage imageNamed:@"LoccalVideo_NoData"];
    self.noResultImageView.textLabes.text = @"您没有本地视频哦！";
    self.noResultImageView.textLabes.textColor = kCellGrayTextColor;
    [self.noResultImageView.textLabes  sizeToFit];
    CGFloat x = (SCREEN_WIDTH - self.noResultImageView.textLabes.frame.size.width)/2;
    self.noResultImageView.textLabes.frame = CGRectMake(x, 274*kScreenScaleHeight, SCREEN_WIDTH, 20*kScreenScaleHeight);
    self.noResultImageView.hidden = YES;
    [self.view addSubview:self.noResultImageView];
}
//全选按钮更新
-(void)showAllType
{
    int j = 0;//统计选择个数
    for( int i = 0;i<[self.videoArray count];i++)
    {
        DownloadModal *modal = [self.videoArray objectAtIndex:i];
        if(modal.isSelect)
        {
            j++;
        }
    }
    if(j<[self.videoArray count])
    {
        [_tottomBar.seclectLButton setTitle:@"全选" forState:UIControlStateNormal];
        _tottomBar.allType = NO;

    }else
    {
        [_tottomBar.seclectLButton setTitle:@"取消" forState:UIControlStateNormal];
        _tottomBar.allType = YES;

    }
}
@end
