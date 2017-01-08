//
//  LWCalendarView.h
//  Example
//
//  Created by Daniel on 16/10/28.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MARGIN_H (10)
#define LINE_GAP (4)
#define PADDING_H (LINE_GAP)
#define TITLE_HEIGHT (40)
#define WEEK_INDICATOR_HEIGHT (20)

#define TITLE_FONT_SIZE 18
#define WEEK_INDICATOR_FONT_SIZE 12
#define DAY_FONT_SIZE 12

@class LWDatePickerView,LWDayView;

@interface LWCalendarView : UIScrollView
@property(nonatomic, strong) NSDate *currentDate;
@property(nonatomic, strong) NSDate *startDate;
@property(nonatomic, strong) NSDate *endDate;

// 选中的按钮(开始和结束)
@property (nonatomic, strong)LWDayView *selectedStartDay;
@property (nonatomic, strong)LWDayView *selectedEndDay;

@property (nonatomic, weak)LWDatePickerView *dateViewDelegate;

-(void)scrollToDate:(NSDate *)date;
 

@end
