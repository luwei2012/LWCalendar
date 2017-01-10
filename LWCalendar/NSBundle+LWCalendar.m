//
//  NSBundle+MJRefresh.m
//  MJRefreshExample
//
//  Created by MJ Lee on 16/6/13.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "LWCalendarHeader.h"

@implementation NSBundle (LWCalendar)

+ (instancetype)LWCalendarBundle{
    static NSBundle *calendarBundle = nil;
    if (calendarBundle == nil) {
        // 这里不使用mainBundle是为了适配pod 1.x和0.x
        calendarBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[LWDayView class]] pathForResource:@"LWCalendar" ofType:@"bundle"]];
    }
    return calendarBundle;
}

+ (UIImage *)LWCalendarCircleImage{
    static UIImage *circleImage = nil;
    if (circleImage == nil) {
        circleImage = [[UIImage imageWithContentsOfFile:[[self LWCalendarBundle] pathForResource:@"circle@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    return circleImage;
}

+ (UIImage *)LWCalendarStartFilterImage{
    static UIImage *startFiltermage = nil;
    if (startFiltermage == nil) {
        startFiltermage = [[UIImage imageWithContentsOfFile:[[self LWCalendarBundle] pathForResource:@"start_filter@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return startFiltermage;
}

+ (UIImage *)LWCalendarEndFilterImage{
    static UIImage *endFilterImage = nil;
    if (endFilterImage == nil) {
        endFilterImage = [[UIImage imageWithContentsOfFile:[[self LWCalendarBundle] pathForResource:@"end_filter@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return endFilterImage;
}
@end
