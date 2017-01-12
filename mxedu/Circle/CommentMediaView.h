//
//  CommentMediaView.h
//  mxedu
//
//  Created by 田晓鹏 on 16/12/3.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommentMediaViewDelegate <NSObject>

-(void)chooseImage:(NSInteger)type;

-(void)chooseVideoFromDevice; //手机中选择视频
-(void)shootVideoWithCamera; //录制

@end

@interface CommentMediaView : UIView

@property (nonatomic) id<CommentMediaViewDelegate> delegate;

-(void)refreshViewWithData:(NSMutableArray*)mediaArray;

@end
