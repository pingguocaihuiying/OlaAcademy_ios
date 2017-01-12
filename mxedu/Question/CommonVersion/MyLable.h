//
//  MyLable.h
//  bonedict
//
//  Created by 刘德胜 on 16/4/27.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//内容居上，居中，局下显示的标签

#import <UIKit/UIKit.h>

typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface MyLable : UILabel
{
@private
    VerticalAlignment _verticalAlignment;
}

@property (nonatomic) VerticalAlignment verticalAlignment;

@end
