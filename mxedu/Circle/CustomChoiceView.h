//
//  customChoiceView.h
//  NTreat
//
//  Created by 刘德胜 on 15/12/24.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomChoiceView;
@protocol customChoiceViewDelegate <NSObject>

//选中某个标签
-(void)didChoiceItemView:(NSInteger)itemtag;

@end

@interface CustomChoiceView : UIView

@property (nonatomic,retain) id<customChoiceViewDelegate> choiceDelegate;
@end
