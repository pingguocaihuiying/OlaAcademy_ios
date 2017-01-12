//
//  MeetingTableViewObject.h
//  NTreat
//
//  Created by Frank on 15/5/11.
//  Copyright (c) 2015年 田晓鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HomeworkTableCell.h"


@class Homework;
@protocol MeetingTableViewDelegate <NSObject>
- (void)tableView:(UITableView *)tableView didSelectRowWithModel:(Homework*)model;
@end

/**
 *  学术会议Table的Delegate和DataSrouce
 */
@interface HomeworkTableViewObject : NSObject<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic) id <MeetingTableViewDelegate> delegate;

@end
