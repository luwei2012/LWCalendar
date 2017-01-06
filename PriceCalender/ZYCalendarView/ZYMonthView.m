//
//  ZYMonthView.m
//  Example
//
//  Created by Daniel on 16/10/28.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import "ZYCalendarHeader.h"



@interface ZYMonthView ()
@property (nonatomic, strong) NSMutableArray *weeksViews;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, weak) ZYCalendarManager *manager;
@property (nonatomic, strong) ZYWeekIndicator *weekIndicator;
@end

@implementation ZYMonthView {
    NSInteger weekNumber;
    CGSize lastSize;
}

@synthesize calendarDelegate = _calendarDelegate, weekIndicator = _weekIndicator ,titleLab = _titleLab;

+(CGFloat)heightForMonthView{
    return 300;
}

#pragma mark 构造函数
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _weeksViews = [NSMutableArray new];
    }
    return self;
}

-(instancetype)init{
    return [self initWithFrame:CGRectMake(0, 0, 0, 0)];
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
    self.titleLab.frame = CGRectMake(0,  0, self.frame.size.width , TITLE_HEIGHT);
    self.weekIndicator.frame = CGRectMake(MARGIN_H, TITLE_HEIGHT + LINE_GAP, self.frame.size.width - MARGIN_H * 2, WEEK_INDICATOR_HEIGHT);
    CGFloat startY = TITLE_HEIGHT + WEEK_INDICATOR_HEIGHT + LINE_GAP * 2;
    CGFloat startX = MARGIN_H;
    CGFloat weekH = (self.frame.size.width -  PADDING_H * 8 - MARGIN_H * 2)/7;
    for (int i = 0; i < weekNumber; i++) {
        ZYWeekView *weekView = _weeksViews[i];
        if (weekView) {
            weekView.frame = CGRectMake(startX, startY + (weekH + LINE_GAP) * i, self.frame.size.width - MARGIN_H * 2, weekH);
        }
    }
    CGRect frame = self.frame;
    frame.size.height = weekNumber * weekH + TITLE_HEIGHT + WEEK_INDICATOR_HEIGHT + (weekNumber + 2) * LINE_GAP;
    self.frame = frame;
}




#pragma mark Get and Set
-(void)setCalendarDelegate:(ZYCalendarView *)calendarDelegate{
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
    CGFloat startY = TITLE_HEIGHT + WEEK_INDICATOR_HEIGHT + LINE_GAP * 2;
    CGFloat startX = MARGIN_H;
    CGFloat weekH = (self.frame.size.width -  PADDING_H * 8 - MARGIN_H * 2)/7;
    for (int i = 0; i < weekNumber; i++) {
        ZYWeekView *weekView = [[ZYWeekView alloc] initWithFrame:CGRectMake(startX, startY + (weekH + LINE_GAP) * i, self.frame.size.width - MARGIN_H * 2, weekH)];
        weekView.monthDelegate = self;
        weekView.theMonthFirstDay = firstDay;
        weekView.date = [self.manager.helper addToDate:firstDay weeks:i];
        [self addSubview:weekView];
        [_weeksViews addObject:weekView];
    }
    CGRect frame = self.frame;
    frame.size.height = weekNumber * weekH + TITLE_HEIGHT + WEEK_INDICATOR_HEIGHT + (weekNumber + 2) * LINE_GAP;
    self.frame = frame;
}

- (UILabel *)titleLab {
    if (_titleLab == nil) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0,  0, self.frame.size.width , TITLE_HEIGHT)];
        _titleLab.font = [UIFont systemFontOfSize:TITLE_FONT_SIZE];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.textColor = [UIColor blackColor];
        [self addSubview:_titleLab];
    }
    return _titleLab;
}


-(ZYWeekIndicator *)weekIndicator{
    if (_weekIndicator == nil) {
        _weekIndicator = [[ZYWeekIndicator alloc] initWithFrame:CGRectMake(MARGIN_H, TITLE_HEIGHT + LINE_GAP, self.frame.size.width - MARGIN_H * 2, WEEK_INDICATOR_HEIGHT)];
        [self addSubview:_weekIndicator];
    }
    return _weekIndicator;
}

@end
