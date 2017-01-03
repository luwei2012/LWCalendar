//
//  DatePickerDialog.h
//  PriceCalender
//
//  Created by luwei on 2016/12/29.
//  Copyright © 2016年 HarrisHan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DatePickerDialog;

@protocol DatePicker <NSObject>

- (void)onDateSet:(DatePickerDialog*)dialog
        YearStart:(int)yearStart
        MonthSart:(int)monthStart
         DayStart:(int)dayStart
          YearEnd:(int)yearEnd
         MonthEnd:(int)monthEnd
           DayEnd:(int)dayEnd;

@end

@interface DatePickerDialog :  UIViewController

+ (instancetype)initWithYearStart:(int)yearStart
                        MonthSart:(int)monthStart
                         DayStart:(int)dayStart
                          YearEnd:(int)yearEnd
                         MonthEnd:(int)monthEnd
                           DayEnd:(int)dayEnd;

- (void)show;

- (void)hiden;

@end
