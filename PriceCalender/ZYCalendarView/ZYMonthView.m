//
//  ZYMonthView.m
//  Example
//
//  Created by Daniel on 16/10/28.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import "ZYCalendarHeader.h"

@interface ZYMonthView ()
@property (nonatomic, strong)NSMutableArray *weeksViews;
@property (nonatomic, strong)UILabel *titleLab;
@property(nonatomic, weak) ZYCalendarManager *manager;
@end

@implementation ZYMonthView {
    NSInteger weekNumber;
    CGFloat weekH;
    CGFloat gap;
}

@synthesize calendarDelegate = _calendarDelegate;

- (void)setDate:(NSDate *)date {
    _date = date;
    [self reload];
}

- (void)commonInit {
    gap = 5;
    _weeksViews  =[NSMutableArray new];
    weekH = (self.frame.size.width-gap*8)/7;
}

- (void)reload {
    // 某月
    NSString *dateStr = [self.manager.titleDateFormatter stringFromDate:_date];
    self.titleLab.text = dateStr;
    
    weekNumber = [self.manager.helper numberOfWeeks:_date];
    // 有几周
    if (_weeksViews.count) {
        [_weeksViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_weeksViews removeAllObjects];
    }
    
    NSDate *firstDay = [self.manager.helper firstDayOfMonth:_date];
        
    for (int i = 0; i < weekNumber; i++) {
        ZYWeekView *weekView = [[ZYWeekView alloc] initWithFrame:CGRectMake(0, weekH+gap*2 + (weekH+gap)*i, self.frame.size.width, weekH)];
        weekView.monthDelegate = self;
        weekView.theMonthFirstDay = firstDay;
        weekView.date = [self.manager.helper addToDate:firstDay weeks:i];
        [self addSubview:weekView];
        [_weeksViews addObject:weekView];
    }
    
    CGRect frame = self.frame;
    frame.size.height = weekNumber * (weekH+gap) + weekH + 2*gap;
    self.frame = frame;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, gap+10, self.frame.size.width-30, weekH-10)];
        _titleLab.font = [UIFont systemFontOfSize:20];
        [self addSubview:_titleLab];
    }
    return _titleLab;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

#pragma mark Get and Set
-(void)setCalendarDelegate:(ZYCalendarView *)calendarDelegate{
    _calendarDelegate = calendarDelegate;
    _manager = _calendarDelegate.dateViewDelegate.dialogDelegate.manager;
}

@end
