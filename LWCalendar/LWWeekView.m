//
//  LWWeekView.m
//  Example
//
//  Created by Daniel on 16/10/28.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import "LWCalendarHeader.h"

@interface LWWeekView ()
@property(nonatomic, weak) LWCalendarManager *manager;
@end

@implementation LWWeekView {
    CGFloat dayViewWidth;
    CGFloat dayViewHeight;
    CGSize lastSize;
    NSMutableArray *dayViews;
}
@synthesize monthDelegate = _monthDelegate, dialogBuilder   = _dialogBuilder;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

-(instancetype)init{
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

-(void)commonInit{
    dayViews = [NSMutableArray new];
    dayViewWidth = self.frame.size.width / 7;
    dayViewHeight = (self.frame.size.width - self.dialogBuilder.LWCalendarRowGap * 8 ) / 7;
    [self updateWithBuilder:self.dialogBuilder];
}

-(void)layoutSubviews{
    CGSize size = self.frame.size;
    if (!lastSize.width || size.width != lastSize.width || size.height != lastSize.height) {
        lastSize = size;
        [self resize];
    }
}

- (void)resize {
    if (dayViews.count > 0) {
        dayViewWidth = self.frame.size.width / 7;
        dayViewHeight = (self.frame.size.width - self.dialogBuilder.LWCalendarRowGap * 8 ) / 7;
        
        for (int i = 0; i < 7; i++) {
            LWDayView *dayView = dayViews[i];
            dayView.frame = CGRectMake(dayViewWidth * i, 0, dayViewWidth, dayViewHeight);
        }
    }
}



#pragma mark Get and Set
-(void)setMonthDelegate:(LWMonthView *)monthDelegate{
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
        LWDayView *dayView = [[LWDayView alloc] initWithFrame:CGRectMake(dayViewWidth * i, 0, dayViewWidth, dayViewHeight)];
        dayView.weekDelegate = self;
        dayView.dialogBuilder = self.dialogBuilder;
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

-(void)setDialogBuilder:(LWDatePickerBuilder *)dialogBuilder{
    if (dialogBuilder && _dialogBuilder != dialogBuilder) {
        _dialogBuilder = dialogBuilder;
        [self updateWithBuilder:dialogBuilder];
    }
}

-(LWDatePickerBuilder *)dialogBuilder{
    if(_dialogBuilder == nil){
        if (self.monthDelegate) {
            _dialogBuilder = self.monthDelegate.dialogBuilder;
        }else{
            _dialogBuilder = [LWDatePickerBuilder defaultBuilder];
        }
    }
    return _dialogBuilder;
}

#pragma mark 根据Build参数更新UI或者约束
-(void)updateWithBuilder:(LWDatePickerBuilder *)builder{
    //dayView设置
    for (int i = 0; i < dayViews.count; i++) {
        LWDayView *dayView = dayViews[i];
        dayView.dialogBuilder = builder;
    }
}

@end
