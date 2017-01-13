//
//  XLCycleScrollView.m
//  CycleScrollViewDemo
//
//  Created by xie liang on 9/14/12.
//  Copyright (c) 2012 xie liang. All rights reserved.
//

#import "XLCycleScrollView.h"


#define scroolTimer 3

@implementation XLCycleScrollView


- (void)dealloc
{
    _scrollView.delegate = nil;
    [timer invalidate];
    NSLog(@"XLCycleScrollView Dealloc");
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
        _scrollView.pagingEnabled = YES;
        [self addSubview:_scrollView];
        
        CGRect rect = self.bounds;
        rect.origin.y = rect.size.height - 40;
        rect.size.height = 30;
        _pageControl = [[UIPageControl alloc] initWithFrame:rect];
        _pageControl.userInteractionEnabled = NO;
        
        [self addSubview:_pageControl];
        
        _curPage = 0;
    }
    return self;
}

- (void)setDataource:(id<XLCycleScrollViewDatasource>)datasource
{
    _datasource = datasource;
    [self reloadData];
}


-(void)repeatPageChange
{
    [_scrollView setContentOffset:CGPointMake((2 * self.frame.size.width), 0) animated:YES];
}


/**
 *  销毁循环滚动时间
 */
- (void)destroyTimer{
    
    if (timer == nil) {
        return;
    }
    
    [timer invalidate];
    
}


- (void)reloadData
{
    [self destroyTimer];
    
    _totalPages = [_datasource numberOfPages];
    
    /**
     *  如果是一张图片的话，关闭滑动以及pageControl
     多张图片的话，显示，并且开启自动滚动timer
     */
    if (_totalPages == 1) {
        
        //        _scrollView.userInteractionEnabled = NO;
        _scrollView.scrollEnabled = NO;
        _pageControl.hidden = YES;
        
    }else{
        
        timer = [NSTimer scheduledTimerWithTimeInterval:scroolTimer target:self selector:@selector(repeatPageChange) userInfo:nil repeats:YES];
        _scrollView.scrollEnabled = YES;
        _pageControl.hidden = NO;
    }
    
    
    if (_totalPages == 0) {
        return;
    }
    
    _pageControl.numberOfPages = _totalPages;
    
    [self loadData];
    
}

- (void)loadData
{
    _pageControl.currentPage = _curPage;
    
    //从scrollView上移除所有的subview
    NSArray *subViews = [_scrollView subviews];
    if([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self getDisplayImagesWithCurpage:_curPage];
    
    for (int i = 0; i < 3; i++) {
        UIView *v = [_curViews objectAtIndex:i];
        v.userInteractionEnabled = YES;
        v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
        [_scrollView addSubview:v];
        
        if (_tapEnabled == YES) {
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(handleTap:)];
            [v addGestureRecognizer:singleTap];
        }
    }
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
    
}

- (void)getDisplayImagesWithCurpage:(int)page
{

    int pre = [self validPageValue:_curPage-1];
    int last = [self validPageValue:_curPage+1];
    
    if (!_curViews) {
        _curViews = [[NSMutableArray alloc] init];
    }
    [_curViews removeAllObjects];
    
    [_curViews addObject:[_datasource pageAtIndex:pre]];
    [_curViews addObject:[_datasource pageAtIndex:page]];
    [_curViews addObject:[_datasource pageAtIndex:last]];
    
}

- (int)validPageValue:(NSInteger)value {
    
    if(value == -1) value = _totalPages - 1;
    if(value == _totalPages) value = 0;
    
    return value;
    
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    
    UIView *blackView = [[UIView alloc]initWithFrame:tap.view.bounds];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.3;
    [tap.view addSubview:blackView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [blackView  removeFromSuperview];
    });
    
    if ([_delegate respondsToSelector:@selector(didClickPage:atIndex:)]) {
        [_delegate didClickPage:self atIndex:_curPage];
    }
}

- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index
{
    if (index == _curPage) {
        [_curViews replaceObjectAtIndex:1 withObject:view];
        for (int i = 0; i < 3; i++) {
            UIView *v = [_curViews objectAtIndex:i];
            v.userInteractionEnabled = YES;
            v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
            [_scrollView addSubview:v];
            
            if (_tapEnabled == YES) {
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(handleTap:)];
                [v addGestureRecognizer:singleTap];
            }
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    
    if (_totalPages == 0 || _totalPages == 1) {
        return;
    }
    
    int x = aScrollView.contentOffset.x;
    
    //往下翻一张
    if(x >= (2*self.frame.size.width)) {
        _curPage = [self validPageValue:_curPage+1];
        [self loadData];
    }
    
    //往上翻
    if(x <= 0) {
        _curPage = [self validPageValue:_curPage-1];
        [self loadData];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:YES];
    
    [self destroyTimer];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:scroolTimer target:self selector:@selector(repeatPageChange) userInfo:nil repeats:YES];
}

@end
