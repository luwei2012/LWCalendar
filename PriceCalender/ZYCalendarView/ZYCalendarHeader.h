//
//  ZYCalendarHeader.h
//  PriceCalender
//
//  Created by luwei on 2017/1/4.
//  Copyright © 2017年 HarrisHan. All rights reserved.
//

#ifndef ZYCalendarHeader_h
#define ZYCalendarHeader_h
#import "ZYDatePickerDialog.h"
#import "JTDateHelper.h"
#import "ZYCalendarManager.h"
#import "ZYCalendarView.h"
#import "ZYDayView.h"
#import "ZYMonthView.h"
#import "ZYWeekView.h"
#import "ZYDatePickerView.h"
#import "ZYDateIndicator.h"
#import "ZYWeekIndicator.h"


#define CORNER_RADIUS  (4)
#define ZYDAYVIEW_CHANGE_STATE (@"ZYchangeState")
#define ZYDAYVIEW_UPDATE_STATE (@"ZYupdateState")
#define ZYDAYVIEW_DATE_CHANGED (@"ZYdateChanged")

#define DATE_TITLE_FONT_SIZE (16)
#define DATE_SHOW_FONT_SIZE (16)
#define DATE_TITLE_HEIGHT (48)


//按钮水平方向的间距：主要是指cancel和confirm按钮
#define BUTTON_MARGIN_H (5)
#define BUTTON_HEIGHT (48)
#define BUTTON_WIDTH (0.25)
#define SHADOW_RADIUS (8.0)
#define SHADOW_COLOR ([UIColor blackColor].CGColor)
#define SHADOW_OFFSET (CGSizeMake(2, 2))
#define SHADOW_OPACITY (0.6)
#define BUTTON_FONT_SIZE (16)


//动画时间
#define ANIMATE_DUTATION (0.5)
//水平方向边距
#define DATEPICKER_MARGIN_H (60)
//垂直方向边距
#define DATEPICKER_MARGIN_V (60)


#endif /* ZYCalendarHeader_h */
