//
//  LWMonthView.m
//  Example
//
//  Created by Daniel on 16/10/28.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import "LWCalendarHeader.h"



@interface LWMonthView ()
@property (nonatomic, strong) NSMutableArray *weeksViews;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, weak) LWCalendarManager *manager;
@property (nonatomic, strong) LWWeekIndicator *weekIndicator;
@end

@implementation LWMonthView {
    NSInteger weekNumber;
    CGSize lastSize;
}

@synthesize
calendarDelegate    = _calendarDelegate,
weekIndicator       = _weekIndicator,
titleLab            = _titleLab,
dialogBuilder       = _dialogBuilder;


#pragma mark 构造函数
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _weeksViews = [NSMutableArray new];
        [self updateWithBuilder:self.dialogBuilder];
    }
    return self;
}

-(instancetype)init{
    return [self initWithFrame:CGRectMake(0, 0, 0, 0)];
}

-(void)layoutSubviews{
    CGSize size = self.frame.size;
    if (!lastSize.width || size.width != lastSize.width || size.height != lastSize.height) {
          // 首次加载
        lastSize = size;
        [self resize];
    }
}


- (void)resize {
    self.titleLab.frame = CGRectMake(0,  0, self.frame.size.width , self.dialogBuilder.LWCalendarTitleHeight);
    self.weekIndicator.frame = CGRectMake(self.dialogBuilder.LWCalendarMarginH, self.dialogBuilder.LWCalendarTitleHeight + self.dialogBuilder.LWCalendarLineGap, self.frame.size.width - self.dialogBuilder.LWCalendarMarginH * 2, self.dialogBuilder.LWWeekIndicatorHeight);
    CGFloat startY = self.dialogBuilder.LWCalendarTitleHeight + self.dialogBuilder.LWWeekIndicatorHeight + self.dialogBuilder.LWCalendarLineGap * 2;
    CGFloat startX = self.dialogBuilder.LWCalendarMarginH;
    CGFloat weekH = (self.frame.size.width -  self.dialogBuilder.LWCalendarRowGap * 8 - self.dialogBuilder.LWCalendarMarginH * 2)/7;
    for (int i = 0; i < weekNumber; i++) {
        LWWeekView *weekView = _weeksViews[i];
        if (weekView) {
            weekView.frame = CGRectMake(startX, startY + (weekH + self.dialogBuilder.LWCalendarLineGap) * i, self.frame.size.width - self.dialogBuilder.LWCalendarMarginH * 2, weekH);
        }
    }
    CGRect frame = self.frame;
    frame.size.height = weekNumber * weekH + self.dialogBuilder.LWCalendarTitleHeight + self.dialogBuilder.LWWeekIndicatorHeight + (weekNumber + 2) * self.dialogBuilder.LWCalendarLineGap;
    self.frame = frame;
}




#pragma mark Get and Set
-(void)setCalendarDelegate:(LWCalendarView *)calendarDelegate{
    _calendarDelegate = calendarDelegate;
    _manager = _calendarDelegate.dateViewDelegate.dialogDelegate.manager;
}

- (void)setDate:(NSDate *)date {
    _date = date;
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
    CGFloat startY = self.dialogBuilder.LWCalendarTitleHeight + self.dialogBuilder.LWWeekIndicatorHeight + self.dialogBuilder.LWCalendarLineGap * 2;
    CGFloat startX = self.dialogBuilder.LWCalendarMarginH;
    CGFloat weekH = (self.frame.size.width -  self.dialogBuilder.LWCalendarRowGap * 8 - self.dialogBuilder.LWCalendarMarginH * 2)/7;
    for (int i = 0; i < weekNumber; i++) {
        LWWeekView *weekView = [[LWWeekView alloc] initWithFrame:CGRectMake(startX, startY + (weekH + self.dialogBuilder.LWCalendarLineGap) * i, self.frame.size.width - self.dialogBuilder.LWCalendarMarginH * 2, weekH)];
        weekView.monthDelegate = self;
        weekView.theMonthFirstDay = firstDay;
        weekView.date = [self.manager.helper addToDate:firstDay weeks:i];
        weekView.dialogBuilder = self.dialogBuilder;
        [self addSubview:weekView];
        [_weeksViews addObject:weekView];
    }
    CGRect frame = self.frame;
    frame.size.height = weekNumber * weekH + self.dialogBuilder.LWCalendarTitleHeight + self.dialogBuilder.LWWeekIndicatorHeight + (weekNumber + 2) * self.dialogBuilder.LWCalendarLineGap;
    self.frame = frame;
    [self updateWithBuilder:self.dialogBuilder];
}

- (UILabel *)titleLab {
    if (_titleLab == nil) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0,  0, self.frame.size.width , self.dialogBuilder.LWCalendarTitleHeight)];
        _titleLab.textAlignment = NSTextAlignmentCenter;

        [self addSubview:_titleLab];
    }
    return _titleLab;
}


-(LWWeekIndicator *)weekIndicator{
    if (_weekIndicator == nil) {
        _weekIndicator = [[LWWeekIndicator alloc] initWithFrame:CGRectMake(self.dialogBuilder.LWCalendarMarginH, self.dialogBuilder.LWCalendarTitleHeight + self.dialogBuilder.LWCalendarLineGap, self.frame.size.width - self.dialogBuilder.LWCalendarMarginH * 2, self.dialogBuilder.LWWeekIndicatorHeight)];
        _weekIndicator.monthDelegate = self;
        [self addSubview:_weekIndicator];
    }
    return _weekIndicator;
}

-(void)setDialogBuilder:(LWDatePickerBuilder *)dialogBuilder{
    if (dialogBuilder && _dialogBuilder != dialogBuilder) {
        _dialogBuilder = dialogBuilder;
        [self updateWithBuilder:dialogBuilder];
    }
}

-(LWDatePickerBuilder *)dialogBuilder{
    if(_dialogBuilder == nil){
        if (self.calendarDelegate) {
            _dialogBuilder = self.calendarDelegate.dialogBuilder;
        }else{
            _dialogBuilder = [LWDatePickerBuilder defaultBuilder];
        }
    }
    return _dialogBuilder;
}

#pragma mark 根据Build参数更新UI或者约束
-(void)updateWithBuilder:(LWDatePickerBuilder *)builder{
    //更新标题
    self.titleLab.font = builder.LWCalendarTitleFont;
    self.titleLab.textColor = builder.LWDatePickerViewDefaultTextColor;
    //更新week指示器
    self.weekIndicator.dialogBuilder = builder;
    //更新weekView
    for (int i = 0; i < weekNumber; i++) {
        LWWeekView *weekView = _weeksViews[i];
        weekView.dialogBuilder = builder;
    }
    
}

@end
