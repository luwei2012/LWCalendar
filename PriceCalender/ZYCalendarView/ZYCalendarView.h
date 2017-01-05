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
#define TITLE_HEIGHT (80)
#define WEEK_INDICATOR_HEIGHT (20)

@class DatePickerView;

@interface ZYCalendarView : UIScrollView
@property(nonatomic, strong) NSDate *currentDate;
@property(nonatomic, strong) NSDate *startDate;
@property(nonatomic, strong) NSDate *endDate;
@property (nonatomic, weak)DatePickerView *dateViewDelegate;

+(CGFloat)heightForCalendarView;

@end
