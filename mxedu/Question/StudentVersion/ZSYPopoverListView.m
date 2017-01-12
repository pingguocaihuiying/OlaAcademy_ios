//
//  ZSYPopoverListView.m
//  MyCustomTableViewForSelected
//
//  Created by Zhu Shouyu on 6/2/13.
//  Copyright (c) 2013 zhu shouyu. All rights reserved.
//

#import "ZSYPopoverListView.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

#import "SysCommon.h"

static const char * const kZSYPopoverListButtonClickForCancel = "kZSYPopoverListButtonClickForCancel";

@interface ZSYPopoverListView ()
@property (nonatomic, retain) UITableView *mainPopoverListView;   //主的选择列表视图
@property (nonatomic, retain) UIButton *cancelButton;
//初始化界面 
- (void)initTheInterface;

//动画进入
- (void)animatedIn;

//动画消失
- (void)animatedOut;

//展示界面
- (void)show;

//消失界面
- (void)dismiss;
@end

@implementation ZSYPopoverListView
@synthesize datasource = _datasource;
@synthesize delegate = _delegate;
@synthesize mainPopoverListView = _mainPopoverListView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initTheInterface];
    }
    return self;
}

- (void)initTheInterface
{
    self.backgroundColor = [UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:0.5];
    
    CGFloat xWidth = self.bounds.size.width;
    CGFloat yHeight = self.bounds.size.height;
    CGRect tableFrame = CGRectMake(xWidth/6.0, yHeight/3.0+10, xWidth*2/3.0, GENERAL_SIZE(400));
    _mainPopoverListView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    self.mainPopoverListView.dataSource = self;
    self.mainPopoverListView.delegate = self;
    [self addSubview:self.mainPopoverListView];
    
    self.mainPopoverListView.layer.cornerRadius = 10.0f;
    self.mainPopoverListView.clipsToBounds = TRUE;
}

- (NSIndexPath *)indexPathForSelectedRow
{
    return [self.mainPopoverListView indexPathForSelectedRow];
}
#pragma mark - Button Method
- (void)setCancelButtonTitle:(NSString *)aTitle block:(ZSYPopoverListViewButtonBlock)block
{
    if (nil == _cancelButton)
    {
        
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cancelButton setTitle:aTitle forState:UIControlStateNormal];
        self.cancelButton.frame = CGRectMake(self.bounds.size.width*5/6-80, self.bounds.size.height/3.0+10+GENERAL_SIZE(320), 60, GENERAL_SIZE(60));
        self.cancelButton.titleLabel.font = LabelFont(28);
        [self.cancelButton setTitleColor:COMMONBLUECOLOR forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(buttonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cancelButton];
        
        self.cancelButton.layer.borderWidth = 1.0f;
        self.cancelButton.layer.borderColor = [COMMONBLUECOLOR CGColor];
        self.cancelButton.layer.cornerRadius = 15.0f;
        self.cancelButton.clipsToBounds = TRUE;
        
    }
    
    objc_setAssociatedObject(self.cancelButton, kZSYPopoverListButtonClickForCancel, [block copy], OBJC_ASSOCIATION_RETAIN);
}
#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.datasource && [self.datasource respondsToSelector:@selector(popoverListView:numberOfRowsInSection:)])
    {
        return [self.datasource popoverListView:self numberOfRowsInSection:section];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datasource && [self.datasource respondsToSelector:@selector(popoverListView:cellForRowAtIndexPath:)])
    {
        return [self.datasource popoverListView:self cellForRowAtIndexPath:indexPath];
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(popoverListView:didDeselectRowAtIndexPath:)])
    {
        [self.delegate popoverListView:self didDeselectRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(popoverListView:didSelectRowAtIndexPath:)])
    {
        [self.delegate popoverListView:self didSelectRowAtIndexPath:indexPath];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return GENERAL_SIZE(100);
}

#pragma mark - Animated Mthod
- (void)animatedIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)animatedOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - show or hide self
- (void)show
{
    
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self];
    
    self.center = CGPointMake(keywindow.bounds.size.width/2.0f,
                              keywindow.bounds.size.height/2.0f);
    [self animatedIn];
}

- (void)dismiss
{
    [self animatedOut];
}

#pragma mark - Reuse Cycle
- (id)dequeueReusablePopoverCellWithIdentifier:(NSString *)identifier
{
    return [self.mainPopoverListView dequeueReusableCellWithIdentifier:identifier];
}

- (UITableViewCell *)popoverCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.mainPopoverListView cellForRowAtIndexPath:indexPath];
}

#pragma mark - UIButton Clicke Method
- (void)buttonWasPressed:(id)sender
{
    ZSYPopoverListViewButtonBlock __block block;
    
    block = objc_getAssociatedObject(sender, kZSYPopoverListButtonClickForCancel);
    if (block)
    {
        block();
    }
    [self animatedOut];
}

- (void)touchForDismissSelf:(id)sender
{
    [self animatedOut];
}
@end
