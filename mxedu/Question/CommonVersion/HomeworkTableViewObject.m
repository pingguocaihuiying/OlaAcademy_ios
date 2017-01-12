//
//  MeetingTableViewObject.m
//  NTreat
//
//  Created by Frank on 15/5/11.
//  Copyright (c) 2015年 田晓鹏. All rights reserved.
//

#import "HomeworkTableViewObject.h"

#import "UIView+Positioning.h"
#import "UIColor+HexColor.h"

#import "SysCommon.h"
#import "Masonry.h"
#import "Homework.h"
#import "MonthHomework.h"

@implementation HomeworkTableViewObject


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MonthHomework *model = self.dataSource[section];
    return model.homeworkArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return GENERAL_SIZE(200);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return GENERAL_SIZE(80);
    }
    return GENERAL_SIZE(100);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    int height = GENERAL_SIZE(100);
    if (section==0) {
        height = GENERAL_SIZE(80);
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    view.backgroundColor = [UIColor clearColor];
    
    UIView *dividerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, GENERAL_SIZE(20))];
    if (section!=0) {
        dividerView.backgroundColor = [UIColor colorWhthHexString:@"#ebebeb"];
        [view addSubview:dividerView];
    }
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_today"]];
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWhthHexString:@"#272b36"];
    label.font = LabelFont(34);
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(GENERAL_SIZE(30));
        make.centerY.equalTo(label);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(GENERAL_SIZE(20));
        make.bottom.equalTo(view.mas_bottom).offset(-GENERAL_SIZE(2));
        make.height.equalTo(@(GENERAL_SIZE(76)));
    }];
    
    MonthHomework *model = self.dataSource[section];
    label.text = [NSString stringWithFormat:@"%@月", model.month];

    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWhthHexString:@"#ebebeb"];
    [view insertSubview:lineView atIndex:0];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(GENERAL_SIZE(2));
        make.left.equalTo(view).offset(GENERAL_SIZE(20));
        make.right.equalTo(view.mas_right).offset(-GENERAL_SIZE(20));
        make.bottom.equalTo(view.mas_bottom).offset(0);
    }];
    
    return view;
}

- (HomeworkTableCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr = @"cellString";
    HomeworkTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[HomeworkTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    
    MonthHomework *model = self.dataSource[indexPath.section];
    
    Homework *homework = model.homeworkArray[indexPath.row];
    
    [cell setupCellWithModel:homework];
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(tableView:didSelectRowWithModel:)]) {
        
        MonthHomework *model = self.dataSource[indexPath.section];
        
        Homework *homework = model.homeworkArray[indexPath.row];
        
        [self.delegate tableView:tableView didSelectRowWithModel:homework];
    }
}

@end
