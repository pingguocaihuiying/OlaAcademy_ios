//
//  ImageCell.m
//  NTreat
//
//  Created by 田晓鹏 on 15-5-23.
//  Copyright (c) 2015年 田晓鹏. All rights reserved.
//

#import "ImageCell.h"
#import <Masonry.h>

@implementation ImageCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"ImageCell" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
        
        self.imageView.clipsToBounds = YES;
        self.imageView.layer.cornerRadius = 5;
    }
    return self;
}

- (void)awakeFromNib {
    
}

@end
