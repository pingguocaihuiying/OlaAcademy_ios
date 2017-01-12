//
//  SDGroupCell.h
//  SDNestedTablesExample
//
//  Created by Daniele De Matteis on 21/05/2012.
//  Copyright (c) 2012 Daniele De Matteis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubjectTableCell.h"
#import "Course.h"
#import "THProgressView.h"
#import "QuestionViewController.h"

@class QuestionViewController;

static const int height = 75;
static const int subCellHeight = 80;

@interface SDGroupCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UIButton *expandBtn;
}

@property (nonatomic, assign) QuestionViewController *parentTable;

- (void) setupInterface;

@property (assign) BOOL isExpanded;
@property (nonatomic) IBOutlet UILabel *itemText;
@property (strong, nonatomic) IBOutlet UILabel *pointLabel;
@property (strong, nonatomic) IBOutlet THProgressView *progressView;
@property (strong, nonatomic) IBOutlet UILabel *progressL;
@property (assign) IBOutlet UITableView *subTable;
@property (assign) SubjectTableCell *subCell;
@property (nonatomic) int subCellsAmt;

@property(nonatomic) Course *course;

- (void) rotateExpandBtn:(id)sender;
- (void) rotateExpandBtnToExpanded;
- (void) rotateExpandBtnToCollapsed;

+ (int) getHeight;
+ (int) getsubCellHeight;

@end
