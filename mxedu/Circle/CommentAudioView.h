//
//  CommentAudioView.h
//  mxedu
//
//  Created by 田晓鹏 on 16/12/3.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "mediaModel.h"

@protocol CommentAudioViewDelegate <NSObject>

-(void)clearMediaData; //清除图片或视频数据
-(void)updateDataSource:(mediaModel*)audioModel; // 返回本地音频数据

@end

@interface CommentAudioView : UIView

@property (nonatomic) id<CommentAudioViewDelegate> delegate;

-(void)deleteAction;

@end
