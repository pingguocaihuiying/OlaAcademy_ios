//
//  SUIBoundsRoundButton.m
//  AllinmdProject
//
//  Created by ZhangKaiChao on 15/3/23.
//  Copyright (c) 2015年 Mac_Libin. All rights reserved.
//

#import "SUIBoundsRoundButton.h"

@implementation SUIBoundsRoundButton

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {

    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(contextRef, YES);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:_cornerRadios];
    
    if(_nomalFillColor)
    {
        [_nomalFillColor setFill];
        [path fill];
        [path addClip];
    }
    
    if(_strokeColor)
    {
        [_strokeColor setStroke];
        [path setLineWidth:_strokeLineWidth?_strokeLineWidth:0.5];
        [path stroke];
        [path addClip];
    }

    if(self.selected)
    {
        if(_selectFillColor)
        {
            [_selectFillColor setFill];
            [path fill];
        }
        
        if(_selectTextColor)
        {
            self.titleLabel.textColor = _selectTextColor;
        }
    }
    else
    {
        if(_nomalTextColor)
        {
            self.titleLabel.textColor = _nomalTextColor;
        }
        if(_highlightedColor && self.highlighted)
        {
            [_highlightedColor setFill];
            [path fill];
            if(_selectTextColor)
            {
                self.titleLabel.textColor = _selectTextColor;
            }
        }
    }
}

@end
