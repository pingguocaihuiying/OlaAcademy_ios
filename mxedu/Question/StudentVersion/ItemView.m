//
//  ItemView.m
//  NTreat
//
//  Created by 刘德胜 on 15/8/25.
//  Copyright (c) 2015年 田晓鹏. All rights reserved.
//

#import "ItemView.h"

#import "SysCommon.h"
#import "UIColor+HexColor.h"

@interface ItemView ()
{
    UILabel *countLabel;
    
    UILabel *titileLabel;
    
}
@end
@implementation ItemView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        countLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH/3.0, 20)];
        countLabel.textColor = RGBCOLOR(255, 102, 90);
        countLabel.font = LabelFont(36);
        countLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:countLabel];
        
        titileLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH/3.0, 20)];
        titileLabel.textColor = RGBCOLOR(144, 144, 144);
        titileLabel.font = LabelFont(28);
        titileLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titileLabel];
        
        
    }
    return self;
}


-(void)setcount:(NSString *)countstring Title:(NSString *)titlestring{
    countLabel.text=countstring;
    titileLabel.text=titlestring;
}

@end
