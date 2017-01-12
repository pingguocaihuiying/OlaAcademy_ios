//
//  TestCell.h
//  CustomProgress
//
//  Created by Admin on 2016/10/18.
//  Copyright © 2016年 江萧. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomProgress.h"
#import "Comment.h"
#import "CommentCell.h"

@interface CommentAudioCell : UITableViewCell

@property (nonatomic,strong) Comment * sdModel;

@property (nonatomic,weak) id<CustomProgressDelegate> delegate;
@property (nonatomic,retain) id<CommentCellDelegate> cellDelegate;


@end
