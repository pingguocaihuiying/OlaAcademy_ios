//
//  customChoiceView.m
//  NTreat
//
//  Created by 刘德胜 on 15/12/24.
//  Copyright © 2015年 田晓鹏. All rights reserved.
//

#import "CustomChoiceView.h"
#import "SysCommon.h"
@interface CustomChoiceView()
{
    UIButton *seltedButton;//记录选中的按钮
}
@end
@implementation CustomChoiceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupSubViews];
    }
    return self;
}
-(void)setupSubViews{
    
    self.backgroundColor = RGBCOLOR(253, 253, 253);
    NSArray *imagesNormal = @[@"ic_takePhoto",@"ic_photoLibrary",@"ic_media",@"ic_shoot"];
    NSArray *imageSeclected = @[@"ic_takePhoto",@"ic_photoLibrary",@"ic_media",@"ic_shoot"];
    
    for (int i=0;i<4;i++) {
        UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4.0*i, 0, SCREEN_WIDTH/4.0, 50)];
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        itemButton.tag=100+i;
        itemButton.frame=CGRectMake(SCREEN_WIDTH/10.0-SCREEN_WIDTH/20.0, 0, GENERAL_SIZE(120), GENERAL_SIZE(160));
        [itemButton setImage:[UIImage imageNamed:imagesNormal[i]] forState:UIControlStateNormal];
        [itemButton setImage:[UIImage imageNamed:imageSeclected[i]] forState:UIControlStateSelected];
        [itemButton addTarget:self action:@selector(didClickitemView:) forControlEvents:UIControlEventTouchUpInside];
        [itemView addSubview:itemButton];
        if (i==0) {
            itemButton.selected = YES;
            seltedButton = itemButton;
        }
        [self addSubview:itemView];
    }
}
-(void)didClickitemView:(UIButton *)sender{
    if (sender!=seltedButton) {
        sender.selected=YES;
        seltedButton.selected=NO;
        
    }
     seltedButton = sender;
    if ([self.choiceDelegate respondsToSelector:@selector(didChoiceItemView:)]) {
        [self.choiceDelegate didChoiceItemView:sender.tag];
    }
}
@end
