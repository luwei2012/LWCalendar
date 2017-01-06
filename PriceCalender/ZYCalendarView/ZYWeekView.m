//
//  ZYWeekView.m
//  Example
//
//  Created by Daniel on 16/10/28.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import "ZYCalendarHeader.h"

@interface ZYWeekView ()
@property(nonatomic, weak) ZYCalendarManager *manager;
@end

@implementation ZYWeekView {
    CGFloat dayViewWidth;
    CGFloat dayViewHeight;
    CGSize lastSize;
    NSMutableArray *dayViews;
}
@synthesize monthDelegate = _monthDelegate;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        dayViews = [NSMutableArray new];
        dayViewWidth = frame.size.width / 7;
        dayViewHeight = (frame.size.width - LINE_GAP * 8 ) / 7;
    }
    return self;
}

-(void)layoutSubviews{
    CGSize size = self.frame.size;
    // 首次加载
    if (!lastSize.width || size.width != lastSize.width || size.height != lastSize.height) {
        lastSize = size;
        [self resize];
    }
}

- (void)resize {
    if (dayViews.count > 0) {
        dayViewWidth = self.frame.size.width / 7;
        dayViewHeight = (self.frame.size.width - LINE_GAP * 8 ) / 7; 
        
        for (int i = 0; i < 7; i++) {
            ZYDayView *dayView = dayViews[i];
            dayView.frame = CGRectMake(dayViewWidth * i, 0, dayViewWidth, dayViewHeight);
        }
    }
}



#pragma mark Get and Set
-(void)setMonthDelegate:(ZYMonthView *)monthDelegate{
    _monthDelegate = monthDelegate;
    _manager = _monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager;
}

- (void)setDate:(NSDate *)date {
    _date = date;
    if (dayViews.count) {
        [dayViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [dayViews removeAllObjects];
    }
    NSDate *firstDate = [self.manager.helper firstWeekDayOfWeek:_date];
    
    for (int i = 0; i < 7; i++) {
        ZYDayView *dayView = [[ZYDayView alloc] initWithFrame:CGRectMake(dayViewWidth * i, 0, dayViewWidth, dayViewHeight)];
        dayView.weekDelegate = self;
        
        NSDate *dayDate = [self.manager.helper addToDate:firstDate days:i];
        
        BOOL isSameMonth = [self.manager.helper date:dayDate isTheSameMonthThan:_theMonthFirstDay];
        if (!isSameMonth) {
            
            if ([self.manager.helper date:dayDate isAfter:[self.manager.helper lastDayOfMonth:_theMonthFirstDay]]) {
                dayDate = [self.manager.helper lastDayOfMonth:_theMonthFirstDay];
            } else if ([self.manager.helper date:dayDate isBefore:_theMonthFirstDay]) {
                dayDate = _theMonthFirstDay;
            }
        }
        dayView.enabled = isSameMonth;
        dayView.date = dayDate;
        [self addSubview:dayView];
        [dayViews addObject:dayView];
    }
}

@end
