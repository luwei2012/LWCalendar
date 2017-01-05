//
//  ZYMonthView.h
//  Example
//
//  Created by Daniel on 16/10/28.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h> 

@class ZYCalendarView;

@interface ZYMonthView : UIView
@property (nonatomic, strong)NSDate *date;
@property (nonatomic, weak)ZYCalendarView *calendarDelegate;

- (void)reload;

@end