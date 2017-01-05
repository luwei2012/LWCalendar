//
//  ZYCalendarView.h
//  Example
//
//  Created by Daniel on 16/10/28.
//  Copyright © 2016年 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DatePickerView;

@interface ZYCalendarView : UIScrollView
@property(nonatomic, strong) NSDate *currentDate;
@property(nonatomic, strong) NSDate *startDate;
@property(nonatomic, strong) NSDate *endDate;
@property (nonatomic, weak)DatePickerView *dateViewDelegate;

+(CGFloat)heightForCalendarView;

@end
