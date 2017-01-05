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
    CGFloat gap;
}
@synthesize monthDelegate = _monthDelegate;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        gap = 5;
        dayViewWidth = frame.size.width/7;
        dayViewHeight = (frame.size.width-gap*8)/7;
    }
    return self;
}

- (void)setDate:(NSDate *)date {
    _date = date;
    
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
    }
}

#pragma mark Get and Set
-(void)setMonthDelegate:(ZYMonthView *)monthDelegate{
    _monthDelegate = monthDelegate;
    _manager = _monthDelegate.calendarDelegate.dateViewDelegate.dialogDelegate.manager;
}

@end
