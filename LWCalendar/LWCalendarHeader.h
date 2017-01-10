//
//  LWCalendarHeader.h
//  PriceCalender
//
//  Created by luwei on 2017/1/4.
//  Copyright © 2017年 HarrisHan. All rights reserved.
//

#ifndef LWCalendarHeader_h
#define LWCalendarHeader_h

#import "LWDatePickerDialog.h"
#import "LWDateHelper.h"
#import "LWCalendarManager.h"
#import "LWCalendarView.h"
#import "LWDayView.h"
#import "LWMonthView.h"
#import "LWWeekView.h"
#import "LWDatePickerView.h"
#import "LWDateIndicator.h"
#import "LWWeekIndicator.h"
#import "LWDatePickerBuilder.h"
#import "NSBundle+LWCalendar.h"

//日期选择器的通知事件
//选中某个日期后的本地通知
#define LWDAYVIEW_CHANGE_STATE (@"LWChangeState")
//手动设置开始、结束日期的本地通知 一般是在Dialog初始化时设置开始和结束时间 用于calendarView通知dayView更新自己的状态 calendarView和dayView隔了很多层，因此使用本地通知的方式
#define LWDAYVIEW_UPDATE_STATE (@"LWUpdateState")
//dayView点击事件，用纸calendarView更新From和To时间的显示需要更新
#define LWDAYVIEW_DATE_CHANGED (@"LWDateChanged")


//颜色工具宏
#define LWHEXCOLOR(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:1.0]

// 图片路径
#define LWCalendarSrcName(file) [@"LWCalendar.bundle" stringByAppendingPathComponent:file]

#endif /* LWCalendarHeader_h */
