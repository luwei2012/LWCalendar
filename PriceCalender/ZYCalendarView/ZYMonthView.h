//
//  ZYMonthView.h
//  Example
//
//  Created by Daniel on 16/10/28.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h> 

@class ZYCalendarView;

/**
 * 应该包含一个标题，显示年月+一个星期指示器+天数布局
 */
@interface ZYMonthView : UIView
@property (nonatomic, strong)NSDate *date;
@property (nonatomic, weak)ZYCalendarView *calendarDelegate;

+(CGFloat)heightForMonthView;

@end
