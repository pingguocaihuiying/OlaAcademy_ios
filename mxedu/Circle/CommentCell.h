//
//  WKCommentCell.h
//  WKDemo
//
//  Created by apple on 14-8-10.
//  Copyright (c) 2014年 com.app. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentCell;
@protocol CommentCellDelegate <NSObject>

//点击点赞按钮
-(void)didPraiseAction:(CommentCell *)seletedCell;

@end

@class Comment;
@interface CommentCell : UITableViewCell
@property (nonatomic,strong)Comment *commentR;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,retain) id<CommentCellDelegate> cellDelegate;

@end
