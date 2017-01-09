//
//  LWCalendarView.h
//  Example
//
//  Created by Daniel on 16/10/28.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h> 

@class LWDatePickerView, LWDayView, LWDatePickerBuilder;

@interface LWCalendarView : UIScrollView
@property(nonatomic, strong) NSDate *currentDate;
@property(nonatomic, strong) NSDate *startDate;
@property(nonatomic, strong) NSDate *endDate;

// 选中的按钮(开始和结束)
@property (nonatomic, strong) LWDayView *selectedStartDay;
@property (nonatomic, strong) LWDayView *selectedEndDay;
@property (nonatomic, weak) LWDatePickerView *dateViewDelegate;
@property (nonatomic, weak) LWDatePickerBuilder *dialogBuilder;

-(void)scrollToDate:(NSDate *)date;
 

@end
