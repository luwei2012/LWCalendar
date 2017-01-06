//
//  ZYCalendarView.m
//  Example
//
//  Created by Daniel on 16/10/28.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import "ZYCalendarHeader.h"

@implementation ZYCalendarView {
    CGSize lastSize;
    
    ZYMonthView *monthView1;
    ZYMonthView *monthView2;
    ZYMonthView *monthView3;
    ZYMonthView *monthView4;
    ZYMonthView *monthView5;
}

@synthesize currentDate = _currentDate, startDate = _startDate, endDate = _endDate , selectedStartDay = _selectedStartDay, selectedEndDay = _selectedEndDay;


+(CGFloat)heightForCalendarView{
    return 300.0f;
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}

- (void)layoutSubviews {
    // 修改大小
    [self resizeViewsIfWidthChanged];
    // 滚动
    [self viewDidScroll];
}


- (void)resizeViewsIfWidthChanged
{
    CGSize size = self.frame.size;
    
    // 首次加载
    if (!lastSize.width) {
        [self repositionViews];
    }
    
    // self的宽改变
    if(size.width != lastSize.width){
        lastSize = size;
        
        monthView1.frame = CGRectMake(0, monthView1.frame.origin.y, size.width, monthView1.frame.size.height);
        monthView2.frame = CGRectMake(0, monthView2.frame.origin.y, size.width, monthView2.frame.size.height);
        monthView3.frame = CGRectMake(0, monthView3.frame.origin.y, size.width, monthView3.frame.size.height);
        monthView4.frame = CGRectMake(0, monthView4.frame.origin.y, size.width, monthView4.frame.size.height);
        monthView5.frame = CGRectMake(0, monthView5.frame.origin.y, size.width, monthView5.frame.size.height);
        
        self.contentSize = CGSizeMake(size.width, self.contentSize.height);
    }
}

// 首次加载
- (void)repositionViews {
    CGSize size = self.frame.size;
    
    if (!monthView1) {
        monthView1 = [[ZYMonthView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0)];
        monthView2 = [[ZYMonthView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0)];
        monthView3 = [[ZYMonthView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0)];
        monthView4 = [[ZYMonthView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0)];
        monthView5 = [[ZYMonthView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0)];
        
        monthView1.tag = 1;
        monthView1.tag = 2;
        monthView1.tag = 3;
        monthView1.tag = 4;
        monthView1.tag = 5;
        
        monthView1.calendarDelegate = self;
        monthView2.calendarDelegate = self;
        monthView3.calendarDelegate = self;
        monthView4.calendarDelegate = self;
        monthView5.calendarDelegate = self;
        
        [self addSubview:monthView1];
        [self addSubview:monthView2];
        [self addSubview:monthView3];
        [self addSubview:monthView4];
        [self addSubview:monthView5];
        
        self.currentDate = _currentDate;
    }
    
    self.contentSize = CGSizeMake(size.width, monthView1.frame.size.height + monthView2.frame.size.height + monthView3.frame.size.height + monthView4.frame.size.height + monthView5.frame.size.height);
    self.contentOffset = CGPointMake(0, monthView1.frame.size.height + monthView2.frame.size.height);
    
    [self resetMonthViewsFrame];
    
}

// 滚动了
- (void)viewDidScroll {
    if(self.contentSize.height <= 0){
        return;
    }
    
    if(self.contentOffset.y < monthView1.frame.size.height + monthView2.frame.size.height/2.0){
        // 加载上一页(如果是当前日期的上一个月, 不加载)
        [self loadPreviousPage];
    }
    else if(self.contentOffset.y > monthView1.frame.size.height+monthView2.frame.size.height+monthView3.frame.size.height/2.0){
        // 加载下一页
        [self loadNextPage];
    }
}

- (void)loadPreviousPage {
    
    ZYMonthView *tmpView = monthView5;
    
    monthView5 = monthView4;
    monthView4 = monthView3;
    monthView3 = monthView2;
    monthView2 = monthView1;
    
    monthView1 = tmpView;
    
    monthView1.date = [self.dateViewDelegate.dialogDelegate.manager.helper addToDate:monthView2.date months:-1];
    
    [self resetMonthViewsFrame];
    
    self.contentOffset = CGPointMake(0, self.contentOffset.y + monthView1.frame.size.height);
}

- (void)loadNextPage {
    
    CGFloat height1 = monthView1.frame.size.height;
    
    ZYMonthView *tmpView = monthView1;
    
    monthView1 = monthView2;
    monthView2 = monthView3;
    monthView3 = monthView4;
    monthView4 = monthView5;
    
    monthView5 = tmpView;
    monthView5.date = [self.dateViewDelegate.dialogDelegate.manager.helper addToDate:monthView4.date months:1];
    
    [self resetMonthViewsFrame];
    
    self.contentOffset = CGPointMake(0, self.contentOffset.y - height1);
}

- (void)resetMonthViewsFrame {
    CGSize size = self.frame.size;
    monthView1.frame = CGRectMake(0, 0, size.width, monthView1.frame.size.height);
    monthView2.frame = CGRectMake(0, CGRectGetMaxY(monthView1.frame), size.width, monthView2.frame.size.height);
    monthView3.frame = CGRectMake(0, CGRectGetMaxY(monthView2.frame), size.width, monthView3.frame.size.height);
    monthView4.frame = CGRectMake(0, CGRectGetMaxY(monthView3.frame), size.width, monthView4.frame.size.height);
    monthView5.frame = CGRectMake(0, CGRectGetMaxY(monthView4.frame), size.width, monthView5.frame.size.height);
    self.contentSize = CGSizeMake(size.width,
                                  monthView1.frame.size.height + monthView2.frame.size.height + monthView3.frame.size.height + monthView4.frame.size.height + monthView5.frame.size.height);
}


-(void)scrollToDate:(NSDate *)date{
    JTDateHelper *helper = self.dateViewDelegate.dialogDelegate.manager.helper;
    int distance  = [helper date:date distanceFrom:monthView3.date];
    monthView1.date = [self.dateViewDelegate.dialogDelegate.manager.helper addToDate:date months:-2];
    monthView2.date = [self.dateViewDelegate.dialogDelegate.manager.helper addToDate:date months:-1];
    monthView3.date = date;
    monthView4.date = [self.dateViewDelegate.dialogDelegate.manager.helper addToDate:date months:1];
    monthView5.date = [self.dateViewDelegate.dialogDelegate.manager.helper addToDate:date months:2];
    [self resetMonthViewsFrame];
    if (distance > 0) {
        //应该向上滚动
        self.contentOffset = CGPointMake(0, monthView1.frame.size.height + monthView2.frame.size.height * 0.5);
    }else if(distance < 0){
        //应该向下滚动
        self.contentOffset = CGPointMake(0, monthView1.frame.size.height + monthView2.frame.size.height + monthView3.frame.size.height/2.0);
    }
    [self setContentOffset:CGPointMake(0, monthView1.frame.size.height + monthView2.frame.size.height) animated:true];
}

#pragma mark Get and Set
//每次取值时首先同步一次startDate
-(NSDate *)startDate{
    if (_selectedStartDay) {
        _startDate = _selectedStartDay.date;
    }
    return _startDate;
}
//每次取值时首先同步一次endDate
-(NSDate *)endDate{
    if (_selectedEndDay) {
        _endDate = _selectedEndDay.date;
    }
    return _endDate;
}

-(void)setCurrentDate:(NSDate *)currentDate{
    _currentDate = currentDate;     
    monthView1.date = [self.dateViewDelegate.dialogDelegate.manager.helper addToDate:_currentDate months:-2];
    monthView2.date = [self.dateViewDelegate.dialogDelegate.manager.helper addToDate:_currentDate months:-1];
    monthView3.date = _currentDate;
    monthView4.date = [self.dateViewDelegate.dialogDelegate.manager.helper addToDate:_currentDate months:1];
    monthView5.date = [self.dateViewDelegate.dialogDelegate.manager.helper addToDate:_currentDate months:2];
}

-(void)setStartDate:(NSDate *)startDate{
    _startDate = startDate;
    //首先需要清空选中的ZYDayView 否则ZYDayView在取startDate值时会将startDate覆盖回来
    if (_selectedStartDay) {
        _selectedStartDay.selected = false;
        _selectedStartDay = nil;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:ZYDAYVIEW_UPDATE_STATE object:nil];
}

-(void)setEndDate:(NSDate *)endDate{
    _endDate = endDate;
    //首先需要清空选中的ZYDayView 否则ZYDayView在取endDate值时会将endDate覆盖回来
    if (_selectedEndDay) {
        _selectedEndDay.selected = false;
        _selectedEndDay = nil;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:ZYDAYVIEW_UPDATE_STATE object:nil];
}

-(void)setSelectedStartDay:(ZYDayView *)selectedStartDay{
    _selectedStartDay = selectedStartDay;
    if (_selectedStartDay) {
        _startDate = _selectedStartDay.date;
    }else{
        _startDate = nil;
    }
}

-(void)setSelectedEndDay:(ZYDayView *)selectedEndDay{
    _selectedEndDay = selectedEndDay;
    if (_selectedEndDay) {
        _endDate = _selectedEndDay.date;
    }else{
        _endDate = nil;
    }
}

@end
