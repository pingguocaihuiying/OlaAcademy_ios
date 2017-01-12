//
//  ChapterViewViewController.m
//  NTreat
//
//  Created by 周冉 on 16/5/4.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "ChapterViewViewController.h"

#import "CourSectionTableCell.h"

@interface ChapterViewViewController ()

@end

@implementation ChapterViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *curriculumVideo = @"curriculumVideo";
    
    CourSectionTableCell *cell = [tableView dequeueReusableCellWithIdentifier:curriculumVideo];
    if (!cell) {
        cell = [[CourSectionTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:curriculumVideo];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.contentView.backgroundColor =  self.fullScrenType == 1?[UIColor blackColor]:[UIColor whiteColor];
    
    cell.contentView.alpha = self.fullScrenType == 1? 0.7 :1;
    cell.backgroundColor =[UIColor clearColor];
    CourseVideo *model = self.dataArray[indexPath.row];
    [cell setCellWithModel:model];
    return  cell;
}

//设置行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CourseVideo* mVideo = self.dataArray[indexPath.row];
    for (CourseVideo *model in self.dataArray) {
        if ([model.videoId isEqualToString:mVideo.videoId]) {
            model.isChosen = 1;
        }else{
            model.isChosen = 0;
        }
    }
    [self.delegat didSelectRowAtIndexPathModal:self.dataArray indexPath:indexPath];
    [self.rootTable reloadData];
    _selectPath = indexPath;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
