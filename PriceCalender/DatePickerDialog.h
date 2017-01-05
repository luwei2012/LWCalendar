//
//  DatePickerDialog.h
//  PriceCalender
//
//  Created by luwei on 2016/12/29.
//  Copyright © 2016年 HarrisHan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DatePickerDialog,ZYCalendarManager,DatePickerView;

@protocol DatePickerDelegate <NSObject>

- (void)onDateSet:(DatePickerDialog*)dialog
        StartDate:(NSDate *)start
          EndDate:(NSDate *)end;

@end

@interface DatePickerDialog :  UIViewController

@property(nonatomic, strong) DatePickerView *dateContainer;
@property(nonatomic, strong) ZYCalendarManager *manager;
@property(nonatomic, strong) NSDate *currentDate;
@property(nonatomic, strong) NSDate *startDate;
@property(nonatomic, strong) NSDate *endDate;
@property(nonatomic, weak) id<DatePickerDelegate> controllerDelegate;

+ (instancetype)initWithDate:(NSDate *)currentDate
                   StartDate:(NSDate *)startDate
                     EndDate:(NSDate *)endDate
                    Delegate:(id<DatePickerDelegate>)delegate;

+ (instancetype)initWithDate:(NSDate *)currentDate
                   StartDate:(NSDate *)startDate
                    Delegate:(id<DatePickerDelegate>)delegate;

+ (instancetype)initWithDate:(NSDate *)currentDate Delegate:(id<DatePickerDelegate>)delegate;

- (void)show;

- (void)hide;

@end
