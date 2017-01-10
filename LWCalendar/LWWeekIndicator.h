//
//  LWWeekIndicator.h
//  PriceCalender
//
//  Created by luwei on 2017/1/5.
//  Copyright © 2017年 HarrisHan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LWDatePickerBuilder, LWMonthView;

@interface LWWeekIndicator : UIView
@property (nonatomic, weak) LWDatePickerBuilder *dialogBuilder;
@property (nonatomic, weak) LWMonthView *monthDelegate;
@end
