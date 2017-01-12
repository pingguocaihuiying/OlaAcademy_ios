//
//  SDGroupCell.m
//  SDNestedTablesExample
//
//  Created by Daniele De Matteis on 21/05/2012.
//  Copyright (c) 2012 Daniele De Matteis. All rights reserved.
//

#import "SDGroupCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation SDGroupCell

@synthesize parentTable, isExpanded, subTable, subCell, subCellsAmt;

+ (int) getHeight
{
    return height;
}

+ (int) getsubCellHeight
{
    return subCellHeight;
}

#pragma mark - Lifecycle

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super initWithCoder:aDecoder]))
    {
        
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    [self setupInterface];
}

- (void) setupInterface
{
    
    expandBtn.frame = CGRectMake(0, 5, 40, 40);
    [expandBtn setBackgroundColor:[UIColor clearColor]];
    if(!isExpanded){
        [expandBtn setImage:[UIImage imageNamed:@"expand"] forState:UIControlStateNormal];
    }else{
        [expandBtn setImage:[UIImage imageNamed:@"retract"] forState:UIControlStateNormal];
    }
    
    [expandBtn addTarget:self.parentTable action:@selector(collapsableButtonTapped:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    [expandBtn addTarget:self action:@selector(rotateExpandBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    self.itemText.frame = CGRectMake(40, 5, 200, 40);
    self.itemText.textColor = RGBCOLOR(81, 84, 93);
    
    self.pointLabel.frame = CGRectMake(40, 42, 0, 16);
    self.pointLabel.backgroundColor = COMMONBLUECOLOR;
    self.pointLabel.textColor = [UIColor whiteColor];
    self.pointLabel.font = [UIFont systemFontOfSize:12.0];
    self.pointLabel.textAlignment = NSTextAlignmentCenter;
    self.pointLabel.layer.masksToBounds = YES;
    self.pointLabel.layer.cornerRadius = 5;
    
    self.progressView.frame = CGRectMake(35, 45, 80, 20);
    self.progressView.borderTintColor = [UIColor whiteColor];
    self.progressView.progressTintColor = COMMONBLUECOLOR;
    self.progressView.progressBackgroundColor = RGBCOLOR(225, 225, 225);
    
    self.progressL.frame = CGRectMake(125, 45, 80, 20);
    self.progressL.textColor = RGBCOLOR(144, 144, 144);
    self.progressL.font = [UIFont systemFontOfSize:14.0];
}

#pragma mark - behavior

-(void) rotateExpandBtn:(id)sender
{
    isExpanded = !isExpanded;
    switch (isExpanded) {
        case 0:
            [self rotateExpandBtnToCollapsed];
            [sender setImage:[UIImage imageNamed:@"expand"] forState:UIControlStateNormal];
            break;
        case 1:
            [self rotateExpandBtnToExpanded];
            [sender setImage:[UIImage imageNamed:@"retract"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (void)rotateExpandBtnToExpanded
{
    [UIView beginAnimations:@"rotateDisclosureButt" context:nil];
    [UIView setAnimationDuration:0.2];
    expandBtn.transform = CGAffineTransformMakeRotation(M_PI*2.5);
    [UIView commitAnimations];
}

- (void)rotateExpandBtnToCollapsed
{
    [UIView beginAnimations:@"rotateDisclosureButt" context:nil];
    [UIView setAnimationDuration:0.2];
    expandBtn.transform = CGAffineTransformMakeRotation(M_PI*2);
    [UIView commitAnimations];
}

#pragma mark - Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return subCellsAmt;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString* cellIdentifier = @"subjectCell";
    SubjectTableCell *cell = [[SubjectTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    Course *subCourse = [_course.subList objectAtIndex:indexPath.row];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    [cell setCellWithModel:subCourse];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return subCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SubjectTableCell *cell = (SubjectTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil)
    {
        cell = (SubjectTableCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    [self.parentTable groupCell:self didSelectSubCell:cell withIndexPath:indexPath];
}

@end
