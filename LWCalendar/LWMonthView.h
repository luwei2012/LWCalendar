//
//  LWMonthView.h
//  Example
//
//  Created by Daniel on 16/10/28.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h> 

@class LWCalendarView, LWDatePickerBuilder;

/**
 * 应该包含一个标题，显示年月+一个星期指示器+天数布局
 */
@interface LWMonthView : UIView
@property (nonatomic, strong)NSDate *date;
@property (nonatomic, weak) LWCalendarView *calendarDelegate;
@property (nonatomic, weak) LWDatePickerBuilder *dialogBuilder; 
@end
