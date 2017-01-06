//
//  ZYCalendarView.h
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

#define TITLE_FONT_SIZE 20
#define WEEK_INDICATOR_FONT_SIZE 12
#define DAY_FONT_SIZE 12

@class DatePickerView;

@interface ZYCalendarView : UIScrollView
@property(nonatomic, strong) NSDate *currentDate;
@property(nonatomic, strong) NSDate *startDate;
@property(nonatomic, strong) NSDate *endDate;
@property (nonatomic, weak)DatePickerView *dateViewDelegate;

+(CGFloat)heightForCalendarView;

@end
