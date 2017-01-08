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

//日期选择器的通知事件
//选中某个日期后的本地通知
#define LWDAYVIEW_CHANGE_STATE (@"LWChangeState")
//手动设置开始、结束日期的本地通知 一般是在Dialog初始化时设置开始和结束时间 用于calendarView通知dayView更新自己的状态 calendarView和dayView隔了很多层，因此使用本地通知的方式
#define LWDAYVIEW_UPDATE_STATE (@"LWUpdateState")
//dayView点击事件，用纸calendarView更新From和To时间的显示需要更新
#define LWDAYVIEW_DATE_CHANGED (@"LWDateChanged")


//日期选择器容器的默认配置的圆角 --LWDatePickerDialog
#define LWDATEPICKERDIALOG_CORNER  (4)
//日期选择器容器水平方向边距 决定了选择器的宽度
#define LWDATEPICKERDIALOG_MARGIN_H (60)
//日期选择器容器垂直方向边距 决定了选择器的高度
#define LWDATEPICKERDIALOG_MARGIN_V (60)
//日期选择器容器显示和隐藏的动画时间
#define ANIMATE_DUTATION (0.5)


//日期选择器 月历View的默认配置 --LWDatePickerView
//选中状态的颜色 这里默认使用的是绿色
#define LWDATEPICKERVIEW_SELECTED_COLOR LWHEXCOLOR(0x128963)
//选中状态的文字颜色 绿色的背景+白色的文字
#define LWDATEPICKERVIEW_SELECTED_TEXT_COLOR [UIColor whiteColor]
//默认普通状态的文字是黑色  白色背景+黑色文字
#define LWDATEPICKERVIEW_DEFAULT_TEXT_COLOR [UIColor blackColor]
//LWDatePickerView阴影的配置参数
#define LWDATEPICKERVIEW_SHADOW_RADIUS (8.0)
#define LWDATEPICKERVIEW_SHADOW_COLOR ([UIColor blackColor].CGColor)
#define LWDATEPICKERVIEW_SHADOW_OFFSET (CGSizeMake(2, 2))
#define LWDATEPICKERVIEW_SHADOW_OPACITY (0.6)

//功能按钮水平方向的间距：主要是指cancel和confirm按钮之间的间距
#define LWDATEPICKERVIEW_BUTTON_MARGIN_H (5)
//功能按钮的高度：主要是指cancel和confirm按钮的高度
#define LWDATEPICKERVIEW_BUTTON_HEIGHT (48)
//功能按钮的宽度相对LWDatePickerView宽度的比例：主要是指cancel和confirm按钮的宽度
#define LWDATEPICKERVIEW_BUTTON_WIDTH (0.25)
//功能按钮的字体大小：主要是指cancel和confirm按钮的字体大小
#define LWDATEPICKERVIEW_BUTTON_FONT_SIZE (16)

//指示器的默认配置 --LWDateIndicator
//指示器的title默认高度 整个指示器高度为title高度+日期提示label高度 日期提示label高度默认为title高度的1.5倍
#define LWDATEINICATOR_TITLE_HEIGHT (48)
//指示器上的title字体大小
#define LWDATEINICATOR_TITLE_FONT_SIZE (16)
//指示器上的选中日期提示文字的字体大小
#define LWDATEINICATOR_DATE_FONT_SIZE (16)

//颜色工具宏
#define LWHEXCOLOR(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:1.0]



#endif /* LWCalendarHeader_h */
